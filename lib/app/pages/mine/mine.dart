import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MinePage extends StatefulWidget {
  const MinePage({super.key});
  @override
  State<MinePage> createState() => _MinePageState();
}

class _MinePageState extends State<MinePage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: const Text('我的'),
    );
  }
}
