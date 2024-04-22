import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:sens_healthy/components/toast.dart';

typedef ValueChangeCallback = void Function(int value);

class NumberSelect extends StatefulWidget {
  const NumberSelect(
      {super.key,
      required this.onValueChange,
      this.disabled = false,
      this.max = 99,
      this.min = 0,
      this.inputSize = 42,
      required this.currentValue});

  final bool disabled;

  final double inputSize;

  final int currentValue;
  final int max;
  final int min;

  final ValueChangeCallback onValueChange;

  @override
  State<NumberSelect> createState() => NumberSelectState();
}

class NumberSelectState extends State<NumberSelect> {
  final TextEditingController _textController = TextEditingController();

  late String inputValue;

  void resetValue({int? valueNew}) {
    setState(() {
      inputValue = valueNew != null ? valueNew.toString() : '1';
      _textController.text = valueNew != null ? valueNew.toString() : '1';
    });
  }

  void handleAddCounter() {
    if (widget.currentValue >= widget.max || widget.disabled) {
      return;
    }
    widget.onValueChange(widget.currentValue + 1);
    inputValue = (widget.currentValue + 1).toString();
    _textController.text = (widget.currentValue + 1).toString();
  }

  void handleReduceCounter() {
    if (widget.currentValue <= widget.min || widget.disabled) {
      return;
    }
    widget.onValueChange(widget.currentValue - 1);
    inputValue = (widget.currentValue - 1).toString();
    _textController.text = (widget.currentValue - 1).toString();
  }

  handleCheckInputValue() {
    final int valueGetInt = inputValue.isNotEmpty ? int.parse(inputValue) : 0;
    if (valueGetInt < widget.min) {
      widget.onValueChange(widget.min);
      inputValue = widget.min.toString();
      _textController.text = widget.min.toString();
      showToast('最少选择${widget.min}件哦');
    } else if (valueGetInt > widget.max) {
      widget.onValueChange(widget.max);
      inputValue = widget.max.toString();
      _textController.text = widget.max.toString();
      showToast('最多选择${widget.max}件哦');
    } else {
      widget.onValueChange(valueGetInt);
      inputValue = valueGetInt.toString();
      _textController.text = valueGetInt.toString();
    }
  }

  void updateValue(String value) {
    setState(() {
      inputValue = value;
    });
  }

  @override
  void initState() {
    super.initState();
    inputValue = widget.currentValue.toString();
    _textController.text = widget.currentValue.toString();
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon: Icon(
            Icons.remove,
            size: 24,
            color: (widget.currentValue <= widget.min || widget.disabled)
                ? const Color.fromRGBO(168, 168, 168, 1)
                : const Color.fromRGBO(33, 33, 33, 1),
          ),
          onPressed: handleReduceCounter,
        ),
        SizedBox(
          width: widget.inputSize,
          height: widget.inputSize,
          child: Center(
            child: TextField(
              enabled: !widget.disabled,
              onTapOutside: (PointerDownEvent p) {
                // 点击外部区域时取消焦点
                if (FocusScope.of(context).hasFocus) {
                  FocusScope.of(context).unfocus();
                }
                handleCheckInputValue();
              },
              onSubmitted: (String value) {
                // 在用户按下确定键或完成输入时调用
                // 点击外部区域时取消焦点
                if (FocusScope.of(context).hasFocus) {
                  FocusScope.of(context).unfocus();
                }
                handleCheckInputValue();
              },
              textAlign: TextAlign.center, // 文字水平居中
              controller: _textController,
              textAlignVertical: TextAlignVertical.center,
              style: const TextStyle(
                fontSize: 14, // 设置字体大小为20像素
              ),
              decoration: InputDecoration(
                contentPadding: EdgeInsets.zero, // 移除默认的内边距
                fillColor: const Color.fromRGBO(239, 239, 239, 1),
                filled: true,
                enabledBorder: OutlineInputBorder(
                  borderSide:
                      const BorderSide(color: Color.fromRGBO(239, 239, 239, 1)),
                  borderRadius: BorderRadius.circular(10), // 设置圆角大小
                ),
                border: OutlineInputBorder(
                  borderSide: const BorderSide(
                      color: Color.fromRGBO(239, 239, 239, 1), width: 0),
                  borderRadius: BorderRadius.circular(10), // 设置圆角大小
                ),
                focusedBorder: OutlineInputBorder(
                  // 聚焦状态下边框样式
                  borderSide: const BorderSide(
                      color: Color.fromRGBO(211, 66, 67, 1), width: 0),
                  borderRadius: BorderRadius.circular(10), // 设置圆角大小
                ),
              ),
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(2)
              ],
              onChanged: (value) => updateValue(value),
            ),
          ),
        ),
        IconButton(
          icon: Icon(
            Icons.add,
            size: 24,
            color: (widget.currentValue >= widget.max || widget.disabled)
                ? const Color.fromRGBO(168, 168, 168, 1)
                : const Color.fromRGBO(33, 33, 33, 1),
          ),
          onPressed: handleAddCounter,
        ),
      ],
    );
  }
}
