import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class PainConsultPage extends StatefulWidget {
  const PainConsultPage({super.key});

  @override
  State<PainConsultPage> createState() => PainConsultPageState();
}

class PainConsultPageState extends State<PainConsultPage> {
  @override
  Widget build(BuildContext context) {
    final EdgeInsets mediaQuerySafeInfo = MediaQuery.of(context).padding;
    final Size mediaQuerySizeInfo = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        padding: EdgeInsets.only(top: mediaQuerySafeInfo.top + 36 + 12 + 50),
        child: Center(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 100,
              height: 100,
              child: Image.asset(
                'assets/images/empty.png',
                fit: BoxFit.contain,
              ),
            ),
            const Text(
              '暂无内容',
              style: TextStyle(
                  color: Color.fromRGBO(224, 222, 223, 1), fontSize: 14),
            )
          ],
        )),
      ),
    );
  }
}
