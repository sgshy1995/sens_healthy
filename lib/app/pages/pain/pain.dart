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
    return Container(
      decoration: const BoxDecoration(color: Color.fromARGB(162, 192, 83, 119)),
      child: const Center(
        child: Text('首页'),
      ),
    );
  }
}
