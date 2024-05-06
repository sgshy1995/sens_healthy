import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../iconfont/icon_font.dart';

class CenterCourseTimeExplainPage extends StatelessWidget {
  CenterCourseTimeExplainPage({super.key});

  void handleGoBack() {
    Get.back();
  }

  static const agreementTextList = [
    '请您仔细阅读以下说明。',
    '本说明描述了我们如何制定「面对面康复课程」的预约时间规则。',
    '作为用户（患者），您需要同意并知悉以下规则，来使用「面对面康复课程」的相关预约时间等功能。',
    '以下称认证用户为「医师」。'
  ];

  static const agreementContentList = [
    {
      'title': '',
      'sub': '',
      'content': [
        '- 用户在购买面对面康复系列课程后，可以选择已经开放的预约时间进行预约。',
        '- 每次预约时间为1小时，每两次预约时间间隔需不小于30分钟（上一次的结束时间到下一次的开始时间）。',
        '- 在成功预约后，在预约时间开始前的「半小时」以上，可以有条件的修改或取消预约。「每次预约」有且仅有一次修改时间的机会；「每个系列课程」有且仅有两次的取消预约的机会。',
        '- 在成功预约后，在预约时间开始前的「半小时」以内，无法再修改或取消预约。',
        '- 因用户个人原因无法按时参加面对面康复直播课程，视为用户自主放弃本次直播授课，损失由用户个人承担。',
        '- 用户在成功预约以后，该系列课程将会与医师绑定；以后每次预约只能预约该医师的开放时间。',
        '- 本说明的最终解释权和管理权归「北京赴康科技有限公司」所有。'
      ]
    }
  ];

  static List<Widget> listNotice = [
    Container(
      margin: const EdgeInsets.only(top: 24),
      child: Text(agreementTextList[0],
          textAlign: TextAlign.justify,
          style: const TextStyle(color: Colors.black, fontSize: 14)),
    ),
    Container(
      margin: const EdgeInsets.only(top: 12),
      child: Text(agreementTextList[1],
          textAlign: TextAlign.justify,
          style: const TextStyle(color: Colors.black, fontSize: 14)),
    ),
    Container(
      margin: const EdgeInsets.only(top: 12),
      child: Text(agreementTextList[2],
          textAlign: TextAlign.justify,
          style: const TextStyle(color: Colors.black, fontSize: 14)),
    ),
    Container(
      margin: const EdgeInsets.only(top: 12),
      child: Text(agreementTextList[3],
          textAlign: TextAlign.justify,
          style: const TextStyle(color: Colors.black, fontSize: 14)),
    ),
    Container(
      margin: const EdgeInsets.only(top: 24),
      child: const Divider(
        height: 2,
        color: Colors.black,
      ),
    )
  ];

  List<Widget> listContent = agreementContentList.map((item) {
    List<Widget> listContentIn = (item['content'] as List).map((e) {
      return Container(
        margin: const EdgeInsets.only(top: 12),
        child: Text(e as String,
            textAlign: TextAlign.justify,
            style: const TextStyle(color: Colors.black, fontSize: 14)),
      );
    }).toList();

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: listContentIn,
      ),
    );
  }).toList();

  List<Widget> listFooter = [
    Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Container(
          margin: const EdgeInsets.only(top: 36),
          child: const Text('赴康云健康',
              textAlign: TextAlign.right,
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                  fontWeight: FontWeight.bold)),
        ),
        Container(
          margin: const EdgeInsets.only(top: 12),
          child: const Text('2024年4月1日 生效',
              textAlign: TextAlign.right,
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                  fontWeight: FontWeight.bold)),
        )
      ],
    )
  ];

  @override
  Widget build(BuildContext context) {
    final EdgeInsets mediaQuerySafeInfo = MediaQuery.of(context).padding;
    final Size mediaQuerySizeInfo = MediaQuery.of(context).size;

    return Scaffold(
        body: Column(
      children: [
        Container(
          color: Colors.white,
          padding: EdgeInsets.fromLTRB(12, mediaQuerySafeInfo.top + 12, 12, 12),
          child: SizedBox(
            height: 36,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                ),
                const Text('预约时间说明',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.bold)),
                const SizedBox(width: 24, height: 24)
              ],
            ),
          ),
        ),
        const Divider(
          height: 2,
          color: Color.fromRGBO(233, 234, 235, 1),
        ),
        Expanded(
            child: Container(
          color: Colors.white,
          width: double.infinity,
          padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
          child: ListView(
            padding: const EdgeInsets.all(0),
            children: listNotice + listContent,
          ),
        ))
      ],
    ));
  }
}
