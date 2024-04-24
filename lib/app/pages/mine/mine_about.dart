import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../iconfont/icon_font.dart';
import '../../controllers/global_controller.dart';
import '../../controllers/user_controller.dart';

import '../../providers/api/user_client_provider.dart';

import 'package:flutter_svg/flutter_svg.dart';

class MineAboutPage extends StatefulWidget {
  const MineAboutPage({super.key});

  @override
  State<MineAboutPage> createState() => _MineAboutPageState();
}

class _MineAboutPageState extends State<MineAboutPage> {
  void handleGoBack() {
    Get.back();
  }

  @override
  Widget build(BuildContext context) {
    final EdgeInsets mediaQuerySafeInfo = MediaQuery.of(context).padding;
    final Size mediaQuerySizeInfo = MediaQuery.of(context).size;

    return Scaffold(
        body: Column(children: [
      Container(
        color: Colors.white,
        padding: EdgeInsets.fromLTRB(12, mediaQuerySafeInfo.top + 12, 12, 12),
        child: SizedBox(
          height: 36,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: 24,
                height: 24,
                child: InkWell(
                  onTap: handleGoBack,
                  child: Center(
                    child: IconFont(
                      IconNames.fanhui,
                      size: 24,
                      color: '#000',
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
      const Divider(
        height: 2,
        color: Color.fromRGBO(255, 255, 255, 1),
      ),
      Expanded(
          child: Container(
        color: Colors.white,
        height: mediaQuerySizeInfo.height -
            12 -
            (mediaQuerySafeInfo.top + 12) -
            36 -
            2,
        width: double.infinity,
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(
                height: 80,
              ),
              Container(
                width: 88,
                height: 88,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: const Color.fromRGBO(235, 236, 236, 1),
                ),
                child: Center(
                  child: SizedBox(
                      width: 64,
                      height: 64,
                      child: Image.asset(
                        'assets/images/logo.png',
                        fit: BoxFit.contain,
                      )),
                ),
              ),
              const SizedBox(
                height: 12,
              ),
              SizedBox(
                height: 20,
                child: SvgPicture.asset(
                  'assets/images/name1.svg',
                  height: 20,
                  semanticsLabel: 'Acme Logo',
                  color: Colors.black,
                ),
              ),
              const SizedBox(
                height: 6,
              ),
              SizedBox(
                height: 20,
                child: SvgPicture.asset('assets/images/name2.svg',
                    height: 20, semanticsLabel: 'Acme Logo 1'),
              ),
              const SizedBox(
                height: 48,
              ),
              const Text(
                '赴康云健康 APP',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 6,
              ),
              const Text(
                'Copyright @ 北京赴康科技有限公司',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 6,
              ),
              const Text(
                'Build Version V-F-1-X',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ))
    ]));
  }
}
