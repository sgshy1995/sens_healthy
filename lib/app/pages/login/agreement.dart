import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../iconfont/icon_font.dart';

class AgreementPage extends StatelessWidget {
  AgreementPage({super.key});

  void handleGoBack() {
    Get.back();
  }

  static const agreementTextList = [
    '为使用「赴康云健康」APP服务（以下简称“本服务”或“本程序”），用户应当阅读并遵守《赴康云健康APP用户使用协议》，请务必审慎阅读、充分理解各条款内容，特别是免除或限制责任的相应条款，以及开通或使用某项服务的单独协议，并选择接受或不接受。',
    '除非用户已阅读并接受本条款所有条款，否则用户无权使用「赴康云健康」APP服务。用户对本服务的登录、查看、发布信息等行为即视为已阅读并同意本条款的约束。',
    '如果用户未满18周岁，请在法定监护人的陪同下阅读本用户协议，并特别注意未成年人使用条款。'
  ];

  static const agreementContentList = [
    {
      'title': '一、协议的范围',
      'content': [
        '1.1 本条款是用户与「赴康云健康」之间关于用户使用本程序服务所订立的协议。“用户”是指注册、登录、使用APP的个人或组织；“其他用户”是指包括其他APP用户、微信公众帐号用户和微信用户等除用户本人外与本程序服务相关的用户。',
        '1.2 本服务是指「赴康云健康」根据本协议向用户提供的服务，包括但不限于为用户提供专业伤痛问答咨询、伤痛恢复指导课程、健康咨询等。',
        '1.3 本程序可使用第三方账号登录，在不与本协议冲突的情况下，用户应遵守《微信公众平台服务协议》等协议规则关于微信公众帐号的其他相关规定。'
      ]
    },
    {
      'title': '二、服务内容',
      'content': [
        '2.1 用户在使用本服务前可能需要提前进行手机号授权，或进行账号注册、登录。',
        '2.2 本服务的具体内容由「赴康云健康」根据实际情况提供，包括但不限于授权用户通过其帐号进行即时通讯、收集个人信息、添加好友、关注他人、发布留言、点赞、发布伤痛问题、商城购买课程和器材等。'
      ]
    },
    {
      'title': '三、用户个人隐私信息保护',
      'content': [
        '3.1 用户在注册帐号或使用本服务的过程中，可能需要填写或提交一些必要的信息，如法律法规、规章规范性文件（以下称“法律法规”）规定的需要填写的身份信息。如用户提交的信息不完整或不符合法律法规的规定，则用户可能无法使用本服务或在使用本服务的过程中受到限制。',
        '3.2 个人隐私信息是指涉及用户个人身份或个人隐私的信息，比如，用户真实姓名、昵称、邮箱、手机号码、生日、性别、用户聊天记录。非个人隐私信息是指用户对本服务的操作状态以及使用习惯等明确且客观反映在「赴康云健康」服务器端的基本记录信息、个人隐私信息范围外的其它普通信息，以及用户同意公开的信息。',
        '3.3 「赴康云健康」非常重视您的信息安全。我们努力采取各种合理的物理、电子和管理方面的安全措施来保护您的用户信息。防止用户信息遭到未经授权访问、公开披露、使用、修改、损坏或丢失。我们会使用加密技术提高用户信息的安全性；我们会使用受信赖的保护机制防止用户信息遭到恶意攻击；我们会部署访问控制机制，尽力确保只有授权人员才可访问用户信息；以及我们会加强对于保护用户信息重要性的认识。',
        '3.4 「赴康云健康」未经用户同意不向任何第三方转让、公开、披露用户个人隐私信息，但以下特定情形除外：',
        '(1) 「赴康云健康」根据法律法规规定或有权机关的指示提供用户的个人隐私信息；',
        '(2) 由于用户将其用户密码告知他人或与他人共享注册帐户与密码，由此导致的任何个人信息的泄漏，或其他非因「赴康云健康」原因导致的个人隐私信息的泄露；',
        '(3) 用户自行向第三方公开其个人隐私信息；',
        '(4) 用户与「赴康云健康」及合作单位之间就用户个人隐私信息的使用公开达成约定，「赴康云健康」因此向合作单位公开用户个人隐私信息；',
        '(5) 任何由于黑客攻击、电脑病毒侵入及其他不可抗力事件导致用户个人隐私信息的泄露；',
        '(6) 用户在使用过程中存在主动散布政治有害、淫秽色情、广告、血腥暴力、诽谤侮辱、泄露个人隐私等信息。',
        '3.5 「赴康云健康」将依赖用户提供的个人信息判断用户是否为未成年人。任何18岁以下的未成年人注册帐号或使用本服务应事先取得家长或其法定监护人（以下简称"监护人"）的书面同意。除根据法律法规的规定及有权机关的指示披露外，「赴康云健康」不会使用或向任何第三方透露未成年人的聊天记录及其他个人隐私信息。除本协议约定的例外情形外，未经监护人事先同意，「赴康云健康」不会使用或向任何第三方透露未成年人的个人隐私信息。'
      ]
    },
    {
      'title': '四、服务使用规则',
      'content': [
        '4.1 用户在本服务中或通过本服务所传送、发布的任何内容并不反映或代表，也不得被视为反映或代表「赴康云健康」的观点、立场或政策，「赴康云健康」对此不承担任何责任。',
        '4.2 用户不得利用「赴康云健康」帐号或本服务进行如下行为：',
        '(1) 提交、发布虚假信息，或盗用他人头像或资料，冒充、利用他人名义的；',
        '(2) 强制、诱导其他用户关注、点击链接页面或分享信息的；',
        '(3) 虚构事实、隐瞒真相以误导、欺骗他人的；',
        '(4) 利用技术手段批量建立虚假帐号的；',
        '(5) 利用「赴康云健康」帐号或本服务从事任何违法犯罪活动的；',
        '(6) 制作、发布与以上行为相关的方法、工具，或对此类方法、工具进行运营或传播，无论这些行为是否为商业目的；',
        '(7) 其他违反法律法规规定、侵犯其他用户合法权益、干扰「赴康云健康」正常运营或「赴康云健康」未明示授权的行为。',
        '4.3 用户有责任妥善保管注册帐号信息及帐号密码的安全，因用户保管不善可能导致遭受盗号或密码失窃，责任由用户自行承担。用户需要对注册帐号以及密码下的行为承担法律责任。用户同意在任何情况下不使用其他用户的帐号或密码。在用户怀疑他人使用其帐号或密码时，用户同意立即通知「赴康云健康」管理员。'
      ]
    },
    {
      'title': '五、知识产权声明',
      'content': [
        '5.1 「赴康云健康」在本服务中提供的内容（包括但不限于网页、文字、图片、音频、视频、图表等）的知识产权归「赴康云健康」所有，用户在使用本服务中所产生的内容的知识产权归用户或相关权利人所有。',
        '5.2 除另有特别声明外，「赴康云健康」提供本服务时所依托软件的著作权、专利权、代码技术及其他知识产权均归「赴康云健康」所有。'
      ]
    },
    {
      'title': '六、法律责任',
      'content': [
        '6.1 用户应遵守第三方平台如《微信公众平台服务协议》中关于“法律责任”的约定，除非该等约定与本协议存在冲突。',
        '6.2 如果「赴康云健康」发现或收到他人举报或投诉用户违反本协议约定的，「赴康云健康」有权不经通知随时对相关内容，包括但不限于用户资料、聊天记录进行审查、删除，并视情节轻重对违规帐号处以包括但不限于警告、帐号封禁、设备封禁、功能封禁的处罚，且通知用户处理结果。',
        '6.3 用户理解并同意，「赴康云健康」有权依合理判断对违反有关法律法规或本协议规定的行为进行处罚，对违法违规的任何用户采取适当的法律行动，并依据法律法规保存有关信息向有关部门报告等，用户应承担由此而产生的一切法律责任。',
        '6.4 用户理解并同意，因用户违反相关法律法规或本协议约定引发的任何后果，均由用户独立承担责任、赔偿损失，与「赴康云健康」无关。如侵害到「赴康云健康」或他人权益的，用户须自行承担全部责任和赔偿一切损失。'
      ]
    },
    {
      'title': '七、其它',
      'content': [
        '7.1 用户理解并确认，「赴康云健康」管理员需要定期或不定期地对「赴康云健康」平台或相关的设备进行检修或者维护，如因此类情况而造成服务在合理时间内的中断，「赴康云健康」无需为此承担任何责任，但会事先进行通告。',
        '7.2 你使用本服务即视为你已阅读并同意受本协议的约束。「赴康云健康」有权在必要时修改本协议。你可以在相关服务页面查阅最新版本的协议。本协议变更后，如果你继续使用APP服务，即视为你已接受修改后的协议。如果你不接受修改后的协议，应当停止使用小程序服务。',
        '7.3 本协议签订地、争议解决管辖方式，均与《微信公众平台服务协议》一致，即为中华人民共和国北京市昌平区，由本协议签订地有管辖权的人民法院管辖。',
        '7.4 本协议的成立、生效、履行、解释及纠纷解决，适用中华人民共和国大陆地区法律（不包括冲突法）。'
      ]
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
    List<Widget> listContentInTitle = [
      Text(item['title'] as String,
          style: const TextStyle(
              color: Colors.black, fontWeight: FontWeight.bold, fontSize: 14))
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
        children: listContentInTitle + listContentIn,
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
                const Text('用户服务协议',
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
