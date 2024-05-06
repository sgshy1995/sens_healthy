import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../iconfont/icon_font.dart';
import '../../../controllers/user_controller.dart';

class MineLiveCourseOrderMenu extends StatefulWidget {
  const MineLiveCourseOrderMenu(
      {super.key, required this.learningCounts, required this.finishCounts});

  final int learningCounts;
  final int finishCounts;

  @override
  State<MineLiveCourseOrderMenu> createState() =>
      _MineLiveCourseOrderMenuState();
}

class _MineLiveCourseOrderMenuState extends State<MineLiveCourseOrderMenu> {
  final UserController userController = Get.put(UserController());

  void handleGotoPatientCoursePage() {
    Get.toNamed('/center');
  }

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
                  const Text('面对面康复订单',
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
          Stack(
            children: [
              Column(
                children: [
                  const SizedBox(
                    height: 12,
                  ),
                  Row(
                    children: [
                      GestureDetector(
                        onTap: handleGotoPatientCoursePage,
                        child: Container(
                          width: (mediaQuerySizeInfo.width - 24 - 24) / 4,
                          height: 54,
                          color: Colors.transparent,
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
                                    IconNames.xuexizhong,
                                    size: 24,
                                    color: 'rgb(0, 0, 0)',
                                  ),
                                ),
                              ),
                              const Text('学习中',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 13,
                                      fontWeight: FontWeight.normal))
                            ],
                          ),
                        ),
                      ),
                      Container(
                        width: (mediaQuerySizeInfo.width - 24 - 24) / 4,
                        height: 54,
                        color: Colors.transparent,
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
                                  IconNames.yiwancheng,
                                  size: 24,
                                  color: 'rgb(0, 0, 0)',
                                ),
                              ),
                            ),
                            const Text('已完成',
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
              (widget.learningCounts >= 0
                  ? Positioned(
                      top: 4,
                      left: ((mediaQuerySizeInfo.width - 24 - 24) / 4) / 2 +
                          10 +
                          ((mediaQuerySizeInfo.width - 24 - 24) / 4) * 0,
                      child: GestureDetector(
                        child: Container(
                          width: 24,
                          height: 24,
                          decoration: const BoxDecoration(
                              color: Color.fromRGBO(249, 81, 84, 1),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(24))),
                          child: Center(
                            child: Text(
                              '${widget.learningCounts > 99 ? '99+' : widget.learningCounts}',
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ))
                  : const SizedBox.shrink()),
              (widget.finishCounts >= 0
                  ? Positioned(
                      top: 4,
                      left: ((mediaQuerySizeInfo.width - 24 - 24) / 4) / 2 +
                          10 +
                          ((mediaQuerySizeInfo.width - 24 - 24) / 4) * 1,
                      child: GestureDetector(
                        child: Container(
                          width: 24,
                          height: 24,
                          decoration: const BoxDecoration(
                              color: Color.fromRGBO(249, 81, 84, 1),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(24))),
                          child: Center(
                            child: Text(
                              '${widget.finishCounts > 99 ? '99+' : widget.finishCounts}',
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ))
                  : const SizedBox.shrink())
            ],
          )
        ],
      ),
    );
  }
}
