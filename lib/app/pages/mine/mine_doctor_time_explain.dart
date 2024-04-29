import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../iconfont/icon_font.dart';

class MineDoctorTimeExplainPage extends StatelessWidget {
  MineDoctorTimeExplainPage({super.key});

  void handleGoBack() {
    Get.back();
  }

  static const agreementTextList = [
    '请您仔细阅读以下说明。',
    '本说明描述了我们如何制定「面对面康复课程」的预约时间规则。',
    '作为普通用户（患者）或认证用户（医师），您需要同意并知悉以下规则，来使用「面对面康复课程」的相关预约时间等功能。'
  ];

  static const agreementContentList = [
    {
      'title': '',
      'sub': '',
      'content': [
        '- 面对面康复课程预约时间说明是赴康健康提供的一项服务，针对拥有授课权限的医师，可以管理自己的授课时间。',
        '- 用户（患者）在购买面对面康复系列课程后，可以选择已经开放的预约时间进行预约。',
        '- 每次预约时间为1小时，每两次预约时间间隔需不小于30分钟（上一次的结束时间到下一次的开始时间）。',
        '- 每次预约时间段需在当天24点之前，即开始时间需小于 23:00。',
        '- 医师在创建预约时间后，在已经被用户（患者）成功预约的情况下，每个预约时间可以有且仅有一次的无责取消机会。之后的每次取消，平台将免费赠送用户（患者）一课时课程，此损失将由相应医师承担。',
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
