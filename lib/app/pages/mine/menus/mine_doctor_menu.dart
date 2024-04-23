import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../iconfont/icon_font.dart';
import '../../../controllers/user_controller.dart';

class MineDoctorMenu extends StatefulWidget {
  const MineDoctorMenu({super.key});

  @override
  State<MineDoctorMenu> createState() => _MineDoctorMenuState();
}

class _MineDoctorMenuState extends State<MineDoctorMenu> {
  final UserController userController = GetInstance().find<UserController>();

  @override
  Widget build(BuildContext context) {
    final EdgeInsets mediaQuerySafeInfo = MediaQuery.of(context).padding;
    final Size mediaQuerySizeInfo = MediaQuery.of(context).size;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          color: Colors.white),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 4,
                    height: 14,
                    margin: const EdgeInsets.only(right: 8),
                    decoration: const BoxDecoration(
                        color: Color.fromRGBO(195, 77, 73, 1),
                        borderRadius: BorderRadius.all(Radius.circular(2))),
                  ),
                  const Text('专业医师升级',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                          fontWeight: FontWeight.bold))
                ],
              ),
              SizedBox(
                width: 16,
                height: 16,
                child: Center(
                  child: IconFont(
                    IconNames.qianjin,
                    size: 16,
                    color: 'rgb(156, 156, 156)',
                  ),
                ),
              )
            ],
          ),
          const SizedBox(
            height: 12,
          ),
          Row(
            children: [
              SizedBox(
                width: (mediaQuerySizeInfo.width - 24 - 24) / 4,
                height: 54,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(bottom: 6),
                      width: 24,
                      height: 24,
                      child: Center(
                        child: IconFont(
                          IconNames.zhuanyerenzheng_menu,
                          size: 24,
                          color: 'rgb(0, 0, 0)',
                        ),
                      ),
                    ),
                    const Text('专业认证',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 13,
                            fontWeight: FontWeight.normal))
                  ],
                ),
              ),
              SizedBox(
                width: (mediaQuerySizeInfo.width - 24 - 24) / 4,
                height: 54,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(bottom: 6),
                      width: 24,
                      height: 24,
                      child: Center(
                        child: IconFont(
                          IconNames.kaitongshoukequanxian,
                          size: 24,
                          color: 'rgb(0, 0, 0)',
                        ),
                      ),
                    ),
                    const Text('授课权限',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 13,
                            fontWeight: FontWeight.normal))
                  ],
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
