import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PainPage extends StatefulWidget {
  const PainPage({super.key});
  @override
  State<PainPage> createState() => _PainPageState();
}

class _PainPageState extends State<PainPage> {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: const Text('首页'),
    );
  }
}
