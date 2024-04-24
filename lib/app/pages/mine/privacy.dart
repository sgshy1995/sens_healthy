import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../iconfont/icon_font.dart';

class PrivacyPage extends StatelessWidget {
  PrivacyPage({super.key});

  void handleGoBack() {
    Get.back();
  }

  static const agreementTextList = [
    '赴康云健康（以下简称“我们”或“赴康”）致力于保护其用户（以下简称“用户”或“您”）的隐私。',
    '本隐私政策描述了我们如何收集、使用和披露通过我们的移动应用程序（“应用程序”）收集的个人信息。'
  ];

  static const agreementContentList = [
    {
      'title': '收集的信息',
      'sub': '我们收集以下类型的个人信息：',
      'content': [
        '- 个人身份信息：姓名、电子邮件地址、电话号码、年龄、性别、地址等。',
        '- 健康信息：病史、治疗计划、康复进度等。',
        '- 设备信息：设备类型、操作系统、IP地址、照片（视频）图库、摄像头和麦克风等。',
        '- 使用信息：应用程序的使用模式、访问时间、地理位置等。'
      ]
    },
    {
      'title': '收集信息的方式',
      'sub': '我们通过以下方式收集信息：',
      'content': [
        '- 用户注册：当您创建应用程序帐户时，我们会收集您的个人身份信息和健康信息。',
        '- 应用程序使用：当您使用应用程序时，我们会收集有关您的使用模式和设备信息的信息。',
        '- 第三方集成：我们可能会与第三方服务（例如健身追踪器）集成，这些服务可能会提供有关您健康和活动的信息。'
      ]
    },
    {
      'title': '使用信息',
      'sub': '我们使用收集的信息来：',
      'content': [
        '- 提供应用程序服务：跟踪您的康复进度、提供个性化建议和连接您与康复师专业人员。',
        '- 改善应用程序：分析使用模式以了解用户需求并改进应用程序性能。',
        '- 研究和开发：使用汇总和匿名的信息进行运动康复研究和开发新功能。'
      ]
    },
    {
      'title': '披露信息',
      'sub': '我们可能会在以下情况下披露您的个人信息：',
      'content': [
        '- 医疗保健专业人员：为了提供医疗保健服务，我们会与您的医疗保健专业人员共享您的健康信息。',
        '- 第三方服务提供商：我们可能会聘请第三方服务提供商来执行功能，例如数据分析和客户支持。这些供应商可能会访问您的个人信息，但仅限于执行其指定任务。',
        '- 法律要求：我们可能会在法律要求或为了保护我们或他人的权利、财产或安全的情况下披露您的个人信息。'
      ]
    },
    {
      'title': '数据安全',
      'sub': '我们实施了行业标准的安全措施来保护您的个人信息免遭未经授权的访问、使用、披露、更改或销毁。',
      'content': []
    },
    {
      'title': '数据保留',
      'sub': '我们将在必要的时间内保留您的个人信息，以提供应用程序服务、遵守法律要求或解决争议。',
      'content': []
    },
    {
      'title': '用户权利',
      'sub': '您对自己的个人信息拥有以下权利：',
      'content': [
        '- 访问权：您可以要求访问我们持有的有关您的个人信息。',
        '- 更正权：如果您认为您的个人信息不准确或不完整，您可以要求更正务。',
        '- 删除权：在某些情况下，您可以要求删除我们持有的有关您的个人信息。',
        '- 限制处理权：您可以要求限制我们处理您的个人信息。',
        '- 数据可移植性权：您可以要求以可机读格式接收我们持有的有关您的个人信息。'
      ]
    },
    {
      'title': '联系我们',
      'sub': '如果您对本隐私政策有任何疑问或疑虑，请通过以下方式联系我们：',
      'content': ['电子邮件：support@fkhse.com']
    },
    {
      'title': '更新',
      'sub': '我们可能会不时更新本隐私政策。我们将在应用程序中发布任何更新，并在必要时通过电子邮件通知您。',
      'content': []
    },
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
      margin: const EdgeInsets.only(top: 24),
      child: const Divider(
        height: 2,
        color: Colors.black,
      ),
    )
  ];

  List<Widget> listContent = agreementContentList.map((item) {
    List<Widget> listContentInTitle = [
      Text(item['title'] as String,
          style: const TextStyle(
              color: Colors.black, fontWeight: FontWeight.bold, fontSize: 14))
    ];

    List<Widget> listContentInSub = [
      const SizedBox(
        height: 12,
      ),
      Text(item['sub'] as String,
          style: const TextStyle(
              color: Colors.black, fontWeight: FontWeight.normal, fontSize: 14))
    ];

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
        children: listContentInTitle + listContentInSub + listContentIn,
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
                const Text('隐私政策',
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
            children: listNotice + listContent + listFooter,
          ),
        ))
      ],
    ));
  }
}
