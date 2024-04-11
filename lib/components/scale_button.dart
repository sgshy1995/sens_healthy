import 'package:flutter/material.dart';

// 定义回调函数类型
typedef OnTabCallback = void Function();

class ScaleButton extends StatefulWidget {
  const ScaleButton(
      {super.key,
      required this.onTab,
      required this.child,
      this.disabled = false});

  final OnTabCallback onTab;

  final Widget child;

  final bool disabled;

  @override
  State<ScaleButton> createState() => _ScaleButtonState();
}

class _ScaleButtonState extends State<ScaleButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _animation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (widget.disabled) {
          return;
        }
        _controller.forward().then((_) {
          _controller.reverse();
        });
        widget.onTab();
      },
      child: ScaleTransition(
        scale: _animation,
        child: widget.child,
      ),
    );
  }
}
