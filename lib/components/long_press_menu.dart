import 'package:flutter/material.dart';
import 'package:custom_pop_up_menu/custom_pop_up_menu.dart';
import 'package:flutter/services.dart';
import 'package:sens_healthy/components/toast.dart';

class LongPressMenu extends StatefulWidget {
  const LongPressMenu(
      {super.key, required this.copyContent, required this.child});
  final String copyContent;
  final Widget child;

  @override
  State<LongPressMenu> createState() => _LongPressMenuState();
}

class _LongPressMenuState extends State<LongPressMenu>
    with SingleTickerProviderStateMixin {
  final CustomPopupMenuController _customPopupMenuController =
      CustomPopupMenuController();

  late AnimationController _controller;
  late Animation<Color?> _colorAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    // 创建颜色渐变动画
    _colorAnimation = ColorTween(
            begin: Colors.transparent, end: const Color.fromRGBO(0, 0, 0, 0.3))
        .animate(_controller);
  }

  @override
  void dispose() {
    _customPopupMenuController.dispose();
    _controller.dispose();
    super.dispose();
  }

  void handleCopyOrderNo() {
    // 复制文本到剪贴板
    Clipboard.setData(ClipboardData(text: widget.copyContent));
    // 显示通知
    showToast('已复制');
    _customPopupMenuController.hideMenu();
  }

  Widget _buildLongPressMenu() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(5),
      child: Container(
        color: const Color.fromRGBO(0, 0, 0, 0.9),
        padding: const EdgeInsets.fromLTRB(24, 12, 24, 12),
        child: GestureDetector(
          onTap: handleCopyOrderNo,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const Icon(
                Icons.content_copy,
                size: 20,
                color: Colors.white,
              ),
              Container(
                margin: const EdgeInsets.only(top: 2),
                child: const Text(
                  '复制',
                  style: TextStyle(color: Colors.white, fontSize: 12),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CustomPopupMenu(
      controller: _customPopupMenuController,
      menuBuilder: _buildLongPressMenu,
      barrierColor: Colors.transparent,
      pressType: PressType.longPress,
      menuOnChange: (p0) {
        if (p0) {
          _controller.forward().then((_) {
            _controller.reverse();
          });
        }
      },
      child: AnimatedBuilder(
        animation: _colorAnimation,
        builder: (context, child) {
          return Align(
            alignment: Alignment.centerLeft,
            child: Container(
              color: _colorAnimation.value,
              child: widget.child,
            ),
          );
        },
      ),
    );
  }
}
