import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/svg.dart';

enum IconNames {
  yangshengqi, qiehuanquanping, chuangzuozhezhongxin, pinglun_1, biaojiyidu, guaduan, maikefengline, jingyinline, shexiangtouguanbi, shexiangtoukaiqi, fanzhuanxiangji, xiangzuo, xiangyou, fuzhuxian, tuse, baocun, huizhiguiji, quxiao_circle, bofangzhong, shipinliebiao, guankanlishi, guankan, sayhi, xuexizhongxin, qiehuan, yuyueshijian_doctor, shoukequanxian_doctor, shangwuhezuo_doctor, doctor_enter, renzhenglishi, fuzhi, apple, biangeng_1, yigoumai, zhuanyerenzheng_menu, kefuyushouhou, shiyongbangzhu, qicai_yifahuo, qicai_daifahuo, qicai_yiquxiao, qicai_yiqianshou, shouhuodizhi, kaitongshoukequanxian, shangwuhezuo, jizhu, guanjie, yiwancheng, daixuexi, xuexizhong, yiyuyue, chongzhi, morenxuanzhong, moren_fill, phone_fill, dizhi_fill, dizhiguanli, lianxi_yishouqing_copy, zhekou, remen, a_yinhangkadaizhifuzhifu, tubiaozhizuomoban, jianshenke, jianji, zixingche, xiaidekecheng, yue, jingshi, qingkong, shouqi, zuixingengxin, live_fill, live, video_fill, video, dingdan, kangfushigongju, kecheng, gouwuche, liebiaoxingshi, duigou, hot, nandu, yanjing, yanjing_fill, fenlei, cainixihuan, nan, nv, shanchu, shezhi, yirenzheng, guanfangrenzheng, a_pinpaiyisheng, xiala, bianji, tupian, xiangji, xiazai, guanbi, gengduo, tanhao, qianjin, fanhui, fenxiang, tianjia, shuaxin_1, shuaxin, sousuo, dianzan, kabao, shoucang, xiaoxi, xiaoxizhongxin, dianzan_1, shoucang_1, turnback, dianhua, paihangbang, weixin, phone, pic_discount, course_order, equipment_order, top_up_order, zhifu_weixin, zhifu_zhifubao, live_copy_copy, shipin_1_copy_111111
}

extension parseString on IconNames {
  String serialize() => this.toString().split('.').last;
}

/// A class includes all icons which you provided from https://iconfont.cn
///
/// How to use it:
/// ```dart
/// IconFont(IconNames.xxx);
/// IconFont(IconNames.xxx, color: '#f00');
/// IconFont(IconNames.xxx, colors: ['#f00', 'blue']);
/// IconFont(IconNames.xxx, size: 30, color: '#000');
/// ```
///
/// The name is dynamic to against server interface.
/// Feel free to input string literal.
/// ```dart
/// IconFont('xxx');
/// ```
class IconFont extends StatelessWidget {
  IconNames? name;
  final String? color;
  final List<String>? colors;
  final double size;

  IconFont(dynamic iconName, { this.size = 18, this.color, this.colors }) {
    this.name = getIconNames(iconName);
  }

  static IconNames getIconNames(dynamic iconName) {
    switch (iconName) {
      case 'yangshengqi':
        iconName = IconNames.yangshengqi;
        break;
      case 'qiehuanquanping':
        iconName = IconNames.qiehuanquanping;
        break;
      case 'chuangzuozhezhongxin':
        iconName = IconNames.chuangzuozhezhongxin;
        break;
      case 'pinglun_1':
        iconName = IconNames.pinglun_1;
        break;
      case 'biaojiyidu':
        iconName = IconNames.biaojiyidu;
        break;
      case 'guaduan':
        iconName = IconNames.guaduan;
        break;
      case 'maikefengline':
        iconName = IconNames.maikefengline;
        break;
      case 'jingyinline':
        iconName = IconNames.jingyinline;
        break;
      case 'shexiangtouguanbi':
        iconName = IconNames.shexiangtouguanbi;
        break;
      case 'shexiangtoukaiqi':
        iconName = IconNames.shexiangtoukaiqi;
        break;
      case 'fanzhuanxiangji':
        iconName = IconNames.fanzhuanxiangji;
        break;
      case 'xiangzuo':
        iconName = IconNames.xiangzuo;
        break;
      case 'xiangyou':
        iconName = IconNames.xiangyou;
        break;
      case 'fuzhuxian':
        iconName = IconNames.fuzhuxian;
        break;
      case 'tuse':
        iconName = IconNames.tuse;
        break;
      case 'baocun':
        iconName = IconNames.baocun;
        break;
      case 'huizhiguiji':
        iconName = IconNames.huizhiguiji;
        break;
      case 'quxiao_circle':
        iconName = IconNames.quxiao_circle;
        break;
      case 'bofangzhong':
        iconName = IconNames.bofangzhong;
        break;
      case 'shipinliebiao':
        iconName = IconNames.shipinliebiao;
        break;
      case 'guankanlishi':
        iconName = IconNames.guankanlishi;
        break;
      case 'guankan':
        iconName = IconNames.guankan;
        break;
      case 'sayhi':
        iconName = IconNames.sayhi;
        break;
      case 'xuexizhongxin':
        iconName = IconNames.xuexizhongxin;
        break;
      case 'qiehuan':
        iconName = IconNames.qiehuan;
        break;
      case 'yuyueshijian_doctor':
        iconName = IconNames.yuyueshijian_doctor;
        break;
      case 'shoukequanxian_doctor':
        iconName = IconNames.shoukequanxian_doctor;
        break;
      case 'shangwuhezuo_doctor':
        iconName = IconNames.shangwuhezuo_doctor;
        break;
      case 'doctor_enter':
        iconName = IconNames.doctor_enter;
        break;
      case 'renzhenglishi':
        iconName = IconNames.renzhenglishi;
        break;
      case 'fuzhi':
        iconName = IconNames.fuzhi;
        break;
      case 'apple':
        iconName = IconNames.apple;
        break;
      case 'biangeng_1':
        iconName = IconNames.biangeng_1;
        break;
      case 'yigoumai':
        iconName = IconNames.yigoumai;
        break;
      case 'zhuanyerenzheng_menu':
        iconName = IconNames.zhuanyerenzheng_menu;
        break;
      case 'kefuyushouhou':
        iconName = IconNames.kefuyushouhou;
        break;
      case 'shiyongbangzhu':
        iconName = IconNames.shiyongbangzhu;
        break;
      case 'qicai_yifahuo':
        iconName = IconNames.qicai_yifahuo;
        break;
      case 'qicai_daifahuo':
        iconName = IconNames.qicai_daifahuo;
        break;
      case 'qicai_yiquxiao':
        iconName = IconNames.qicai_yiquxiao;
        break;
      case 'qicai_yiqianshou':
        iconName = IconNames.qicai_yiqianshou;
        break;
      case 'shouhuodizhi':
        iconName = IconNames.shouhuodizhi;
        break;
      case 'kaitongshoukequanxian':
        iconName = IconNames.kaitongshoukequanxian;
        break;
      case 'shangwuhezuo':
        iconName = IconNames.shangwuhezuo;
        break;
      case 'jizhu':
        iconName = IconNames.jizhu;
        break;
      case 'guanjie':
        iconName = IconNames.guanjie;
        break;
      case 'yiwancheng':
        iconName = IconNames.yiwancheng;
        break;
      case 'daixuexi':
        iconName = IconNames.daixuexi;
        break;
      case 'xuexizhong':
        iconName = IconNames.xuexizhong;
        break;
      case 'yiyuyue':
        iconName = IconNames.yiyuyue;
        break;
      case 'chongzhi':
        iconName = IconNames.chongzhi;
        break;
      case 'morenxuanzhong':
        iconName = IconNames.morenxuanzhong;
        break;
      case 'moren_fill':
        iconName = IconNames.moren_fill;
        break;
      case 'phone_fill':
        iconName = IconNames.phone_fill;
        break;
      case 'dizhi_fill':
        iconName = IconNames.dizhi_fill;
        break;
      case 'dizhiguanli':
        iconName = IconNames.dizhiguanli;
        break;
      case 'lianxi_yishouqing_copy':
        iconName = IconNames.lianxi_yishouqing_copy;
        break;
      case 'zhekou':
        iconName = IconNames.zhekou;
        break;
      case 'remen':
        iconName = IconNames.remen;
        break;
      case 'a_yinhangkadaizhifuzhifu':
        iconName = IconNames.a_yinhangkadaizhifuzhifu;
        break;
      case 'tubiaozhizuomoban':
        iconName = IconNames.tubiaozhizuomoban;
        break;
      case 'jianshenke':
        iconName = IconNames.jianshenke;
        break;
      case 'jianji':
        iconName = IconNames.jianji;
        break;
      case 'zixingche':
        iconName = IconNames.zixingche;
        break;
      case 'xiaidekecheng':
        iconName = IconNames.xiaidekecheng;
        break;
      case 'yue':
        iconName = IconNames.yue;
        break;
      case 'jingshi':
        iconName = IconNames.jingshi;
        break;
      case 'qingkong':
        iconName = IconNames.qingkong;
        break;
      case 'shouqi':
        iconName = IconNames.shouqi;
        break;
      case 'zuixingengxin':
        iconName = IconNames.zuixingengxin;
        break;
      case 'live_fill':
        iconName = IconNames.live_fill;
        break;
      case 'live':
        iconName = IconNames.live;
        break;
      case 'video_fill':
        iconName = IconNames.video_fill;
        break;
      case 'video':
        iconName = IconNames.video;
        break;
      case 'dingdan':
        iconName = IconNames.dingdan;
        break;
      case 'kangfushigongju':
        iconName = IconNames.kangfushigongju;
        break;
      case 'kecheng':
        iconName = IconNames.kecheng;
        break;
      case 'gouwuche':
        iconName = IconNames.gouwuche;
        break;
      case 'liebiaoxingshi':
        iconName = IconNames.liebiaoxingshi;
        break;
      case 'duigou':
        iconName = IconNames.duigou;
        break;
      case 'hot':
        iconName = IconNames.hot;
        break;
      case 'nandu':
        iconName = IconNames.nandu;
        break;
      case 'yanjing':
        iconName = IconNames.yanjing;
        break;
      case 'yanjing_fill':
        iconName = IconNames.yanjing_fill;
        break;
      case 'fenlei':
        iconName = IconNames.fenlei;
        break;
      case 'cainixihuan':
        iconName = IconNames.cainixihuan;
        break;
      case 'nan':
        iconName = IconNames.nan;
        break;
      case 'nv':
        iconName = IconNames.nv;
        break;
      case 'shanchu':
        iconName = IconNames.shanchu;
        break;
      case 'shezhi':
        iconName = IconNames.shezhi;
        break;
      case 'yirenzheng':
        iconName = IconNames.yirenzheng;
        break;
      case 'guanfangrenzheng':
        iconName = IconNames.guanfangrenzheng;
        break;
      case 'a_pinpaiyisheng':
        iconName = IconNames.a_pinpaiyisheng;
        break;
      case 'xiala':
        iconName = IconNames.xiala;
        break;
      case 'bianji':
        iconName = IconNames.bianji;
        break;
      case 'tupian':
        iconName = IconNames.tupian;
        break;
      case 'xiangji':
        iconName = IconNames.xiangji;
        break;
      case 'xiazai':
        iconName = IconNames.xiazai;
        break;
      case 'guanbi':
        iconName = IconNames.guanbi;
        break;
      case 'gengduo':
        iconName = IconNames.gengduo;
        break;
      case 'tanhao':
        iconName = IconNames.tanhao;
        break;
      case 'qianjin':
        iconName = IconNames.qianjin;
        break;
      case 'fanhui':
        iconName = IconNames.fanhui;
        break;
      case 'fenxiang':
        iconName = IconNames.fenxiang;
        break;
      case 'tianjia':
        iconName = IconNames.tianjia;
        break;
      case 'shuaxin_1':
        iconName = IconNames.shuaxin_1;
        break;
      case 'shuaxin':
        iconName = IconNames.shuaxin;
        break;
      case 'sousuo':
        iconName = IconNames.sousuo;
        break;
      case 'dianzan':
        iconName = IconNames.dianzan;
        break;
      case 'kabao':
        iconName = IconNames.kabao;
        break;
      case 'shoucang':
        iconName = IconNames.shoucang;
        break;
      case 'xiaoxi':
        iconName = IconNames.xiaoxi;
        break;
      case 'xiaoxizhongxin':
        iconName = IconNames.xiaoxizhongxin;
        break;
      case 'dianzan_1':
        iconName = IconNames.dianzan_1;
        break;
      case 'shoucang_1':
        iconName = IconNames.shoucang_1;
        break;
      case 'turnback':
        iconName = IconNames.turnback;
        break;
      case 'dianhua':
        iconName = IconNames.dianhua;
        break;
      case 'paihangbang':
        iconName = IconNames.paihangbang;
        break;
      case 'weixin':
        iconName = IconNames.weixin;
        break;
      case 'phone':
        iconName = IconNames.phone;
        break;
      case 'pic_discount':
        iconName = IconNames.pic_discount;
        break;
      case 'course_order':
        iconName = IconNames.course_order;
        break;
      case 'equipment_order':
        iconName = IconNames.equipment_order;
        break;
      case 'top_up_order':
        iconName = IconNames.top_up_order;
        break;
      case 'zhifu_weixin':
        iconName = IconNames.zhifu_weixin;
        break;
      case 'zhifu_zhifubao':
        iconName = IconNames.zhifu_zhifubao;
        break;
      case 'live_copy_copy':
        iconName = IconNames.live_copy_copy;
        break;
      case 'shipin_1_copy_111111':
        iconName = IconNames.shipin_1_copy_111111;
        break;

    }
    return iconName;
  }

  static String getColor(int arrayIndex, String? color, List<String>? colors, String defaultColor) {
    if (color != null && color.isNotEmpty) {
      return color;
    }

    if (colors != null && colors.isNotEmpty && colors.length > arrayIndex) {
      return colors.elementAt(arrayIndex);
    }

    return defaultColor;
  }

  @override
  Widget build(BuildContext context) {
    String svgXml;

    switch (this.name!) {
      case IconNames.yangshengqi:
        svgXml = '''
          <svg viewBox="0 0 1228 1024" xmlns="http://www.w3.org/2000/svg">
            <path
              d="M541.24348958 159.99804687a118.65234375 118.65234375 0 0 1 166.11328125 23.73046876l1.30517578 1.77978515A118.65234375 118.65234375 0 0 1 731.08723958 254.91992187v514.16015625a118.65234375 118.65234375 0 0 1-189.84375 94.921875l-179.28369141-134.47265625H256.47786458a118.65234375 118.65234375 0 0 1-118.65234375-116.67480468V413.12304687a118.65234375 118.65234375 0 0 1 118.65234375-118.65234374h105.48193359z m369.08789063 65.41699219C1026.7688802 298.62353516 1087.04427083 396.51171875 1087.04427083 515.95507813c0 119.44335938-60.27539063 217.33154297-176.71289063 290.57958984a39.55078125 39.55078125 0 0 1-42.08203124-66.99902344C962.73616536 680.13037109 1007.94270833 606.64501953 1007.94270833 515.95507813c0-90.68994141-45.20654297-164.13574219-139.69335938-223.58056641a39.55078125 39.55078125 0 1 1 42.08203126-66.95947266zM644.07552083 231.18945312a39.55078125 39.55078125 0 0 0-55.37109375-7.91015624L388.30061849 373.57226562H256.47786458a39.55078125 39.55078125 0 0 0-39.55078125 39.55078126v197.75390624a39.55078125 39.55078125 0 0 0 39.55078125 39.55078126h131.82275391l200.40380859 150.29296874a39.55078125 39.55078125 0 0 0 63.28125-31.64062499v-514.16015625a39.55078125 39.55078125 0 0 0-7.91015625-23.73046875z m206.69238281 132.49511719c63.55810547 39.35302734 97.84863281 90.76904297 97.84863282 152.27050782 0 61.50146484-34.29052734 112.95703125-97.84863282 152.27050781a39.55078125 39.55078125 0 0 1-41.60742187-67.23632813c41.92382813-25.98486328 60.35449219-53.63085938 60.35449219-85.03417968 0-31.40332031-18.43066406-59.04931641-60.35449219-85.03417969a39.55078125 39.55078125 0 1 1 41.60742187-67.23632813z"
              fill="''' + getColor(0, color, colors, '#333333') + '''"
            />
          </svg>
        ''';
        break;
      case IconNames.qiehuanquanping:
        svgXml = '''
          <svg viewBox="0 0 1024 1024" xmlns="http://www.w3.org/2000/svg">
            <path
              d="M905.92578125 181.8828125a26.3671875 26.3671875 0 0 0-26.3671875 26.3671875V881.140625H205.61328125a26.3671875 26.3671875 0 0 0 0 52.734375h700.3125a26.3671875 26.3671875 0 0 0 26.3671875-26.3671875V208.25a26.3671875 26.3671875 0 0 0-26.3671875-26.3671875z"
              fill="''' + getColor(0, color, colors, '#333333') + '''"
            />
            <path
              d="M414.44140625 783.58203125a26.3671875 26.3671875 0 0 0-26.3671875-26.3671875H142.859375V142.859375h614.35546875v247.8515625a26.3671875 26.3671875 0 0 0 52.734375 0V116.4921875a26.3671875 26.3671875 0 0 0-26.3671875-26.3671875H116.4921875a26.3671875 26.3671875 0 0 0-26.3671875 26.3671875v667.08984375a26.3671875 26.3671875 0 0 0 26.3671875 26.3671875h271.58203125a26.3671875 26.3671875 0 0 0 26.3671875-26.3671875z"
              fill="''' + getColor(1, color, colors, '#333333') + '''"
            />
            <path
              d="M605.33984375 783.58203125a26.3671875 26.3671875 0 0 0 26.3671875 26.3671875h151.875a26.3671875 26.3671875 0 0 0 26.3671875-26.3671875v-151.34765625a26.3671875 26.3671875 0 1 0-52.734375 0v87.5390625L301.0625 263.62109375h87.5390625a26.3671875 26.3671875 0 0 0 0-52.734375H237.25390625a26.3671875 26.3671875 0 0 0-26.3671875 26.3671875v152.40234375a26.3671875 26.3671875 0 0 0 52.734375 0V301.0625l456.15234375 456.15234375h-88.06640625a26.3671875 26.3671875 0 0 0-26.3671875 26.3671875z"
              fill="''' + getColor(2, color, colors, '#333333') + '''"
            />
          </svg>
        ''';
        break;
      case IconNames.chuangzuozhezhongxin:
        svgXml = '''
          <svg viewBox="0 0 1024 1024" xmlns="http://www.w3.org/2000/svg">
            <path
              d="M821.375 830.75000029a28.125 28.125 0 0 1 0 56.25h-618.75a28.125 28.125 0 0 1 0-56.25h618.75zM811.99999971 136.99999971a112.5 112.5 0 0 1 112.5 112.5v412.50000058a112.5 112.5 0 0 1-112.5 112.5H212.00000029a112.5 112.5 0 0 1-112.5-112.5V249.49999971a112.5 112.5 0 0 1 112.5-112.5h599.99999942z m0 56.25H212.00000029a56.25 56.25 0 0 0-56.15625058 52.95000058L155.75000029 249.49999971v412.50000058a56.25 56.25 0 0 0 52.94999971 56.15624971L212.00000029 718.25000029h599.99999942a56.25 56.25 0 0 0 56.15625058-52.95000058L868.24999971 662.00000029V249.49999971a56.25 56.25 0 0 0-52.94999971-56.15624971L811.99999971 193.24999971z m-36.41249971 111.31875a28.125 28.125 0 0 1 2.025 37.63125l-1.93124971 2.1375-186.65625058 187.50000058a28.125 28.125 0 0 1-37.59374971 2.06249942l-2.1375-1.93124971L455.75 439.19375029l-167.625 167.69999971a28.125 28.125 0 0 1-37.64999971 1.93124971l-2.1375-1.93124971a28.125 28.125 0 0 1-1.93125058-37.64999971l1.93125058-2.1375 187.44374971-187.50000058a28.125 28.125 0 0 1 37.575-1.98749971l2.1375 1.9125 93.43125 92.71874971 166.87500029-167.58749971a28.125 28.125 0 0 1 39.76875-0.09375029z"
              fill="''' + getColor(0, color, colors, '#333333') + '''"
            />
          </svg>
        ''';
        break;
      case IconNames.pinglun_1:
        svgXml = '''
          <svg viewBox="0 0 1024 1024" xmlns="http://www.w3.org/2000/svg">
            <path
              d="M157.568 751.296c-11.008-18.688-18.218667-31.221333-21.802667-37.909333A424.885333 424.885333 0 0 1 85.333333 512C85.333333 276.362667 276.362667 85.333333 512 85.333333s426.666667 191.029333 426.666667 426.666667-191.029333 426.666667-426.666667 426.666667a424.778667 424.778667 0 0 1-219.125333-60.501334 2786.56 2786.56 0 0 0-20.053334-11.765333l-104.405333 28.48c-23.893333 6.506667-45.802667-15.413333-39.285333-39.296l28.437333-104.288z m65.301333 3.786667l-17.258666 63.306666 63.306666-17.258666a32 32 0 0 1 24.522667 3.210666 4515.84 4515.84 0 0 1 32.352 18.944A360.789333 360.789333 0 0 0 512 874.666667c200.298667 0 362.666667-162.368 362.666667-362.666667S712.298667 149.333333 512 149.333333 149.333333 311.701333 149.333333 512c0 60.586667 14.848 118.954667 42.826667 171.136 3.712 6.912 12.928 22.826667 27.370667 47.232a32 32 0 0 1 3.338666 24.714667z m145.994667-70.773334a32 32 0 1 1 40.917333-49.205333A159.189333 159.189333 0 0 0 512 672c37.888 0 73.674667-13.173333 102.186667-36.885333a32 32 0 0 1 40.917333 49.216A223.178667 223.178667 0 0 1 512 736a223.178667 223.178667 0 0 1-143.136-51.690667z"
              fill="''' + getColor(0, color, colors, '#333333') + '''"
            />
          </svg>
        ''';
        break;
      case IconNames.biaojiyidu:
        svgXml = '''
          <svg viewBox="0 0 1024 1024" xmlns="http://www.w3.org/2000/svg">
            <path
              d="M895.946667 734.048l1.066666 1.013333a29.824 29.824 0 0 1 0 43.413334l-162.261333 152.96a31.925333 31.925333 0 0 1-22.762667 8.704 31.925333 31.925333 0 0 1-22.773333-8.704l-93.184-87.84a29.824 29.824 0 0 1 0-43.413334l1.077333-1.013333a32 32 0 0 1 43.904 0l70.976 66.901333 140.053334-132.021333a32 32 0 0 1 43.904 0zM768 85.333333c64.8 0 117.333333 52.533333 117.333333 117.333334v394.666666a32 32 0 0 1-64 0V202.666667a53.333333 53.333333 0 0 0-53.333333-53.333334H256a53.333333 53.333333 0 0 0-53.333333 53.333334v618.666666a53.333333 53.333333 0 0 0 53.333333 53.333334h234.666667a32 32 0 0 1 0 64H256c-64.8 0-117.333333-52.533333-117.333333-117.333334V202.666667c0-64.8 52.533333-117.333333 117.333333-117.333334zM554.666667 544a32 32 0 0 1 0 64H341.333333a32 32 0 0 1 0-64z m128-170.666667a32 32 0 0 1 0 64H341.333333a32 32 0 0 1 0-64z"
              fill="''' + getColor(0, color, colors, '#333333') + '''"
            />
          </svg>
        ''';
        break;
      case IconNames.guaduan:
        svgXml = '''
          <svg viewBox="0 0 1070 1024" xmlns="http://www.w3.org/2000/svg">
            <path
              d="M249.95717568 98.04644104l-3.01305674 2.19131367C139.33495537 177.95113577 88.54343076 263.33411555 101.45653056 355.21277591c16.51311563 117.31355332 100.01782617 248.08803487 212.36179219 361.95809589l5.28263174 5.3217624c116.84398623 116.7657249 259.08373477 209.46612832 372.13205273 220.77487267 86.7134206 8.64786357 170.68769824-42.33931435 252.39240176-147.01368252l0.46956709-0.58695909 1.40870215-1.87826924a79.04382188 79.04382188 0 0 0-16.31746231-109.0569955 1919.59095498 1919.59095498 0 0 0-85.85254688-61.82635606 1552.89805575 1552.89805575 0 0 0-66.75681181-42.88714277 111.83526914 111.83526914 0 0 0-125.64837246 6.65220234l-44.60889024 34.04362676a11.73918164 11.73918164 0 0 1-12.75657714 0.93913418c-33.53492813-18.15660089-66.63941982-43.43497119-99.23521377-75.99163447-31.85231221-31.85231221-55.76111191-63.19592666-71.8829209-93.91345225a11.66092031 11.66092031 0 0 1 1.05652616-12.52179317l34.43493253-45.15671777c27.82185996-36.5088542 30.52187227-86.32211484 6.73046367-125.60924179a1537.67625117 1537.67625117 0 0 0-43.16105742-67.18724912 1937.86494698 1937.86494698 0 0 0-62.68722891-86.79168194 79.1220832 79.1220832 0 0 0-108.86134306-16.43485342z m46.64368125 63.86114708a1859.99504326 1859.99504326 0 0 1 60.14374014 83.3090581c14.47832373 21.28704873 28.13490528 42.57409834 40.96974286 63.78288574 7.12177031 11.73918164 6.30002724 26.68707246-2.03479101 37.60451104l-34.43493253 45.19584931a89.92212979 89.92212979 0 0 0-8.10003515 96.33954903c20.03487011 38.11320878 48.71760293 75.7177207 85.89167754 112.85266465 37.72190302 37.72190302 76.77424687 67.57855488 117.27442266 89.49169336a90.00039113 90.00039113 0 0 0 97.39607607-7.55220675l44.60888936-33.96536542a33.57405878 33.57405878 0 0 1 37.72190303-1.99566036c20.34791455 12.28701006 41.47844151 25.90446006 63.39157998 40.73495977 27.39142354 18.54790665 54.82197773 38.34799278 82.36992393 59.28286641l0.15652177 0.19565244a0.78261241 0.78261241 0 0 1 0.11739199 0.66522041l-0.07826133 0.19565331-0.27391376 0.39130578 0.2347831-0.31304444c-66.91333447 85.65689443-127.99620878 122.75270771-182.93557763 117.27442265-90.31343643-9.00003955-219.48356338-93.20910117-324.51010664-198.19651377l-5.08697844-5.08697842c-101.46565898-102.91349092-176.83120372-220.85313398-190.44865458-317.81877362-8.21742714-58.38286289 27.39142354-118.17442705 113.67440772-180.54861066l2.89566475-2.07392256c0.19565332-0.15652266 0.58695908-0.11739199 0.86087285 0.07826134l0.19565332 0.15652266z"
              fill="''' + getColor(0, color, colors, '#333333') + '''"
            />
          </svg>
        ''';
        break;
      case IconNames.maikefengline:
        svgXml = '''
          <svg viewBox="0 0 1024 1024" xmlns="http://www.w3.org/2000/svg">
            <path
              d="M401.94748666 933.875a36.6847825 36.6847825 0 0 1 0-73.369565h73.36956501v-75.64402167a293.55163083 293.55163083 0 0 1-256.75679335-286.36141333L218.52357334 493.65760834v-36.6847825a36.6847825 36.6847825 0 0 1 73.369565-1.02717335V493.65760834a220.10869582 220.10869582 0 0 0 440.21739166 3.66847833V456.97282584a36.6847825 36.6847825 0 0 1 73.369565-1.02717335V493.65760834a293.51494582 293.51494582 0 0 1-256.75679333 291.20380499L548.68661668 860.50543499h73.36956499a36.6847825 36.6847825 0 0 1 0 73.36956501H401.94748666zM512.00183417 90.125a146.73913083 146.73913083 0 0 1 146.73913082 146.73913083v256.79347751a146.73913083 146.73913083 0 1 1-293.47826083-1e-8V236.86413083a146.73913083 146.73913083 0 0 1 146.73913-146.73913083z m0 73.369565a73.369565 73.369565 0 0 0-73.369565 73.36956583v256.7934775a73.369565 73.369565 0 1 0 146.73913 0V236.86413083a73.369565 73.369565 0 0 0-73.36956501-73.36956582z"
              fill="''' + getColor(0, color, colors, '#333333') + '''"
            />
          </svg>
        ''';
        break;
      case IconNames.jingyinline:
        svgXml = '''
          <svg viewBox="0 0 1024 1024" xmlns="http://www.w3.org/2000/svg">
            <path
              d="M254.85233041 420.28804333a36.6847825 36.6847825 0 0 1 36.68478251 35.65760916V493.65760834a220.10869582 220.10869582 0 0 0 304.70380416 203.23369583l54.95380418 55.02717416a291.4972825 291.4972825 0 0 1-102.82744584 32.942935L548.33059125 860.50543499h73.369565a36.6847825 36.6847825 0 0 1 0 73.36956501H401.59146042a36.6847825 36.6847825 0 0 1 0-73.369565h73.369565v-75.64402167a293.55163083 293.55163083 0 0 1-256.75679333-286.36141333L218.16754791 493.65760834v-36.6847825a36.6847825 36.6847825 0 0 1 36.6847825-36.68478251z m110.05434751 45.30570667l172.52853251 172.5285325A146.73913083 146.73913083 0 0 1 364.90667791 493.65760834v-28.06385834z m366.84782584 31.69565249V456.97282584a36.6847825 36.6847825 0 0 1 73.36956582-1.02717335V493.65760834c0 58.32880418-17.02173916 112.6222825-46.33288083 158.33152249l109.65081501 109.65081499a36.6847825 36.6847825 0 0 1 3.04483749 48.42391251l-3.04483749 3.44837a36.6847825 36.6847825 0 0 1-51.8722825 0L175.83330874 172.77581501A36.6847825 36.6847825 0 1 1 227.66890625 120.9402175L364.90667791 258.14130418V236.86413083A146.73913083 146.73913083 0 0 1 504.30885207 90.30842416L511.64580874 90.125a146.73913083 146.73913083 0 0 1 146.73913001 146.73913083v256.79347751c0 17.3152175-3.00815249 33.97010834-8.51086917 49.3777175L585.01537375 478.25V236.86413083a73.369565 73.369565 0 0 0-67.86684833-73.18614167L511.64580874 163.49456501a73.369565 73.369565 0 0 0-73.36956582 73.36956582v94.64673834l266.95516333 266.95516333A219.00815249 219.00815249 0 0 0 731.75450376 497.32608667z"
              fill="''' + getColor(0, color, colors, '#333333') + '''"
            />
          </svg>
        ''';
        break;
      case IconNames.shexiangtouguanbi:
        svgXml = '''
          <svg viewBox="0 0 1117 1024" xmlns="http://www.w3.org/2000/svg">
            <path
              d="M947.99343054 133.82262067l0.07191059 0.07191058a35.27210589 35.27210589 0 0 1 0 49.83398438L264.12446705 869.68288366a35.09232983 35.09232983 0 0 1-49.61825263 0.07191059l-0.07191059-0.07191059a35.27210589 35.27210589 0 0 1 0-49.83398437L898.37517791 133.89453125a35.09232983 35.09232983 0 0 1 49.61825264-0.07191058z m23.514737 125.59170831a53.93288366 53.93288366 0 0 1 7.91015625 28.11700958V664.09073175a53.93288366 53.93288366 0 0 1-85.21395575 43.97327776L763.68678991 615.26349397v15.20907372c0 38.72381072-3.59552522 60.18909808-13.59108678 81.00719098l-2.6606892 5.21351215a117.82537322 117.82537322 0 0 1-48.93510249 48.82723699l-1.68989751 0.89888111c-20.99786897 10.858487-41.92382813 14.95738629-79.85662245 15.24502862H450.5524679l71.73073522-71.91051129h91.90163367c26.60688892-0.07191058 37.75301825-1.797763 46.88565362-5.89666228l2.48091236-1.18652344 1.22247834-0.68314936c8.41352955-4.45845143 14.74165455-10.82253211 19.23606242-19.23606166 5.75284113-10.71466584 7.76633508-21.17764582 7.7663351-52.27894182l-0.0359557-90.60724476L763.68678991 467.66717009v59.32617188l143.82102259 102.25674659V323.5225495zM612.49493928 170.42507116c41.95978303 0 63.64080291 4.17080988 86.22070313 16.25177521 9.09667969 4.85395924 17.36638884 10.78657642 24.73721611 17.6180755L672.61212678 255.27947478a47.82049041 47.82049041 0 0 0-7.83824567-5.17755724c-10.71466584-5.75284113-21.17764582-7.76633508-52.27894183-7.76633508H265.81436457c-28.90802522 0.10786549-39.51482634 2.08540455-49.18678993 7.08318495l-1.22247911 0.68315013c-8.41352955 4.45845143-14.74165455 10.82253211-19.23606166 19.23606164C190.41619353 280.05264582 188.40269879 290.515625 188.40269879 321.61692102v310.72531947c0.10786549 28.90802522 2.08540455 39.51482634 7.08318572 49.1867899l0.68314936 1.22247912c4.45845143 8.41352955 10.82253211 14.74165455 19.23606166 19.23606165 2.58877863 1.40225519 5.17755647 2.58877863 8.0539774 3.55957031L170.42507116 758.72496442a117.86132813 117.86132813 0 0 1-37.78897393-42.24742536l-0.8988811-1.68989673c-11.07421875-21.46528736-15.10120746-42.78675433-15.24502863-82.33753558V321.61692102c0-41.95978303 4.17080988-63.64080291 16.25177522-86.22070312A117.82537322 117.82537322 0 0 1 181.67906598 186.6049358l1.68989674-0.89888111c21.46528736-11.07421875 42.78675433-15.10120746 82.33753558-15.24502863z"
              fill="''' + getColor(0, color, colors, '#333333') + '''"
            />
          </svg>
        ''';
        break;
      case IconNames.shexiangtoukaiqi:
        svgXml = '''
          <svg viewBox="0 0 1365 1024" xmlns="http://www.w3.org/2000/svg">
            <path
              d="M766.80666215 138.4648434c51.28417943 0 77.78320287 5.09765617 105.38085971 19.86328143a143.74511753 143.74511753 0 0 1 59.54589809 59.54589886c14.23828125 26.63085963 19.46777362 52.20703125 19.86328143 99.97558577v20.87402327l160.13671867-111.26953151a65.9179685 65.9179685 0 0 1 87.89062516 11.42578194l3.86718734 5.05371077a65.9179685 65.9179685 0 0 1 11.77734359 37.66113298V741.83398446a65.9179685 65.9179685 0 0 1-104.15039013 53.7451171L951.59670138 682.15625018v18.58886719c0 47.32910131-4.39453133 73.56445313-16.61132812 99.00878853l-3.25195331 6.37207041a143.74511753 143.74511753 0 0 1-59.54589808 59.54589887c-26.63085963 14.23828125-52.20703125 19.46777362-99.97558577 19.86328142H345.37111561c-51.28417943 0-77.78320287-5.09765617-105.38085971-19.86328143a143.74511753 143.74511753 0 0 1-59.54589809-59.54589886c-13.97460963-26.14746102-19.29199202-51.28417943-19.81933603-97.5585935L160.58107638 703.16210963V323.25488265c0-51.28417943 5.09765617-77.78320287 19.86328143-105.38085896A143.74511753 143.74511753 0 0 1 239.99025589 158.32812483C266.13771692 144.35351597 291.2744361 139.03613281 337.54885016 138.50878881L342.95412335 138.4648434z m-1e-8 87.89062518H343.08595954c-34.93652369 0.13183619-47.76855452 2.41699227-60.16113291 8.70117188l-1.45019582 0.79101563c-10.28320313 5.44921858-18.01757778 13.22753941-23.51074175 23.51074253C250.93263923 272.45410182 248.47170156 285.24218725 248.47170156 323.25488265v379.77539079c0.13183619 34.93652369 2.41699227 47.76855452 8.70117188 60.16113289l0.79101562 1.45019505c5.44921858 10.28320313 13.22753941 18.01757778 23.51074175 23.51074255 13.09570321 7.03124982 25.88378941 9.4921875 63.89648481 9.49218749h421.43554653c36.60644497 0 49.83398438-2.28515609 62.44628898-8.70117188l1.45019582-0.79101561c10.28320313-5.44921858 18.01757778-13.22753941 23.51074176-23.51074255 7.03124982-13.09570321 9.4921875-25.88378941 9.4921875-63.89648401v-377.49023472c0-36.60644497-2.28515609-49.83398438-8.70117187-62.44628898l-0.79101563-1.45019505a55.89843775 55.89843775 0 0 0-23.51074176-23.51074253c-13.09570321-7.03124982-25.88378941-9.4921875-63.8964848-9.49218751zM1127.37795173 323.60644506l-175.78125035 122.21191405v128.54003907l175.78125035 124.93652335V323.60644506z"
              fill="''' + getColor(0, color, colors, '#333333') + '''"
            />
          </svg>
        ''';
        break;
      case IconNames.fanzhuanxiangji:
        svgXml = '''
          <svg viewBox="0 0 1185 1024" xmlns="http://www.w3.org/2000/svg">
            <path
              d="M746.24033733 116.4921875a83.26480288 83.26480288 0 0 1 77.311369 52.33192829L852.56949037 241.38939181H927.5078125a124.89720431 124.89720431 0 0 1 124.89720431 124.89720355v416.32401283a124.89720431 124.89720431 0 0 1-124.89720431 124.89720431H261.38939181a124.89720431 124.89720431 0 0 1-124.89720431-124.89720431V366.28659536a124.89720431 124.89720431 0 0 1 124.89720431-124.89720355h74.93832213l29.01778326-72.56527602A83.26480288 83.26480288 0 0 1 442.65686697 116.4921875h303.58347036z m0 83.26480288H442.65686697l-49.95888141 124.89720354H261.38939181a41.63240144 41.63240144 0 0 0-41.63240143 39.84220793V782.61060819a41.63240144 41.63240144 0 0 0 39.84220793 41.63240143H927.5078125a41.63240144 41.63240144 0 0 0 41.63240144-39.84220794V366.28659536a41.63240144 41.63240144 0 0 0-39.84220795-41.63240144h-133.09878724l-49.95888142-124.89720355z m29.55900481 291.34354408a191.50904569 191.50904569 0 0 1-235.22306731 242.3005761l-6.86934654-2.206518 17.65213861 31.93205246-43.6307572 24.23005692-64.61348639-116.52909096 116.57072356-64.57185456 24.14679248 43.63075641-40.88301764 22.77292348a133.22368429 133.22368429 0 0 0 177.31239704-163.82349881l55.49599079-17.73540304z m-94.63044831-187.84539502l64.61348716 116.52909173-116.57072356 64.57185456-24.14679325-43.63075642 31.34919832-17.48560895a133.22368429 133.22368429 0 0 0-170.06835938 166.52960498l-55.49599079 17.77703564a191.50904569 191.50904569 0 0 1 250.46052644-237.2630549l-23.77210136-42.79810896 43.63075642-24.23005768z"
              fill="''' + getColor(0, color, colors, '#333333') + '''"
            />
          </svg>
        ''';
        break;
      case IconNames.xiangzuo:
        svgXml = '''
          <svg viewBox="0 0 1024 1024" xmlns="http://www.w3.org/2000/svg">
            <path
              d="M759.28910416 119.40184793v785.19630414c0 31.06891852-19.77112986 39.54225971-45.19115344 19.77112986l-508.40048496-392.59815207c-14.12223613-11.29778866-14.12223613-31.06891852 0-42.36670718l508.40048496-392.59815208c25.4200248-16.94668239 45.19115466-8.47334119 45.19115344 22.59557733z"
              fill="''' + getColor(0, color, colors, '#333333') + '''"
            />
          </svg>
        ''';
        break;
      case IconNames.xiangyou:
        svgXml = '''
          <svg viewBox="0 0 1024 1024" xmlns="http://www.w3.org/2000/svg">
            <path
              d="M796.96920091 492.22887014l-508.40048496-392.59815207c-25.4200248-19.77112986-45.19115466-11.29778866-45.19115344 19.77112986v785.19630414c0 31.06891852 19.77112986 39.54225971 45.19115344 19.77112986l508.40048496-392.59815207c14.12223613-11.29778866 14.12223613-28.24447105 0-39.54225972z"
              fill="''' + getColor(0, color, colors, '#333333') + '''"
            />
          </svg>
        ''';
        break;
      case IconNames.fuzhuxian:
        svgXml = '''
          <svg viewBox="0 0 1024 1024" xmlns="http://www.w3.org/2000/svg">
            <path
              d="M765.42085028 126.77855056a88.37381268 88.37381268 0 1 1 30.22384393 144.80049205L264.78320148 802.44053536a88.37381268 88.37381268 0 1 1-59.43138903-53.11266143L742.5320328 212.1918405a88.37381268 88.37381268 0 0 1 22.88881748-85.41328994z"
              fill="''' + getColor(0, color, colors, '#333333') + '''"
            />
          </svg>
        ''';
        break;
      case IconNames.tuse:
        svgXml = '''
          <svg viewBox="0 0 1024 1024" xmlns="http://www.w3.org/2000/svg">
            <path
              d="M200.71999971 932.00000029A78.59999971 78.59999971 0 0 1 122.00000029 853.28c0-43.44000029 78.72000029-183.96 78.71999942-183.96s78.72000029 140.51999971 78.72000029 183.96A78.77999971 78.77999971 0 0 1 200.71999971 932.00000029m708.66-390.48000029L568.61 878.90000029 227.6 541.76000029 568.61 204.62000029l340.80000029 336.89999971m-340.80000029-262.19999971l-236.54999971 232.29h472.86l-236.31000029-232.26000029m151.44000029-149.94l-113.52000058 112.5-37.91999971-37.41000029L682.12999971 91.99999971l37.92000058 37.41000029"
              fill="''' + getColor(0, color, colors, '#333333') + '''"
            />
          </svg>
        ''';
        break;
      case IconNames.baocun:
        svgXml = '''
          <svg viewBox="0 0 1024 1024" xmlns="http://www.w3.org/2000/svg">
            <path
              d="M834.992 102.4a54.59093333 54.59093333 0 0 1 54.59093333 54.59093333V866.144a54.59093333 54.59093333 0 0 1-54.59093333 54.56746667H180.4512a54.59093333 54.59093333 0 0 1-54.58986667-54.56746667V156.99093333A54.59093333 54.59093333 0 0 1 180.4512 102.4h654.56426667zM316.8256 429.6928a54.4992 54.4992 0 0 1-54.59093333-54.4992V156.96746667h-81.78346667v709.1776h654.67733333V156.99093333H753.30133333v218.112a54.59093333 54.59093333 0 0 1-54.59093333 54.58986667H316.8256z m0-54.4992h381.86133333V156.96746667H316.8256v218.22613333z m381.77066667 218.1344a27.2608 27.2608 0 1 1 0.09066666 54.4768H316.8256a27.2384 27.2384 0 1 1 0-54.4768h381.77066667z"
              fill="''' + getColor(0, color, colors, '#333333') + '''"
            />
          </svg>
        ''';
        break;
      case IconNames.huizhiguiji:
        svgXml = '''
          <svg viewBox="0 0 1024 1024" xmlns="http://www.w3.org/2000/svg">
            <path
              d="M828.66666667 631.66333334c-44.93 0.94-84.63 32.13-99.63 78.29-1.86 5.85-6.93 9.77-12.61 9.75H252.74666667c-44.57 0.27-81.04-38.56-81.84-87.1-0.2-23.5 8.22-46.11 23.4-62.81 15.17-16.7 35.84-26.1 57.41-26.12h484.71c35.8 0 69.54-15.33 95.1-43.11 25.37-27.39 39.62-64.7 39.57-103.61 0-39.06-14.07-75.76-39.57-103.61-25.16-27.6-59.4-43.1-95.1-43.05H298.67666667c-5.68 0.02-10.75-3.9-12.62-9.75-14.95-46.2-54.67-77.41-99.63-78.29C126.62666667 161.53333334 77.54666667 213.63333334 76.66666667 278.78333334c-0.39 57.33 37.29 106.58 89.12 116.47 51.83 9.89 102.64-22.46 120.15-76.53 1.92-5.86 7.01-9.76 12.72-9.75h436.73c44.47 0 81.4 38.65 81.83 87.1 0.2 23.5-8.22 46.11-23.4 62.81-15.18 16.7-35.84 26.1-57.41 26.11H251.71666667c-35.8 0-69.54 15.27-95.1 43.05-25.37 27.4-39.63 64.7-39.63 103.61s14.27 76.21 39.63 103.61c25.5 27.78 59.3 43.11 95.1 43.11h464.7c5.71 0 10.78 3.93 12.67 9.81 17.74 53.76 68.41 85.81 120.06 75.95 51.65-9.85 89.3-58.76 89.22-115.89-0.85-65.14-49.9-117.27-109.7-116.58zM184.43666667 338.28333334c-28.81-1.41-51.5-27.26-51.5-58.67 0-31.42 22.69-57.27 51.5-58.68 28.81 1.4 51.5 27.26 51.5 58.68 0 31.42-22.69 57.27-51.5 58.67z m646.22 469.41c-28.81-1.41-51.5-27.26-51.5-58.67s22.69-57.27 51.5-58.68c28.81 1.41 51.5 27.26 51.5 58.68s-22.69 57.26-51.5 58.67z m0 0"
              fill="''' + getColor(0, color, colors, '#333333') + '''"
            />
          </svg>
        ''';
        break;
      case IconNames.quxiao_circle:
        svgXml = '''
          <svg viewBox="0 0 1024 1024" xmlns="http://www.w3.org/2000/svg">
            <path
              d="M512 933.875a425.7421875 425.7421875 0 0 1-168.6234375-35.0015625 31.921875 31.921875 0 0 1 25.453125-58.5421875 359.690625 359.690625 0 1 0-152.071875-125.9859375 32.034375 32.034375 0 0 1-52.81875 36.2671875A421.9734375 421.9734375 0 1 1 512 933.875z"
              fill="''' + getColor(0, color, colors, '#333333') + '''"
            />
            <path
              d="M390.0078125 665.1125a32.9484375 32.9484375 0 0 1-23.371875-9.7453125 33.3421875 33.3421875 0 0 1 0-46.1109375l245.4609375-242.2125a32.6109375 32.6109375 0 1 1 46.1109375 46.1109375L412.746875 655.3671875a31.5 31.5 0 0 1-22.7390625 9.7453125z"
              fill="''' + getColor(1, color, colors, '#333333') + '''"
            />
            <path
              d="M643.8359375 665.0984375a30.459375 30.459375 0 0 1-22.725-9.7453125L378.8984375 413.140625a32.6109375 32.6109375 0 0 1 46.1109375-46.1109375l242.2125 242.2125a32.146875 32.146875 0 0 1 0 46.1109375 32.9484375 32.9484375 0 0 1-23.3859375 9.7453125z"
              fill="''' + getColor(2, color, colors, '#333333') + '''"
            />
          </svg>
        ''';
        break;
      case IconNames.bofangzhong:
        svgXml = '''
          <svg viewBox="0 0 1024 1024" xmlns="http://www.w3.org/2000/svg">
            <path
              d="M544 128v768h-64V128h64z m-192 128v512H288V256h64z m384 0v512h-64V256h64zM160 384v256H96v-256h64z m768 0v256h-64v-256h64z"
              fill="''' + getColor(0, color, colors, '#333333') + '''"
            />
          </svg>
        ''';
        break;
      case IconNames.shipinliebiao:
        svgXml = '''
          <svg viewBox="0 0 1024 1024" xmlns="http://www.w3.org/2000/svg">
            <path
              d="M902.779659 795.440467c-6.179746-6.181793-14.304797-9.577123-22.950711-9.577123L129.341299 785.863345c-17.945721 0-32.540114 14.59644-32.540114 32.525788 0 17.962094 14.594393 32.555463 32.540114 32.555463l750.487649 0c17.931395 0 32.525788-14.594393 32.525788-32.555463C912.354735 809.745265 908.959406 801.61919 902.779659 795.440467"
              fill="''' + getColor(0, color, colors, '#333333') + '''"
            />
            <path
              d="M879.828948 461.055724 129.341299 461.055724c-17.945721 0-32.525788 14.594393-32.525788 32.541137 0 17.930371 14.580067 32.525788 32.525788 32.525788l750.487649 0c17.931395 0 32.525788-14.594393 32.525788-32.525788 0-8.647961-3.39533-16.800641-9.575076-22.980387C896.599913 464.436728 888.474862 461.055724 879.828948 461.055724"
              fill="''' + getColor(1, color, colors, '#333333') + '''"
            />
            <path
              d="M902.779659 154.426115c-6.179746-6.179746-14.304797-9.574053-22.950711-9.574053L129.341299 144.852062c-17.945721 0-32.540114 14.594393-32.540114 32.540114 0 17.946744 14.594393 32.525788 32.540114 32.525788l750.487649 0c17.931395 0 32.525788-14.579043 32.525788-32.525788C912.354735 168.745239 908.959406 160.606885 902.779659 154.426115"
              fill="''' + getColor(2, color, colors, '#333333') + '''"
            />
          </svg>
        ''';
        break;
      case IconNames.guankanlishi:
        svgXml = '''
          <svg viewBox="0 0 1024 1024" xmlns="http://www.w3.org/2000/svg">
            <path
              d="M511.998125 92C280.038125 92 92 280.038125 92 511.998125S280.038125 932 511.998125 932 932 743.958125 932 511.998125 743.958125 92 511.998125 92z m331.7353125 560.098125c-77.0765625 182.4825-287.4909375 267.931875-469.974375 190.8553125S105.8271875 555.4625 182.90375 372.9790625 470.3946875 105.0471875 652.878125 182.12375c157.5084375 66.5278125 246.159375 234.98625 211.805625 402.4809375a359.9953125 359.9953125 0 0 1-20.9503125 67.4934375z"
              fill="''' + getColor(0, color, colors, '#333333') + '''"
            />
            <path
              d="M541.3540625 499.4740625V272.1134375c0-16.5534375-13.419375-29.971875-29.971875-29.971875s-29.971875 13.419375-29.971875 29.971875v252.1921875l188.8884375 188.8884375c11.7046875 11.7046875 30.6825 11.7046875 42.3871875 0s11.7046875-30.6825 0-42.3871875L541.3540625 499.4740625z"
              fill="''' + getColor(1, color, colors, '#333333') + '''"
            />
          </svg>
        ''';
        break;
      case IconNames.guankan:
        svgXml = '''
          <svg viewBox="0 0 1024 1024" xmlns="http://www.w3.org/2000/svg">
            <path
              d="M166.632727 891.112727c-9.774545 0-19.549091-2.56-28.16-7.912727-13.730909-8.610909-22.109091-23.04-22.109091-38.632727V180.596364c0-15.592727 8.378182-30.021818 22.109091-38.632728 15.592727-9.774545 35.607273-10.705455 52.130909-2.327272l333.730909 165.934545c11.403636 5.818182 16.290909 19.781818 10.472728 31.185455-5.818182 11.403636-19.781818 16.290909-31.185455 10.472727L169.890909 181.294545c-3.258182-1.629091-6.749091 0-7.214545 0.698182L162.909091 844.567273c0.232727-0.465455 1.629091 0 3.258182 0 1.163636 0 2.327273-0.232727 3.490909-0.698182L835.490909 512.465455l-224.116364-111.709091c-11.403636-5.818182-16.290909-19.781818-10.472727-31.185455 5.818182-11.403636 19.781818-16.290909 31.185455-10.472727l225.745454 112.407273c16.290909 8.145455 26.298182 23.738182 26.298182 40.96s-10.007273 32.814545-26.298182 40.96L190.603636 885.527273c-7.68 3.723636-15.825455 5.585455-23.970909 5.585454z m671.650909-377.250909h0.232728-0.232728z"
              fill="''' + getColor(0, color, colors, '#333333') + '''"
            />
          </svg>
        ''';
        break;
      case IconNames.sayhi:
        svgXml = '''
          <svg viewBox="0 0 1024 1024" xmlns="http://www.w3.org/2000/svg">
            <path
              d="M965.888 459.7248c0-201.8816-201.216-365.568-449.4848-365.568s-449.4848 163.6352-449.4848 365.568c0 178.2272 156.8768 326.5536 364.3904 358.912l55.5008 97.0752c12.7488 22.3232 45.2096 21.7088 57.088-1.1264l49.2032-94.72c211.712-29.5936 372.7872-179.5072 372.7872-360.1408z"
              fill="''' + getColor(0, color, colors, '#f39996') + '''"
            />
            <path
              d="M516.4544 218.0096c-222.3104 0-406.8352 131.328-442.9312 303.7696 31.488 149.76 175.0016 268.3904 357.888 296.8576l55.5008 97.0752c12.7488 22.3232 45.2096 21.7088 57.088-1.1264l49.2032-94.72c186.88-26.1632 334.2848-146.0736 366.2336-298.1376-36.1984-172.3904-220.672-303.7184-442.9824-303.7184z"
              fill="''' + getColor(1, color, colors, '#e8817d') + '''"
            />
            <path
              d="M516.4544 341.8624c-194.7648 0-360.5504 100.7616-422.9632 241.7152 53.0944 119.8592 180.992 210.688 337.92 235.1104l55.5008 97.0752c12.7488 22.3232 45.2096 21.7088 57.088-1.1264l49.2032-94.72c160.7168-22.4768 292.2496-114.3808 346.2656-236.3904-62.5152-140.9024-228.2496-241.664-423.0144-241.664z"
              fill="''' + getColor(2, color, colors, '#dd6d6a') + '''"
            />
            <path
              d="M516.4544 465.664c-164.864 0-308.8896 72.192-387.1232 179.8144 64.4096 88.576 173.4656 153.1392 302.0288 173.1584l55.5008 97.0752c12.7488 22.3232 45.2096 21.7088 57.088-1.1264l49.2032-94.72c132.1472-18.4832 244.5824-83.8656 310.4256-174.336-78.2336-107.6224-222.2592-179.8656-387.1232-179.8656z"
              fill="''' + getColor(3, color, colors, '#d45f5b') + '''"
            />
            <path
              d="M486.8608 915.7632c12.7488 22.3232 45.2096 21.7088 57.088-1.1264l49.2032-94.72c99.6864-13.9264 188.1088-54.5792 253.7984-112.4864-82.1248-72.448-199.7824-117.8624-330.496-117.8624-130.7136 0-248.3712 45.4144-330.496 117.8624 63.8464 56.32 149.1968 96.3072 245.4016 111.3088l55.5008 97.024z"
              fill="''' + getColor(4, color, colors, '#C34D49') + '''"
            />
            <path
              d="M518.0416 275.712c-19.8144 0-35.84 16.0256-35.84 35.84v91.1872H382.2592V311.552c0-19.8144-16.0256-35.84-35.84-35.84s-35.84 16.0256-35.84 35.84v254.1056c0 19.8144 16.0256 35.84 35.84 35.84s35.84-16.0256 35.84-35.84V474.4192h99.9424v91.1872c0 19.8144 16.0256 35.84 35.84 35.84s35.84-16.0256 35.84-35.84V311.552c0-19.8144-16.0256-35.84-35.84-35.84zM665.7024 384.6144c-19.8144 0-35.84 16.0256-35.84 35.84v140.3392c0 19.8144 16.0256 35.84 35.84 35.84s35.84-16.0256 35.84-35.84V420.4544c0-19.8144-16.0768-35.84-35.84-35.84zM665.7024 349.3888c23.9616 0 43.4176-19.456 43.4176-43.4176 0-23.9616-19.456-43.4176-43.4176-43.4176-23.9616 0-43.4176 19.456-43.4176 43.4176 0 24.0128 19.4048 43.4176 43.4176 43.4176z"
              fill="''' + getColor(5, color, colors, '#FFFFFF') + '''"
            />
          </svg>
        ''';
        break;
      case IconNames.xuexizhongxin:
        svgXml = '''
          <svg viewBox="0 0 1024 1024" xmlns="http://www.w3.org/2000/svg">
            <path
              d="M909.6 221c-5-4.9-51.4-48-126.6-70-64.6-18.8-161.3-24.7-268.8 45.3-21.8-14.9-54.3-33.2-95.3-45.3-71.1-20.7-181.1-25.7-301.7 68.8C105.1 229.2 98 243.7 98 259v433.7c0 17.6 9.3 33.9 24.5 42.9 15.3 9 34 9.2 49.5 0.6 1.1-0.6 117.8-60.4 324.1 4 4.9 1.6 9.8 2.3 14.8 2.3h0.5c8.5 0.1 17.1-2 24.8-6.3 1.1-0.6 117.8-60.4 324.1 4 4.9 1.6 9.8 2.3 14.8 2.3 10.5 0 20.9-3.4 29.5-9.7 12.8-9.4 20.3-24.3 20.3-40.1V256.9c0-13.5-5.5-26.5-15.3-35.9zM461.1 627.7c-55.3-12.4-104.6-17.1-147.2-17.1-47.1 0-86.1 5.7-116.3 12.6v-339c62.7-43 126.5-55.9 189.7-38.6 32.9 9 58.6 24.5 73.8 35.2v346.9z m364.2 0c-55.3-12.4-104.6-17.1-147.2-17.1-47.1 0-86.1 5.7-116.3 12.6v-339c62.7-43 126.5-55.9 189.7-38.6 32.9 9 58.6 24.5 73.8 35.2v346.9z"
              fill="''' + getColor(0, color, colors, '#ffffff') + '''"
            />
            <path
              d="M924.2 850.6c-6.7 21.4-26.3 35-47.5 35-4.9 0-10-0.7-14.9-2.3-206.3-64.4-323-4.6-324.1-4-8.3 4.7-17.5 6.7-26.5 6.2-0.6 0.1-1.2 0.1-1.9 0.1-4.9 0-10-0.7-14.9-2.3-206.3-64.4-322.9-4.6-324.1-4-24 13.4-54.4 4.7-67.7-19.4-13.4-24-4.7-54.3 19.4-67.7 5.9-3.3 146-78.7 386.2-8.8 47.5-19.2 181.6-58.1 383.1 4.8 26.5 8.3 41.1 36.2 32.9 62.4z"
              fill="''' + getColor(1, color, colors, '#ffffff') + '''"
            />
          </svg>
        ''';
        break;
      case IconNames.qiehuan:
        svgXml = '''
          <svg viewBox="0 0 1024 1024" xmlns="http://www.w3.org/2000/svg">
            <path
              d="M758.1640625 259.36718723a175.78124973 175.78124973 0 0 1 175.78124973 175.78125054v105.46875h-70.31249973v-105.46875a105.46875 105.46875 0 0 0-105.46875-105.46875h-632.8125a35.15625027 35.15625027 0 0 1-20.39062527-63.77343804L350.98437527 90.125l40.78124973 57.23437473-156.79687473 112.0078125h523.125z m-492.18749973 492.18750054a175.78124973 175.78124973 0 0 1-175.78125054-175.78125054v-105.46875h70.31250054v105.46875a105.46875 105.46875 0 0 0 105.46875 105.46875h632.8125a35.15625027 35.15625027 0 0 1 20.39062446 63.77343804l-246.09374946 175.78124973-40.78125054-57.23437473 156.79687554-112.0078125H265.90624973z"
              fill="''' + getColor(0, color, colors, '#333333') + '''"
            />
          </svg>
        ''';
        break;
      case IconNames.yuyueshijian_doctor:
        svgXml = '''
          <svg viewBox="0 0 1024 1024" xmlns="http://www.w3.org/2000/svg">
            <path
              d="M560.54518557 516.8545189l116.50844444 116.50844444-67.96326002 67.96325888-140.78103666-140.78103665H463.45481443V317.81925888h97.09037114v199.03526002zM512 900.3614811c-213.59881443 0-388.3614811-174.76266667-388.3614811-388.3614811s174.76266667-388.3614811 388.3614811-388.3614811 388.3614811 174.76266667 388.3614811 388.3614811-174.76266667 388.3614811-388.3614811 388.3614811z m0-97.09036999c160.19911111 0 291.27111111-131.072 291.27111111-291.27111111s-131.072-291.27111111-291.27111111-291.27111111-291.27111111 131.072-291.27111111 291.27111111 131.072 291.27111111 291.27111111 291.27111111z"
              fill="''' + getColor(0, color, colors, '#EB5759') + '''"
            />
          </svg>
        ''';
        break;
      case IconNames.shoukequanxian_doctor:
        svgXml = '''
          <svg viewBox="0 0 1024 1024" xmlns="http://www.w3.org/2000/svg">
            <path
              d="M557.51111147 759.18222187V809.2444448h136.53333333v91.02222187H329.9555552v-91.02222187h136.53333333v-50.06222293c-154.73777813-22.7555552-273.06666667-154.73777813-273.06666666-314.02666667s118.32888853-291.27111147 273.06666666-314.02666666V126.57777814h91.02222294v4.5511104c154.73777813 22.7555552 273.06666667 154.73777813 273.06666666 314.02666666s-118.32888853 291.27111147-273.06666666 314.02666667zM512 672.71111147c127.43111147 0 227.5555552-100.1244448 227.5555552-227.55555627s-100.1244448-227.5555552-227.5555552-227.5555552-227.5555552 100.1244448-227.5555552 227.5555552 100.1244448 227.5555552 227.5555552 227.55555627z m0-136.53333333c-50.06222187 0-91.02222187-40.96-91.02222187-91.02222294s40.96-91.02222187 91.02222187-91.02222186 91.02222187 40.96 91.02222187 91.02222186-40.96 91.02222187-91.02222187 91.02222294z"
              fill="''' + getColor(0, color, colors, '#0B7FF8') + '''"
            />
          </svg>
        ''';
        break;
      case IconNames.shangwuhezuo_doctor:
        svgXml = '''
          <svg viewBox="0 0 1024 1024" xmlns="http://www.w3.org/2000/svg">
            <path
              d="M317.81925888 560.54518557H220.72888889v242.72592554h97.09036999v-242.72592554z m97.09037113 0l97.09036999 101.94488888 97.09036999-97.09037112V463.45481443h291.27111111v436.90666667h-291.27111111v-194.18073998l-29.12711111 29.12711111-67.96325888 63.10873998-67.96325888-67.96325888-29.12711111-29.12711111V900.3614811H123.6385189v-436.90666667h291.27111111v97.09037114z m388.3614811 0h-97.09036999v242.72592554h97.09036999v-242.72592554z m97.09036999-291.27111112c0 82.52681443-63.10874112 145.63555555-145.63555555 145.63555556s-145.63555555-63.10874112-145.63555556-145.63555556 63.10874112-145.63555555 145.63555556-145.63555555 145.63555555 63.10874112 145.63555555 145.63555555z m-97.09036999 0c0-29.12711111-19.41807445-48.54518557-48.54518556-48.54518556s-48.54518557 19.41807445-48.54518443 48.54518556 19.41807445 48.54518557 48.54518443 48.54518443 48.54518557-19.41807445 48.54518556-48.54518443z m-388.3614811 0c0 82.52681443-63.10874112 145.63555555-145.63555556 145.63555556S123.6385189 351.80088889 123.6385189 269.27407445s63.10874112-145.63555555 145.63555555-145.63555555 145.63555555 63.10874112 145.63555556 145.63555555zM317.81925888 269.27407445c0-29.12711111-19.41807445-48.54518557-48.54518443-48.54518556s-48.54518557 19.41807445-48.54518556 48.54518556 19.41807445 48.54518557 48.54518556 48.54518443 48.54518557-19.41807445 48.54518443-48.54518443z"
              fill="''' + getColor(0, color, colors, '#F4C95B') + '''"
            />
          </svg>
        ''';
        break;
      case IconNames.doctor_enter:
        svgXml = '''
          <svg viewBox="0 0 1097 1024" xmlns="http://www.w3.org/2000/svg">
            <path
              d="M863.03246624 782.19614139a127.72242801 127.72242801 0 0 1-91.69738054-38.52615894 128.47577481 128.47577481 0 0 1-37.10986689-91.57684542c0-71.70355508 57.78170481-130.04273639 128.80724743-130.0427364 71.01047626 0 128.79218106 58.33918131 128.79218107 130.07286998 0 71.71862228-57.78170481 130.07287078-128.79218106 130.07287078z m1e-8-207.92373624a76.04283279 76.04283279 0 0 0-54.723116 23.06748148 75.89216327 75.89216327 0 0 0-21.8771933 54.22590747c0 42.69970074 34.36768432 77.39885769 76.6003093 77.3988577 42.21755859 0 76.57017572-34.69915695 76.57017572-77.33858972 0-42.65449997-34.35261713-77.35365693-76.57017572-77.35365693zM629.61547305 617.68025192l-134.38201492-51.76999676c-7.59373682-2.74218256-14.6450635-7.18692901-21.4854527-13.56024326l-13.06303473-12.43022388c-8.18134689 12.09875042-18.87887246 21.89225967-30.04347299 31.62550177l-0.31640542 0.28627185c-8.97989447 8.12107891-17.46258041 15.79015009-21.47038632 22.9921463a115.27713776 115.27713776 0 0 0-11.52620673 25.14671879l-0.1808031 0.48214214-1.49162724 3.51059574a22.51000415 22.51000415 0 0 1-20.97317696 15.09707126H170.28481946c-6.25277911 0-12.06861685-3.22432471-15.54907901-8.61828745a18.56246704 18.56246704 0 0 1-1.43135926-17.52284839l5.43916434-12.97263318c2.30524118-5.60490106 5.71036899-14.29852368 9.91404519-24.98098206 4.77621908-12.20421918 10.56192324-26.98488501 16.9201703-42.75996871 23.03734707-58.68572113 51.63439444-130.90155194 68.19295851-168.4031586 0.10546875-0.3917406 0.3766734-1.114953 0.66294526-1.82309985 0.2109375-0.54241013 0.43694138-1.08481943 0.64787805-1.73269748 5.19809326-12.49049103 11.60154189-24.98098206 24.19750168-34.12661325 11.07419898-7.45813367 24.00163137-11.84261297 39.68631354-13.4849089a137.71180755 137.71180755 0 0 1 20.28009732-0.40680699 134.71348672 134.71348672 0 0 1-30.70641824-86.00207876c0-57.42009861 36.10038181-108.96409149 89.82908075-128.27990533A138.10354816 138.10354816 0 0 1 445.2865604 90.12650705c67.36427738 1.05468586 123.97076037 52.839749 131.76036748 120.46016382a135.94897567 135.94897567 0 0 1-29.25999178 101.3552883 135.9339093 135.9339093 0 0 1-81.88880493 48.4402033l86.24314984 82.17507678c1.79296545 1.41629206 3.87220276 2.69698178 5.90623928 3.51059574l118.75759993 45.66788718a67.3040094 67.3040094 0 0 1 37.12493407 35.84424435c7.02119312 16.39282819 7.39786651 35.00049518 1.03961866 51.07691794-12.18915198 33.50886878-48.62100723 52.26720612-85.3541999 39.02336746zM522.39914624 235.19097952a79.38769345 79.38769345 0 0 0-19.36101462-62.42232156A79.04115363 79.04115363 0 0 0 443.79493399 145.87417532c-8.04574457 0-16.89003671 1.61216235-26.27673899 4.7611519a81.09025735 81.09025735 0 0 0-48.59087283 49.14834932l-0.06026797 0.15066953a72.92397683 72.92397683 0 0 0-4.64061675 26.29180618c0 22.8264104 9.71817489 44.62826853 26.63834517 59.83080854a77.60979438 77.60979438 0 0 0 61.80457709 19.55688409c36.23598413-4.21874258 65.55624472-33.8252742 69.72978653-70.42286536z m141.52374316 315.23046379a10.09484829 10.09484829 0 0 0-6.04184243-5.58983306l-118.87813586-45.71308877c-7.15679543-2.41070993-15.08200405-7.29239777-23.33868614-14.44919238a25178.31385537 25178.31385537 0 0 0-98.6432385-94.57516626l-6.0870432-6.13224316-0.30133822-0.1808031a26.09593588 26.09593588 0 0 0-5.69530262-2.62164743l-8.28681564-2.4559107c-24.78511175-6.96092514-45.18574503-10.33591937-62.25658484-10.33591938-3.3900606 0-6.59931894 0-9.73324211 0.45200857-8.99496167 1.29575693-12.3398215 3.02845441-13.36437295 3.72153324 0.06026797-0.10546875-1.3258905 1.44642563-4.61048317 9.73324127a19.75275522 19.75275522 0 0 1-1.16015379 2.63671463c-0.27120465 0.54241013-0.54241013 1.06975223-0.72321321 1.61216236l-0.19587031 0.49720853c-12.85209723 28.32584189-34.0211445 81.64773386-52.6890803 128.6716451-5.15289248 13.01783395-10.18524985 25.65899451-14.85600018 37.36600516-3.64619888 9.55243817-7.54853521 19.54181772-11.64674267 29.75720114h125.88426177c0.49720852 0 1.13002021-0.30133905 1.3560249-0.85881555 2.13950528-4.86662063 4.70088473-9.55243817 7.18692902-14.05745261 8.66348904-16.39282819 23.60989077-28.97372077 34.51835386-38.1645519 22.6154729-19.70755445 25.29738748-25.47819141 22.75107522-35.01556321a30.11880817 30.11880817 0 0 1-1.65736313-9.83871003v-29.12438945c0-6.23771192 3.55579733-11.67687625 9.28123352-14.19305494 5.80077053-2.56137945 12.29462073-1.41629206 16.98043826 2.96818643l69.66951856 66.83693445c1.05468586 1.06975223 2.03403652 1.77789825 3.54073013 2.54631225l135.49696793 51.13718509c5.49943231 2.0792373 12.02341608-0.78348038 13.99718463-6.10210957 0.90401632-2.44084351 0.7533468-5.15289248-0.49720853-8.52788672z m-76.40443982 96.68453713c25.80966403 0 37.95361523 7.59373682 51.31798902 21.62105584l110.86252487 113.96631364a9.28123352 9.28123352 0 0 0 6.90065716 3.02845523H920.70870312c40.04791973 0 73.07464636 32.86099073 73.60198846 73.25544946a72.62263779 72.62263779 0 0 1-20.85264102 52.83974899A73.14998071 73.14998071 0 0 1 921.20591165 933.875H721.79499576c-10.30578497 0-19.66235366-1.83816623-27.85876776-5.43916433a79.41782703 79.41782703 0 0 1-24.39337116-16.61883208l-35.82917715-36.6879927a9.25109994 9.25109994 0 0 0-6.90065716-3.0284544H168.29598371C125.24974395 872.10055649 90.21911438 836.72338791 90.21911438 793.25527317v-81.36146118C90.21911438 676.44130823 118.77096097 647.60318979 153.87692489 647.60318979c-0.0150672 0 404.80340625-0.49720852 433.64152469-0.49720935z m-443.08849411 64.78783155v81.36146118c0 13.56024326 10.92352944 24.60430865 24.36323759 24.60430864h467.46679889c11.10433254 0 21.25944882 4.32421133 29.36546135 12.52062544l42.09702266 43.51331469c2.30524118 1.85323342 4.32421133 3.45032858 7.08146026 4.64061676 1.61216235 0.64787805 4.39954568 1.09988662 6.99105954 1.09988664h199.41091589c4.86662063 0 10.18524985-2.32030838 13.89171671-6.05690882l0.1808031-0.1958703a18.53233264 18.53233264 0 0 0 5.81583774-13.84651511 20.3554325 20.3554325 0 0 0-20.38556608-19.58701849H738.70009967c-5.75556976 0-10.95366384-2.29017481-14.2683901-6.32811429l-123.54888621-126.74307651c-5.48436511-5.52956589-5.48436511-5.52956589-12.86716443-5.52956671-29.33532697 0-433.64152469 0.49720852-433.64152551 0.49720935a10.00444675 10.00444675 0 0 0-9.94417794 10.04964753z m-23.20308379 167.37860714c3.88726996 0.87388275 8.45255154 1.35602407 12.76169568 1.35602408h491.31776156c6.88559079 0 13.0931683 2.60658023 17.94472174 7.50333526a25.01111646 25.01111646 0 0 1 5.25836123 27.48209354 24.75497818 24.75497818 0 0 1-23.20308297 15.74494931H116.57118772c-14.76559863 0-26.35207334-11.69194345-26.35207334-26.62327799v-1.5066936c0-7.50333444 3.37499423-14.49439399 9.25109995-19.18021152a25.14671878 25.14671878 0 0 1 21.75665735-4.77621907z"
              fill="''' + getColor(0, color, colors, '#333333') + '''"
            />
          </svg>
        ''';
        break;
      case IconNames.renzhenglishi:
        svgXml = '''
          <svg viewBox="0 0 1024 1024" xmlns="http://www.w3.org/2000/svg">
            <path
              d="M512 90.125C279.125 90.125 90.125 279.125 90.125 512s189 421.875 421.875 421.875 421.875-189 421.875-421.875S744.875 90.125 512 90.125z m45.5625 685.546875L250.4375 346.625l143.859375-0.421875 163.6875 258.609375 116.859375-258.609375 92.8125 0.421875-210.09375 429.046875z"
              fill="''' + getColor(0, color, colors, '#333333') + '''"
            />
          </svg>
        ''';
        break;
      case IconNames.fuzhi:
        svgXml = '''
          <svg viewBox="0 0 1024 1024" xmlns="http://www.w3.org/2000/svg">
            <path
              d="M122.09375 571.71875a30.1875 30.09375 0 1 0 60.375 0 30.1875 30.09375 0 1 0-60.375 0Z"
              fill="''' + getColor(0, color, colors, '#333333') + '''"
            />
            <path
              d="M727.71875 454.53125l-252.65625-1.96875c-13.40625-0.09375-24.375 12.9375-24.375 29.0625s10.96875 29.34375 24.375 29.4375l252.65625 1.96875c13.40625 0.09375 24.375-12.9375 24.375-29.0625s-10.96875-29.34375-24.375-29.4375zM727.71875 573.59375l-252.65625-1.96875c-13.40625-0.09375-24.375 12.9375-24.375 29.0625s10.96875 29.34375 24.375 29.4375l252.65625 1.96875c13.40625 0.1875 24.375-12.9375 24.375-29.0625s-10.96875-29.34375-24.375-29.4375z"
              fill="''' + getColor(1, color, colors, '#333333') + '''"
            />
            <path
              d="M722.09375 91.90625H422.9375c-66 0-120 54-120 120h-60.84375c-66 0-120 54-120 120v120c-0.09375 16.59375 13.5 30 30.1875 30 16.6875 0 30.1875-13.5 30.1875-30.09375V332c0-33 27-60 60-60H302.9375v419.8125c0 66 54 120 120 120h239.15625c-0.09375 33-27 59.8125-60 59.8125H242.46875c-33 0-60-27-60-60V691.53125c0-16.59375-13.5-30.09375-30.1875-30.09375-16.6875 0-30.28125 13.5-30.28125 30.09375v120.28125c0 66 54 120 120 120h360.09375c66 0 120-54 120-120h60.9375c66 0 120-54 120-120V271.90625l-180.9375-180z m0.09375 59.4375l119.71875 120.28125H782c-33 0-60-27-60-60v-60.28125h0.1875z m60 600.9375H422.09375c-33 0-60-27-60-60v-480.9375c0-33 27-60 60-60H661.0625V211.0625c0 66 54 120 120 120h61.125v361.21875c0 33-27 60-60 60z"
              fill="''' + getColor(2, color, colors, '#333333') + '''"
            />
          </svg>
        ''';
        break;
      case IconNames.apple:
        svgXml = '''
          <svg viewBox="0 0 1024 1024" xmlns="http://www.w3.org/2000/svg">
            <path
              d="M623.89333333 225.06666667c49.17333333-60.05333333 38.18666667-125.65333333 32.74666667-131.09333334-5.44-5.44-76.48 5.44-125.65333333 71.04-43.73333333 60.05333333-43.73333333 125.65333333-38.18666667 131.09333334C498.34666667 301.54666667 569.28 296.10666667 623.89333333 225.06666667L623.89333333 225.06666667zM744.10666667 530.98666667c-5.44-87.36 76.48-141.97333333 92.8-152.96l0-5.44c0 0-71.04-87.36-174.72-81.92-65.49333333 5.44-98.34666667 38.18666667-141.97333334 38.18666666-54.61333333 0-103.78666667-38.18666667-163.84-38.18666666-49.17333333 0-191.14666667 43.73333333-202.02666666 229.33333333-10.88 185.70666667 120.10666667 360.42666667 169.28 393.17333333 49.17333333 32.74666667 81.92 21.86666667 136.53333333-5.44 27.30666667-16.42666667 114.66666667-21.86666667 163.84 10.88 60.05333333 21.86666667 147.41333333 5.44 245.76-213.01333333C858.77333333 705.70666667 749.54666667 678.4 744.10666667 530.98666667L744.10666667 530.98666667zM744.10666667 530.98666667"
              fill="''' + getColor(0, color, colors, '#333333') + '''"
            />
          </svg>
        ''';
        break;
      case IconNames.biangeng_1:
        svgXml = '''
          <svg viewBox="0 0 1024 1024" xmlns="http://www.w3.org/2000/svg">
            <path
              d="M870.21875 423.3125c-15 0-26.53125 11.53125-26.53125 26.53125v336c0 44.25-35.34375 79.59375-79.59375 79.59375H224.65625c-44.25 0-79.59375-35.34375-79.59375-79.59375V317.1875c0-44.25 35.34375-79.59375 79.59375-79.59375h337.78125c15 0 26.53125-11.53125 26.53125-26.53125s-11.53125-26.53125-26.53125-26.53125H224.65625C151.25 184.53125 92 243.78125 92 317.1875v468.65625c0 73.40625 59.25 132.65625 132.65625 132.65625h539.4375c73.40625 0 132.65625-59.25 132.65625-132.65625V449.84375c0-14.15625-11.53125-26.53125-26.53125-26.53125z m0 0"
              fill="''' + getColor(0, color, colors, '#333333') + '''"
            />
            <path
              d="M906.40625 144.6875l-14.15625-14.15625c-16.78125-16.78125-38.90625-25.6875-61.875-25.6875s-45.09375 8.8125-61.875 25.6875L512.9375 385.25l-61.875 61.875c-42.46875 42.46875-30.9375 134.4375-29.15625 145.03125l2.625 19.5 19.5 2.625c4.40625 0.84375 21.1875 3.5625 43.3125 3.5625 32.71875 0 76.03125-5.34375 101.71875-30.9375l317.4375-317.4375c16.78125-16.78125 25.6875-38.90625 25.6875-61.875-0.09375-24-8.90625-46.03125-25.78125-62.90625zM551 549.78125c-14.15625 14.15625-51.28125 16.78125-78.75 15-0.84375-27.375 0.84375-64.59375 15.9375-79.59375l22.125-22.125 63.65625 63.65625-22.96875 23.0625z m317.4375-318.375L613.71875 486.03125l-62.8125-62.8125 254.71875-254.71875c13.21875-13.21875 36.28125-13.21875 48.65625 0l14.15625 14.15625c14.15625 13.40625 14.15625 35.4375 0 48.75z m0 0"
              fill="''' + getColor(1, color, colors, '#333333') + '''"
            />
          </svg>
        ''';
        break;
      case IconNames.yigoumai:
        svgXml = '''
          <svg viewBox="0 0 1024 1024" xmlns="http://www.w3.org/2000/svg">
            <path
              d="M104.03123579 101.18679135h828.50449382v828.50449382H104.03123579V101.18679135z m55.23363335 55.23363335v718.03722841h718.03722841V156.4204247H159.26486914z m110.46726541 0h55.23363336v718.03722841H269.73213455V156.4204247z"
              fill="''' + getColor(0, color, colors, '#333333') + '''"
            />
          </svg>
        ''';
        break;
      case IconNames.zhuanyerenzheng_menu:
        svgXml = '''
          <svg viewBox="0 0 1024 1024" xmlns="http://www.w3.org/2000/svg">
            <path
              d="M713.32724978 853.7581037l144.98828562-144.98828681 36.24707202 36.247072-181.23535764 181.23535762-5.17815348-5.17815228-108.74121481-108.74121482 36.24707201-36.247072 77.67229628 77.67229629zM542.44819794 874.47071645v51.78153006H128.19595022v-165.70089836L273.18423704 615.56306132h378.00517571l56.95968355 56.95968476-36.24707201 36.24707081-36.24707079-41.4252243H293.89684978L179.97748149 781.2639609V874.47071645h362.47071645z m155.34459259-543.70607407c0 129.45382756-103.56306132 233.01688889-233.01688888 233.01688889S231.75901275 460.21846873 231.75901275 330.76464238 335.32207408 97.74775349 464.77590165 97.74775349 697.79279053 201.31081482 697.79279053 330.76464238z m-51.78153127 0C646.01125926 232.37973333 563.16080948 149.52928355 464.77590165 149.52928355S283.54054281 232.37973333 283.54054281 330.76464238 366.39099259 512 464.77590165 512 646.01125926 429.14955022 646.01125926 330.76464238z"
              fill="''' + getColor(0, color, colors, '#333333') + '''"
            />
          </svg>
        ''';
        break;
      case IconNames.kefuyushouhou:
        svgXml = '''
          <svg viewBox="0 0 1024 1024" xmlns="http://www.w3.org/2000/svg">
            <path
              d="M541.02597572 873.04849423v-51.78153127h103.56306131v51.78153127h155.3445926v-466.03377777c-15.53445925-144.98828683-134.63197984-258.90765392-284.79842016-258.90765513S245.87124979 262.02642963 230.33679053 407.01471646v517.81530782H126.773728v-362.47071523h51.78153126v-129.45382757C178.55525926 246.49197036 328.72169837 96.32553127 515.13520947 96.32553127S851.7151609 246.49197036 851.7151609 432.90548148V562.35930905h51.78153005v362.47071523h-362.47071523v-51.78153005z"
              fill="''' + getColor(0, color, colors, '#333333') + '''"
            />
          </svg>
        ''';
        break;
      case IconNames.shiyongbangzhu:
        svgXml = '''
          <svg viewBox="0 0 1024 1024" xmlns="http://www.w3.org/2000/svg">
            <path
              d="M102.60901357 99.5749395h828.50449382v828.50449381H102.60901357V99.5749395z m55.23363335 55.23363334v718.03722841h718.03722841V154.80857284H157.84264692z m552.33632965 220.93453212v55.23363205H323.54354569v-55.23363205h386.63543088z m0 220.93453083v55.23363334H323.54354569v-55.23363334h386.63543088z"
              fill="''' + getColor(0, color, colors, '#333333') + '''"
            />
          </svg>
        ''';
        break;
      case IconNames.qicai_yifahuo:
        svgXml = '''
          <svg viewBox="0 0 1024 1024" xmlns="http://www.w3.org/2000/svg">
            <path
              d="M860.26666635 597.33333367l-38.4-38.4 29.866667-29.866667L941.33333334 618.66666667l-89.59999999 89.6-29.866667-29.866667 38.4-38.4h-196.266666v-42.666666h196.266666zM326.93333334 452.26666667l123.73333301 72.533333 294.4-170.666666-128.00000001-72.533334-290.133333 170.666667z m-42.66666699-21.333333l294.39999999-170.666667-127.99999999-72.533333-294.40000001 170.666666 128.00000001 72.533334zM130.66666635 392.53333367v260.266666l298.666667 170.666667v-260.266667l-298.666667-170.666666z m639.99999999 0l-298.66666599 170.666666v260.266667l217.59999999-123.733333 38.4 29.866666-277.33333399 157.866667L88.00000035 678.39999967V345.59999967l362.666666-209.066666L813.33333335 345.59999967V533.33333367h-42.66666701V392.53333367z"
              fill="''' + getColor(0, color, colors, '#333333') + '''"
            />
          </svg>
        ''';
        break;
      case IconNames.qicai_daifahuo:
        svgXml = '''
          <svg viewBox="0 0 1024 1024" xmlns="http://www.w3.org/2000/svg">
            <path
              d="M191.62666667 343.60888853l323.12888853 186.59555627 323.12888961-186.59555627-323.12888961-186.5955552-323.12888853 186.5955552z m-18.2044448 40.96v268.51555627l318.57777813 182.04444373v-268.5155552l-318.57777813-182.0444448z m682.66666666 0l-318.57777706 182.0444448v268.5155552l318.57777706-182.04444373V384.56888853zM514.7555552 102.4L901.60000001 325.4044448v354.98666667l-386.84444481 223.00444373L127.91111147 680.39111147V325.4044448L514.7555552 102.4z"
              fill="''' + getColor(0, color, colors, '#333333') + '''"
            />
          </svg>
        ''';
        break;
      case IconNames.qicai_yiquxiao:
        svgXml = '''
          <svg viewBox="0 0 1024 1024" xmlns="http://www.w3.org/2000/svg">
            <path
              d="M832.00000001 588.79999967l59.733333-59.733333 29.866667 29.866667-59.733333 59.733333 59.733333 59.733333-29.866667 29.866667-59.733333-59.733333-59.733333 59.733333-29.866667-29.866667 59.733333-59.733333-59.733333-59.733333 29.866667-29.866667 59.733333 59.733333zM345.60000001 452.26666667l123.733333 72.533333 294.4-170.666666-128-72.533334-290.133333 170.666667z m-42.666667-21.333333l294.4-170.666667-128-72.533333-294.4 170.666666 128 72.533334zM149.33333301 392.53333367v260.266666l298.666667 170.666667v-260.266667l-298.666667-170.666666z m640 0l-298.666666 170.666666v260.266667l217.6-123.733333 38.4 29.866666-277.333334 157.866667L106.66666701 678.39999967V345.59999967l362.666666-209.066666L832.00000001 345.59999967V533.33333367h-42.666667V392.53333367z"
              fill="''' + getColor(0, color, colors, '#333333') + '''"
            />
          </svg>
        ''';
        break;
      case IconNames.qicai_yiqianshou:
        svgXml = '''
          <svg viewBox="0 0 1024 1024" xmlns="http://www.w3.org/2000/svg">
            <path
              d="M789.06666668 652.79999967l106.666667-106.666666 29.866666 29.866666-106.666666 106.666667-29.866667 29.866667-89.6-89.6 29.866667-29.866667 59.733333 59.733333zM328.26666668 452.26666667l123.733333 72.533333 294.4-170.666666-128-72.533334-290.133333 170.666667z m-42.666667-21.333333l294.4-170.666667-128-72.533333-294.4 170.666666 128 72.533334zM131.99999968 392.53333367v260.266666l298.666667 170.666667v-260.266667l-298.666667-170.666666z m640 0l-298.666666 170.666666v260.266667l217.6-123.733333 38.4 29.866666-277.333334 157.866667L89.33333368 678.39999967V345.59999967l362.666666-209.066666L814.66666668 345.59999967V533.33333367h-42.666667V392.53333367z"
              fill="''' + getColor(0, color, colors, '#333333') + '''"
            />
          </svg>
        ''';
        break;
      case IconNames.shouhuodizhi:
        svgXml = '''
          <svg viewBox="0 0 1024 1024" xmlns="http://www.w3.org/2000/svg">
            <path
              d="M763.73333334 876.08888853v-91.02222186h-91.02222187l45.5111104-45.51111147h91.02222293v182.0444448H217.6v-182.0444448h91.02222187l45.51111147 45.51111147H263.11111147v91.02222186h500.62222187z m-63.7155552-309.4755552c40.96-45.51111147 63.7155552-104.6755552 63.7155552-168.39111146 0-136.53333333-113.77777813-250.31111147-250.31111147-250.3111104S263.11111147 261.68888853 263.11111147 398.22222187c0 63.7155552 22.7555552 122.88 63.7155552 168.39111146l186.5955552 186.5955552 186.59555627-186.5955552z m18.20444373 45.51111147l-200.24888853 200.24888853L308.62222187 612.1244448C254.00888854 557.51111147 217.6 484.69333333 217.6 398.22222187 217.6 234.38222187 349.58222187 102.4 513.42222187 102.4S809.2444448 234.38222187 809.2444448 398.22222187c0 77.36888853-27.30666667 145.6355552-77.3688896 200.2488896l-13.65333333 13.65333333zM513.42222187 512c-63.7155552 0-113.77777813-50.06222187-113.77777707-113.77777813S449.70666667 284.4444448 513.42222187 284.4444448 627.2 334.50666667 627.2 398.22222187 577.13777814 512 513.42222187 512z m0-45.51111147c36.40888853 0 68.26666667-31.85777813 68.26666667-68.26666666S549.83111147 329.9555552 513.42222187 329.9555552 445.1555552 361.81333333 445.1555552 398.22222187s31.85777813 68.26666667 68.26666667 68.26666666z"
              fill="''' + getColor(0, color, colors, '#333333') + '''"
            />
          </svg>
        ''';
        break;
      case IconNames.kaitongshoukequanxian:
        svgXml = '''
          <svg viewBox="0 0 1024 1024" xmlns="http://www.w3.org/2000/svg">
            <path
              d="M536.17777814 785.06666667v91.02222186h182.04444373v45.51111147H308.62222187v-45.51111147h182.0444448v-91.02222186c-177.49333333-13.65333333-318.57777813-159.28888853-318.57777813-341.33333334S313.17333334 116.05333333 490.66666667 102.4h45.51111147c177.49333333 13.65333333 318.57777813 159.28888853 318.57777706 341.33333333s-141.0844448 327.68-318.57777706 341.33333334z m-22.75555627-45.51111147c163.84 0 295.82222187-131.98222187 295.82222293-295.82222187S677.26222187 147.91111147 513.42222187 147.91111147 217.6 279.89333333 217.6 443.73333333 349.58222187 739.5555552 513.42222187 739.5555552z m0-227.5555552c-36.40888853 0-68.26666667-31.85777813-68.26666667-68.26666667S477.01333334 375.46666667 513.42222187 375.46666667s68.26666667 31.85777813 68.26666667 68.26666666-31.85777813 68.26666667-68.26666667 68.26666667z"
              fill="''' + getColor(0, color, colors, '#333333') + '''"
            />
          </svg>
        ''';
        break;
      case IconNames.shangwuhezuo:
        svgXml = '''
          <svg viewBox="0 0 1024 1024" xmlns="http://www.w3.org/2000/svg">
            <path
              d="M594.22972799 609.76418726V438.8851354h310.68918519v466.03377778h-310.68918519v-222.6605819l-77.6722963 77.67229629-129.45382634-129.45382757 36.24707079-36.24707201 93.20675555 93.20675557 77.6722963-77.6722963z m258.90765513-119.09752059h-207.12612386v362.47071645h207.12612386v-362.47071645z m-466.03377777 0H179.97748149v362.47071645h207.12612386v-362.47071645z m51.78153005 0v414.25224651H128.19595022v-466.03377778h310.68918518v51.78153127z m466.03377778-258.90765392c0 88.02860206-67.31599053 155.34459259-155.34459259 155.3445926s-155.34459259-67.31599053-155.3445926-155.3445926 67.31599053-155.34459259 155.3445926-155.34459259 155.34459259 67.31599053 155.34459259 155.34459259z m-51.78153006 0c0-56.95968355-46.60337778-103.56306132-103.56306253-103.56306253s-103.56306132 46.60337778-103.56306133 103.56306253 46.60337778 103.56306132 103.56306133 103.56306133 103.56306132-46.60337778 103.56306253-103.56306133z m-414.25224772 0c0 88.02860206-67.31599053 155.34459259-155.34459259 155.3445926S128.19595022 319.78761482 128.19595022 231.75901275s67.31599053-155.34459259 155.34459259-155.34459259 155.34459259 67.31599053 155.34459259 155.34459259z m-51.78153005 0c0-56.95968355-46.60337778-103.56306132-103.56306254-103.56306253s-103.56306132 46.60337778-103.56306132 103.56306253 46.60337778 103.56306132 103.56306132 103.56306133 103.56306132-46.60337778 103.56306254-103.56306133z"
              fill="''' + getColor(0, color, colors, '#333333') + '''"
            />
          </svg>
        ''';
        break;
      case IconNames.jizhu:
        svgXml = '''
          <svg viewBox="0 0 1024 1024" xmlns="http://www.w3.org/2000/svg">
            <path
              d="M566.75 295.25c-15.75 0-39-1.5-69-6-6.75-0.75-12-5.25-15-11.25-3.75-8.25-14.25-30-21.75-39.75-1.5 0-5.25 0.75-8.25 2.25-1.5 1.5-5.25 3.75-5.25 6.75-0.75 4.5-3 8.25-6 11.25-28.5 30-53.25 32.25-68.25 29.25-23.25-4.5-41.25-23.25-54.75-56.25-0.75-1.5-0.75-3-1.5-3.75 0-1.5-5.25-28.5-6-50.25 0-6.75 3.75-13.5 9.75-17.25 12.75-8.25 39.75-16.5 63.75-3 1.5 0 3-0.75 3.75-1.5 0.75-4.5 3-8.25 6.75-11.25 0.75-0.75 2.25-6 0-17.25-0.75-3.75-0.75-8.25 0.75-12s9-21 27-23.25c12.75-1.5 25.5 5.25 36 20.25 1.5-1.5 3.75-3 6-3.75l24-9.75c6-2.25 12.75-1.5 18 1.5 0 0 8.25 4.5 21.75 3L627.5 62c9.75-3.75 20.25 0 25.5 9 4.5 9 45 87 42 140.25 0.75 8.25 0.75 31.5-16.5 51.75-17.25 19.5-44.25 30-81.75 30-5.25 1.5-15 2.25-30 2.25z m-52.5-44.25c51.75 7.5 75 3 75 2.25 1.5 0 3-0.75 4.5-0.75 25.5 0.75 44.25-5.25 53.25-15.75 9-9.75 7.5-21.75 7.5-22.5v-4.5c2.25-28.5-16.5-75.75-29.25-104.25l-84 35.25c-1.5 0.75-3 0.75-4.5 1.5-18 3-31.5-0.75-40.5-3.75l-3 0.75c-4.5 12-12.75 16.5-17.25 18-6.75 2.25-13.5 1.5-19.5-0.75-8.25-1.5-15.75-6-21-11.25-0.75 8.25-3.75 14.25-6 18.75 0 3-0.75 6-2.25 9-6.75 15.75-27.75 21.75-44.25 24.75-5.25 0.75-11.25-0.75-15.75-4.5-5.25-3.75-11.25-4.5-15.75-3 1.5 12 3 23.25 3.75 28.5 7.5 18 16.5 28.5 24.75 30 3.75 0.75 13.5 0.75 30-15 6-16.5 20.25-29.25 39-33.75 17.25-4.5 33.75 0.75 42.75 12 7.5 9.75 17.25 27.75 22.5 39zM396.5 143.75z m0 0z m0 0z m0 0z"
              fill="''' + getColor(0, color, colors, '#333333') + '''"
            />
            <path
              d="M629.75 515c-8.25 0-17.25-0.75-27-2.25-9 0-39.75-1.5-96-19.5-6-2.25-11.25-6.75-12.75-13.5-2.25-8.25-9.75-31.5-15.75-42.75-1.5 0-5.25 0-8.25 1.5-1.5 0.75-5.25 2.25-6.75 6-1.5 4.5-4.5 7.5-8.25 9.75-33 24.75-57.75 24-72.75 18.75-21.75-8.25-37.5-29.25-45.75-63.75 0-1.5-0.75-3-0.75-4.5 0-1.5-0.75-29.25 2.25-49.5 0.75-6.75 5.25-12.75 12-15.75 14.25-6 42-10.5 63.75 6 1.5 0 3 0 4.5-0.75 1.5-3.75 4.5-7.5 8.25-9.75 0.75-0.75 3.75-5.25 2.25-17.25-0.75-4.5 0.75-8.25 3-12 1.5-3 12-19.5 30.75-18.75 12.75 0.75 24 9 32.25 25.5 2.25-1.5 3.75-2.25 6-2.25l25.5-6c6-1.5 12.75 0 17.25 4.5 0 0 7.5 6 21.75 6.75l105-24.75c9.75-2.25 20.25 3 23.25 12.75 3 9.75 31.5 93 20.25 144.75-0.75 8.25-3.75 31.5-24 48.75-15.75 11.25-36 18-60 18z m-25.5-42.75h3.75c25.5 4.5 44.25 1.5 54.75-7.5 9.75-8.25 10.5-21 10.5-21 0-1.5 0-3 0.75-5.25 6.75-27.75-4.5-77.25-12.75-107.25L572 352.25c-2.25 2.25-4.5 2.25-6 2.25-18 0-31.5-6-39.75-10.5l-2.25 0.75c-6 11.25-14.25 14.25-19.5 15-7.5 1.5-14.25-0.75-19.5-3.75-7.5-3-14.25-8.25-18.75-14.25-2.25 7.5-5.25 12.75-9 17.25-0.75 3-1.5 5.25-3 8.25-8.25 14.25-30 18-47.25 18-6 0-11.25-2.25-15-6-4.5-4.5-10.5-6-15.75-6-0.75 12-0.75 23.25-0.75 28.5 4.5 18.75 11.25 30 19.5 33 3.75 1.5 13.5 3 32.25-10.5 8.25-15 24.75-25.5 44.25-27 18-1.5 33 5.25 39.75 18.75 6 11.25 12.75 30.75 16.5 42.75 50.25 15 73.5 14.25 74.25 14.25 1.5-0.75 1.5-0.75 2.25-0.75zM428 333.5z m0 0z m0 0z m0 0z m0 0z"
              fill="''' + getColor(1, color, colors, '#333333') + '''"
            />
            <path
              d="M636.5 733.25c-11.25 0-23.25-1.5-36-4.5-9-0.75-39-3.75-94.5-26.25-6-2.25-10.5-8.25-12-14.25-1.5-8.25-7.5-32.25-12-44.25-1.5-0.75-5.25-0.75-8.25 0.75-1.5 0.75-6 2.25-7.5 5.25-1.5 3-3 5.25-6 7.5-3.75 3-39.75 30-74.25 16.5-22.5-9-37.5-31.5-43.5-67.5V602c0-1.5 1.5-29.25 6-49.5 1.5-6.75 6-12.75 12.75-15 14.25-5.25 42.75-7.5 63 11.25h4.5c1.5-3.75 4.5-6.75 8.25-9 0.75-0.75 3.75-5.25 3.75-17.25 0-4.5 0.75-8.25 3.75-12 2.25-3 13.5-18 31.5-16.5 12.75 1.5 23.25 10.5 30.75 27.75 2.25-0.75 3.75-1.5 6-2.25l25.5-4.5c6-0.75 12.75 0.75 17.25 5.25 0 0 6.75 6 21 8.25L683 512c9.75-1.5 19.5 4.5 22.5 14.25 2.25 9.75 24.75 94.5 9.75 145.5-0.75 8.25-6 30.75-27 46.5-14.25 10.5-31.5 15-51.75 15zM530.75 669.5c48.75 18.75 72 19.5 72.75 19.5 1.5 0 3 0 4.5 0.75 25.5 6 44.25 5.25 55.5-3 10.5-7.5 11.25-19.5 11.25-19.5 0-1.5 0.75-3 0.75-5.25 9-27 1.5-77.25-5.25-108L579.5 568.25h-4.5c-18-1.5-30.75-7.5-39-12.75l-3 0.75c-6.75 11.25-16.5 13.5-21 14.25-6.75 0.75-13.5-2.25-18-5.25-7.5-3-13.5-9.75-17.25-15-3 7.5-6.75 12.75-10.5 16.5-0.75 3-2.25 5.25-3.75 7.5-9.75 13.5-31.5 15-48 14.25-6 0-11.25-3-14.25-7.5-3.75-5.25-9.75-6.75-15-6.75-1.5 12-2.25 23.25-3 28.5 3.75 19.5 9.75 31.5 18 34.5 9 3.75 24-3 32.25-8.25 9-15 27-24.75 46.5-24.75 17.25 0 32.25 8.25 38.25 21.75 5.25 12 10.5 31.5 13.5 43.5zM437 539.75z m2.25-0.75z m0 0z m0 0z m0 0z"
              fill="''' + getColor(2, color, colors, '#333333') + '''"
            />
            <path
              d="M612.5 961.25c-16.5 0-35.25-4.5-54.75-13.5-9-2.25-37.5-12-87-44.25-5.25-3.75-9-9.75-9-16.5 0-9-0.75-33-3.75-45.75-1.5-0.75-4.5-1.5-8.25-0.75-1.5 0-6 0.75-8.25 3.75-2.25 3-5.25 5.25-9 6.75-14.25 6-48.75 18-75.75 0-19.5-13.5-28.5-38.25-27.75-74.25 0-1.5 0-3 0.75-4.5 0-1.5 7.5-27.75 15-47.25 3-6.75 9-11.25 15.75-12.75 15-2.25 42.75 0.75 60 23.25 1.5 0 3 0.75 3.75 0.75 2.25-3.75 6-6 10.5-7.5 0.75-0.75 4.5-3.75 6.75-15.75 0.75-4.5 3-8.25 6-11.25 3-2.25 16.5-15 34.5-9.75 12.75 3.75 21 15 24.75 33 2.25-0.75 4.5-0.75 6.75-0.75l26.25 0.75c6.75 0 12 3.75 15.75 9 0 0 6 7.5 18 12l108 4.5c10.5 0.75 18.75 8.25 19.5 18.75 0.75 9.75 5.25 97.5-20.25 144.75-3 7.5-12 29.25-36 40.5-9.75 4.5-21 6.75-32.25 6.75z m-111.75-85.5c44.25 27.75 67.5 33.75 67.5 33.75 1.5 0 3 0.75 4.5 1.5 23.25 10.5 42 13.5 54.75 8.25 12-5.25 15.75-17.25 15.75-18 0.75-1.5 0.75-3 1.5-4.5 14.25-24.75 16.5-75 16.5-106.5l-91.5-3.75c-1.5 0-3 0-4.5-0.75-17.25-5.25-28.5-13.5-35.25-20.25H527c-9 9.75-18 9.75-23.25 9.75-7.5-0.75-12.75-4.5-17.25-9-6.75-4.5-11.25-12-14.25-18.75-4.5 6.75-9 11.25-13.5 14.25-1.5 2.25-3 4.5-5.25 6.75-9.75 9-26.25 10.5-50.25 4.5-5.25-1.5-9.75-5.25-12.75-10.5-3-6-8.25-8.25-12.75-9.75-3.75 11.25-6.75 22.5-8.25 27-0.75 19.5 3 32.25 9.75 37.5 7.5 5.25 22.5 3 33.75-1.5 13.5-14.25 34.5-18 50.25-15 17.25 3.75 30 14.25 33 29.25 3 12.75 4.5 33 4.5 45.75zM437 728.75z m0 0z m0 0z m0 0z m0 0z"
              fill="''' + getColor(3, color, colors, '#333333') + '''"
            />
          </svg>
        ''';
        break;
      case IconNames.guanjie:
        svgXml = '''
          <svg viewBox="0 0 1024 1024" xmlns="http://www.w3.org/2000/svg">
            <path
              d="M398.08520867 588.83829211c-32.264883-2.63386779-51.36042618-19.09554319-53.99429397-52.67736007v-1.3169339c-2.63386779-7.24313727-7.24313727-11.85240592-15.80320761-9.87700506-8.56007117 0-11.85240592 4.60926864-11.85240591 11.8524059V545.37947015c0 28.97254823 23.04634487 59.92049735 50.70195921 65.8466999 9.87700507 2.63386779 20.41247707 5.92620337 30.94794829 1.31693388 7.24313727-2.63386779 8.56007117-7.24313727 8.56007117-13.1693398s-2.63386779-10.53547202-8.56007117-10.53547202z m293.01781559-121.15792775c-19.09554319 17.77860928-38.19108637 20.41247707-59.92049734 5.92620254-8.56007117-5.92620337-17.12014234-3.29233475-21.72941099 4.60926946s-1.31693391 15.80320762 5.92620338 20.41247709c13.16933981 8.56007117 27.65561436 15.80320762 43.45882195 14.48627371 20.41247707-1.31693391 38.19108637-8.56007117 51.36042536-25.02174573 4.60926864-5.92620337 5.92620337-13.16933981 0-19.09554319-5.92620337-7.24313727-13.16933981-7.24313727-19.09554236-1.31693388z"
              fill="''' + getColor(0, color, colors, '#333333') + '''"
            />
            <path
              d="M538.33867963 616.49390647c-20.41247707-3.29233475-36.21568468-19.09554319-40.82495334-38.19108638-5.92620337-28.97254823-19.09554319-42.14188807-48.06809143-46.7511567-30.28948214-5.92620337-40.82495417-17.12014234-45.43422282-48.06809143-2.63386779-14.48627371-9.87700507-26.33867963-20.4124771-33.58181689-7.24313727-4.60926864-15.80320762-7.24313727-25.02174571-7.24313728-4.60926864 0-9.87700507 0-13.16933981 1.31693391-1.31693391 0-3.29233475 1.31693391-4.60926947 1.31693472-3.29233475 1.31693391-7.24313727 1.31693391-11.8524059 2.6338678-40.82495417 14.48627371-68.48056768 40.82495417-81.64990833 79.0160397-5.92620337 17.12014234-5.92620337 32.264883-4.60926865 46.75115754v14.48627371c-1.31693391 21.72941098-5.92620337 38.19108637-15.80320761 53.99429397-21.07094404 30.94794909-46.75115671 59.92049735-70.45596937 87.57611087-4.60926864 5.92620337-10.53547202 10.53547202-15.80320759 15.80320844-11.85240592 10.53547202-21.72941098 20.41247707-30.94794911 32.26488299-17.12014234 24.36327878-10.53547202 42.14188807-2.63386861 52.67735925 27.65561436 36.21568468 59.92049735 65.18823293 96.13618202 96.13618205l2.63386863 1.31693389c5.92620337 3.29233475 10.53547202 5.92620337 17.1201415 5.92620337 4.60926864 0 9.87700507-1.31693391 13.16933983-3.29233475l1.31693388-1.31693389c3.29233475-1.31693391 5.92620337-2.63386779 8.56007117-4.60926947 14.48627371-8.56007117 25.02174573-19.09554319 34.89875162-30.28948215l17.77860847-17.77860845 62.55436513-56.62816261 7.24313728-3.29233475c3.29233475-2.63386779 5.92620337-4.60926864 8.56007034-7.24313727 8.56007117-5.92620337 15.80320762-11.85240592 24.3632796-15.8032076 17.12014234-7.24313727 37.53261859-8.56007117 57.94509568-9.87700507 61.23743124-2.63386779 109.30552185-42.14188807 123.79179638-100.74545068 4.60926864-17.77860928 2.63386779-33.5818169-5.92620338-45.43422364-6.58467031-9.87700507-19.75401013-17.12014234-38.8495533-21.0709432z m11.85240674 59.92049651c-10.53547202 43.45882195-46.75115671 72.43137021-91.52691341 74.40677107h-1.31693389c-23.04634487 1.31693391-45.43422279 2.63386779-69.79750241 11.85240591-11.85240592 4.60926864-21.72941098 13.16933981-30.94794827 20.41247707-2.63386779 2.63386779-5.92620337 4.60926864-8.56007117 5.92620336-1.31693391 1.31693391-2.63386779 1.31693391-2.63386779 1.31693392l-2.63386863 1.31693391-65.84669988 58.6035626c-7.24313727 5.92620337-14.48627371 13.16933981-20.41247709 20.41247709-9.87700507 9.87700507-17.77860928 17.77860928-27.65561352 25.02174574-1.31693391 0-1.31693391 1.31693391-2.63386864 1.31693471h-2.63386778c-32.264883-27.65561436-62.55436514-55.31122788-87.57611086-87.5761117-1.31693391-2.63386779-2.63386779-4.60926864 3.29233474-13.16933981 5.92620337-9.87700507 14.48627371-17.12014234 24.3632796-26.33867962l17.77860845-17.7786093c25.02174573-27.65561436 50.70195923-57.94509567 73.08983716-91.52691255 13.16933981-20.41247707 20.41247707-43.45882195 21.72941098-71.11443631v-17.12014234c0-11.85240592 0-24.36327878 3.29233475-34.8987508 9.87700507-28.97254823 28.97254823-46.75115671 59.92049736-57.94509567 2.63386779-1.31693391 4.60926864-1.31693391 7.24313726-1.31693389h1.3169339c2.63386779 0 3.29233475-1.31693391 5.92620255-1.3169339 4.60926864-1.31693391 9.87700507-1.31693391 11.85240589 1.3169339 3.29233475 2.63386779 4.60926864 7.24313727 5.92620339 10.53547201 7.24313727 44.77575587 30.28948214 67.16363378 73.08983715 75.72370496 14.48627371 2.63386779 17.12014234 4.60926864 20.41247708 20.41247708 7.24313727 33.5818169 34.89875079 59.92049735 68.48056769 65.84669989 8.56007117 1.31693391 14.48627371 3.29233475 17.12014235 7.24313645 1.97540085 3.9508017 1.97540085 10.53547202-0.65846696 18.43707622z m374.0092553-464.87770175v-2.6338678l-1.3169339-2.63386862c-4.60926864-9.87700507-15.80320762-23.04634487-21.72941098-30.28948131l-25.02174572-25.02174657-9.87700508-9.87700506c-7.24313727-7.24313727-14.48627371-14.48627371-21.72941097-20.41247708-8.56007117-4.60926864-20.41247707-13.16933981-32.26488299-21.72941099-9.87700507-5.92620337-17.12014234-9.87700507-24.36327879-8.56007033-13.16933981 2.63386779-30.28948214 19.09554319-42.14188805 32.264883l-20.41247709 19.09554235c-5.92620337 3.29233475-9.87700507 8.56007117-13.16933981 10.53547201-22.38787793 24.36327878-48.72655837 46.09268977-79.67450748 66.50516767-21.72941098 14.48627371-39.50802026 20.41247707-59.92049652 19.09554236-17.77860928-1.31693391-37.53261859 1.31693391-56.6281626 8.56007117-59.92049735 20.41247707-97.45311593 90.20997866-80.3329736 151.4474099 13.16933981 49.38502534 45.43422279 81.64990833 92.84384729 92.8438473 1.31693391 0 2.63386779 0 2.63386781 1.31693388 0 0 1.31693391 1.31693391 1.31693388 3.29233477 15.80320762 48.06809061 61.23743124 84.28377612 107.98858796 86.25917696H650.27807009c51.36042618 0 90.20997866-23.04634487 116.54865914-68.48056768 15.80320762-26.33867963 14.48627371-56.62816178 14.4862737-81.64990834 0-17.77860928 2.63386779-30.94794909 9.87700506-43.45882195 32.264883-51.36042618 72.43137021-93.50231423 107.98858795-129.71799894 5.92620337-5.92620337 11.85240592-14.48627371 15.80320762-19.09554317v-1.3169339c1.31693391-1.31693391 1.31693391-2.63386779 2.63386863-2.63386779 6.58467031-7.90160422 7.90160422-15.14474066 6.58466948-23.70481184z m-36.87415163 7.24313727c-2.63386779 3.29233475-8.56007117 11.85240592-11.85240593 15.80320761-37.53261859 36.21568468-79.0160397 81.64990833-113.25632436 135.6442023-10.53547202 17.12014234-15.80320762 37.53261859-15.80320762 62.55436432 0 23.04634487 1.31693391 44.77575587-9.87700506 63.87129905-19.09554319 34.89875079-48.06809061 51.36042618-86.25917698 51.36042616h-7.24313726c-32.264883-1.31693391-65.84669989-28.97254823-78.35757276-62.55436514-4.60926864-14.48627371-14.48627371-23.04634487-28.97254825-26.33867961-34.89875079-8.56007117-57.94509567-32.264883-67.16363378-68.48056769-11.85240592-43.45882195 15.80320762-94.81924814 58.60356261-109.30552269 15.80320762-4.60926864 30.28948214-7.24313727 43.45882198-5.92620254 27.65561436 2.63386779 53.99429397-4.60926864 81.64990831-24.36327878 32.264883-21.72941098 59.92049735-44.77575587 85.60071002-69.79750241 3.29233475-3.29233475 5.92620337-5.92620337 9.87700508-7.24313727l25.02174573-24.36327877c5.92620337-7.24313727 14.48627371-15.80320762 19.09554317-19.09554318h1.3169339v-1.97540085c5.92620337 3.29233475 21.72941098 14.48627371 27.65561436 20.41247706 5.92620337 4.60926864 13.16933981 11.85240592 19.09554235 17.7786093l2.63386863 2.6338678c3.29233475 2.63386779 5.92620337 4.60926864 8.56007033 7.24313727 8.56007117 8.56007117 17.12014234 15.80320762 24.3632796 24.36327878 3.29233475 3.29233475 8.56007117 10.53547202 11.85240593 15.8032076v1.97540168z"
              fill="''' + getColor(1, color, colors, '#333333') + '''"
            />
          </svg>
        ''';
        break;
      case IconNames.yiwancheng:
        svgXml = '''
          <svg viewBox="0 0 1024 1024" xmlns="http://www.w3.org/2000/svg">
            <path
              d="M471.15731754 589.73205113l231.98125827-231.98125827 38.66354348 38.66354219-270.64480175 270.64480175-160.17753504-160.17753505 38.66354218-38.66354347 121.51399286 121.51399285zM101.09197653 98.15271728h828.50449382v828.50449381H101.09197653V98.15271728z m55.23363335 55.23363334v718.03722841h718.03722841V153.38635062H156.32560988z"
              fill="''' + getColor(0, color, colors, '#333333') + '''"
            />
          </svg>
        ''';
        break;
      case IconNames.daixuexi:
        svgXml = '''
          <svg viewBox="0 0 1024 1024" xmlns="http://www.w3.org/2000/svg">
            <path
              d="M511.99999965 944.35555591C298.09777778 944.35555591 125.15555591 771.41333298 125.15555591 557.51111111S298.09777778 170.66666631 511.99999965 170.66666631 898.84444445 343.60888925 898.84444445 557.51111111 725.90222258 944.35555591 511.99999965 944.35555591z m0-45.51111146c186.5955552 0 341.33333333-154.73777813 341.33333333-341.33333334S698.59555591 216.17777778 511.99999965 216.17777778 170.66666631 370.91555591 170.66666631 557.51111111 325.40444445 898.84444445 511.99999965 898.84444445zM625.77777778 79.64444445v45.51111146h-227.5555552V79.64444445h227.5555552z m59.1644448 273.06666666l31.85777707 31.85777814-186.5955552 186.5955552-31.85777814-31.85777814L684.94222258 352.71111111z"
              fill="''' + getColor(0, color, colors, '#333333') + '''"
            />
          </svg>
        ''';
        break;
      case IconNames.xuexizhong:
        svgXml = '''
          <svg viewBox="0 0 1024 1024" xmlns="http://www.w3.org/2000/svg">
            <path
              d="M539.21185224 518.37155556l131.072 131.072-33.98163002 33.98163001-145.63555555-145.63555555V295.06370333h48.54518557v223.30785223z m-24.27259336 407.77955555C286.77688889 926.15111111 102.30518557 741.67940779 102.30518557 513.51703666S286.77688889 100.88296335 514.93925888 100.88296335 927.57333334 285.35466667 927.57333334 513.51703666 743.10163001 926.15111111 514.93925888 926.15111111z m0-48.54518556c199.03525888 0 364.08888889-165.05363001 364.08888889-364.08888889S713.9745189 149.42814778 514.93925888 149.42814778 150.85037 314.48177778 150.85037 513.51703666 315.904 877.60592555 514.93925888 877.60592555z"
              fill="''' + getColor(0, color, colors, '#333333') + '''"
            />
          </svg>
        ''';
        break;
      case IconNames.yiyuyue:
        svgXml = '''
          <svg viewBox="0 0 1024 1024" xmlns="http://www.w3.org/2000/svg">
            <path
              d="M296.48592555 226.60740779h436.90666667V129.51703667h48.54518556v97.09037112h145.63555556v631.08740665H102.30518557V226.60740779h145.63555555V129.51703667h48.54518443v97.09037112zM150.85037 275.15259222v533.99703779h728.17777777V275.15259222H150.85037z m242.72592668 97.09037113v48.54518442H247.94074112v-48.54518442h145.63555556z m194.18073998 0v48.54518442h-145.63555556v-48.54518442h145.63555556z m194.18074112 0v48.54518442h-145.63555556v-48.54518442h145.63555556z m-388.3614811 291.27111111v48.54518443H247.94074112v-48.54518443h145.63555556z m194.18073998 0v48.54518443h-145.63555556v-48.54518443h145.63555556z m194.18074112 0v48.54518443h-145.63555556v-48.54518443h145.63555556z m-388.3614811-145.63555555v48.54518442H247.94074112v-48.54518442h145.63555556z m194.18073998 0v48.54518442h-145.63555556v-48.54518442h145.63555556z m194.18074112 0v48.54518442h-145.63555556v-48.54518442h145.63555556z"
              fill="''' + getColor(0, color, colors, '#333333') + '''"
            />
          </svg>
        ''';
        break;
      case IconNames.chongzhi:
        svgXml = '''
          <svg viewBox="0 0 1024 1024" xmlns="http://www.w3.org/2000/svg">
            <path
              d="M513.59521484 78.49970703c-237.57539062 0-430.86005859 193.28466797-430.86005859 430.86005859s193.28466797 430.86005859 430.86005859 430.8600586c237.57539062 0 430.86005859-193.28466797 430.8600586-430.86005859 0-237.57539062-193.28466797-430.86005859-430.8600586-430.8600586zM719.82792969 698.76757813c0 8.37597656-7.45224609 15.35976562-15.35976563 15.35976562h-51.67177734c-7.90751953 0-15.81591797-1.85976562-23.26816406-4.65556641-13.95527344-6.06005859-24.67177734-16.75195313-30.72041016-31.20029297-2.784375-6.97236328-4.65556641-14.8921875-4.65556641-22.79970703v-135.43242187h-162.43242187v0.92460937c-1.3921875 16.29580078-3.73183594 31.65556641-6.04775391 46.09248047-3.73183594 19.08017578-9.31201172 36.75585938-16.75195312 53.98769531-14.8921875 32.12402344-37.715625 58.18798828-65.64023438 82.37988282-3.25195313 2.784375-6.97236328 4.20029297-11.17177734 3.73183593-4.18798828-0.46757813-7.90751953-2.784375-11.64023438-6.98466796-5.12402344-6.04775391-4.18798828-15.81591797 2.32822266-21.40751954 24.67177734-20.48466797 44.22041016-43.75195313 57.25195313-71.68798828 6.51533203-14.8921875 11.64023438-30.72041016 14.8921875-47.47236328 2.32822266-12.1078125 4.20029297-25.14023437 5.12402343-39.56396484h-45.61259765c-5.12402344 0-9.31201172-2.784375-12.57539063-6.51533203-2.784375-4.20029297-3.73183594-9.29970703-1.85976562-13.96757813l47.9399414-133.115625h-61.89521484c-8.37597656 0-15.35976562-6.98466797-15.35976563-15.35976562v-0.46757813c0-8.37597656 6.98466797-15.34746094 15.35976563-15.34746094h171.27597656v-26.53242187c0-8.37597656 6.98466797-15.35976562 15.35976563-15.35976563h0.46757812c8.83212891 0 15.34746094 6.98466797 15.34746094 15.35976563v26.53242187h172.2243164c8.37597656 0 14.8921875 6.97236328 14.89218751 15.34746094v0.46757813c0 8.37597656-6.51533203 15.35976562-14.8921875 15.35976562h-278.79521485c0 1.3921875 0 2.784375-0.46757812 4.18798828l-42.34746094 117.75585938h247.62041016c7.45224609 0 13.5-2.32822266 18.62402343-7.43994141 5.58017578-5.12402344 8.37597656-11.64023438 8.37597656-19.56005859v-35.83212891c0-8.37597656 6.51533203-15.35976562 15.34746094-15.35976562h0.46757813c8.37597656 0 15.35976562 6.98466797 15.35976562 15.35976562v35.83212891c0 8.37597656-1.3921875 15.82822266-4.6555664 22.81201172-6.06005859 14.42460938-16.75195313 25.12792969-30.73183594 31.18798828-7.43994141 2.784375-14.8921875 4.65556641-22.79970703 4.6555664h-0.92460938v135.44472657c0 7.90751953 2.784375 13.96757812 7.90751953 19.09248047s11.17177734 7.90751953 19.08017578 7.90751953h51.67177735c7.90751953 0 15.35976562 6.51533203 15.35976562 15.35976562v0.92460938z"
              fill="''' + getColor(0, color, colors, '#333333') + '''"
            />
          </svg>
        ''';
        break;
      case IconNames.morenxuanzhong:
        svgXml = '''
          <svg viewBox="0 0 1024 1024" xmlns="http://www.w3.org/2000/svg">
            <path
              d="M90.41421014 415.35068447C101.18244015 545.00958794 203.36806497 659.13967642 494.05885183 866.55311282c5.26311887 3.75467349 11.46722498 5.73614209 17.93103059 5.73614209 6.44019626 0 12.62659516-1.98315527 17.8711647-5.72602368 290.75655488-207.45222253 392.9581994-321.63627475 403.72811609-451.48742303l-0.01096134-49.55106034C922.11603528 230.36663455 836.75603379 160.96294092 762.03778714 153.67619314c-12.98747543-1.30692673-25.71693887-1.96544888-37.94218176-1.96544887-91.17118625 0-130.96245767 39.28705088-181.25888791 99.22691161l-30.83840414 36.78871372-30.8476788-36.79714545C430.88877497 190.99779596 391.10846405 151.71074509 299.84452875 151.71074509c-12.23451755 0-24.94543085 0.66020884-37.7963119 1.95786007C187.20265048 160.96631345 101.85108072 230.44083429 90.41083762 365.80131l0.0075888 49.54853073L90.41421014 415.35068447 90.41421014 415.35068447z"
              fill="''' + getColor(0, color, colors, '#333333') + '''"
            />
          </svg>
        ''';
        break;
      case IconNames.moren_fill:
        svgXml = '''
          <svg viewBox="0 0 1024 1024" xmlns="http://www.w3.org/2000/svg">
            <path
              d="M553.8816 217.87306667l-11.02506667-10.88853334-5.97333333 6.07573334 7.09973333 3.03786666c-2.6624 6.656-5.76853333 13.7216-9.28426666 21.23093334l19.18293333-19.456z m0 0M571.42613333 243.4048l3.3792 7.0656 5.97333334-6.07573333-11.02506667-10.8544-19.11466667 19.3536c7.54346667-3.2768 14.47253333-6.41706667 20.7872-9.48906667z m0 0M546.85013333 256.7168l-5.90506666 5.97333333 11.02506666 10.88853334 16.24746667-16.4864c-6.00746667 2.83306667-11.9808 5.49546667-17.92 7.91893333l-3.44746667-8.2944z m0 0M531.59253333 240.4352l-9.38666666-3.95946667c3.44746667-6.17813333 6.5536-12.21973333 9.35253333-18.09066666l-17.5104 17.74933333 11.02506667 10.88853333 6.51946666-6.58773333z m0 0"
              fill="''' + getColor(0, color, colors, '#333333') + '''"
            />
            <path
              d="M580.23253333 102.8096H104.78933333l818.41493334 818.41493333V445.78133333L580.23253333 102.8096z m136.9088 264.02133333l25.01973334 2.38933334c0.3072 20.48 0.27306667 35.66933333-0.1024 45.53386666l-27.9552-2.3552c1.09226667-11.29813333 2.08213333-26.48746667 3.03786666-45.568z m-301.39733333-67.41333333c10.47893333-4.16426667 21.4016-9.48906667 32.768-15.9744l7.168 14.77973333c-11.63946667 6.0416-22.7328 11.264-33.31413333 15.70133334l-6.62186667-14.50666667z m25.01973333 27.88693333c6.17813333-8.6016 11.91253333-17.88586667 17.2032-27.88693333l12.86826667 7.68a332.11733333 332.11733333 0 0 1-16.24746667 28.53546667l-13.824-8.32853334z m22.4256 16.2816c4.9152-10.17173333 9.28426667-20.20693333 13.03893334-30.13973333l13.5168 6.17813333c-3.95946667 11.33226667-7.8848 21.53813333-11.84426667 30.54933334l-14.71146667-6.58773334z m100.52266667 75.40053334c-8.26026667 1.57013333-17.8176 3.72053333-28.672 6.4512-1.77493333-22.56213333 6.9632-48.26453333 26.24853333-77.1072-24.4736 18.1248-50.8928 27.27253333-79.32586666 27.3408a221.52533333 221.52533333 0 0 0 2.49173333-28.0576c2.01386667 0.1024 3.9936 0.23893333 5.9392 0.27306666 1.91146667-7.03146667 3.41333333-14.16533333 4.47146667-21.33333333l13.03893333 3.72053333a2452.992 2452.992 0 0 0-64.27306667-54.03306666l13.24373334-16.93013334 29.4912 26.89706667 7.50933333-7.61173333-25.12213333-24.81493334 12.4928-12.62933333 25.12213333 24.81493333 6.7584-6.8608-23.6544-23.3472 52.70186667-53.3504 63.1808 62.3616-52.70186667 53.38453334-23.6544-23.3472-6.7584 6.82666666 25.3952 25.088-12.4928 12.62933334-25.3952-25.088-6.7584 6.8608 29.42293333 25.87306666a172.1344 172.1344 0 0 0-14.19946666 12.25386667l-9.14773334-7.95306667a140.1856 140.1856 0 0 1-2.69653333 15.53066667c20.992-2.73066667 43.9296-14.88213333 68.84693333-36.52266667l-14.40426666-14.19946666 17.37386666-17.6128 15.32586667 15.12106666a2796.88533333 2796.88533333 0 0 0 35.56693333-35.49866666l17.74933334 17.5104c-15.5648 15.7696-27.47733333 27.57973333-35.70346667 35.36213333l26.89706667 26.5216-17.37386667 17.6128-24.6784-24.3712c-23.58613333 31.30026667-34.33813333 60.68906667-32.256 88.23466667z m95.1296-125.1328a332.11733333 332.11733333 0 0 1-8.22613333 33.0752l-21.67466667-7.0656c4.47146667-12.04906667 8.0896-23.17653333 10.8544-33.34826667l19.0464 7.33866667z m-43.89546667 180.77013333a25.32693333 25.32693333 0 0 0 17.16906667-7.71413333l44.3392-44.91946667-13.7216-13.55093333 17.23733333-17.47626667 31.60746667 31.19786667-47.5136 48.128 29.93493333 1.1264a149.67466667 149.67466667 0 0 0-10.68373333 21.84533333c-24.064-0.2048-47.54773333 1.024-70.51946667 3.61813333l2.1504-22.25493333z m169.33546667-1.80906667c-36.01066667 43.65653333-49.18613333 83.42186667-39.5264 119.33013334-12.8 2.56-23.9616 4.98346667-33.4848 7.2704-2.79893333-33.00693333 4.096-62.1568 20.61653333-87.41546667a162.57706667 162.57706667 0 0 1-89.15626666 19.456c2.9696-10.3424 5.18826667-21.02613333 6.62186666-31.98293333 28.63786667 2.79893333 51.78026667-0.54613333 69.46133334-10.06933334 17.64693333-9.48906667 43.28106667-31.5392 76.86826666-66.048l20.03626667 19.7632c-11.19573333 11.09333333-21.64053333 20.95786667-31.4368 29.696z m0 0"
              fill="''' + getColor(1, color, colors, '#333333') + '''"
            />
          </svg>
        ''';
        break;
      case IconNames.phone_fill:
        svgXml = '''
          <svg viewBox="0 0 1024 1024" xmlns="http://www.w3.org/2000/svg">
            <path
              d="M260.8 634.88C144.32 495.68 88.96 352 108.8 241.28v-5.12c59.52-156.16 230.08-160 256-76.16L416 309.76a70.08 70.08 0 0 1-16.96 71.68l-51.2 51.2a474.56 474.56 0 0 0 233.6 234.56l43.2-43.2a70.08 70.08 0 0 1 66.56-18.56l172.8 42.88c81.92 23.36 87.68 192-79.04 261.44-173.44 48.32-404.16-131.84-524.16-274.88z"
              fill="''' + getColor(0, color, colors, '#333333') + '''"
            />
          </svg>
        ''';
        break;
      case IconNames.dizhi_fill:
        svgXml = '''
          <svg viewBox="0 0 1024 1024" xmlns="http://www.w3.org/2000/svg">
            <path
              d="M504.33495807 96.5249385C339.27608499 96.5249385 205.62156055 230.32829832 205.62156055 395.23833603c0 34.23222784 5.80459543 67.12493418 16.37193467 97.78510272V493.46994648l0.44650771 0.8930146c5.06041616 14.28823388 11.16268313 28.12996087 18.1579639 41.3763448l0.14883618 0.29767154 0.14883536 0.29767153c2.82788003 5.20925235 5.80459543 10.41850387 8.930147 15.47892087l0.29767154 0.44650691 0.14883536 0.29767154 197.80274322 342.6199508c25.00441012 43.16237402 87.36659885 43.16237402 112.22217279 0L758.99296613 551.51589746l0.89301461-1.33952151 6.3999385-11.16268314c0.29767154-0.44650772 0.59534307-0.89301462 0.74417845-1.33952152l0.14883618-0.44650772 0.14883535-0.29767153c7.29295312-13.6928908 13.6928908-27.98112551 18.90214316-42.71586713l0.44650772-0.89301463v-0.29767153c10.56734006-30.66016937 16.37193548-63.55287488 16.37193467-97.78510272C803.04835477 230.32829832 669.24499497 96.5249385 504.33495807 96.5249385z m0 431.47490735c-78.43645267 0-141.84049219-63.55287488-141.84049219-141.84049219s63.55287488-141.84049219 141.84049219-141.84049219 141.84049219 63.55287488 141.84049137 141.84049219-63.55287488 141.84049219-141.84049136 141.84049219z"
              fill="''' + getColor(0, color, colors, '#333333') + '''"
            />
          </svg>
        ''';
        break;
      case IconNames.dizhiguanli:
        svgXml = '''
          <svg viewBox="0 0 1024 1024" xmlns="http://www.w3.org/2000/svg">
            <path
              d="M821.653333 633.813333L576.533333 917.333333a85.333333 85.333333 0 0 1-129.066666 0.064L198.634667 629.952c-1.152-1.322667-2.133333-2.773333-2.88-4.266667A361.088 361.088 0 0 1 149.333333 448c0-200.298667 162.368-362.666667 362.666667-362.666667s362.666667 162.368 362.666667 362.666667c0 63.744-16.490667 125.162667-47.381334 179.370667a21.269333 21.269333 0 0 1-5.632 6.421333zM792.32 602.453333A318.442667 318.442667 0 0 0 832 448c0-176.725333-143.274667-320-320-320-176.725333 0-320 143.274667-320 320 0 55.317333 14.037333 108.522667 40.384 155.733333l247.317333 285.738667a42.666667 42.666667 0 0 0 64.554667-0.021333L792.32 602.453333zM512 597.333333a149.333333 149.333333 0 1 1 0-298.666666 149.333333 149.333333 0 0 1 0 298.666666z m0-42.666666a106.666667 106.666667 0 1 0 0-213.333334 106.666667 106.666667 0 0 0 0 213.333334z"
              fill="''' + getColor(0, color, colors, '#333333') + '''"
            />
          </svg>
        ''';
        break;
      case IconNames.lianxi_yishouqing_copy:
        svgXml = '''
          <svg viewBox="0 0 1024 1024" xmlns="http://www.w3.org/2000/svg">
            <path
              d="M496.729043 180.602435l22.038261-22.038261 15.738435 15.716174-22.016 22.038261zM304.239304 411.670261l59.792696-59.837218 14.180174 14.157914-59.814957 59.837217zM279.930435 386.760348l59.792695-59.814957 12.599653 12.577392-59.814957 59.837217z"
              fill="''' + getColor(0, color, colors, '#333333') + '''"
            />
            <path
              d="M405.147826 0L0 402.921739V1024L1024 0H405.147826z m200.347826 111.304348c15.582609-6.678261 28.93913-15.582609 44.521739-26.713044 2.226087 6.678261 4.452174 13.356522 6.678261 17.808696-20.034783 13.356522-37.843478 22.26087-55.652174 26.713043-4.452174 17.808696-13.356522 35.617391-24.486956 53.426087-4.452174-2.226087-11.130435-4.452174-17.808696-4.452173 11.130435-15.582609 17.808696-28.93913 24.486957-44.52174-15.582609 2.226087-28.93913 0-42.295653-4.452174l-6.67826 6.678261-11.130435-11.130434 73.460869-73.46087 8.904348 8.904348c2.226087 17.808696 2.226087 33.391304 0 51.2z m-100.173913 178.086956h-17.808696c0-17.808696-6.678261-35.617391-22.260869-51.2l-22.26087-22.260869 77.913044-77.913044L556.521739 173.634783l-66.782609 66.782608c8.904348 15.582609 15.582609 31.165217 15.582609 48.973913zM543.165217 20.034783l20.034783 20.034782c2.226087 2.226087 6.678261 2.226087 8.904348 0l15.582609-15.582608 6.67826 13.356521-17.808695 17.808696c-8.904348 8.904348-15.582609 6.678261-24.486957 0l-13.356522-13.356522-28.93913 28.939131 4.452174 4.452174c11.130435 11.130435 13.356522 26.713043 8.904348 44.521739h-17.808696c4.452174-15.582609 4.452174-26.713043-4.452174-33.391305l-13.356522-13.356521L543.165217 20.034783z m-111.304347 122.434782l-13.356522-13.356522 13.356522-13.356521 13.356521 13.356521 42.295652-42.295652 11.130435 11.130435-42.295652 42.295652 11.130435 11.130435 35.617391-35.617391 8.904348 11.130435-84.591304 84.591304-8.904348-11.130435 35.617391-35.617391-11.130435-11.130435-44.521739 44.521739-11.130435-11.130435 44.52174-44.521739zM244.869565 313.878261c2.226087 8.904348 4.452174 20.034783 6.678261 28.93913l55.652174-55.652174c-8.904348-2.226087-17.808696-4.452174-28.93913-6.67826l4.452173-17.808696c13.356522 2.226087 24.486957 4.452174 35.617392 4.452174l-2.226087 11.130435 66.782609-66.782609 11.130434 11.130435-64.556521 64.556521 13.356521 13.356522 60.104348-60.104348 11.130435 11.130435-60.104348 60.104348 13.356522 13.356522 60.104348-60.104348 11.130434 11.130435-60.104347 62.330434 13.356521 13.356522 69.008696-69.008696 11.130435 11.130435-142.469565 142.469565 6.67826 6.678261-13.356521 13.356522-62.330435-62.330435c0 11.130435 2.226087 22.26087 2.226087 33.391305-6.678261-2.226087-13.356522-2.226087-20.034783-2.226087 2.226087-35.617391-4.452174-69.008696-15.582608-102.4l17.808695-8.904348z m69.008696 267.130435l-97.947826 97.947826c-17.808696 17.808696-37.843478 17.808696-57.878261 0l-95.721739-95.721739 15.582608-15.582609 24.486957 24.486956 111.304348-111.304347-46.747826-46.747826-133.565218 133.565217-13.356521-13.356522 149.147826-149.147826 86.817391 86.817391-15.582609 15.582609-11.130434-11.130435-111.304348 111.304348 53.426087 53.426087c11.130435 11.130435 22.26087 11.130435 33.391304 0l91.269565-91.269565c11.130435-11.130435 13.356522-20.034783 6.678261-31.165218-4.452174-8.904348-13.356522-22.26087-24.486956-35.617391 6.678261-2.226087 13.356522-6.678261 22.260869-11.130435 11.130435 15.582609 20.034783 26.713043 24.486957 35.617392 11.130435 20.034783 6.678261 35.617391-11.130435 53.426087z m202.573913-182.539131l-8.904348-8.904348-111.304348 111.304348 8.904348 8.904348-13.356522 13.356522-60.104347-60.104348 140.243478-140.243478 60.104348 60.104348-15.582609 15.582608z m180.313043-193.669565l-120.208695 120.208696-26.713044-26.713044 13.356522-13.356522 17.808696 17.808696 46.747826-46.747826-22.26087-22.26087-84.591304 84.591305-11.130435-11.130435 84.591304-84.591304-15.582608-15.582609-37.843479 37.843478c0 6.678261 2.226087 15.582609 0 22.26087-6.678261 0-11.130435 0-17.808695 2.226087 2.226087-15.582609 0-31.165217-6.678261-46.747826l13.356522-13.356522c4.452174 6.678261 4.452174 13.356522 6.678261 17.808696l100.173913-100.173913 11.130434 11.130434-55.652174 55.652174 15.582609 15.582609L690.086957 126.886957l11.130434 11.130434-82.365217 82.365218 22.260869 22.260869 46.747827-46.747826L667.826087 178.086957l13.356522-13.356522 33.391304 33.391304-13.356522 13.356522-4.452174-6.678261z"
              fill="''' + getColor(1, color, colors, '#333333') + '''"
            />
            <path
              d="M463.961043 214.26087l22.038261-22.038261 15.738435 15.738434-22.038261 22.038261zM269.356522 373.982609l60.104348-60.104348-13.356522-13.356522-60.104348 60.104348v2.226087zM552.069565 115.756522c11.130435 2.226087 24.486957 2.226087 35.617392 0 2.226087-13.356522 4.452174-24.486957 2.226086-37.843479l-37.843478 37.843479zM355.483826 462.914783l111.749565-111.794087 26.757566 26.757565-111.749566 111.794087z"
              fill="''' + getColor(2, color, colors, '#333333') + '''"
            />
          </svg>
        ''';
        break;
      case IconNames.zhekou:
        svgXml = '''
          <svg viewBox="0 0 1024 1024" xmlns="http://www.w3.org/2000/svg">
            <path
              d="M825.892525 648.275733 825.892525 96.525404 199.583083 96.525404 199.583083 648.275733 86.092285 648.275733 512.739339 923.57887 939.382299 648.275733Z"
              fill="''' + getColor(0, color, colors, '#333333') + '''"
            />
          </svg>
        ''';
        break;
      case IconNames.remen:
        svgXml = '''
          <svg viewBox="0 0 1024 1024" xmlns="http://www.w3.org/2000/svg">
            <path
              d="M186.56 337.81333333c56.74666667-64.21333333 102.18666667-135.68 96.64-214.29333333-0.53333333-8-0.42666667-16-0.96-23.89333333-0.32-3.84 2.56-7.14666667 6.50666667-7.46666667 2.34666667-0.10666667 4.58666667-0.32 6.82666666-0.32 170.88 0 309.44 132.26666667 309.44 295.36 0 12.26666667-0.85333333 24.21333333-2.45333333 36.05333333-0.85333333 6.50666667 6.82666667 10.34666667 11.52 5.76 49.28-47.57333333 81.81333333-110.82666667 88.32-181.54666666 0.42666667-4.90666667 5.86666667-7.78666667 10.34666667-5.22666667 113.49333333 66.66666667 189.33333333 185.92 189.33333333 322.45333333 0 156.05333333-99.09333333 290.02666667-240.53333333 347.73333334-25.6 10.45333333-54.08 11.94666667-80.74666667 4.26666666-61.12-17.49333333-118.93333333-49.81333333-167.36-96.85333333-18.13333333-17.70666667-33.92-36.8-47.89333333-56.74666667-3.2-4.69333333-10.34666667-3.62666667-12.05333334 1.6-14.4 41.70666667-21.22666667 85.22666667-20.58666666 128.85333334 0.10666667 5.12-5.22666667 8.53333333-9.92 6.29333333-126.4-63.25333333-213.01333333-189.33333333-213.01333334-335.14666667 0-81.28 25.70666667-159.46666667 71.46666667-221.12"
              fill="''' + getColor(0, color, colors, '#333333') + '''"
            />
          </svg>
        ''';
        break;
      case IconNames.a_yinhangkadaizhifuzhifu:
        svgXml = '''
          <svg viewBox="0 0 1024 1024" xmlns="http://www.w3.org/2000/svg">
            <path
              d="M812 862H212c-71.68 0-130-58.32-130-130V292c0-71.68 58.32-130 130-130h600c71.68 0 130 58.32 130 130v440c0 71.68-58.32 130-130 130zM212 222c-38.59 0-70 31.41-70 70v440c0 38.59 31.41 70 70 70h600c38.59 0 70-31.41 70-70V292c0-38.59-31.41-70-70-70H212z"
              fill="''' + getColor(0, color, colors, '#333333') + '''"
            />
            <path
              d="M912 402H112c-16.57 0-30-13.43-30-30v-80c0-71.68 58.32-130 130-130h600c71.68 0 130 58.32 130 130v80c0 16.57-13.44 30-30 30z m-770-60h740v-50c0-38.59-31.41-70-70-70H212c-38.59 0-70 31.41-70 70v50zM532 542H212c-16.57 0-30-13.43-30-30s13.43-30 30-30h320c16.56 0 30 13.43 30 30s-13.44 30-30 30zM332 682H212c-16.57 0-30-13.44-30-30s13.43-30 30-30h120c16.57 0 30 13.44 30 30s-13.43 30-30 30zM812 542h-80c-16.56 0-30-13.43-30-30s13.44-30 30-30h80c16.56 0 30 13.43 30 30s-13.44 30-30 30z"
              fill="''' + getColor(1, color, colors, '#333333') + '''"
            />
          </svg>
        ''';
        break;
      case IconNames.tubiaozhizuomoban:
        svgXml = '''
          <svg viewBox="0 0 1024 1024" xmlns="http://www.w3.org/2000/svg">
            <path
              d="M215.412 747.654c0 20.425 16.557 36.983 36.983 36.983h30.761-30.761c-20.425 0-36.983 16.558-36.983 36.983v30.761-30.761c0-20.425-16.558-36.983-36.983-36.983h-30.761 30.761c20.424-0.001 36.983-16.558 36.983-36.983v-30.761 30.761z"
              fill="''' + getColor(0, color, colors, '#ED8F27') + '''"
            />
            <path
              d="M227.99 852.377h-25.154v-30.755c0-13.462-10.948-24.409-24.41-24.409h-30.763v-25.154h30.763c13.462 0 24.41-10.948 24.41-24.41v-30.754h25.154v30.754c0 13.462 10.947 24.41 24.4 24.41v25.154c-13.453 0-24.4 10.947-24.4 24.409v30.755z m-16.606-67.741a49.398 49.398 0 0 1 4.029 4.028 47.603 47.603 0 0 1 4.02-4.028 47.764 47.764 0 0 1-4.02-4.029 49.094 49.094 0 0 1-4.029 4.029z m71.77 12.577H252.39v-25.154h30.764v25.154z"
              fill="''' + getColor(1, color, colors, '#ED8F27') + '''"
            />
            <path
              d="M721.536 134.403c0 22.309 18.084 40.393 40.393 40.393h33.598-33.598c-22.309 0-40.393 18.085-40.393 40.394v33.598-33.598c0-22.309-18.085-40.394-40.394-40.394h-33.598 33.598c22.309 0 40.394-18.084 40.394-40.393v-33.598 33.598z"
              fill="''' + getColor(2, color, colors, '#ED8F27') + '''"
            />
            <path
              d="M735.275 248.784h-27.474v-33.591c0-14.703-11.958-26.66-26.661-26.66h-33.6v-27.474h33.6c14.703 0 26.661-11.958 26.661-26.661v-33.59h27.474v33.59c0 14.703 11.957 26.661 26.651 26.661v27.474c-14.694 0-26.651 11.957-26.651 26.66v33.591z m-18.138-73.988a53.875 53.875 0 0 1 4.4 4.399 52.217 52.217 0 0 1 4.39-4.399 52.08 52.08 0 0 1-4.39-4.4 53.888 53.888 0 0 1-4.4 4.4z m78.389 13.737h-33.6v-27.474h33.6v27.474z"
              fill="''' + getColor(3, color, colors, '#ED8F27') + '''"
            />
            <path
              d="M488.445 842.076h39.783v29.79h-39.783zM746.417 256.375h104.96v29.79h-104.96zM879.543 256.375h35.335v29.79h-35.335zM566.969 842.076h23.449v29.79h-23.449zM433.533 842.076h23.449v29.79h-23.449z"
              fill="''' + getColor(4, color, colors, '#300604') + '''"
            />
            <path
              d="M911.405 372.591v339.597l-102.581-0.632S704.592 833.938 705.788 833.75c1.196-0.188 0-123.314 0-123.314l-269.809 1.751V372.591h475.426z"
              fill="''' + getColor(5, color, colors, '#FCE3C3') + '''"
            />
            <path
              d="M699.002 722.731H423.641V361.913h498.444v360.818H813.782L699.002 855.4V722.731z m201.725-339.46H444.999v318.101H720.36v96.697l83.66-96.697h96.707V383.271z"
              fill="''' + getColor(6, color, colors, '#300604') + '''"
            />
            <path
              d="M696.574 861.92V725.159H421.212V359.484h503.302v365.675H814.892L696.574 861.92zM426.07 720.302h275.361v128.579l111.24-128.579h106.985v-355.96H426.07v355.96z m291.862 84.287V703.801H442.571V380.843h460.585v322.958h-98.025l-87.199 100.788zM447.428 698.943h275.361v92.606l80.121-92.606h95.388V385.7h-450.87v313.243z"
              fill="''' + getColor(7, color, colors, '#300604') + '''"
            />
            <path
              d="M658.299 372.903V245.987H110.875v344.052h87.393l88.483 100.92-1.169-100.92h147.937V372.903z"
              fill="''' + getColor(8, color, colors, '#228E9D') + '''"
            />
            <path
              d="M289.99 706.907L187.59 600.72h-87.394V235.306h568.781v148.278h-224.78V600.72H290.464l-0.474 106.187zM121.555 579.362h75.819l74.253 77.834 0.228-77.834h150.983V362.226h224.781V256.664H121.555v322.698z"
              fill="''' + getColor(9, color, colors, '#300604') + '''"
            />
            <path
              d="M292.392 712.896L186.559 603.148H97.768V232.877h573.639v153.136H446.625v217.136H292.882l-0.49 109.747zM102.625 598.291h85.997l98.966 102.627 0.458-102.627h153.721V381.155h224.781V237.734H102.625v360.557z m171.413 64.95l-77.703-81.451h-77.208V254.235h530.922v110.419H425.267V581.79H274.276l-0.238 81.451z m-150.055-86.308h74.43l70.802 74.217 0.218-74.217H420.41V359.797h224.78V259.093H123.983v317.84z"
              fill="''' + getColor(10, color, colors, '#300604') + '''"
            />
            <path
              d="M320.956 450.316c3.896 2.639 8.151 5.2 12.767 7.688 4.615 2.487 7.671 4.466 9.17 5.934 1.498 1.47 2.248 3.552 2.248 6.249 0 1.917-0.885 3.835-2.652 5.754-1.769 1.917-3.911 2.877-6.428 2.877-2.039 0-4.511-0.66-7.417-1.979-2.908-1.318-6.324-3.236-10.25-5.754-3.926-2.518-8.227-5.453-12.902-8.811-8.691 4.435-19.361 6.653-32.007 6.653-10.25 0-19.436-1.634-27.557-4.9-8.123-3.267-14.94-7.971-20.454-14.115-5.515-6.144-9.665-13.441-12.452-21.893s-4.181-17.651-4.181-27.602c0-10.129 1.453-19.421 4.36-27.872s7.117-15.644 12.632-21.578c5.514-5.934 12.228-10.474 20.139-13.621 7.912-3.146 16.903-4.72 26.973-4.72 13.666 0 25.399 2.773 35.199 8.316 9.8 5.545 17.217 13.428 22.252 23.646 5.035 10.221 7.552 22.223 7.552 36.009 0 20.92-5.664 37.492-16.992 49.719z m-20.949-14.565c3.716-4.255 6.458-9.29 8.227-15.104 1.768-5.812 2.652-12.556 2.652-20.229 0-9.65-1.559-18.012-4.675-25.085-3.117-7.071-7.567-12.421-13.351-16.048-5.785-3.626-12.423-5.439-19.915-5.439-5.335 0-10.265 1.004-14.79 3.012-4.526 2.009-8.422 4.931-11.688 8.766-3.268 3.837-5.844 8.736-7.732 14.7-1.888 5.965-2.832 12.663-2.832 20.095 0 15.164 3.536 26.837 10.609 35.019 7.072 8.182 16.004 12.272 26.792 12.272 4.435 0 8.991-0.929 13.666-2.787-2.818-2.098-6.338-4.194-10.564-6.294-4.226-2.097-7.118-3.715-8.676-4.854-1.559-1.138-2.337-2.756-2.337-4.855 0-1.798 0.749-3.385 2.248-4.765 1.498-1.378 3.147-2.068 4.945-2.068 5.453-0.002 14.594 4.555 27.421 13.664z"
              fill="''' + getColor(11, color, colors, '#ED8F27') + '''"
            />
            <path
              d="M336.06 481.246c-2.409 0-5.164-0.718-8.421-2.195-3-1.36-6.552-3.353-10.557-5.922-3.621-2.321-7.593-5.021-11.822-8.034-8.756 4.156-19.437 6.262-31.775 6.262-10.513 0-20.089-1.708-28.463-5.076-8.433-3.391-15.618-8.353-21.355-14.746-5.713-6.364-10.071-14.02-12.951-22.754-2.855-8.657-4.303-18.2-4.303-28.362 0-10.354 1.511-19.998 4.493-28.662 3.004-8.734 7.428-16.285 13.149-22.441 5.734-6.171 12.807-10.957 21.021-14.225 8.163-3.246 17.539-4.892 27.871-4.892 14.024 0 26.269 2.904 36.395 8.631 10.186 5.764 18.003 14.068 23.235 24.687 5.177 10.51 7.802 22.986 7.802 37.082 0 20.268-5.297 36.813-15.753 49.233a151.194 151.194 0 0 0 10.25 6.035c4.859 2.619 8.038 4.691 9.718 6.336 1.976 1.939 2.977 4.625 2.977 7.984 0 2.536-1.108 5.026-3.294 7.399-2.243 2.429-5.007 3.66-8.217 3.66z m-30.354-21.808l1.202 0.863c4.605 3.307 8.91 6.247 12.796 8.738 3.809 2.443 7.154 4.323 9.941 5.587 2.578 1.169 4.736 1.762 6.415 1.762 1.849 0 3.324-0.666 4.643-2.095 1.333-1.447 2.009-2.829 2.009-4.107 0-2.035-0.497-3.512-1.52-4.516-0.913-0.895-3.152-2.581-8.622-5.529-4.671-2.517-9.038-5.146-12.977-7.814l-2.342-1.586 1.922-2.075c10.846-11.707 16.346-27.88 16.346-48.068 0-13.345-2.457-25.099-7.302-34.936-4.793-9.726-11.949-17.331-21.27-22.604-9.387-5.31-20.827-8.002-34.003-8.002-9.714 0-18.487 1.53-26.075 4.548-7.539 2.999-14.018 7.379-19.257 13.018-5.257 5.656-9.333 12.626-12.115 20.715-2.806 8.154-4.229 17.267-4.229 27.082 0 9.645 1.365 18.675 4.059 26.841 2.669 8.093 6.69 15.169 11.953 21.031 5.237 5.836 11.816 10.372 19.553 13.484 7.795 3.135 16.762 4.725 26.651 4.725 12.198 0 22.595-2.149 30.903-6.388l1.319-0.674z m-32.402-9.3c-11.477 0-21.109-4.412-28.63-13.113-7.432-8.596-11.2-20.912-11.2-36.606 0-7.646 0.991-14.654 2.945-20.828 1.978-6.247 4.736-11.477 8.198-15.541 3.489-4.098 7.712-7.264 12.552-9.411 4.816-2.137 10.124-3.221 15.775-3.221 7.919 0 15.053 1.955 21.205 5.811 6.175 3.872 10.981 9.635 14.283 17.126 3.239 7.353 4.882 16.122 4.882 26.064 0 7.875-0.928 14.918-2.757 20.936-1.861 6.118-4.795 11.5-8.721 15.995l-1.444 1.654-1.791-1.271c-15.383-10.925-22.638-13.218-26.016-13.218-1.177 0-2.257 0.467-3.3 1.427-0.998 0.919-1.463 1.865-1.463 2.978 0 1.325 0.414 2.217 1.34 2.894 1.44 1.054 4.24 2.614 8.324 4.641 4.339 2.156 8.018 4.351 10.935 6.521l3.49 2.598-4.043 1.607c-4.94 1.962-9.84 2.957-14.564 2.957z m-0.359-93.864c-4.969 0-9.613 0.943-13.805 2.803-4.169 1.851-7.811 4.583-10.824 8.121-3.04 3.568-5.484 8.231-7.266 13.858-1.804 5.698-2.719 12.213-2.719 19.361 0 14.494 3.371 25.741 10.018 33.43 6.649 7.693 14.812 11.433 24.955 11.433 2.662 0 5.403-0.37 8.191-1.103a82.858 82.858 0 0 0-6.17-3.375c-4.391-2.179-7.345-3.837-9.03-5.069-2.179-1.59-3.332-3.947-3.332-6.815 0-2.496 1.02-4.7 3.031-6.552 1.955-1.798 4.172-2.71 6.59-2.71 5.743 0 14.578 4.194 26.975 12.812 2.786-3.618 4.918-7.822 6.35-12.529 1.69-5.558 2.547-12.126 2.547-19.521 0-9.265-1.503-17.375-4.469-24.105-2.903-6.586-7.082-11.623-12.419-14.97-5.364-3.364-11.631-5.069-18.623-5.069z"
              fill="''' + getColor(12, color, colors, '#ED8F27') + '''"
            />
            <path
              d="M624.43 637.357l-33.173-14.077 87.555-206.489 86.981 206.536-33.222 13.983-53.876-127.944z"
              fill="''' + getColor(13, color, colors, '#B12800') + '''"
            />
            <path
              d="M632.618 552.594h88.915v36.036h-88.915z"
              fill="''' + getColor(14, color, colors, '#B12800') + '''"
            />
          </svg>
        ''';
        break;
      case IconNames.jianshenke:
        svgXml = '''
          <svg viewBox="0 0 1024 1024" xmlns="http://www.w3.org/2000/svg">
            <path
              d="M791.04 304.10666667c-2.56 0-5.01333333-0.96-6.82666667-2.77333334L725.33333333 242.45333333c-3.73333333-3.73333333-3.73333333-9.81333333 0-13.54666666L834.98666667 119.46666667l0.64-0.64c6.08-5.12 13.76-7.78666667 22.08-7.78666667 19.2 0 40.85333333 14.4 51.41333333 34.24 8.32 15.68 8.10666667 32.10666667-0.64 45.12-0.32 0.53333333-0.74666667 0.96-1.17333333 1.38666667L797.86666667 301.33333333c-1.81333333 1.81333333-4.26666667 2.77333333-6.82666667 2.77333334z"
              fill="''' + getColor(0, color, colors, '#66C1FF') + '''"
            />
            <path
              d="M857.70666667 120.74666667c27.2 0 61.01333333 37.33333333 42.88 64.42666666L791.04 294.50666667 732.26666667 235.73333333l109.44-109.44c4.69333333-3.94666667 10.13333333-5.54666667 16-5.54666666m0-19.2c-10.56 0-20.37333333 3.41333333-28.26666667 10.02666666-0.42666667 0.42666667-0.85333333 0.74666667-1.28 1.17333334L718.72 222.18666667c-7.46666667 7.46666667-7.46666667 19.62666667 0 27.2L777.6 308.26666667c3.73333333 3.73333333 8.64 5.65333333 13.54666667 5.65333333s9.81333333-1.92 13.54666666-5.65333333L914.13333333 198.61333333c0.85333333-0.85333333 1.70666667-1.81333333 2.34666667-2.88 10.77333333-16.10666667 11.2-36.05333333 1.06666667-54.93333333-5.65333333-10.56-14.4-20.37333333-24.74666667-27.41333333-11.30666667-7.78666667-23.46666667-11.84-35.09333333-11.84z"
              fill="''' + getColor(1, color, colors, '#330867') + '''"
            />
            <path
              d="M752.10666667 494.08c-54.50666667 0-112.64-28.37333333-155.41333334-75.84-34.66666667-38.4-55.78666667-84.90666667-59.62666666-130.98666667-3.94666667-47.04 10.66666667-88 40.96-115.30666666 23.14666667-20.90666667 53.44-31.89333333 87.57333333-31.89333334 54.50666667 0 112.64 28.37333333 155.41333333 75.84 34.66666667 38.4 55.78666667 84.90666667 59.62666667 130.98666667 3.94666667 47.04-10.66666667 88-40.96 115.30666667-23.14666667 20.90666667-53.44 31.89333333-87.57333333 31.89333333z"
              fill="''' + getColor(2, color, colors, '#F7D7FF') + '''"
            />
            <path
              d="M665.6 149.65333333c50.02666667 0 105.70666667 25.38666667 148.37333333 72.64 68.69333333 76.26666667 77.33333333 180.37333333 19.30666667 232.74666667-22.08 19.84-50.56 29.44-81.17333333 29.44-50.02666667 0-105.70666667-25.38666667-148.37333334-72.64-68.69333333-76.26666667-77.33333333-180.37333333-19.30666666-232.74666667 22.08-19.84 50.56-29.44 81.17333333-29.44m0-19.2v19.2-19.2c-36.58666667 0-69.12 11.84-94.08 34.34666667-16.64 15.04-28.90666667 33.81333333-36.48 55.78666667-7.14666667 20.8-9.70666667 43.52-7.68 67.52 3.94666667 48.10666667 26.02666667 96.64 62.08 136.64 22.18666667 24.64 48.96 44.90666667 77.33333333 58.45333333 27.94666667 13.44 57.38666667 20.48 85.22666667 20.48 36.58666667 0 69.12-11.84 94.08-34.34666667 16.64-15.04 28.90666667-33.81333333 36.48-55.78666666 7.14666667-20.8 9.70666667-43.52 7.68-67.52-3.94666667-48.10666667-26.02666667-96.64-62.08-136.64-22.18666667-24.64-48.96-44.90666667-77.33333333-58.45333334-27.84-13.33333333-57.28-20.48-85.22666667-20.48z"
              fill="''' + getColor(3, color, colors, '#330867') + '''"
            />
            <path
              d="M692.58666667 579.09333333c-60.58666667 0-125.22666667-31.57333333-172.8-84.37333333-38.50666667-42.77333333-62.08-94.4-66.34666667-145.6-4.37333333-52.16 11.84-97.6 45.44-127.89333333 25.6-23.14666667 59.2-35.30666667 97.06666667-35.30666667 60.58666667 0 125.22666667 31.57333333 172.8 84.37333333 38.50666667 42.77333333 62.08 94.4 66.34666666 145.6 4.37333333 52.16-11.84 97.6-45.44 127.89333334-25.6 23.14666667-59.2 35.30666667-97.06666666 35.30666666z"
              fill="''' + getColor(4, color, colors, '#F7D7FF') + '''"
            />
            <path
              d="M595.94666667 195.62666667c55.89333333 0 118.08 28.37333333 165.65333333 81.17333333 76.69333333 85.12 86.4 201.49333333 21.54666667 259.94666667-24.64 22.18666667-56.42666667 32.85333333-90.66666667 32.85333333-55.89333333 0-118.08-28.37333333-165.65333333-81.17333333-76.69333333-85.22666667-86.29333333-201.6-21.54666667-259.94666667 24.64-22.29333333 56.53333333-32.85333333 90.66666667-32.85333333m0-19.2v19.2-19.2c-40.32 0-76.16 13.12-103.57333334 37.76-18.34666667 16.53333333-31.78666667 37.12-40.10666666 61.33333333-7.89333333 22.93333333-10.66666667 47.89333333-8.53333334 74.45333333 4.37333333 53.22666667 28.8 106.98666667 68.8 151.25333334 24.64 27.30666667 54.18666667 49.70666667 85.65333334 64.85333333 30.82666667 14.82666667 63.46666667 22.72 94.29333333 22.72 40.32 0 76.16-13.01333333 103.57333333-37.76 18.34666667-16.53333333 31.78666667-37.12 40.10666667-61.33333333 7.89333333-22.93333333 10.66666667-47.89333333 8.53333333-74.45333334-4.37333333-53.22666667-28.8-106.98666667-68.8-151.25333333-24.64-27.30666667-54.18666667-49.70666667-85.65333333-64.85333333-30.82666667-14.93333333-63.46666667-22.72-94.29333333-22.72z"
              fill="''' + getColor(5, color, colors, '#330867') + '''"
            />
            <path
              d="M597.97333333 246.61333333c42.88 0 91.41333333 22.50666667 128.96 64.10666667 59.30666667 65.81333333 68.37333333 154.34666667 20.26666667 197.76-17.70666667 16-40.74666667 23.57333333-65.6 23.57333333-42.88 0-91.41333333-22.50666667-128.96-64.10666666-59.41333333-65.81333333-68.37333333-154.34666667-20.26666667-197.76 17.70666667-16 40.74666667-23.57333333 65.6-23.57333334m0-6.4c-27.41333333 0-51.62666667 8.74666667-69.86666666 25.28-12.58666667 11.41333333-21.76 25.70666667-27.30666667 42.77333334-5.22666667 16.21333333-6.93333333 34.13333333-5.01333333 53.12 3.94666667 38.72 22.4 78.08 52.05333333 110.93333333 37.44 41.49333333 87.36 66.24 133.65333333 66.24 27.41333333 0 51.62666667-8.74666667 69.86666667-25.28 12.58666667-11.41333333 21.76-25.70666667 27.30666667-42.77333333 5.22666667-16.21333333 6.93333333-34.13333333 5.01333333-53.12-3.94666667-38.72-22.4-78.08-52.05333333-110.93333334-37.33333333-41.49333333-87.36-66.24-133.65333334-66.24z"
              fill="''' + getColor(6, color, colors, '#330867') + '''"
            />
            <path
              d="M317.86666667 777.38666667c-2.56 0-5.01333333-0.96-6.82666667-2.77333334L252.26666667 715.73333333c-3.73333333-3.73333333-3.73333333-9.81333333 0-13.54666666l343.68-344.42666667 0.64-0.64c6.08-5.12 13.76-7.78666667 22.08-7.78666667 19.2 0 40.85333333 14.4 51.41333333 34.24 8.32 15.68 8.10666667 32.10666667-0.64 45.12-0.32 0.53333333-0.74666667 0.96-1.17333333 1.38666667l-343.68 344.53333333c-1.70666667 1.81333333-4.16 2.77333333-6.72 2.77333334z"
              fill="''' + getColor(7, color, colors, '#66C1FF') + '''"
            />
            <path
              d="M618.66666667 359.04c27.2 0 61.01333333 37.33333333 42.88 64.42666667L317.86666667 767.78666667l-58.88-58.88L602.66666667 364.58666667c4.69333333-3.84 10.13333333-5.54666667 16-5.54666667m0-19.2v19.2-19.2c-10.56 0-20.37333333 3.41333333-28.26666667 10.02666667-0.42666667 0.42666667-0.85333333 0.74666667-1.28 1.17333333L245.44 695.36c-7.46666667 7.46666667-7.46666667 19.62666667 0 27.09333333l58.88 58.88c3.62666667 3.62666667 8.53333333 5.65333333 13.54666667 5.65333334 5.12 0 10.02666667-2.02666667 13.54666666-5.65333334l343.68-344.42666666c0.85333333-0.85333333 1.70666667-1.81333333 2.34666667-2.88 10.77333333-16.10666667 11.2-36.05333333 1.06666667-54.93333334-5.65333333-10.56-14.4-20.37333333-24.74666667-27.41333333-11.30666667-7.78666667-23.46666667-11.84-35.09333333-11.84z"
              fill="''' + getColor(8, color, colors, '#330867') + '''"
            />
            <path
              d="M492.69333333 593.6l-58.88-58.88 69.44-69.86666667c26.45333333-21.97333333 80.85333333 26.02666667 58.88 58.88l-69.44 69.86666667z"
              fill="''' + getColor(9, color, colors, '#FFE08A') + '''"
            />
            <path
              d="M386.98666667 897.92c-63.78666667 0-131.94666667-33.17333333-182.08-88.85333333-40.64-45.01333333-65.38666667-99.52-69.86666667-153.49333334-4.58666667-54.93333333 12.37333333-102.72 47.78666667-134.61333333 26.98666667-24.32 62.29333333-37.12 102.18666666-37.12 63.78666667 0 131.94666667 33.17333333 182.08 88.85333333 40.64 45.01333333 65.38666667 99.52 69.86666667 153.49333334 4.58666667 54.93333333-12.37333333 102.72-47.78666667 134.61333333-26.98666667 24.21333333-62.29333333 37.12-102.18666666 37.12z"
              fill="''' + getColor(10, color, colors, '#F7D7FF') + '''"
            />
            <path
              d="M285.01333333 493.33333333c58.98666667 0 124.69333333 29.97333333 174.93333334 85.76 81.06666667 89.92 91.2 212.8 22.82666666 274.56-26.02666667 23.46666667-59.62666667 34.66666667-95.78666666 34.66666667-58.98666667 0-124.69333333-29.97333333-174.93333334-85.76-81.06666667-89.92-91.2-212.8-22.82666666-274.56 26.02666667-23.36 59.62666667-34.66666667 95.78666666-34.66666667m0-19.2v19.2-19.2c-42.34666667 0-79.89333333 13.65333333-108.58666666 39.57333334-19.2 17.28-33.28 38.93333333-42.02666667 64.32-8.21333333 24-11.2 50.34666667-8.96 78.18666666 4.69333333 56 30.29333333 112.53333333 72.32 159.14666667 25.92 28.69333333 57.06666667 52.26666667 90.13333333 68.16 32.42666667 15.57333333 66.66666667 23.89333333 99.09333334 23.89333333 42.34666667 0 79.89333333-13.65333333 108.58666666-39.57333333 19.2-17.28 33.28-38.93333333 42.02666667-64.32 8.21333333-24 11.2-50.34666667 8.96-78.18666667-4.69333333-56-30.29333333-112.53333333-72.32-159.14666666-25.92-28.69333333-57.06666667-52.26666667-90.13333333-68.16-32.53333333-15.57333333-66.77333333-23.89333333-99.09333334-23.89333334z"
              fill="''' + getColor(11, color, colors, '#330867') + '''"
            />
            <path
              d="M346.13333333 894.82666667c-53.01333333 0-109.54666667-27.52-151.14666666-73.70666667-33.70666667-37.33333333-54.29333333-82.56-58.02666667-127.36-3.84-45.76 10.34666667-85.65333333 39.89333333-112.21333333 22.50666667-20.26666667 52.05333333-31.04 85.22666667-31.04 53.01333333 0 109.54666667 27.52 151.14666667 73.70666666 33.70666667 37.33333333 54.29333333 82.56 58.02666666 127.36 3.84 45.76-10.34666667 85.65333333-39.89333333 112.21333334-22.4 20.26666667-51.94666667 31.04-85.22666667 31.04z"
              fill="''' + getColor(12, color, colors, '#F7D7FF') + '''"
            />
            <path
              d="M262.18666667 560c48.53333333 0 102.61333333 24.64 144 70.61333333 66.77333333 74.02666667 75.09333333 175.25333333 18.77333333 226.02666667-21.44 19.30666667-49.06666667 28.58666667-78.82666667 28.58666667-48.53333333 0-102.61333333-24.64-144-70.61333334-66.77333333-74.02666667-75.09333333-175.25333333-18.77333333-226.02666666 21.44-19.30666667 49.06666667-28.58666667 78.82666667-28.58666667m0-19.2v19.2-19.2c-35.73333333 0-67.41333333 11.62666667-91.73333334 33.49333333-16.21333333 14.61333333-28.16 32.96-35.52 54.4-6.93333333 20.26666667-9.49333333 42.34666667-7.46666666 65.81333334 3.84 46.82666667 25.38666667 94.08 60.37333333 133.01333333 21.65333333 24 47.68 43.62666667 75.30666667 56.96 27.2 13.01333333 55.89333333 19.94666667 82.98666666 19.94666667 35.73333333 0 67.41333333-11.62666667 91.73333334-33.49333334 16.21333333-14.61333333 28.16-32.96 35.52-54.4 6.93333333-20.26666667 9.49333333-42.34666667 7.46666666-65.81333333-3.84-46.82666667-25.38666667-94.08-60.37333333-133.01333333-21.65333333-24-47.68-43.62666667-75.30666667-56.96-27.09333333-13.01333333-55.78666667-19.94666667-82.98666666-19.94666667z"
              fill="''' + getColor(13, color, colors, '#330867') + '''"
            />
            <path
              d="M290.77333333 900.26666667c-40.74666667 0-84.05333333-21.12-115.94666666-56.53333334-25.81333333-28.58666667-41.6-63.25333333-44.37333334-97.6-2.88-35.30666667 8-66.13333333 30.93333334-86.72 17.49333333-15.68 40.32-24 66.02666666-24 40.74666667 0 84.05333333 21.12 115.94666667 56.53333334 25.81333333 28.58666667 41.6 63.25333333 44.37333333 97.6 2.88 35.30666667-8 66.13333333-30.93333333 86.72-17.49333333 15.68-40.32 24-66.02666667 24z"
              fill="''' + getColor(14, color, colors, '#F7D7FF') + '''"
            />
            <path
              d="M227.30666667 645.01333333c36.69333333 0 77.54666667 18.66666667 108.8 53.33333334 50.45333333 55.89333333 56.74666667 132.37333333 14.18666666 170.77333333-16.21333333 14.61333333-37.12 21.54666667-59.52 21.54666667-36.69333333 0-77.54666667-18.66666667-108.8-53.33333334-50.45333333-55.89333333-56.74666667-132.37333333-14.18666666-170.77333333 16.10666667-14.61333333 37.01333333-21.54666667 59.52-21.54666667m0-19.2v19.2-19.2c-28.16 0-53.22666667 9.17333333-72.42666667 26.56-12.90666667 11.62666667-22.29333333 26.02666667-28.16 43.09333334-5.44 15.89333333-7.46666667 33.28-5.86666667 51.62666666 2.98666667 36.37333333 19.62666667 73.06666667 46.82666667 103.25333334 16.74666667 18.56 36.90666667 33.81333333 58.34666667 44.16 21.12 10.13333333 43.52 15.57333333 64.74666666 15.57333333 28.16 0 53.22666667-9.17333333 72.42666667-26.56 12.90666667-11.62666667 22.29333333-26.02666667 28.16-43.09333333 5.44-15.89333333 7.46666667-33.28 5.86666667-51.62666667-2.98666667-36.37333333-19.62666667-73.06666667-46.82666667-103.25333333-16.74666667-18.56-36.90666667-33.81333333-58.34666667-44.16-21.12-10.24-43.52-15.57333333-64.74666666-15.57333334z"
              fill="''' + getColor(15, color, colors, '#330867') + '''"
            />
            <path
              d="M189.01333333 910.08c-2.56 0-4.90666667-0.96-6.72-2.77333333l-59.09333333-58.56c-3.73333333-3.73333333-3.84-9.81333333-0.10666667-13.54666667l95.14666667-97.06666667c0.64-0.64 1.28-1.17333333 2.02666667-1.6 7.57333333-4.48 15.46666667-6.72 23.46666666-6.72 22.93333333 0 40.53333333 18.66666667 47.78666667 37.22666667 7.57333333 19.41333333 4.90666667 38.50666667-7.14666667 49.81333333l-88.42666666 90.24c-1.92 2.02666667-4.26666667 2.98666667-6.93333334 2.98666667z"
              fill="''' + getColor(16, color, colors, '#66C1FF') + '''"
            />
            <path
              d="M243.62666667 739.52c32.85333333 0 55.57333333 50.56 33.92 70.61333333l-88.53333334 90.45333334-59.09333333-58.56 95.14666667-97.06666667c6.29333333-3.84 12.58666667-5.44 18.56-5.44m0-19.2c-9.70666667 0-19.2 2.66666667-28.37333334 8.10666667-1.49333333 0.85333333-2.77333333 1.92-3.94666666 3.09333333l-95.14666667 97.06666667c-7.36 7.57333333-7.25333333 19.62666667 0.21333333 27.09333333l59.09333334 58.56c3.62666667 3.52 8.42666667 5.54666667 13.54666666 5.54666667h0.10666667c5.12 0 10.02666667-2.13333333 13.54666667-5.76l88.21333333-90.13333334c14.82666667-14.08 18.45333333-37.12 9.38666667-60.16-4.48-11.41333333-11.84-21.86666667-20.69333334-29.44-10.56-9.17333333-23.04-13.97333333-35.94666666-13.97333333z"
              fill="''' + getColor(17, color, colors, '#330867') + '''"
            />
            <path
              d="M171.30666667 916.69333333c-13.65333333 0-28.05333333-6.50666667-39.46666667-17.70666666-20.37333333-20.16-24.21333333-48.32-8.64-64 6.29333333-6.29333333 14.82666667-9.70666667 24.64-9.70666667 13.65333333 0 28.05333333 6.50666667 39.46666667 17.70666667 9.28 9.17333333 15.57333333 20.58666667 17.49333333 32.10666666 2.13333333 12.48-1.06666667 24.10666667-8.85333333 31.89333334-6.29333333 6.4-14.82666667 9.70666667-24.64 9.70666666z"
              fill="''' + getColor(18, color, colors, '#18A3D3') + '''"
            />
            <path
              d="M147.84 834.88c10.66666667 0 22.82666667 5.22666667 32.64 14.93333333 16.32 16.21333333 20.16 38.72 8.64 50.45333334-4.58666667 4.58666667-10.88 6.82666667-17.81333333 6.82666666-10.66666667 0-22.82666667-5.22666667-32.64-14.93333333-16.32-16.21333333-20.16-38.72-8.64-50.45333333 4.48-4.58666667 10.88-6.82666667 17.81333333-6.82666667m0-19.2c-12.26666667 0-23.46666667 4.48-31.46666667 12.58666667-9.92 10.02666667-14.08 24.74666667-11.41333333 40.32 2.34666667 13.44 9.49333333 26.66666667 20.16 37.33333333 13.22666667 13.01333333 29.97333333 20.48 46.18666667 20.48 12.26666667 0 23.46666667-4.48 31.46666666-12.58666667 9.92-10.02666667 14.08-24.74666667 11.41333334-40.32-2.34666667-13.44-9.49333333-26.66666667-20.16-37.33333333-13.22666667-13.01333333-29.97333333-20.48-46.18666667-20.48z"
              fill="''' + getColor(19, color, colors, '#330867') + '''"
            />
          </svg>
        ''';
        break;
      case IconNames.jianji:
        svgXml = '''
          <svg viewBox="0 0 1024 1024" xmlns="http://www.w3.org/2000/svg">
            <path
              d="M903.95 299.375v435.375c0 98.775-80.1 178.875-178.875 178.875h-435.375c-98.775 0-178.875-80.1-178.875-178.875V299.375c0-99 80.1-178.875 178.875-178.875h435.375c98.6625 0 178.875 79.875 178.875 178.875z"
              fill="''' + getColor(0, color, colors, '#53DEDC') + '''"
            />
            <path
              d="M903.95 299.375v46.2375h-793.125V299.375c0-17.4375 2.475-34.3125 6.8625-50.2875 1.8-5.5125 3.7125-10.8 5.7375-16.2 0.9-2.475 2.025-4.6125 3.15-7.0875 12.375-27.675 31.6125-51.525 55.8-69.525 21.2625-16.2 46.4625-27.45 73.9125-32.5125 7.7625-1.575 15.75-2.7 23.85-2.925 3.15-0.45 6.1875-0.45 9.5625-0.45h435.375c39.825 0 76.6125 13.05 106.2 34.9875 14.4 10.575 27 23.2875 37.4625 37.4625 8.4375 11.475 15.75 23.85 21.2625 37.4625 0.45 0.9 0.675 1.8 1.125 2.7 0.45 0.9 0.9 2.025 1.125 2.925 1.35 3.375 2.475 6.4125 3.375 10.0125 5.4 16.65 8.325 34.875 8.325 53.4375z"
              fill="''' + getColor(1, color, colors, '#FFFFFF') + '''"
            />
            <path
              d="M182.2625 156.3875c-24.075 17.8875-43.425 41.85-55.8 69.525l-8.8875 23.2875c-4.3875 15.975-6.8625 32.7375-6.8625 50.2875v46.2375h35.8875l112.5-112.5-76.8375-76.8375zM404.7875 120.5H289.5875c-3.375 0-6.4125 0-9.5625 0.45l112.05 112.05-112.6125 112.6125h125.1L517.175 233 404.7875 120.5zM663.0875 120.5H537.9875l112.5 112.5-112.95 112.6125h125.325L775.475 233zM895.5125 245.825l-99.7875 99.7875h108.225V299.375c0-18.5625-2.925-36.7875-8.4375-53.55z"
              fill="''' + getColor(2, color, colors, '#282828') + '''"
            />
            <path
              d="M892.1375 235.8125H206v-5.5125h684c0.45 0.9 0.675 1.8 1.125 2.7 0.3375 0.7875 0.7875 1.9125 1.0125 2.8125zM110.825 344.15h793.125v4.05h-793.125z"
              fill="''' + getColor(3, color, colors, '#282828') + '''"
            />
          </svg>
        ''';
        break;
      case IconNames.zixingche:
        svgXml = '''
          <svg viewBox="0 0 1024 1024" xmlns="http://www.w3.org/2000/svg">
            <path
              d="M666.4 571.6l-62 19 66.4-283c2.8-12.2 13.8-21 26.4-21 17.4 0 30.2 16 26.4 33l-57.2 252zM387.2 657.6l-54.6 16.8-26-75.4-48.8-142.8-39.8-114.8h57l35.6 100 50.4 142.4z"
              fill="''' + getColor(0, color, colors, '#E3F3F7') + '''"
            />
            <path
              d="M218 341.4l26.4 76.2H302l-27-76.2z"
              fill="''' + getColor(1, color, colors, '#D1DBC6') + '''"
            />
            <path
              d="M190.4 771.2c0-27.6 15.4-53 39.8-65.8L678.4 568c107.2-34.8 215.2 28.4 215.2 139 0 81.2-65.8 138.4-147 138.4h-482c-41 0-74.2-33.4-74.2-74.2z"
              fill="''' + getColor(2, color, colors, '#E3F3F7') + '''"
            />
            <path
              d="M339 785.8c-11.8 0-23-7.6-26.6-19.6-4.6-14.8 3.6-30.4 18.4-35l358.2-111.4c18.6-5.8 37.2-8.2 55.2-7 43 2.8 75.8 27.2 90.4 67.2 5.2 14.4-2.2 30.4-16.6 35.8-14.4 5.2-30.4-2.2-35.8-16.6-7-19.2-20.6-29.2-41.6-30.6-11.2-0.8-23 0.8-35 4.6l-358.2 111.4c-2.8 0.8-5.6 1.2-8.4 1.2z"
              fill="''' + getColor(3, color, colors, '#D1DBC6') + '''"
            />
            <path
              d="M746.4 790.4H265.6c-5.8 0-11.4-2.4-15.2-6.6-3.6-4-5.4-9-5-14.2v-0.6c0.6-6.8 5.6-12.6 12.6-14.8 42.6-13 437.4-134.2 437.4-134.2 14-4.6 28.2-6.8 42.4-6.8 48.6 0 101 29.2 101 93.6-0.2 55-46.6 83.6-92.4 83.6z m-8.6-160.4c-12.4 0-24.8 2-37.2 6-0.2 0-394.8 121.2-437.4 134.2-0.6 0.2-1 0.6-1 0.6 0 0.6 0.4 1.2 0.6 1.4 0.8 0.8 1.8 1.4 3 1.4h480.8c37.4 0 75.4-23 75.4-66.8 0-52.8-43.8-76.8-84.2-76.8z"
              fill="''' + getColor(4, color, colors, '#434244') + '''"
            />
            <path
              d="M175.4 863.4m-54.6 0a54.6 54.6 0 1 0 109.2 0 54.6 54.6 0 1 0-109.2 0Z"
              fill="''' + getColor(5, color, colors, '#6A6B6D') + '''"
            />
            <path
              d="M175.4 926.2c-34.6 0-62.8-28.2-62.8-62.8s28.2-62.8 62.8-62.8 62.8 28.2 62.8 62.8-28.2 62.8-62.8 62.8z m0-109c-25.4 0-46.2 20.6-46.2 46.2 0 25.4 20.6 46.2 46.2 46.2s46.2-20.6 46.2-46.2c-0.2-25.4-20.8-46.2-46.2-46.2z"
              fill="''' + getColor(6, color, colors, '#434244') + '''"
            />
            <path
              d="M866.4 863.4m-54.6 0a54.6 54.6 0 1 0 109.2 0 54.6 54.6 0 1 0-109.2 0Z"
              fill="''' + getColor(7, color, colors, '#6A6B6D') + '''"
            />
            <path
              d="M866.4 926.2c-34.6 0-62.8-28.2-62.8-62.8s28.2-62.8 62.8-62.8c34.6 0 62.8 28.2 62.8 62.8s-28.2 62.8-62.8 62.8z m0-109c-25.4 0-46.2 20.6-46.2 46.2 0 25.4 20.6 46.2 46.2 46.2 25.4 0 46.2-20.6 46.2-46.2-0.2-25.4-20.8-46.2-46.2-46.2z"
              fill="''' + getColor(8, color, colors, '#434244') + '''"
            />
            <path
              d="M746.4 853.6H264.6c-45.6 0-82.6-37-82.6-82.6 0-30.8 17-58.8 44.4-73.2l1.4-0.6L676 560c20.2-6.6 41.2-10 61.8-10 93.6 0 164.2 67.4 164.2 156.8 0 83.8-67 146.8-155.6 146.8z m-513-140.4c-21.4 11.4-34.6 33.6-34.6 58 0 36.4 29.6 65.8 65.8 65.8h481.8c79 0 138.6-56 138.6-130 0-81.2-62-140.2-147.4-140.2-19 0-38 3-56.8 9.2l-447.4 137.2z"
              fill="''' + getColor(9, color, colors, '#434244') + '''"
            />
            <path
              d="M593 602.8l69.6-297.2c3.8-16.2 18-27.4 34.6-27.4 10.8 0 21 4.8 27.6 13.4 6.8 8.4 9.2 19.4 6.8 30l-58.2 256.6-80.4 24.6z m104.2-307.8c-8.8 0-16.2 6-18.2 14.4L616 578.4l43.4-13.4 56-247.2c1.2-5.6 0-11.4-3.6-15.8s-9-7-14.6-7z"
              fill="''' + getColor(10, color, colors, '#434244') + '''"
            />
            <path
              d="M387.2 657.6l-54.6 16.8L218 345.2h57.8z"
              fill="''' + getColor(11, color, colors, '#57C0EE') + '''"
            />
            <path
              d="M327.2 684.8l-121-351.8h74.6l117.2 330-70.8 21.8z m-97.4-335l108 314.2 38.6-11.8-107.4-302.4h-39.2z"
              fill="''' + getColor(12, color, colors, '#434244') + '''"
            />
            <path
              d="M149.6 265.6h87.4c16.4 0 32.6 3.8 47.4 11 15 7.2 37.6 15.4 63.2 15.4 1.4 0 2.8 0 4.2 0.2 33 2.4 30.2 52.2-2.8 52.2H129.4c-17.2 0-29.8-16.4-25.2-33.2 5.8-21.4 18.6-45.6 45.4-45.6z"
              fill="''' + getColor(13, color, colors, '#6A6B6D') + '''"
            />
            <path
              d="M693 353.8c-7.6 0-15-3.8-19-10.8-6.4-10.6-3-24.2 7.4-30.6l124.4-75.4 44.8-116.6c4.4-11.6 17.4-17.2 28.8-12.8 11.6 4.4 17.2 17.4 12.8 28.8l-47.6 123.8c-1.8 4.6-5 8.6-9.2 11l-130.8 79.4c-3.6 2.2-7.6 3.2-11.6 3.2z"
              fill="''' + getColor(14, color, colors, '#57C0EE') + '''"
            />
            <path
              d="M693 362.2c-10.8 0-20.6-5.6-26.2-14.8-4.2-7-5.6-15.2-3.6-23.2 2-8 6.8-14.6 13.8-19l122-74 43.8-114c4.6-11.8 16-19.6 28.6-19.6 3.8 0 7.4 0.6 11 2 15.8 6 23.6 23.8 17.6 39.6l-47.6 123.8c-2.4 6.4-7 11.8-12.8 15.2l-130.8 79.4c-4.8 3-10.2 4.6-15.8 4.6z m178.4-247.8c-5.8 0-11 3.6-13 9l-45.8 119.2-126.8 77c-3.2 2-5.4 5-6.4 8.6-0.8 3.6-0.4 7.4 1.6 10.6 2.6 4.2 7 6.8 12 6.8 2.6 0 5-0.8 7.2-2l130.8-79.4c2.6-1.6 4.6-4 5.8-7l47.6-123.8c2.8-7.2-0.8-15.2-8-18-1.6-0.6-3.2-1-5-1z"
              fill="''' + getColor(15, color, colors, '#434244') + '''"
            />
            <path
              d="M516.8 616.2h38.2v116.2h-38.2z"
              fill="''' + getColor(16, color, colors, '#D1DBC6') + '''"
            />
            <path
              d="M563.4 741h-54.8V608h54.8v133z m-38.2-16.8h21.4v-99.6h-21.4v99.6z"
              fill="''' + getColor(17, color, colors, '#434244') + '''"
            />
            <path
              d="M485.8 600.4H586V632h-100.2z"
              fill="''' + getColor(18, color, colors, '#D1DBC6') + '''"
            />
            <path
              d="M594.4 640.4h-117v-48.2h117v48.2z m-100.2-16.8h83.4v-14.8h-83.4v14.8z"
              fill="''' + getColor(19, color, colors, '#434244') + '''"
            />
            <path
              d="M536 734m-24 0a24 24 0 1 0 48 0 24 24 0 1 0-48 0Z"
              fill="''' + getColor(20, color, colors, '#D1DBC6') + '''"
            />
            <path
              d="M536 766.4c-17.8 0-32.4-14.4-32.4-32.4 0-17.8 14.4-32.4 32.4-32.4s32.4 14.4 32.4 32.4c-0.2 17.8-14.6 32.4-32.4 32.4z m0-48c-8.6 0-15.6 7-15.6 15.6s7 15.6 15.6 15.6 15.6-7 15.6-15.6-7-15.6-15.6-15.6z"
              fill="''' + getColor(21, color, colors, '#434244') + '''"
            />
            <path
              d="M353 343c-1.4 0-2.8-0.2-4.4-0.4-1.8-0.2-44.6-7-60.8-10.4-13.4-2.8-40.8-14-53.2-19.4H147c-15.4 0-27.8-12.4-27.8-27.8s12.4-27.8 27.8-27.8h93.2c3.8 0 7.6 0.8 11 2.2 17.8 7.6 41.2 16.8 48.2 18.2 14.6 3.2 57.2 9.8 57.6 9.8 15.2 2.4 25.6 16.6 23.2 31.8-1.8 14-13.8 23.8-27.2 23.8z"
              fill="''' + getColor(22, color, colors, '#B1B2B5') + '''"
            />
            <path
              d="M348.8 352.8H129.4c-10.8 0-21-5-27.6-13.6-6.6-8.6-8.8-19.6-5.8-30 11.8-42.8 35.6-51.8 53.6-51.8h87.4c17.4 0 35.2 4 51 11.8 13.8 6.6 35.4 14.6 59.6 14.6 1.6 0 3.2 0 4.8 0.2 21.2 1.6 31.6 18.8 31 35-0.6 16.8-12.6 33.8-34.6 33.8zM149.6 274c-17.6 0-30.2 13.2-37.6 39.4-1.4 5.4-0.4 11 3 15.4s8.6 7 14.2 7h219.6c13.6 0 17.6-11.2 17.8-17.6 0.2-7.6-3.6-17-15.6-17.8-1.2 0-2.4-0.2-3.6-0.2-27.4 0-51.4-8.8-66.8-16.4-13.6-6.6-28.8-10-43.6-10H149.6z"
              fill="''' + getColor(23, color, colors, '#434244') + '''"
            />
          </svg>
        ''';
        break;
      case IconNames.xiaidekecheng:
        svgXml = '''
          <svg viewBox="0 0 1024 1024" xmlns="http://www.w3.org/2000/svg">
            <path
              d="M686.10165224 146.0402545H185.20990332a73.78957705 73.78957705 0 0 0-73.67709375 72.21479941v571.30680322a73.67709287 73.67709287 0 0 1 73.67709375-73.67709375H686.10165224z"
              fill="''' + getColor(0, color, colors, '#FFDC69') + '''"
            />
            <path
              d="M125.03090322 806.32198935H98.93458935v-600.66515566h1.2373251a86.72524981 86.72524981 0 0 1 85.03798887-72.21480029h513.48996914v595.04095107H185.20990332a61.07887266 61.07887266 0 0 0-61.07887265 61.07887266 14.39796621 14.39796621 0 0 0 0 2.13719766z m-0.89987255-583.90502343v506.17850273A86.16282979 86.16282979 0 0 1 185.20990332 703.17405898h488.29352783V158.63847471H185.20990332a61.52880938 61.52880938 0 0 0-61.07887265 59.84154756z"
              fill="''' + getColor(1, color, colors, '#484F59') + '''"
            />
            <path
              d="M686.10165224 715.88476338H185.20990332a73.67709287 73.67709287 0 0 0 0 147.35418662H686.10165224z"
              fill="''' + getColor(2, color, colors, '#FFFFFF') + '''"
            />
            <path
              d="M698.69987246 875.72468604H185.20990332a86.27531396 86.27531396 0 1 1 0-172.55062706h513.48996915zM185.20990332 728.48298447a61.07887266 61.07887266 0 0 0 0 122.15774532h488.29352783V728.48298447z"
              fill="''' + getColor(3, color, colors, '#484F59') + '''"
            />
            <path
              d="M328.62714541 939.05324141l-53.42995283-33.85771787-53.42995284 33.85771787V812.6210999h106.85990567v126.43214151z"
              fill="''' + getColor(4, color, colors, '#FF7A7A') + '''"
            />
            <path
              d="M209.16901865 961.88751583V800.02287969h132.05634697V961.88751583l-66.02817304-41.95657354z m66.02817393-71.76486359l40.83173262 25.98383057v-90.8871627H233.91552324v90.99964688zM547.63371055 751.7671956H686.10165224v25.19644044H547.63371055zM354.72345928 365.94669219h138.35545752v25.1964413h-138.35545752zM304.21809336 416.22709063h239.47867354v25.19644042H304.21809336z"
              fill="''' + getColor(5, color, colors, '#484F59') + '''"
            />
            <path
              d="M179.69818115 797.88568115H686.10165224v25.19644132H179.69818115zM167.09996094 153.12675342H192.29640224v558.1461621H167.09996094z"
              fill="''' + getColor(6, color, colors, '#484F59') + '''"
            />
            <path
              d="M863.15164385 300.25597168L876.42476914 286.98284638a123.73252295 123.73252295 0 0 0 0-174.46285722L875.07495987 110.72024317a123.73252295 123.73252295 0 0 0-174.46285724-1e-8l-13.723062 13.2731253-13.16064112-13.2731253a123.73252295 123.73252295 0 0 0-174.46285722 0l-1.9122293 1.799746a123.73252295 123.73252295 0 0 0 0 174.46285722l13.27312529 13.2731253 176.26260235 176.26260235z"
              fill="''' + getColor(7, color, colors, '#FF7A7A') + '''"
            />
            <path
              d="M678.0027957 485.40481895L488.46706807 295.86909131a136.1057748 136.1057748 0 0 1 0-192.23534707l1.91223017-1.79974599a135.88080644 135.88080644 0 0 1 192.23534619 0l4.27439619 4.38688037 4.38688037-4.38688037a135.88080644 135.88080644 0 0 1 192.23534708 0l1.79974599 1.79974599a136.1057748 136.1057748 0 0 1 0 192.23534707L695.77528555 485.40481895z m-91.56206689-398.19375528a109.89697675 109.89697675 0 0 0-78.73887745 32.39542441l-1.91223017 1.799746a111.02181855 111.02181855 0 0 0 0 156.69036738l181.09941943 180.64948272 180.6494836-180.64948272a110.90933438 110.90933438 0 0 0 0-156.69036738l-1.799746-1.799746a110.90933438 110.90933438 0 0 0-156.69036738 0L695.77528555 132.87961338h-17.77248985L664.72967128 119.60648809a109.6720084 109.6720084 0 0 0-78.28894247-32.39542442z"
              fill="''' + getColor(8, color, colors, '#484F59') + '''"
            />
            <path
              d="M532.78580761 260.54907998a12.59822021 12.59822021 0 0 1-8.88624492-3.71197529 85.71289307 85.71289307 0 0 1 0-121.0329044l1.799746-1.68726181a85.15047217 85.15047217 0 0 1 60.62893681-25.19644131 12.59822021 12.59822021 0 0 1 0 25.19644131A60.62893594 60.62893594 0 0 0 543.35931435 152.0019125l-1.68726181 1.79974512a60.51645176 60.51645176 0 0 0 0 85.3754414 12.59822021 12.59822021 0 0 1 0 17.88497315 12.82318857 12.82318857 0 0 1-8.88624492 3.48700781z"
              fill="''' + getColor(9, color, colors, '#484F59') + '''"
            />
          </svg>
        ''';
        break;
      case IconNames.yue:
        svgXml = '''
          <svg viewBox="0 0 1024 1024" xmlns="http://www.w3.org/2000/svg">
            <path
              d="M398.517389 256.714779l235.342006 0 63.10627-86.570681c0 0 47.312562-57.732889-15.794731-83.421968-60.335157-24.580838-156.751067-22.655999-164.971285-22.452361-8.268314-0.203638-104.636129-2.128477-164.971285 22.452361-63.082734 25.688055-15.818267 83.421968-15.818267 83.421968L398.517389 256.714779z"
              fill="''' + getColor(0, color, colors, '#F15A4A') + '''"
            />
            <path
              d="M621.095697 301.054637 406.997528 301.054637c0 0-283.274692 105.657388-283.274692 397.165602 0 254.790964 311.719534 262.703167 390.323776 260.686231 78.623685 2.015913 390.323776-5.895267 390.323776-260.686231C904.370389 406.712025 621.095697 301.054637 621.095697 301.054637zM592.014358 654.969179l63.958684 0c14.856359 0 26.900673 11.93789 26.900673 26.894534 0 14.853289-12.170181 26.894534-27.00812 26.894534L551.712467 708.758246l0 115.895567c0 15.084557-12.193717 27.313066-27.472702 27.313066-15.172561 0-27.472702-12.446473-27.472702-27.313066L496.767064 708.758246l-97.339956 0c-14.915711 0-27.00812-11.93789-27.00812-26.894534 0-14.853289 11.965519-26.894534 26.721595-26.894534l97.626481 0 0-55.239092-96.52438 0c-15.366989 0-27.823696-12.325723-27.823696-27.76946 0-15.33629 12.554944-27.76946 27.823696-27.76946l62.394049 0-72.256674-72.256674c-9.638521-9.638521-9.674337-25.229614 0.069585-34.974559 9.677407-9.677407 25.282826-9.761318 34.974559-0.069585l83.372849 83.372849c6.481621 6.481621 8.599865 15.651468 6.342452 23.928992l5.38873 0c-1.397836-7.819083 0.924045-16.136515 6.953366-22.165836l84.854597-84.854597c9.863648-9.863648 25.746384-9.777691 35.595706 0.071631 9.917884 9.917884 9.881045 25.786293 0.070608 35.595706l-71.354118 71.353095 78.400604 0c15.366989 0 27.823696 12.325723 27.823696 27.76946 0 15.33629-12.554944 27.76946-27.823696 27.76946L551.712467 599.73111l0 55.239092L592.014358 654.970202z"
              fill="''' + getColor(1, color, colors, '#F15A4A') + '''"
            />
          </svg>
        ''';
        break;
      case IconNames.jingshi:
        svgXml = '''
          <svg viewBox="0 0 1024 1024" xmlns="http://www.w3.org/2000/svg">
            <path
              d="M519.8941088 82.34201173c-233.04998827 0-422.0121216 188.96213333-422.0121216 422.0121216s188.96213333 422.0121216 422.0121216 422.0121216 422.0121216-188.96213333 422.0121216-422.0121216S752.94409707 82.34201173 519.8941088 82.34201173zM519.8941088 777.470448c-27.40596373 0-49.64848533-22.2425216-49.64848533-49.64848533s22.2425216-49.64848533 49.64848533-49.64848534 49.64848533 22.2425216 49.64848533 49.64848534S547.30007253 777.470448 519.8941088 777.470448zM569.54259413 578.8268608c0 27.40596373-22.2425216 49.64848533-49.64848533 49.64848533s-49.64848533-22.2425216-49.64848533-49.64848533l0-273.06666667c0-27.40596373 22.2425216-49.64848533 49.64848533-49.64848533s49.64848533 22.2425216 49.64848533 49.64848533L569.54259413 578.8268608z"
              fill="''' + getColor(0, color, colors, '#333333') + '''"
            />
          </svg>
        ''';
        break;
      case IconNames.qingkong:
        svgXml = '''
          <svg viewBox="0 0 1024 1024" xmlns="http://www.w3.org/2000/svg">
            <path
              d="M289.4 781.05999969l18.22000031-23.55999938-31.68 64.27999969a16.99999969 16.99999969 0 0 0 10.83999938 23.94l56.00000062 15a16.99999969 16.99999969 0 0 0 16.2-4.2c19.24000031-18.58000031 33.40000031-33.73999969 42.45999938-45.43999969l18.24-23.56000031-31.69999969 64.27999969a16.99999969 16.99999969 0 0 0 10.84000031 23.94l79.2 21.22000031a16.99999969 16.99999969 0 0 0 16.2-4.2c19.24000031-18.6 33.40000031-33.73999969 42.43999969-45.43999969l18.24-23.56000031-31.69999969 64.27999969A16.99999969 16.99999969 0 0 0 534.06000031 912.00000031l67.59999938 18.12a16.99999969 16.99999969 0 0 0 16.2-4.2c19.24000031-18.6 33.40000031-33.76000031 42.44000062-45.46000031l18.24-23.56000031-31.70000062 64.30000031a16.99999969 16.99999969 0 0 0 10.86 23.92000031l81.02000062 21.87999938 3.6-0.19999969c12.43999969-0.66 27.24-4.72000031 41.1-12 27.91999969-14.71999969 45.16000031-40.5 48.91999969-73.36000031 1.99999969-17.35999969 4.48000031-36.13999969 7.87999969-59.55999938 1.54000031-10.51999969 2.76-18.76000031 5.84000062-39.22000031 10.36000031-68.74000031 13.72000031-94.72000031 16.05999938-125.32000031l0.88000031-11.59999969 2.65999969-2.74000031 11.56000031-1.26a39.19999969 39.19999969 0 0 0 23.26000031-10.51999969c10.06000031-9.6 13.87999969-23.80000031 10.39999969-39.55999969l-35.20000031-160.86c-2.83999969-12.84-10.56-26.20000031-21.69999938-37.34000062-10.92-10.90000031-24.3-18.88000031-37.40000062-22.39999969L710.40000031 342.60000031l-2.12000062-3.68000062L757.86000031 153.99999969c7.8-29.11999969-11.02000031-59.76-42.16000031-68.1l-74.53999969-19.98c-31.12000031-8.34-62.74000031 8.77999969-70.56 37.90000031l-49.54000031 184.93999969-3.67999969 2.12000062-110.72000062-29.66000062c-13.12000031-3.52000031-28.72000031-3.28000031-43.59999938 0.70000031-15.24 4.08-28.60000031 11.80000031-37.46000062 21.49999969l-110.91999938 121.68c-10.87999969 11.92000031-14.68000031 26.1-10.8 39.46000031 3.9 13.33999969 14.86000031 23.62000031 30.84 28.62l12.75999938 4.00000031 2.00000062 3.63999938-3.40000031 12.94000031c-19.8 74.86000031-49.57999969 128.35999969-80.35999969 141.46000031-44.56000031 18.94000031-68.38000031 46.33999969-73.52000062 79.71999938-4.72000031 30.64000031 8.7 62.92000031 35.24000062 85.82000062l20.65999969 7.81999969 70.00000031 18.76000031a40.00000031 40.00000031 0 0 0 38.64-10.36000031c14.32000031-14.32000031 25.2-26.28 32.65999969-35.89999969z m516.91999969-371.77999969c13.26 3.55999969 28.08 18 30.72 30l32.4 147.91999969a10.00000031 10.00000031 0 0 1-12.36 11.80000031L257.6 438.39999969a10.00000031 10.00000031 0 0 1-4.8-16.39999969l102-111.9c8.28-9.07999969 28.33999969-14.20000031 41.59999969-10.63999969l132.50000062 35.49999938a19.99999969 19.99999969 0 0 0 24.49999969-14.13999938l54.66-204.04000031a19.99999969 19.99999969 0 0 1 24.49999969-14.14000031l72.24 19.36000031a19.99999969 19.99999969 0 0 1 14.14000031 24.49999969l-54.67999969 204.04000031a19.99999969 19.99999969 0 0 0 14.13999938 24.48l127.92 34.27999969zM327.74 689.72c-31.56 42.31999969-60.55999969 74.14000031-87 95.44000031l-5.53999969 4.47999938-2.66000062 0.56000062-82.59999938-22.60000031-2.74000031-3c-12.22000031-13.27999969-18.16000031-29.1-15.91999969-43.68 3.07999969-19.99999969 20.68000031-36.88000031 49.87999969-49.30000031 29.74000031-12.64000031 56.08000031-44.16 77.74000031-93.66 9.40000031-21.52000031 17.7-45.67999969 24.73999969-71.79999938l3.64000031-13.5 3.66-2.12000062 530.77999969 142.22000062 2.20000031 3.09999938-0.74000062 11.46c-1.86 28.68-28.44 215.05999969-30.12 229.60000031-2.20000031 19.14-10.60000031 32.80000031-25.87999969 41.62000031a68.65999969 68.65999969 0 0 1-20.05999969 7.59999938l-4.70000062 0.68000062-56.59999969-15.16000031 10.54000031-19.02c7.75999969-14.04 21.24-41.1 40.39999969-81.19999969a19.8 19.8 0 0 0-9.34000031-26.4l-2.94-1.40000062a19.99999969 19.99999969 0 0 0-24.61999969 6.08000062c-31.54000031 42.24-60.49999969 73.98-86.88 95.19999938l-5.53999969 4.46000062-2.66000062 0.55999969-49.26-13.2 10.42000031-19.00000031c3.34000031-6.07999969 6.6-12.19999969 9.79999969-18.39999938 6.6-12.66 16.78000031-33.55999969 30.56000062-62.64a19.96000031 19.96000031 0 0 0-9.36-26.54000062l-2.84000062-1.35999938a19.99999969 19.99999969 0 0 0-24.72 6.03999938c-31.5 42.19999969-60.43999969 73.90000031-86.82 95.14000031l-5.53999969 4.45999969-2.65999969 0.56000062-48.88000031-13.10000062 10.42000031-18.99999938c3.04000031-5.52 6.3-11.64 9.79999969-18.40000031 6.55999969-12.61999969 16.84000031-33.70000031 30.84-63.22000031a19.66000031 19.66000031 0 0 0-9.48-26.25999938l-3.12-1.44a19.99999969 19.99999969 0 0 0-24.43999969 6.19999969c-31.54000031 42.24-60.52000031 74.04-86.98000031 95.34l-5.53999969 4.45999969-2.66000062 0.56000062-30.6-8.20000031 10.40000062-18.97999969c3.31999969-6.10000031 6.6-12.22000031 9.79999969-18.40000031 6.54-12.64000031 16.81999969-33.72 30.82000031-63.24a19.74 19.74 0 0 0-9.44000062-26.32000031l-3.03999938-1.41999938a19.99999969 19.99999969 0 0 0-24.52000031 6.13999969z"
              fill="''' + getColor(0, color, colors, '#333333') + '''"
            />
          </svg>
        ''';
        break;
      case IconNames.shouqi:
        svgXml = '''
          <svg viewBox="0 0 1024 1024" xmlns="http://www.w3.org/2000/svg">
            <path
              d="M917.284001 726.276225c-5.406127 5.437849-13.06762 8.396227-21.479197 8.396227-9.611915 0-18.953677-3.843538-25.713638-10.543124L511.980046 364.006388 153.873018 724.08328c-6.729262 6.745634-16.072047 10.619872-25.654286 10.619872-8.470929 0-16.131399-2.989077-21.598924-8.457626-12.301164-12.435217-11.32493-33.69031 2.192945-47.312562l376.764969-378.821815c6.758937-6.788613 15.860223-10.723226 25.052582-10.8143l3.425006 0c8.981559 0.301875 17.814738 4.205788 24.423249 10.8143l376.733247 378.853537C928.728658 692.616614 929.690566 713.88501 917.284001 726.276225"
              fill="''' + getColor(0, color, colors, '#333333') + '''"
            />
          </svg>
        ''';
        break;
      case IconNames.zuixingengxin:
        svgXml = '''
          <svg viewBox="0 0 1024 1024" xmlns="http://www.w3.org/2000/svg">
            <path
              d="M512.646875 933.875a425.08125 425.08125 0 0 1-144.73125-25.3125 32.4140625 32.4140625 0 1 1 22.0640625-60.9609375 358.115625 358.115625 0 1 0-162.253125-119.98125A32.4421875 32.4421875 0 0 1 175.8078125 766.53125a416.0953125 416.0953125 0 0 1-85.66875-254.8828125A421.875 421.875 0 1 1 512.646875 933.875z"
              fill="''' + getColor(0, color, colors, '#333333') + '''"
            />
            <path
              d="M664.578125 623.2625a28.125 28.125 0 0 1-12.3328125-2.6015625l-156.4875-64.940625a32.34375 32.34375 0 0 1-20.1375-29.896875V270.0125a32.4703125 32.4703125 0 1 1 64.940625 0v234.421875l136.40625 56.4890625a31.9359375 31.9359375 0 0 1 17.5359375 42.1875 33.0609375 33.0609375 0 0 1-29.925 20.1515625z"
              fill="''' + getColor(1, color, colors, '#333333') + '''"
            />
          </svg>
        ''';
        break;
      case IconNames.live_fill:
        svgXml = '''
          <svg viewBox="0 0 1024 1024" xmlns="http://www.w3.org/2000/svg">
            <path
              d="M772.437333 90.136381l51.712 51.712-136.094476 136.094476h132.973714a71.094857 71.094857 0 0 1 71.314286 70.89981v472.600381a71.094857 71.094857 0 0 1-71.314286 70.899809H202.971429A71.094857 71.094857 0 0 1 131.657143 821.443048V348.842667A71.094857 71.094857 0 0 1 202.971429 277.942857h132.949333L199.850667 141.848381l51.712-51.712 187.806476 187.806476h145.237333l187.830857-187.806476zM548.571429 414.47619h-73.142858v341.333334h73.142858V414.47619zM414.47619 487.619048h-73.142857v195.047619h73.142857v-195.047619z m268.190477 24.380952h-73.142857v146.285714h73.142857v-146.285714z"
              fill="''' + getColor(0, color, colors, '#333333') + '''"
            />
          </svg>
        ''';
        break;
      case IconNames.live:
        svgXml = '''
          <svg viewBox="0 0 1024 1024" xmlns="http://www.w3.org/2000/svg">
            <path
              d="M772.437333 97.52381l51.712 51.712-126.342095 126.342095H828.952381a73.142857 73.142857 0 0 1 73.142857 73.142857v487.619048a73.142857 73.142857 0 0 1-73.142857 73.142857H195.047619a73.142857 73.142857 0 0 1-73.142857-73.142857v-487.619048a73.142857 73.142857 0 0 1 73.142857-73.142857h131.120762L199.850667 149.23581 251.562667 97.52381l178.054095 178.054095h164.742095L772.437333 97.52381zM828.952381 348.720762H195.047619v487.619048h633.904762v-487.619048z m-280.380952 73.142857v341.333333h-73.142858v-341.333333h73.142858z m-134.095239 73.142857v195.047619h-73.142857v-195.047619h73.142857z m268.190477 24.380953v146.285714h-73.142857v-146.285714h73.142857z"
              fill="''' + getColor(0, color, colors, '#333333') + '''"
            />
          </svg>
        ''';
        break;
      case IconNames.video_fill:
        svgXml = '''
          <svg viewBox="0 0 1024 1024" xmlns="http://www.w3.org/2000/svg">
            <path
              d="M682.666667 195.047619a73.142857 73.142857 0 0 1 73.142857 73.142857v102.448762l111.616-66.803809a39.009524 39.009524 0 0 1 15.847619-5.315048l4.193524-0.219429a39.009524 39.009524 0 0 1 39.009523 39.009524v350.012953a39.009524 39.009524 0 0 1-59.123809 33.401904L755.809524 653.604571V755.809524a73.142857 73.142857 0 0 1-73.142857 73.142857H170.666667a73.142857 73.142857 0 0 1-73.142857-73.142857V268.190476a73.142857 73.142857 0 0 1 73.142857-73.142857h512z m-280.380953 149.601524l-58.172952 58.197333 96.938667 96.938667-96.938667 96.987428 58.172952 58.197334 155.160381-155.160381-155.160381-155.160381z"
              fill="''' + getColor(0, color, colors, '#333333') + '''"
            />
          </svg>
        ''';
        break;
      case IconNames.video:
        svgXml = '''
          <svg viewBox="0 0 1024 1024" xmlns="http://www.w3.org/2000/svg">
            <path
              d="M682.666667 195.047619a73.142857 73.142857 0 0 1 73.142857 73.142857v102.4l59.904-35.937524A73.142857 73.142857 0 0 1 926.47619 397.409524V626.590476a73.142857 73.142857 0 0 1-110.762666 62.732191L755.809524 653.409524V755.809524a73.142857 73.142857 0 0 1-73.142857 73.142857H170.666667a73.142857 73.142857 0 0 1-73.142857-73.142857V268.190476a73.142857 73.142857 0 0 1 73.142857-73.142857h512z m0 73.142857H170.666667v487.619048h512V268.190476z m-268.190477 105.886476L552.399238 512l-51.712 51.712L414.47619 649.923048l-51.712-51.712 86.186667-86.235429-86.186667-86.186667L414.47619 374.101333z m438.857143 23.308191l-97.523809 58.489905v112.225523l97.523809 58.514286V397.409524z"
              fill="''' + getColor(0, color, colors, '#333333') + '''"
            />
          </svg>
        ''';
        break;
      case IconNames.dingdan:
        svgXml = '''
          <svg viewBox="0 0 1024 1024" xmlns="http://www.w3.org/2000/svg">
            <path
              d="M800.037628 928.016126L223.962372 928.016126c-52.980346 0-95.983874-43.003528-95.983874-95.983874l0-639.892491c0-52.980346 43.003528-95.983874 95.983874-95.983874l575.903242 0c52.980346 0 95.983874 43.003528 95.983874 95.983874l0 639.892491C896.021502 884.840585 852.84596 928.016126 800.037628 928.016126zM223.962372 159.973123c-17.545439 0-31.994625 14.449185-31.994625 31.994625l0 639.892491c0 17.717453 14.449185 31.994625 31.994625 31.994625l575.903242 0c17.717453 0 31.994625-14.277171 31.994625-31.994625l0-639.892491c0-17.545439-14.277171-31.994625-31.994625-31.994625L223.962372 159.973123z"
              fill="''' + getColor(0, color, colors, '#333333') + '''"
            />
            <path
              d="M640.924576 544.768688L287.779607 544.768688c-17.717453 0-31.994625-14.277171-31.994625-31.994625 0-17.717453 14.277171-31.994625 31.994625-31.994625l353.144969 0c17.717453 0 31.994625 14.277171 31.994625 31.994625C672.9192 530.491517 658.642029 544.768688 640.924576 544.768688z"
              fill="''' + getColor(1, color, colors, '#333333') + '''"
            />
            <path
              d="M734.84428 735.532337l-447.236687 0c-17.717453 0-31.994625-14.277171-31.994625-31.994625s14.277171-31.994625 31.994625-31.994625l447.236687 0c17.717453 0 31.994625 14.277171 31.994625 31.994625S752.561734 735.532337 734.84428 735.532337z"
              fill="''' + getColor(2, color, colors, '#333333') + '''"
            />
            <path
              d="M255.784982 305.325046c0 26.490173 21.501764 47.991937 47.991937 47.991937s47.991937-21.501764 47.991937-47.991937-21.501764-47.991937-47.991937-47.991937S255.784982 278.834873 255.784982 305.325046z"
              fill="''' + getColor(3, color, colors, '#333333') + '''"
            />
            <path
              d="M463.061986 305.325046c0 26.490173 21.501764 47.991937 47.991937 47.991937s47.991937-21.501764 47.991937-47.991937-21.501764-47.991937-47.991937-47.991937S463.061986 278.834873 463.061986 305.325046z"
              fill="''' + getColor(4, color, colors, '#333333') + '''"
            />
            <path
              d="M671.199059 305.325046c0 26.490173 21.501764 47.991937 47.991937 47.991937s47.991937-21.501764 47.991937-47.991937-21.501764-47.991937-47.991937-47.991937S671.199059 278.834873 671.199059 305.325046z"
              fill="''' + getColor(5, color, colors, '#333333') + '''"
            />
          </svg>
        ''';
        break;
      case IconNames.kangfushigongju:
        svgXml = '''
          <svg viewBox="0 0 1024 1024" xmlns="http://www.w3.org/2000/svg">
            <path
              d="M512 924.14375a412.1296875 412.1296875 0 1 1 292.0640625-120.9375A411.103125 411.103125 0 0 1 512 924.14375z m0-787.5984375a375.46875 375.46875 0 1 0 265.6265625 110.025A373.44375 373.44375 0 0 0 512 136.5453125z"
              fill="''' + getColor(0, color, colors, '#333333') + '''"
            />
            <path
              d="M512 933.875a421.875 421.875 0 0 1-298.546875-720.1828125 422.04375 422.04375 0 1 1 597.1078125 596.615625A418.2609375 418.2609375 0 0 1 512 933.875z m0-824.4421875a402.1875 402.1875 0 1 0 285.0046875 117.7734375A400.78125 400.78125 0 0 0 512 109.4328125z m0 787.753125a384.8625 384.8625 0 1 1 272.8125-112.6265625A383.203125 383.203125 0 0 1 512 897.1859375z m0-751.078125a365.625 365.625 0 1 0 259.2140625 106.875A365.7796875 365.7796875 0 0 0 512 146.121875z"
              fill="''' + getColor(1, color, colors, '#333333') + '''"
            />
            <path
              d="M233.1546875 475.83125a109.125 109.125 0 0 1-81.16875-31.1625 106.5515625 106.5515625 0 0 1-29.221875-59.0625 20.840625 20.840625 0 0 1 0.646875-9.084375 419.428125 419.428125 0 0 1 97.396875-154.546875 411.215625 411.215625 0 0 1 154.546875-97.396875 14.2734375 14.2734375 0 0 1 9.084375-0.646875 104.4703125 104.4703125 0 0 1 59.0625 29.221875c27.2671875 27.2671875 37.0125 68.8359375 27.2671875 116.8875a266.79375 266.79375 0 0 1-74.025 128.5734375c-48.009375 47.9953125-109.7015625 77.2171875-163.5890625 77.2171875z m-72.73125-92.2078125a70.59375 70.59375 0 0 0 18.1828125 34.4109375 75.65625 75.65625 0 0 0 55.1953125 20.1234375c44.803125 0 96.103125-25.3125 137.6578125-66.88125a225.73125 225.73125 0 0 0 63.6328125-109.6875c7.790625-35.071875 1.29375-64.2796875-16.875-83.1234375a70.59375 70.59375 0 0 0-34.425-18.1828125A379.4625 379.4625 0 0 0 160.409375 383.665625z"
              fill="''' + getColor(2, color, colors, '#333333') + '''"
            />
            <path
              d="M233.1546875 485.5765625a121.5140625 121.5140625 0 0 1-88.3125-33.75 114.159375 114.159375 0 0 1-31.8234375-64.940625 31.6125 31.6125 0 0 1 1.29375-13.640625A426.99375 426.99375 0 0 1 372.0640625 115.4375a32.6109375 32.6109375 0 0 1 13.640625-1.29375 116.1984375 116.1984375 0 0 1 64.940625 31.8234375c29.86875 29.86875 40.2609375 74.671875 29.86875 125.971875a269.2828125 269.2828125 0 0 1-76.6265625 133.115625c-49.9640625 49.9921875-114.24375 80.521875-170.7328125 80.521875zM381.9078125 132.9734375a5.85 5.85 0 0 0-3.2484375 0.646875 407.4890625 407.4890625 0 0 0-246.09375 246.09375 9.6328125 9.6328125 0 0 0-0.646875 4.5421875 92.671875 92.671875 0 0 0 26.6203125 53.9015625 102.515625 102.515625 0 0 0 74.025 27.928125c51.3 0 110.390625-27.928125 157.1484375-74.671875a259.8328125 259.8328125 0 0 0 71.4234375-123.3703125c9.7453125-44.15625 0.646875-82.4625-24.01875-107.7890625a96.665625 96.665625 0 0 0-53.9015625-26.6203125c-0.7171875-0.6609375-0.7171875-0.6609375-1.3078125-0.6609375zM233.1546875 448.5640625a84.9234375 84.9234375 0 0 1-61.6921875-22.725 75.4171875 75.4171875 0 0 1-20.784375-39.6140625 6.890625 6.890625 0 0 1 0.646875-5.1890625 389.2078125 389.2078125 0 0 1 229.21875-229.21875 16.14375 16.14375 0 0 1 5.1890625-0.646875 77.9203125 77.9203125 0 0 1 39.6140625 20.784375c20.784375 20.784375 27.928125 53.240625 19.4765625 91.5609375a237.8953125 237.8953125 0 0 1-66.234375 114.9328125c-44.1421875 43.48125-98.690625 70.115625-145.434375 70.115625z m-62.9859375-64.2796875a56.08125 56.08125 0 0 0 14.934375 27.2671875 69.80625 69.80625 0 0 0 48.0515625 17.5359375c42.1875 0 90.9140625-24.0328125 131.1609375-64.2796875a217.5890625 217.5890625 0 0 0 61.0453125-105.2015625c6.496875-31.8234375 1.9546875-57.796875-14.2875-74.025a61.875 61.875 0 0 0-27.2671875-14.934375 369.1265625 369.1265625 0 0 0-129.8671875 83.7703125 378.39375 378.39375 0 0 0-83.784375 129.853125z"
              fill="''' + getColor(3, color, colors, '#333333') + '''"
            />
            <path
              d="M272.7546875 709.5921875A205.5234375 205.5234375 0 0 1 124.7046875 653.75a18.365625 18.365625 0 1 1 25.93125-26.0296875c85.78125 84.375 261.6890625 46.7578125 392.203125-83.1234375 130.5140625-130.5140625 167.5265625-306.5625 83.109375-392.203125a18.365625 18.365625 0 1 1 25.9734375-25.9734375c98.7046875 100.6453125 61.0453125 299.9953125-83.7703125 444.15a475.3125 475.3125 0 0 1-235.06875 133.115625 387.73125 387.73125 0 0 1-60.328125 5.90625z"
              fill="''' + getColor(4, color, colors, '#333333') + '''"
            />
            <path
              d="M272.2625 709.60625a213.24375 213.24375 0 0 1-152.9015625-57.234375 27.759375 27.759375 0 0 1-8.353125-19.6875 27.2109375 27.2109375 0 0 1 7.70625-19.6875 28.321875 28.321875 0 0 1 19.9125-8.26875 27.7875 27.7875 0 0 1 19.9125 7.6359375c81.5625 78.8625 249.2578125 42.609375 374.540625-81.4078125s161.8875-289.996875 82.2375-370.7578125a24.8484375 24.8484375 0 0 1-7.70625-19.6875 28.9265625 28.9265625 0 0 1 8.353125-19.6875 27.7875 27.7875 0 0 1 19.9125-7.6359375 28.3359375 28.3359375 0 0 1 19.9125 8.26875c101.503125 101.75625 64.2375 303.35625-82.8703125 448.9875a478.715625 478.715625 0 0 1-237.65625 132.91875 364.4578125 364.4578125 0 0 1-63 6.24375z m-132.975-85.8515625a8.296875 8.296875 0 0 0-6.4265625 2.5453125 9.1546875 9.1546875 0 0 0 0 12.65625 194.8921875 194.8921875 0 0 0 139.4015625 51.5109375 313.7203125 313.7203125 0 0 0 58.4578125-5.7234375 461.25 461.25 0 0 0 228.065625-127.828125C698.1875 418.90625 735.453125 230.0328125 641.65625 135.2796875a8.296875 8.296875 0 0 0-6.4265625-2.5453125 6.2859375 6.2859375 0 0 0-5.7796875 2.5453125 9.1546875 9.1546875 0 0 0 0 12.65625c87.3703125 87.7640625 50.1046875 266.4703125-82.2375 397.4765625-132.975 131.6390625-312.8625 167.8921875-401.5125 81.4078125a7.846875 7.846875 0 0 0-6.4125-3.065625z"
              fill="''' + getColor(5, color, colors, '#333333') + '''"
            />
            <path
              d="M393.453125 877.3859375a341.71875 341.71875 0 0 1-99.9984375-14.2875 18.703125 18.703125 0 0 1 11.0390625-35.71875c125.971875 38.9671875 282.4734375-11.0390625 398.053125-126.5625s164.9390625-271.40625 126.5625-398.053125a18.703125 18.703125 0 0 1 35.71875-11.0390625c42.8625 138.965625-10.3921875 309.740625-135.7171875 435.065625-97.340625 96.7078125-220.7109375 150.5953125-335.6578125 150.5953125z"
              fill="''' + getColor(6, color, colors, '#333333') + '''"
            />
            <path
              d="M392.7640625 877.3859375a376.2984375 376.2984375 0 0 1-103.5703125-14.3578125 26.7890625 26.7890625 0 0 1-19.0125-33.75 28.40625 28.40625 0 0 1 13.7671875-16.2421875 28.8421875 28.8421875 0 0 1 21.628125-1.8703125c123.8765625 36.225 277.25625-10.6171875 391.9640625-119.278125 114.046875-108.6609375 163.209375-255.4171875 125.15625-373.44375a26.7890625 26.7890625 0 0 1 19.0125-33.75 28.575 28.575 0 0 1 35.3953125 18.1125c44.578125 136.7578125-10.490625 304.7484375-138.9515625 427.78125-98.2828125 93.09375-224.128125 146.7984375-345.3890625 146.7984375z m-95.6953125-48.7125a9.6328125 9.6328125 0 0 0-3.9375 1.2515625 11.25 11.25 0 0 0-4.584375 4.9921875 8.6203125 8.6203125 0 0 0 5.8921875 10.6171875 357.3984375 357.3984375 0 0 0 97.6640625 13.7390625c116.015625 0 236.615625-51.834375 331.003125-141.7640625 123.8765625-118.0265625 176.315625-278.521875 134.3671875-409.0359375a9.2109375 9.2109375 0 0 0-11.1375-5.625 8.6203125 8.6203125 0 0 0-5.90625 10.6171875c39.9796875 124.2703125-10.490625 278.521875-129.7828125 392.175s-280.5328125 162.365625-411.6375 123.6515625c0.028125-0.61875-0.675-0.61875-1.940625-0.61875z"
              fill="''' + getColor(7, color, colors, '#333333') + '''"
            />
          </svg>
        ''';
        break;
      case IconNames.kecheng:
        svgXml = '''
          <svg viewBox="0 0 1024 1024" xmlns="http://www.w3.org/2000/svg">
            <path
              d="M512 725.9609375a26.353125 26.353125 0 0 1-12.3328125-2.6015625l-250.65-105.2015625a32.34375 32.34375 0 0 1-20.1375-29.925v-423.28125a32.990625 32.990625 0 0 1 14.2875-27.2671875 32.00625 32.00625 0 0 1 30.515625-2.6015625l137.6578125 57.796875a32.34375 32.34375 0 0 1-24.6796875 59.7375l-92.8125-38.9671875v352.603125l185.709375 77.9203125v-374.0625a32.34375 32.34375 0 0 1 20.1234375-29.86875l250.65-105.2015625a33.8625 33.8625 0 0 1 30.515625 2.6015625 32.1609375 32.1609375 0 0 1 14.2875 27.2671875v423.3234375a32.34375 32.34375 0 0 1-20.1234375 29.86875l-137.0109375 57.15a32.34375 32.34375 0 0 1-24.6796875-59.7375l116.8875-49.3453125v-352.546875l-185.7375 77.8921875v401.3015625a32.990625 32.990625 0 0 1-14.2875 27.2671875 30.375 30.375 0 0 1-18.1828125 5.878125z"
              fill="''' + getColor(0, color, colors, '#333333') + '''"
            />
            <path
              d="M512 891.6875a35.15625 35.15625 0 0 1-11.334375-1.9125L110.2765625 738.490625A31.978125 31.978125 0 0 1 90.125 708.48125V329.3a31.4859375 31.4859375 0 1 1 62.971875 0v356.8359375L512 825.3546875l358.903125-139.21875v-331.3125a31.4859375 31.4859375 0 1 1 62.971875 0v353.64375a32.6390625 32.6390625 0 0 1-20.1515625 30.009375L523.334375 889.7609375A30.121875 30.121875 0 0 1 512 891.6875z"
              fill="''' + getColor(1, color, colors, '#333333') + '''"
            />
          </svg>
        ''';
        break;
      case IconNames.gouwuche:
        svgXml = '''
          <svg viewBox="0 0 1024 1024" xmlns="http://www.w3.org/2000/svg">
            <path
              d="M362.428355 812.03023719c-33.22022531 0-59.98992094 26.76969562-59.98992094 59.98992094 0 33.22022531 26.76969562 59.98992094 59.98992094 59.98992093s59.98992094-26.76969562 59.98992094-59.98992093C422.41827688 838.79993281 395.64858031 812.03023719 362.428355 812.03023719L362.428355 812.03023719z"
              fill="''' + getColor(0, color, colors, '#333333') + '''"
            />
            <path
              d="M782.51906562 812.03023719c-33.22022531 0-59.98992094 26.76969562-59.98992093 59.98992094 0 33.22022531 26.76969562 59.98992094 59.98992094 59.98992093s59.98992094-26.76969562 59.98992093-59.98992093C842.5089875 838.79993281 815.57802781 812.03023719 782.51906562 812.03023719L782.51906562 812.03023719z"
              fill="''' + getColor(1, color, colors, '#333333') + '''"
            />
            <path
              d="M842.02519719 782.03527625L354.68772031 782.03527625c-43.21854562 0-81.2766675-34.18780406-86.43709031-77.89013906l-50.95918031-358.16563032L188.42533156 178.58827437c-1.77389531-14.67495375-15.15874313-26.6084325-28.05980156-26.6084325L121.98488188 151.97984187c-16.61011219 0-29.99496094-13.38484781-29.99496094-29.99496093s13.38484781-29.99496094 29.99496094-29.99496094l38.219385 0c43.702335 0 82.24424625 34.18780406 87.56593312 77.89013906l28.86611813 166.74617813L327.75676156 696.40450156c1.61263219 13.86863813 14.3524275 25.64085375 26.93095875 25.64085375l487.33747688 0c16.61011219 0 29.99496094 13.38484781 29.99496093 29.99496094S858.63531031 782.03527625 842.02519719 782.03527625z"
              fill="''' + getColor(2, color, colors, '#333333') + '''"
            />
            <path
              d="M392.26205281 662.05543438c-15.64253344 0-28.704855-11.93347875-29.83369687-27.73727532-1.29010594-16.44884906 11.12716312-30.96253969 27.73727531-32.0913825l407.02838906-29.99496094c14.99748-0.16126313 27.57601219-11.77221562 29.18864438-25.15706343l47.25012562-270.27717094c1.12884281-9.99832031-1.61263219-21.1254825-7.57937156-27.89853844-3.87031781-4.35410719-8.70821438-6.61179281-14.3524275-6.61179281L331.94960563 242.28725c-16.61011219 0-29.99496094-13.38484781-29.99496094-29.99496094S315.50075562 181.97480281 331.94960563 181.97480281l519.42885937 0c22.89937875 0 44.02486125 9.51453094 59.34486844 26.76969563 17.57769187 19.8353775 25.47958969 47.57265281 22.09306219 76.60003406l-47.25012563 270.43843406c-5.16042375 42.08970281-43.0572825 76.27750688-86.27582719 76.27750688l-404.77070343 29.83369687C393.71342188 661.89417125 392.90710531 662.05543438 392.26205281 662.05543438z"
              fill="''' + getColor(3, color, colors, '#333333') + '''"
            />
          </svg>
        ''';
        break;
      case IconNames.liebiaoxingshi:
        svgXml = '''
          <svg viewBox="0 0 1024 1024" xmlns="http://www.w3.org/2000/svg">
            <path
              d="M896.021502 255.956996 607.897867 255.956996c-17.717453 0-31.994625-14.277171-31.994625-31.994625 0-17.717453 14.277171-31.994625 31.994625-31.994625l287.951621 0c17.717453 0 31.994625 14.277171 31.994625 31.994625C928.016126 241.679825 913.738955 255.956996 896.021502 255.956996z"
              fill="''' + getColor(0, color, colors, '#333333') + '''"
            />
            <path
              d="M896.021502 415.930119 607.897867 415.930119c-17.717453 0-31.994625-14.277171-31.994625-31.994625s14.277171-31.994625 31.994625-31.994625l287.951621 0c17.717453 0 31.994625 14.277171 31.994625 31.994625S913.738955 415.930119 896.021502 415.930119z"
              fill="''' + getColor(1, color, colors, '#333333') + '''"
            />
            <path
              d="M896.021502 672.05913 607.897867 672.05913c-17.717453 0-31.994625-14.277171-31.994625-31.994625s14.277171-31.994625 31.994625-31.994625l287.951621 0c17.717453 0 31.994625 14.277171 31.994625 31.994625S913.738955 672.05913 896.021502 672.05913z"
              fill="''' + getColor(2, color, colors, '#333333') + '''"
            />
            <path
              d="M896.021502 832.032253 607.897867 832.032253c-17.717453 0-31.994625-14.277171-31.994625-31.994625s14.277171-31.994625 31.994625-31.994625l287.951621 0c17.717453 0 31.994625 14.277171 31.994625 31.994625S913.738955 832.032253 896.021502 832.032253z"
              fill="''' + getColor(3, color, colors, '#333333') + '''"
            />
            <path
              d="M383.935495 479.919368 191.967747 479.919368c-52.980346 0-95.983874-43.003528-95.983874-95.983874L95.983874 191.967747c0-52.980346 43.003528-95.983874 95.983874-95.983874l191.967747 0c52.980346 0 95.983874 43.003528 95.983874 95.983874l0 191.967747C479.919368 436.915841 436.915841 479.919368 383.935495 479.919368zM191.967747 159.973123c-17.545439 0-31.994625 14.449185-31.994625 31.994625l0 191.967747c0 17.545439 14.449185 31.994625 31.994625 31.994625l191.967747 0c17.545439 0 31.994625-14.449185 31.994625-31.994625L415.930119 191.967747c0-17.545439-14.449185-31.994625-31.994625-31.994625L191.967747 159.973123 191.967747 159.973123z"
              fill="''' + getColor(4, color, colors, '#333333') + '''"
            />
            <path
              d="M383.935495 928.016126 191.967747 928.016126c-52.980346 0-95.983874-43.003528-95.983874-95.983874L95.983874 639.892491c0-52.980346 43.003528-95.983874 95.983874-95.983874l191.967747 0c52.980346 0 95.983874 43.003528 95.983874 95.983874l0 191.967747C479.919368 884.840585 436.915841 928.016126 383.935495 928.016126zM191.967747 607.897867c-17.545439 0-31.994625 14.277171-31.994625 31.994625l0 191.967747c0 17.717453 14.449185 31.994625 31.994625 31.994625l191.967747 0c17.545439 0 31.994625-14.277171 31.994625-31.994625L415.930119 639.892491c0-17.717453-14.449185-31.994625-31.994625-31.994625L191.967747 607.897867 191.967747 607.897867z"
              fill="''' + getColor(5, color, colors, '#333333') + '''"
            />
          </svg>
        ''';
        break;
      case IconNames.duigou:
        svgXml = '''
          <svg viewBox="0 0 1024 1024" xmlns="http://www.w3.org/2000/svg">
            <path
              d="M383.29630697 812.30861712c-34.32098481 0-64.35184654-12.87036929-90.09258518-38.6111079l-171.60492404-171.60492408c-51.48147723-51.48147723-51.48147723-132.99381616 0-180.18517028 51.48147723-51.48147723 132.99381616-51.48147723 180.18517026 0l90.09258514 90.09258514 338.91972506-270.27775542c55.77160034-42.90123101 137.28393923-34.32098481 180.18517026 21.45061551s34.32098481 137.28393923-21.45061551 180.18517027l-429.01231019 343.20984816c-21.4506155 17.16049241-47.19135413 25.7407386-77.2222158 25.7407386"
              fill="''' + getColor(0, color, colors, '#333333') + '''"
            />
          </svg>
        ''';
        break;
      case IconNames.hot:
        svgXml = '''
          <svg viewBox="0 0 1024 1024" xmlns="http://www.w3.org/2000/svg">
            <path
              d="M517.546667 91.733333A42.666667 42.666667 0 0 0 494.933333 85.333333h-4.266666a21.333333 21.333333 0 0 0-21.333334 21.333334v197.12a21.333333 21.333333 0 0 1-39.253333 11.52 305.92 305.92 0 0 0-104.106667-74.666667 20.053333 20.053333 0 0 0-18.346666 0 20.906667 20.906667 0 0 0-8.96 17.493333c-13.226667 120.746667-128 170.666667-128 341.333334a341.333333 341.333333 0 0 0 682.666666 0c0-267.946667-232.96-443.306667-335.786666-507.733334zM512 853.333333a170.666667 170.666667 0 0 1-170.666667-170.666666c0-115.2 116.053333-181.76 128-246.613334a10.666667 10.666667 0 0 1 11.946667-8.533333A281.173333 281.173333 0 0 1 682.666667 682.666667a170.666667 170.666667 0 0 1-170.666667 170.666666z"
              fill="''' + getColor(0, color, colors, '#333333') + '''"
            />
          </svg>
        ''';
        break;
      case IconNames.nandu:
        svgXml = '''
          <svg viewBox="0 0 1024 1024" xmlns="http://www.w3.org/2000/svg">
            <path
              d="M620.02080427 129.93385813l-47.98982827 383.90697529a29.12711111 29.12711111 0 0 1-28.90574507 25.51534933H257.83682845a17.47626667 17.47626667 0 0 1-13.15380338-28.98147555l344.84751928-394.11311502a17.47626667 17.47626667 0 0 1 30.49608534 13.67226595z"
              fill="''' + getColor(0, color, colors, '#333333') + '''"
            />
            <path
              d="M401.15386595 890.52428515l47.98982827-383.90697528a29.12711111 29.12711111 0 0 1 28.89991965-25.51534934h285.30005333a17.47626667 17.47626667 0 0 1 13.15380338 28.98730098l-344.84751929 394.1072896a17.47626667 17.47626667 0 0 1-30.49608534-13.67226596z"
              fill="''' + getColor(1, color, colors, '#333333') + '''"
            />
          </svg>
        ''';
        break;
      case IconNames.yanjing:
        svgXml = '''
          <svg viewBox="0 0 1024 1024" xmlns="http://www.w3.org/2000/svg">
            <path
              d="M512 832c-156.448 0-296.021333-98.730667-418.410667-291.605333a52.938667 52.938667 0 0 1 0-56.789334C215.978667 290.730667 355.552 192 512 192c156.448 0 296.021333 98.730667 418.410667 291.605333a52.938667 52.938667 0 0 1 0 56.789334C808.021333 733.269333 668.448 832 512 832z m0-576c-129.514667 0-249.461333 83.850667-360.117333 256C262.538667 684.149333 382.485333 768 512 768c129.514667 0 249.461333-83.850667 360.117333-256C761.461333 339.850667 641.514667 256 512 256z m0 405.333333c-83.210667 0-150.666667-66.858667-150.666667-149.333333S428.789333 362.666667 512 362.666667s150.666667 66.858667 150.666667 149.333333S595.210667 661.333333 512 661.333333z m0-64c47.552 0 86.101333-38.208 86.101333-85.333333S559.552 426.666667 512 426.666667c-47.552 0-86.101333 38.208-86.101333 85.333333s38.549333 85.333333 86.101333 85.333333z"
              fill="''' + getColor(0, color, colors, '#333333') + '''"
            />
          </svg>
        ''';
        break;
      case IconNames.yanjing_fill:
        svgXml = '''
          <svg viewBox="0 0 1024 1024" xmlns="http://www.w3.org/2000/svg">
            <path
              d="M512 192c156.448 0 296.021333 98.730667 418.410667 291.605333a52.938667 52.938667 0 0 1 0 56.789334C808.021333 733.269333 668.448 832 512 832c-156.448 0-296.021333-98.730667-418.410667-291.605333a52.938667 52.938667 0 0 1 0-56.789334C215.978667 290.730667 355.552 192 512 192z m0 128c-106.037333 0-192 85.962667-192 192s85.962667 192 192 192 192-85.962667 192-192-85.962667-192-192-192z m0 320c70.688 0 128-57.312 128-128s-57.312-128-128-128-128 57.312-128 128 57.312 128 128 128z"
              fill="''' + getColor(0, color, colors, '#333333') + '''"
            />
          </svg>
        ''';
        break;
      case IconNames.fenlei:
        svgXml = '''
          <svg viewBox="0 0 1024 1024" xmlns="http://www.w3.org/2000/svg">
            <path
              d="M476.7232 112.503467L121.634133 279.825067a68.266667 68.266667 0 0 0 1.6896 124.279466l355.089067 155.648a68.266667 68.266667 0 0 0 54.818133 0l355.089067-155.6992a68.266667 68.266667 0 0 0 1.672533-124.279466l-355.089066-167.253334a68.266667 68.266667 0 0 0-58.197334 0zM150.7328 341.572267l355.089067-167.304534 355.072 167.253334-355.089067 155.6992-355.072-155.648zM860.842667 685.346133a34.133333 34.133333 0 0 1 28.962133 61.781334l-2.4064 1.1264-368.810667 155.682133a34.133333 34.133333 0 0 1-23.671466 1.0752l-2.8672-1.0752-368.7936-155.648a34.133333 34.133333 0 0 1 24.064-63.829333l2.491733 0.938666 355.498667 150.050134 355.5328-150.101334z"
              fill="''' + getColor(0, color, colors, '#000000') + '''"
            />
            <path
              d="M853.333333 512l-341.486933 153.634133L170.666667 512.341333v55.210667c0 13.4656 7.748267 25.6512 19.712 30.9248l286.190933 126.976a78.7968 78.7968 0 0 0 35.2768 8.3968c12.049067 0 24.081067-2.798933 35.293867-8.3968l286.498133-127.249067A33.7408 33.7408 0 0 0 853.333333 567.278933V512z"
              fill="''' + getColor(1, color, colors, '#C34D49') + '''"
            />
          </svg>
        ''';
        break;
      case IconNames.cainixihuan:
        svgXml = '''
          <svg viewBox="0 0 1024 1024" xmlns="http://www.w3.org/2000/svg">
            <path
              d="M294.144 568.864a13.6 13.6 0 0 0 1.344 1.664l154.56 164.928c33.952 39.968 90.72 39.968 125.12-0.48l153.6-164.864a140.16 140.16 0 0 0 3.776-4.032l2.272-2.432a13.536 13.536 0 0 0 1.792-2.368c20.48-25.6 31.392-57.696 31.392-92.832a148.448 148.448 0 0 0-256-102.304 148.448 148.448 0 0 0-256 102.304c0 37.12 14.08 73.408 38.144 100.416zM512 928C282.24 928 96 741.76 96 512S282.24 96 512 96s416 186.24 416 416-186.24 416-416 416z"
              fill="''' + getColor(0, color, colors, '#333333') + '''"
            />
          </svg>
        ''';
        break;
      case IconNames.nan:
        svgXml = '''
          <svg viewBox="0 0 1024 1024" xmlns="http://www.w3.org/2000/svg">
            <path
              d="M795.189333 176.917333H682.666667a32 32 0 1 1 0-64h192a32 32 0 0 1 32 32v192a32 32 0 1 1-64 0V219.946667l-105.866667 105.866666A350.613333 350.613333 0 0 1 821.333333 554.666667c0 194.4-157.6 352-352 352S117.333333 749.066667 117.333333 554.666667s157.6-352 352-352a350.538667 350.538667 0 0 1 221.6 78.506666l104.256-104.256zM469.333333 842.666667c159.061333 0 288-128.938667 288-288S628.394667 266.666667 469.333333 266.666667 181.333333 395.605333 181.333333 554.666667s128.938667 288 288 288z"
              fill="''' + getColor(0, color, colors, '#333333') + '''"
            />
          </svg>
        ''';
        break;
      case IconNames.nv:
        svgXml = '''
          <svg viewBox="0 0 1024 1024" xmlns="http://www.w3.org/2000/svg">
            <path
              d="M485.333333 768v-43.765333C321.077333 710.688 192 573.088 192 405.333333 192 228.597333 335.264 85.333333 512 85.333333c176.736 0 320 143.264 320 320 0 164.106667-123.52 299.349333-282.666667 317.845334V768H640a32 32 0 0 1 0 64h-90.666667v77.333333a32 32 0 0 1-64 0V832H384a32 32 0 0 1 0-64h101.333333zM512 661.333333c141.386667 0 256-114.613333 256-256S653.386667 149.333333 512 149.333333 256 263.946667 256 405.333333s114.613333 256 256 256z"
              fill="''' + getColor(0, color, colors, '#333333') + '''"
            />
          </svg>
        ''';
        break;
      case IconNames.shanchu:
        svgXml = '''
          <svg viewBox="0 0 1024 1024" xmlns="http://www.w3.org/2000/svg">
            <path
              d="M202.666667 256h-42.666667a32 32 0 0 1 0-64h704a32 32 0 0 1 0 64H266.666667v565.333333a53.333333 53.333333 0 0 0 53.333333 53.333334h384a53.333333 53.333333 0 0 0 53.333333-53.333334V352a32 32 0 0 1 64 0v469.333333c0 64.8-52.533333 117.333333-117.333333 117.333334H320c-64.8 0-117.333333-52.533333-117.333333-117.333334V256z m224-106.666667a32 32 0 0 1 0-64h170.666666a32 32 0 0 1 0 64H426.666667z m-32 288a32 32 0 0 1 64 0v256a32 32 0 0 1-64 0V437.333333z m170.666666 0a32 32 0 0 1 64 0v256a32 32 0 0 1-64 0V437.333333z"
              fill="''' + getColor(0, color, colors, '#333333') + '''"
            />
          </svg>
        ''';
        break;
      case IconNames.shezhi:
        svgXml = '''
          <svg viewBox="0 0 1024 1024" xmlns="http://www.w3.org/2000/svg">
            <path
              d="M944.48 552.458667l-182.357333 330.666666a73.792 73.792 0 0 1-64.565334 38.325334h-362.133333a73.792 73.792 0 0 1-64.565333-38.325334l-182.357334-330.666666a75.338667 75.338667 0 0 1 0-72.682667l182.357334-330.666667a73.792 73.792 0 0 1 64.565333-38.325333h362.133333a73.792 73.792 0 0 1 64.565334 38.325333l182.357333 330.666667a75.338667 75.338667 0 0 1 0 72.682667z m-55.989333-31.146667a10.773333 10.773333 0 0 0 0-10.378667l-182.037334-330.666666a10.517333 10.517333 0 0 0-9.205333-5.482667H335.733333a10.517333 10.517333 0 0 0-9.205333 5.482667l-182.037333 330.666666a10.773333 10.773333 0 0 0 0 10.378667l182.037333 330.666667a10.517333 10.517333 0 0 0 9.205333 5.472h361.514667a10.517333 10.517333 0 0 0 9.205333-5.472l182.037334-330.666667zM513.738667 682.666667c-94.261333 0-170.666667-76.405333-170.666667-170.666667s76.405333-170.666667 170.666667-170.666667c94.250667 0 170.666667 76.405333 170.666666 170.666667s-76.416 170.666667-170.666666 170.666667z m0-64c58.912 0 106.666667-47.754667 106.666666-106.666667s-47.754667-106.666667-106.666666-106.666667-106.666667 47.754667-106.666667 106.666667 47.754667 106.666667 106.666667 106.666667z"
              fill="''' + getColor(0, color, colors, '#333333') + '''"
            />
          </svg>
        ''';
        break;
      case IconNames.yirenzheng:
        svgXml = '''
          <svg viewBox="0 0 1024 1024" xmlns="http://www.w3.org/2000/svg">
            <path
              d="M32 300.0896l0 378.5952 960 0L992 300.0896 32 300.0896zM978.4832 665.168L45.5168 665.168l0-351.552 932.9568 0L978.4736 665.168z"
              fill="''' + getColor(0, color, colors, '#FF7300') + '''"
            />
            <path
              d="M696.2624 408.8192c-8.2752-9.3312-22.7136-24.4704-43.3056-45.4176l-16.0992 13.9968c16.1952 16.9056 29.8368 32.5728 40.9248 47.0112L696.2624 408.8192z"
              fill="''' + getColor(1, color, colors, '#FF7300') + '''"
            />
            <path
              d="M659.2832 549.0464c0 10.2048-2.64 19.008-7.92 26.4096l15.0528 17.1744c10.9152-12.4896 27.0336-29.3184 48.3264-50.4384-2.6208-9.168-4.3008-16.8192-5.0016-22.9824-11.9808 13.0368-22.0128 23.4144-30.1152 31.1616L679.6256 447.3824l-52.2816 0 0 19.008 31.9488 0L659.2928 549.0464z"
              fill="''' + getColor(2, color, colors, '#FF7300') + '''"
            />
            <path
              d="M793.184 585.488L751.2032 585.488 751.2032 439.4528 730.8704 439.4528 730.8704 585.4976 694.16 585.4976 694.16 605.0336 889.3184 605.0336 889.3184 585.4976 814.3232 585.4976 814.3232 585.488 814.3232 491.4752 875.5808 491.4752 875.5808 471.9296 814.3232 471.9296 814.3232 392.4416 885.0848 392.4416 885.0848 372.9056 708.6752 372.9056 708.6752 392.4416 793.184 392.4416Z"
              fill="''' + getColor(3, color, colors, '#FF7300') + '''"
            />
            <path
              d="M311.3984 464.528L153.4784 464.528l0-36.1824-22.7136 0L130.7648 565.664c0 27.8112 13.4688 41.7216 40.3968 41.7216l140.496 0c24.2976 0 39.0912-9.9552 44.3616-29.8368 2.8128-10.9152 5.4624-25.5264 7.92-43.8336-8.2752-2.2848-15.8496-4.9344-22.7136-7.92-1.5648 17.9712-3.9456 32.3328-7.1136 43.0656-3.168 10.9152-12.3264 16.3776-27.4656 16.3776L176.4608 585.2384c-15.3216 0-22.9728-8.1024-22.9728-24.2976l0-76.8576 157.9296 0 0 16.0992 22.1856 0 0-123.072L120.992 377.1104l0 19.536 190.4064 0L311.3984 464.528z"
              fill="''' + getColor(4, color, colors, '#FF7300') + '''"
            />
            <path
              d="M401.3408 554.0576c0 9.6768-2.8128 17.424-8.448 23.2416l15.5808 16.3776c3.3408-4.7616 7.392-9.3312 12.144-13.7376 16.7232-14.9664 34.2528-29.4912 52.56-43.5744-1.7472-6.4992-3.1488-13.632-4.2048-21.3792-18.3072 15.4944-33.9744 28.4352-47.0112 38.8224L421.9616 446.0576l-55.9872 0 0 19.008 35.3856 0L401.36 554.0576z"
              fill="''' + getColor(5, color, colors, '#FF7300') + '''"
            />
            <path
              d="M439.1072 601.5968c6.1632 6.3456 11.2608 11.9616 15.3216 16.9056 44.4576-34.5024 71.5296-78.3456 81.2064-131.52 13.5648 58.0992 39.1296 100.3584 76.7232 126.7584 5.1072-6.5184 10.8288-13.2864 17.1552-20.3328-48.144-28.512-77.0592-82.9632-86.736-163.3344 0.4512-22.1856 0.7392-44.8512 0.9216-67.9968l-21.3888 0c0 24.6528-0.2688 46.8384-0.7968 66.5472C521.1584 504.6848 493.6928 562.3328 439.1072 601.5968z"
              fill="''' + getColor(6, color, colors, '#FF7300') + '''"
            />
            <path
              d="M450.2048 410.9216c-12.8544-14.0928-27.7344-29.664-44.6304-46.7424l-15.5808 13.2096c15.6672 16.9056 29.664 33.1008 41.9808 48.5952L450.2048 410.9216z"
              fill="''' + getColor(7, color, colors, '#FF7300') + '''"
            />
          </svg>
        ''';
        break;
      case IconNames.guanfangrenzheng:
        svgXml = '''
          <svg viewBox="0 0 1024 1024" xmlns="http://www.w3.org/2000/svg">
            <path
              d="M908.3904 415.8464l-121.856-212.3264c-30.9248-53.8624-88.6784-87.3984-150.7328-87.552l-244.7872-0.6144h-0.4608c-61.9008 0-119.6544 33.2288-150.784 86.784L116.8384 413.8496c-31.1808 53.7088-31.3344 120.4736-0.4608 174.336l121.856 212.2752c30.9248 53.8624 88.6784 87.3984 150.7328 87.552l244.7872 0.6144h0.4608c61.9008 0 119.6544-33.2288 150.784-86.784l122.9312-211.6608c31.1808-53.6576 31.3856-120.4736 0.4608-174.336z"
              fill="''' + getColor(0, color, colors, '#7B79FF') + '''"
            />
            <path
              d="M488.8576 648.448c-7.6288 0-15.0528-2.8672-20.7872-8.0896l-127.9488-117.3504c-12.4928-11.4688-13.3632-30.9248-1.8944-43.4176a30.7456 30.7456 0 0 1 43.4176-1.8944l102.0928 93.6448 131.7376-188.3648a30.72 30.72 0 0 1 42.8032-7.5776 30.72 30.72 0 0 1 7.5776 42.8032l-151.808 217.088a30.6688 30.6688 0 0 1-21.8112 12.9536c-1.1264 0.1536-2.2528 0.2048-3.3792 0.2048z"
              fill="''' + getColor(1, color, colors, '#FFFFFF') + '''"
            />
          </svg>
        ''';
        break;
      case IconNames.a_pinpaiyisheng:
        svgXml = '''
          <svg viewBox="0 0 1024 1024" xmlns="http://www.w3.org/2000/svg">
            <path
              d="M599.264 75.632c77.1264 0 139.6416 62.5248 139.6416 139.6416v146.6208c0 130.1376-105.4944 235.632-235.632 235.632-130.1376 0-235.6416-105.504-235.6416-235.632V215.264c0-77.1168 62.5248-139.6416 139.6416-139.6416h192z m0 38.4h-192c-54.9888 0-99.744 43.8528-101.184 98.496l-0.048 2.7456v146.6208c0 108.9312 88.3104 197.232 197.2416 197.232 107.8176 0 195.4272-86.5152 197.2032-193.9104l0.0288-3.3216V215.264c0-54.9984-43.8432-99.744-98.496-101.2032l-2.736-0.0384z"
              fill="''' + getColor(0, color, colors, '#333333') + '''"
            />
            <path
              d="M267.632 338.3264h460.8v38.4h-460.8zM502.4 156.8a19.2 19.2 0 0 1 19.2 19.2v38.4h38.4a19.2 19.2 0 1 1 0 38.4h-38.4v38.4a19.2 19.2 0 1 1-38.4 0v-38.4h-38.4a19.2 19.2 0 1 1 0-38.4h38.4v-38.4a19.2 19.2 0 0 1 19.2-19.2z"
              fill="''' + getColor(1, color, colors, '#333333') + '''"
            />
            <path
              d="M684.7712 564.368c111.0144 0 204.96 82.0032 219.9552 192l9.9744 73.1136c7.8144 57.312-32.3136 110.112-89.616 117.9264-4.6944 0.6336-9.4176 0.96-14.1504 0.96H195.6128c-57.84 0-104.7264-46.896-104.7264-104.736 0-4.7328 0.3168-9.456 0.96-14.1504l9.9744-73.1136c14.9952-109.9968 108.9408-192 219.9552-192h362.9952z m0 38.4H321.776c-90.7008 0-167.6352 66.192-181.44 155.5104l-0.4704 3.2736-9.9744 73.1232a66.336 66.336 0 0 0 63.4464 75.2544l2.2752 0.0384H810.944a66.336 66.336 0 0 0 65.9904-73.0272l-0.2784-2.2656-9.9648-73.1232c-12.2592-89.8752-88.2432-157.152-178.5984-158.7552l-3.312-0.0288z"
              fill="''' + getColor(2, color, colors, '#333333') + '''"
            />
          </svg>
        ''';
        break;
      case IconNames.xiala:
        svgXml = '''
          <svg viewBox="0 0 1024 1024" xmlns="http://www.w3.org/2000/svg">
            <path
              d="M917.284001 297.722752c-5.406127-5.437849-13.06762-8.396227-21.479197-8.396227-9.611915 0-18.953677 3.844561-25.713638 10.543124L511.980046 659.992589 153.873018 299.91672c-6.729262-6.745634-16.072047-10.619872-25.654286-10.619872-8.470929 0-16.131399 2.989077-21.598924 8.457626-12.301164 12.435217-11.32493 33.69031 2.192945 47.312562l376.764969 378.821815c6.758937 6.788613 15.860223 10.723226 25.052582 10.8143l3.425006 0c8.981559-0.301875 17.814738-4.205788 24.423249-10.8143l376.733247-378.852514C928.728658 331.382363 929.690566 310.113967 917.284001 297.722752"
              fill="''' + getColor(0, color, colors, '#333333') + '''"
            />
          </svg>
        ''';
        break;
      case IconNames.bianji:
        svgXml = '''
          <svg viewBox="0 0 1024 1024" xmlns="http://www.w3.org/2000/svg">
            <path
              d="M862.709333 116.042667a32 32 0 1 1 45.248 45.248L455.445333 613.813333a32 32 0 1 1-45.258666-45.258666L862.709333 116.053333zM853.333333 448a32 32 0 0 1 64 0v352c0 64.8-52.533333 117.333333-117.333333 117.333333H224c-64.8 0-117.333333-52.533333-117.333333-117.333333V224c0-64.8 52.533333-117.333333 117.333333-117.333333h341.333333a32 32 0 0 1 0 64H224a53.333333 53.333333 0 0 0-53.333333 53.333333v576a53.333333 53.333333 0 0 0 53.333333 53.333333h576a53.333333 53.333333 0 0 0 53.333333-53.333333V448z"
              fill="''' + getColor(0, color, colors, '#333333') + '''"
            />
          </svg>
        ''';
        break;
      case IconNames.tupian:
        svgXml = '''
          <svg viewBox="0 0 1024 1024" xmlns="http://www.w3.org/2000/svg">
            <path
              d="M938.666667 553.92V768c0 64.8-52.533333 117.333333-117.333334 117.333333H202.666667c-64.8 0-117.333333-52.533333-117.333334-117.333333V256c0-64.8 52.533333-117.333333 117.333334-117.333333h618.666666c64.8 0 117.333333 52.533333 117.333334 117.333333v297.92z m-64-74.624V256a53.333333 53.333333 0 0 0-53.333334-53.333333H202.666667a53.333333 53.333333 0 0 0-53.333334 53.333333v344.48A290.090667 290.090667 0 0 1 192 597.333333a286.88 286.88 0 0 1 183.296 65.845334C427.029333 528.384 556.906667 437.333333 704 437.333333c65.706667 0 126.997333 16.778667 170.666667 41.962667z m0 82.24c-5.333333-8.32-21.130667-21.653333-43.648-32.917333C796.768 511.488 753.045333 501.333333 704 501.333333c-121.770667 0-229.130667 76.266667-270.432 188.693334-2.730667 7.445333-7.402667 20.32-13.994667 38.581333-7.68 21.301333-34.453333 28.106667-51.370666 13.056-16.437333-14.634667-28.554667-25.066667-36.138667-31.146667A222.890667 222.890667 0 0 0 192 661.333333c-14.464 0-28.725333 1.365333-42.666667 4.053334V768a53.333333 53.333333 0 0 0 53.333334 53.333333h618.666666a53.333333 53.333333 0 0 0 53.333334-53.333333V561.525333zM320 480a96 96 0 1 1 0-192 96 96 0 0 1 0 192z m0-64a32 32 0 1 0 0-64 32 32 0 0 0 0 64z"
              fill="''' + getColor(0, color, colors, '#333333') + '''"
            />
          </svg>
        ''';
        break;
      case IconNames.xiangji:
        svgXml = '''
          <svg viewBox="0 0 1024 1024" xmlns="http://www.w3.org/2000/svg">
            <path
              d="M269.44 256l23.296-75.381333A74.666667 74.666667 0 0 1 364.074667 128h295.850666a74.666667 74.666667 0 0 1 71.338667 52.618667L754.56 256H821.333333c64.8 0 117.333333 52.533333 117.333334 117.333333v426.666667c0 64.8-52.533333 117.333333-117.333334 117.333333H202.666667c-64.8 0-117.333333-52.533333-117.333334-117.333333V373.333333c0-64.8 52.533333-117.333333 117.333334-117.333333h66.773333z m23.605333 64H202.666667a53.333333 53.333333 0 0 0-53.333334 53.333333v426.666667a53.333333 53.333333 0 0 0 53.333334 53.333333h618.666666a53.333333 53.333333 0 0 0 53.333334-53.333333V373.333333a53.333333 53.333333 0 0 0-53.333334-53.333333h-90.378666a32 32 0 0 1-30.570667-22.549333l-30.272-97.930667a10.666667 10.666667 0 0 0-10.186667-7.52H364.074667a10.666667 10.666667 0 0 0-10.186667 7.52l-30.272 97.92A32 32 0 0 1 293.045333 320zM512 725.333333c-88.362667 0-160-71.637333-160-160 0-88.362667 71.637333-160 160-160 88.362667 0 160 71.637333 160 160 0 88.362667-71.637333 160-160 160z m0-64a96 96 0 1 0 0-192 96 96 0 0 0 0 192z"
              fill="''' + getColor(0, color, colors, '#333333') + '''"
            />
          </svg>
        ''';
        break;
      case IconNames.xiazai:
        svgXml = '''
          <svg viewBox="0 0 1024 1024" xmlns="http://www.w3.org/2000/svg">
            <path
              d="M723.22964844 432.8984375a210.9375 210.9375 0 1 0-421.875 0 158.203125 158.203125 0 1 0 0 316.40625v52.734375a210.9375 210.9375 0 0 1-48.515625-416.28515625 263.77734375 263.77734375 0 0 1 518.90625 0A211.04296875 211.04296875 0 0 1 723.22964844 802.0390625v-52.734375a158.203125 158.203125 0 0 0 0-316.40625z m-421.875 316.40625h52.734375v52.734375H301.35464844v-52.734375z m369.140625 0h52.734375v52.734375h-52.734375v-52.734375z"
              fill="''' + getColor(0, color, colors, '#333333') + '''"
            />
            <path
              d="M534.28238281 786.58789063V512.15820313a26.73632813 26.73632813 0 0 0-26.3671875-26.52539063c-14.5546875 0-26.3671875 12.28710938-26.3671875 26.52539063v274.42968749l-29.7421875-29.74218749a26.52539063 26.52539063 0 0 0-37.125 0.15820312 26.05078125 26.05078125 0 0 0-0.15820312 37.125l74.8828125 74.93554688a25.83984375 25.83984375 0 0 0 18.5625 7.48828124 24.78515625 24.78515625 0 0 0 18.45703125-7.48828125l74.8828125-74.8828125a26.52539063 26.52539063 0 0 0-0.15820313-37.17773437 26.05078125 26.05078125 0 0 0-37.125-0.15820313l-29.7421875 29.7421875z"
              fill="''' + getColor(1, color, colors, '#333333') + '''"
            />
          </svg>
        ''';
        break;
      case IconNames.guanbi:
        svgXml = '''
          <svg viewBox="0 0 1024 1024" xmlns="http://www.w3.org/2000/svg">
            <path
              d="M548.992 503.744L885.44 167.328a31.968 31.968 0 1 0-45.248-45.248L503.744 458.496 167.328 122.08a31.968 31.968 0 1 0-45.248 45.248l336.416 336.416L122.08 840.16a31.968 31.968 0 1 0 45.248 45.248l336.416-336.416L840.16 885.44a31.968 31.968 0 1 0 45.248-45.248L548.992 503.744z"
              fill="''' + getColor(0, color, colors, '#333333') + '''"
            />
          </svg>
        ''';
        break;
      case IconNames.gengduo:
        svgXml = '''
          <svg viewBox="0 0 1024 1024" xmlns="http://www.w3.org/2000/svg">
            <path
              d="M253.09234608 602.61767941a90.61767941 90.61767941 0 1 1 0-181.23535882 90.61767941 90.61767941 0 0 1 0 181.23535882z m258.90765392 0a90.61767941 90.61767941 0 1 1 0-181.23535882 90.61767941 90.61767941 0 0 1 0 181.23535882z m258.90765392 0a90.61767941 90.61767941 0 1 1 0-181.23535882 90.61767941 90.61767941 0 0 1 0 181.23535882z"
              fill="''' + getColor(0, color, colors, '#333333') + '''"
            />
          </svg>
        ''';
        break;
      case IconNames.tanhao:
        svgXml = '''
          <svg viewBox="0 0 1024 1024" xmlns="http://www.w3.org/2000/svg">
            <path
              d="M512 85.333333c235.637333 0 426.666667 191.029333 426.666667 426.666667 0 78.293333-21.152 153.568-60.586667 219.274667a32 32 0 0 1-54.88-32.938667A360.789333 360.789333 0 0 0 874.666667 512c0-200.298667-162.368-362.666667-362.666667-362.666667S149.333333 311.701333 149.333333 512s162.368 362.666667 362.666667 362.666667a360.789333 360.789333 0 0 0 186.314667-51.445334 32 32 0 0 1 32.928 54.88A424.778667 424.778667 0 0 1 512 938.666667C276.362667 938.666667 85.333333 747.637333 85.333333 512S276.362667 85.333333 512 85.333333z m0 565.333334a42.666667 42.666667 0 1 1 0 85.333333 42.666667 42.666667 0 0 1 0-85.333333z m0-362.666667a42.666667 42.666667 0 0 1 42.666667 42.666667v234.666666a42.666667 42.666667 0 1 1-85.333334 0V330.666667a42.666667 42.666667 0 0 1 42.666667-42.666667z"
              fill="''' + getColor(0, color, colors, '#333333') + '''"
            />
          </svg>
        ''';
        break;
      case IconNames.qianjin:
        svgXml = '''
          <svg viewBox="0 0 1024 1024" xmlns="http://www.w3.org/2000/svg">
            <path
              d="M319.67119134 883.71430514L364.70787983 928.75204152 780.73169011 512.64283192 364.70787983 96.58138965 319.67119134 141.61807815 690.73008186 512.67009422Z"
              fill="''' + getColor(0, color, colors, '#333333') + '''"
            />
          </svg>
        ''';
        break;
      case IconNames.fanhui:
        svgXml = '''
          <svg viewBox="0 0 1024 1024" xmlns="http://www.w3.org/2000/svg">
            <path
              d="M704.32880866 140.28569486L659.29212017 95.24795848 243.26830989 511.35716808 659.29212017 927.41861035 704.32880866 882.38192185 333.26991814 511.32990578Z"
              fill="''' + getColor(0, color, colors, '#333333') + '''"
            />
          </svg>
        ''';
        break;
      case IconNames.fenxiang:
        svgXml = '''
          <svg viewBox="0 0 1024 1024" xmlns="http://www.w3.org/2000/svg">
            <path
              d="M853.333333 533.333333a32 32 0 0 1 64 0v266.666667c0 64.8-52.533333 117.333333-117.333333 117.333333H224c-64.8 0-117.333333-52.533333-117.333333-117.333333V256c0-64.8 52.533333-117.333333 117.333333-117.333333h277.333333a32 32 0 0 1 0 64H224a53.333333 53.333333 0 0 0-53.333333 53.333333v544a53.333333 53.333333 0 0 0 53.333333 53.333333h576a53.333333 53.333333 0 0 0 53.333333-53.333333V533.333333z m-42.058666-277.333333l-89.792-95.402667a32 32 0 0 1 46.613333-43.861333l140.544 149.333333C927.861333 286.485333 913.376 320 885.333333 320H724.704C643.029333 320 576 391.210667 576 480v192a32 32 0 1 1-64 0V480c0-123.296 94.784-224 212.704-224h86.570667z"
              fill="''' + getColor(0, color, colors, '#333333') + '''"
            />
          </svg>
        ''';
        break;
      case IconNames.tianjia:
        svgXml = '''
          <svg viewBox="0 0 1024 1024" xmlns="http://www.w3.org/2000/svg">
            <path
              d="M907.94666667 564.05333333H116.05333333c-28.69333333 0-52.05333333-23.46666667-52.05333333-52.05333333 0-28.69333333 23.46666667-52.05333333 52.05333333-52.05333333h791.78666667c28.69333333 0 52.05333333 23.46666667 52.05333333 52.05333333 0.10666667 28.69333333-23.36 52.05333333-51.94666666 52.05333333z"
              fill="''' + getColor(0, color, colors, '#333333') + '''"
            />
            <path
              d="M459.94666667 907.94666667V116.05333333c0-28.69333333 23.46666667-52.05333333 52.05333333-52.05333333 28.69333333 0 52.05333333 23.46666667 52.05333333 52.05333333v791.78666667c0 28.69333333-23.46666667 52.05333333-52.05333333 52.05333333-28.69333333 0.10666667-52.05333333-23.36-52.05333333-51.94666666z"
              fill="''' + getColor(1, color, colors, '#333333') + '''"
            />
          </svg>
        ''';
        break;
      case IconNames.shuaxin_1:
        svgXml = '''
          <svg viewBox="0 0 1024 1024" xmlns="http://www.w3.org/2000/svg">
            <path
              d="M824.6 611.3c-3.2 165-138 297.8-303.8 297.8-167.8 0-303.9-136.1-303.9-303.9S353 301.3 520.8 301.3v-91.7c-218.5 0-395.6 177.1-395.6 395.6s177.1 395.6 395.6 395.6c216.5 0 392.3-173.8 395.6-389.5h-91.8z"
              fill="''' + getColor(0, color, colors, '#333333') + '''"
            />
            <path
              d="M839.9 265.7L520.8 64.2l-0.1 374.2z"
              fill="''' + getColor(1, color, colors, '#333333') + '''"
            />
          </svg>
        ''';
        break;
      case IconNames.shuaxin:
        svgXml = '''
          <svg viewBox="0 0 1024 1024" xmlns="http://www.w3.org/2000/svg">
            <path
              d="M822.496 473.152a32 32 0 0 0-31.392 55.776l97.450667 54.848c20.32 11.434667 45.653333-2.005333 47.594666-25.248 1.674667-20.16 2.517333-35.573333 2.517334-46.528C938.666667 276.362667 747.637333 85.333333 512 85.333333S85.333333 276.362667 85.333333 512s191.029333 426.666667 426.666667 426.666667c144.106667 0 276.053333-72.032 354.752-189.536a32 32 0 1 0-53.173333-35.616C746.645333 813.461333 634.538667 874.666667 512 874.666667c-200.298667 0-362.666667-162.368-362.666667-362.666667s162.368-362.666667 362.666667-362.666667c197.098667 0 357.472 157.226667 362.538667 353.109334l-52.042667-29.290667z"
              fill="''' + getColor(0, color, colors, '#333333') + '''"
            />
          </svg>
        ''';
        break;
      case IconNames.sousuo:
        svgXml = '''
          <svg viewBox="0 0 1024 1024" xmlns="http://www.w3.org/2000/svg">
            <path
              d="M797.525333 752.266667c62.069333-72.736 97.28-165.002667 97.28-262.186667C894.816 266.528 713.621333 85.333333 490.08 85.333333 266.538667 85.333333 85.333333 266.538667 85.333333 490.069333 85.333333 713.610667 266.538667 894.826667 490.069333 894.826667a404.693333 404.693333 0 0 0 118.208-17.546667 32 32 0 0 0-18.666666-61.216 340.693333 340.693333 0 0 1-99.541334 14.762667C301.888 830.816 149.333333 678.261333 149.333333 490.069333 149.333333 301.888 301.888 149.333333 490.069333 149.333333 678.261333 149.333333 830.826667 301.888 830.826667 490.069333c0 89.28-35.381333 173.696-97.141334 237.322667a36.992 36.992 0 0 0 0.384 51.925333l149.973334 149.973334a32 32 0 0 0 45.258666-45.248L797.525333 752.266667z"
              fill="''' + getColor(0, color, colors, '#333333') + '''"
            />
          </svg>
        ''';
        break;
      case IconNames.dianzan:
        svgXml = '''
          <svg viewBox="0 0 1024 1024" xmlns="http://www.w3.org/2000/svg">
            <path
              d="M621.674667 408.021333c16.618667-74.24 28.224-127.936 34.837333-161.194666C673.152 163.093333 629.941333 85.333333 544.298667 85.333333c-77.226667 0-116.010667 38.378667-138.88 115.093334l-0.586667 2.24c-13.728 62.058667-34.72 110.165333-62.506667 144.586666a158.261333 158.261333 0 0 1-119.733333 58.965334l-21.909333 0.469333C148.437333 407.808 106.666667 450.816 106.666667 503.498667V821.333333c0 64.8 52.106667 117.333333 116.394666 117.333334h412.522667c84.736 0 160.373333-53.568 189.12-133.92l85.696-239.584c21.802667-60.96-9.536-128.202667-70.005333-150.186667a115.552 115.552 0 0 0-39.488-6.954667H621.674667zM544.256 149.333333c39.253333 0 59.498667 36.48 49.888 84.928-7.573333 38.144-21.984 104.426667-43.221333 198.666667-4.512 20.021333 10.56 39.093333 30.912 39.093333h218.666666c6.101333 0 12.16 1.066667 17.909334 3.168 27.445333 9.984 41.674667 40.554667 31.776 68.266667l-85.568 239.573333C744.981333 838.026667 693.301333 874.666667 635.402667 874.666667H223.498667C194.314667 874.666667 170.666667 850.784 170.666667 821.333333V503.498667c0-17.866667 14.144-32.448 31.829333-32.821334l21.866667-0.469333a221.12 221.12 0 0 0 167.381333-82.56c34.346667-42.602667 59.146667-99.306667 74.869333-169.877333C482.101333 166.336 499.552 149.333333 544.266667 149.333333z"
              fill="''' + getColor(0, color, colors, '#333333') + '''"
            />
          </svg>
        ''';
        break;
      case IconNames.kabao:
        svgXml = '''
          <svg viewBox="0 0 1024 1024" xmlns="http://www.w3.org/2000/svg">
            <path
              d="M832 394.666667H192v160h213.333333a32 32 0 0 1 32 32 74.666667 74.666667 0 0 0 149.333334 0 32 32 0 0 1 32-32h213.333333V394.666667z m0-64V224a53.333333 53.333333 0 0 0-53.333333-53.333333H245.333333a53.333333 53.333333 0 0 0-53.333333 53.333333v106.666667h640z m0 288H646.954667C632.512 679.818667 577.568 725.333333 512 725.333333c-65.568 0-120.512-45.514667-134.954667-106.666666H192v181.333333a53.333333 53.333333 0 0 0 53.333333 53.333333h533.333334a53.333333 53.333333 0 0 0 53.333333-53.333333V618.666667zM245.333333 106.666667h533.333334c64.8 0 117.333333 52.533333 117.333333 117.333333v576c0 64.8-52.533333 117.333333-117.333333 117.333333H245.333333c-64.8 0-117.333333-52.533333-117.333333-117.333333V224c0-64.8 52.533333-117.333333 117.333333-117.333333z"
              fill="''' + getColor(0, color, colors, '#333333') + '''"
            />
          </svg>
        ''';
        break;
      case IconNames.shoucang:
        svgXml = '''
          <svg viewBox="0 0 1024 1024" xmlns="http://www.w3.org/2000/svg">
            <path
              d="M335.008 916.629333c-35.914667 22.314667-82.88 10.773333-104.693333-25.557333a77.333333 77.333333 0 0 1-8.96-57.429333l46.485333-198.24a13.141333 13.141333 0 0 0-4.021333-12.864l-152.16-132.586667c-31.605333-27.52-35.253333-75.648-8.234667-107.733333a75.68 75.68 0 0 1 51.733333-26.752L354.848 339.2c4.352-0.362667 8.245333-3.232 10.026667-7.594667l76.938666-188.170666c16.032-39.2 60.618667-57.92 99.52-41.461334a76.309333 76.309333 0 0 1 40.832 41.461334l76.938667 188.16c1.781333 4.373333 5.674667 7.253333 10.026667 7.605333l199.712 16.277333c41.877333 3.413333 72.885333 40.458667 69.568 82.517334a76.938667 76.938667 0 0 1-26.08 51.978666l-152.16 132.586667c-3.541333 3.082667-5.141333 8.074667-4.021334 12.853333l46.485334 198.24c9.621333 41.013333-15.36 82.336-56.138667 92.224a75.285333 75.285333 0 0 1-57.525333-9.237333l-170.976-106.24a11.296 11.296 0 0 0-12.010667 0l-170.986667 106.24zM551.786667 756.032l170.976 106.24c2.624 1.621333 5.717333 2.122667 8.650666 1.408 6.410667-1.557333 10.56-8.426667 8.928-15.424l-46.485333-198.24a77.141333 77.141333 0 0 1 24.277333-75.733333L870.293333 441.706667c2.485333-2.165333 4.053333-5.312 4.330667-8.746667 0.565333-7.136-4.490667-13.173333-10.976-13.696l-199.712-16.288a75.989333 75.989333 0 0 1-64.064-47.168l-76.938667-188.16a12.309333 12.309333 0 0 0-6.538666-6.741333c-5.898667-2.496-12.725333 0.373333-15.328 6.741333l-76.949334 188.16a75.989333 75.989333 0 0 1-64.064 47.168l-199.701333 16.288a11.68 11.68 0 0 0-7.978667 4.181333 13.226667 13.226667 0 0 0 1.333334 18.261334l152.16 132.586666a77.141333 77.141333 0 0 1 24.277333 75.733334l-46.485333 198.229333a13.333333 13.333333 0 0 0 1.514666 9.877333c3.488 5.792 10.581333 7.530667 16.064 4.128l170.986667-106.229333a75.296 75.296 0 0 1 79.562667 0z"
              fill="''' + getColor(0, color, colors, '#333333') + '''"
            />
          </svg>
        ''';
        break;
      case IconNames.xiaoxi:
        svgXml = '''
          <svg viewBox="0 0 1024 1024" xmlns="http://www.w3.org/2000/svg">
            <path
              d="M821.333333 800H547.584l-86.464 96.074667a32 32 0 1 1-47.573333-42.816l96-106.666667A32 32 0 0 1 533.333333 736h288a53.333333 53.333333 0 0 0 53.333334-53.333333V234.666667a53.333333 53.333333 0 0 0-53.333334-53.333334H202.666667a53.333333 53.333333 0 0 0-53.333334 53.333334v448a53.333333 53.333333 0 0 0 53.333334 53.333333h138.666666a32 32 0 0 1 0 64H202.666667c-64.8 0-117.333333-52.533333-117.333334-117.333333V234.666667c0-64.8 52.533333-117.333333 117.333334-117.333334h618.666666c64.8 0 117.333333 52.533333 117.333334 117.333334v448c0 64.8-52.533333 117.333333-117.333334 117.333333zM704 341.333333a32 32 0 0 1 0 64H320a32 32 0 0 1 0-64h384zM512 512a32 32 0 0 1 0 64H320a32 32 0 0 1 0-64h192z"
              fill="''' + getColor(0, color, colors, '#333333') + '''"
            />
          </svg>
        ''';
        break;
      case IconNames.xiaoxizhongxin:
        svgXml = '''
          <svg viewBox="0 0 1024 1024" xmlns="http://www.w3.org/2000/svg">
            <path
              d="M192.032 631.402667V404.725333C192.032 228.330667 335.285333 85.333333 512 85.333333s319.968 142.997333 319.968 319.392v226.677334l60.608 121.013333c10.645333 21.237333-4.832 46.218667-28.618667 46.218667H160.042667c-23.786667 0-39.253333-24.981333-28.618667-46.218667l60.608-121.013333z m620.16 103.36l-40.842667-81.536a31.893333 31.893333 0 0 1-3.381333-14.282667V404.725333c0-141.12-114.602667-255.509333-255.968-255.509333S256.032 263.605333 256.032 404.725333V638.933333c0 4.96-1.162667 9.845333-3.381333 14.293334l-40.842667 81.525333h600.384z m-443.306667 152.32a31.893333 31.893333 0 0 1-4.149333-44.981334 32.032 32.032 0 0 1 45.056-4.138666A159.36 159.36 0 0 0 512 874.773333a159.36 159.36 0 0 0 102.186667-36.8 32.032 32.032 0 0 1 45.056 4.138667 31.893333 31.893333 0 0 1-4.16 44.981333A223.402667 223.402667 0 0 1 512 938.666667c-52.981333 0-103.2-18.453333-143.114667-51.594667z"
              fill="''' + getColor(0, color, colors, '#333333') + '''"
            />
          </svg>
        ''';
        break;
      case IconNames.dianzan_1:
        svgXml = '''
          <svg viewBox="0 0 1024 1024" xmlns="http://www.w3.org/2000/svg">
            <path
              d="M621.674667 408.021333c16.618667-74.24 28.224-127.936 34.837333-161.194666C673.152 163.093333 629.941333 85.333333 544.298667 85.333333c-77.226667 0-116.010667 38.378667-138.88 115.093334l-0.586667 2.24c-13.728 62.058667-34.72 110.165333-62.506667 144.586666a158.261333 158.261333 0 0 1-119.733333 58.965334l-21.909333 0.469333C148.437333 407.808 106.666667 450.816 106.666667 503.498667V821.333333c0 64.8 52.106667 117.333333 116.394666 117.333334h412.522667c84.736 0 160.373333-53.568 189.12-133.92l85.696-239.584c21.802667-60.96-9.536-128.202667-70.005333-150.186667a115.552 115.552 0 0 0-39.488-6.954667H621.674667z"
              fill="''' + getColor(0, color, colors, '#333333') + '''"
            />
          </svg>
        ''';
        break;
      case IconNames.shoucang_1:
        svgXml = '''
          <svg viewBox="0 0 1024 1024" xmlns="http://www.w3.org/2000/svg">
            <path
              d="M335.008 916.629333c-35.914667 22.314667-82.88 10.773333-104.693333-25.557333a77.333333 77.333333 0 0 1-8.96-57.429333l46.485333-198.24a13.141333 13.141333 0 0 0-4.021333-12.864l-152.16-132.586667c-31.605333-27.52-35.253333-75.648-8.234667-107.733333a75.68 75.68 0 0 1 51.733333-26.752L354.848 339.2c4.352-0.362667 8.245333-3.232 10.026667-7.594667l76.938666-188.170666c16.032-39.2 60.618667-57.92 99.52-41.461334a76.309333 76.309333 0 0 1 40.832 41.461334l76.938667 188.16c1.781333 4.373333 5.674667 7.253333 10.026667 7.605333l199.712 16.277333c41.877333 3.413333 72.885333 40.458667 69.568 82.517334a76.938667 76.938667 0 0 1-26.08 51.978666l-152.16 132.586667c-3.541333 3.082667-5.141333 8.074667-4.021334 12.853333l46.485334 198.24c9.621333 41.013333-15.36 82.336-56.138667 92.224a75.285333 75.285333 0 0 1-57.525333-9.237333l-170.976-106.24a11.296 11.296 0 0 0-12.010667 0l-170.986667 106.24z"
              fill="''' + getColor(0, color, colors, '#333333') + '''"
            />
          </svg>
        ''';
        break;
      case IconNames.turnback:
        svgXml = '''
          <svg viewBox="0 0 1024 1024" xmlns="http://www.w3.org/2000/svg">
            <path
              d="M622.650611 284.901749 447.745069 284.901749 447.745069 142.823869 63.980685 334.705038l383.76336 191.882192L447.744046 384.834762l189.391465 0c149.914358 0 224.855164 62.789045 224.855164 188.368158 0 129.928165-77.435627 194.876386-232.338602 194.876386L187.952184 768.079306l0 99.93199L634.146433 868.011296c211.184817 0 316.777737-95.104031 316.777737-285.311071C950.924169 384.178823 841.510224 284.901749 622.650611 284.901749z"
              fill="''' + getColor(0, color, colors, '#333333') + '''"
            />
          </svg>
        ''';
        break;
      case IconNames.dianhua:
        svgXml = '''
          <svg viewBox="0 0 1024 1024" xmlns="http://www.w3.org/2000/svg">
            <path
              d="M446.272 573.44a509.653333 509.653333 0 0 1-81.92-100.650667c67.786667-30.474667 112.138667-93.461333 112.138667-169.792C476.48 194.592 388.96 106.666667 280.906667 106.666667 170.058667 106.666667 85.333333 188.746667 85.333333 302.997333c0 158.250667 82.56 328.554667 200.618667 439.658667 100.010667 94.122667 258.986667 161.738667 413.461333 174.570667 0.832 0.074667 1.674667 0.106667 2.517334 0.106666h41.162666a30.517333 30.517333 0 0 0 0-61.045333h-39.872c-140.672-11.978667-286.026667-73.930667-375.456-158.090667-106.410667-100.16-181.408-254.837333-181.408-395.2 0-80.106667 56.981333-135.285333 134.549334-135.285333 74.282667 0 134.549333 60.533333 134.549333 135.285333 0 60.309333-40.896 107.989333-103.008 123.349334a30.517333 30.517333 0 0 0-19.786667 43.658666c27.573333 53.312 66.037333 104.426667 111.573334 147.690667 51.264 48.693333 109.941333 86.112 172.053333 108.16a30.506667 30.506667 0 0 0 40.362667-24.064c10.453333-67.093333 61.621333-114.026667 126.442666-114.026667 74.272 0 134.549333 60.544 134.549334 135.285334 0 25.578667-7.04 50.026667-20.149334 71.253333a30.528 30.528 0 0 0 51.925334 32.074667A196.096 196.096 0 0 0 938.666667 723.050667c0-108.394667-87.530667-196.330667-195.573334-196.330667-83.072 0-151.210667 52.384-177.621333 128.864-42.368-19.552-82.773333-47.541333-119.2-82.144z"
              fill="''' + getColor(0, color, colors, '#333333') + '''"
            />
          </svg>
        ''';
        break;
      case IconNames.paihangbang:
        svgXml = '''
          <svg viewBox="0 0 1024 1024" xmlns="http://www.w3.org/2000/svg">
            <path
              d="M544 661.333333a32 32 0 0 1-64 0V362.666667a32 32 0 0 1 64 0v298.666666z m160 0a32 32 0 0 1-64 0V490.666667a32 32 0 0 1 64 0v170.666666z m-320 0a32 32 0 0 1-64 0V448a32 32 0 0 1 64 0v213.333333zM202.666667 138.666667h618.666666c64.8 0 117.333333 52.533333 117.333334 117.333333v512c0 64.8-52.533333 117.333333-117.333334 117.333333H202.666667c-64.8 0-117.333333-52.533333-117.333334-117.333333V256c0-64.8 52.533333-117.333333 117.333334-117.333333z m0 64a53.333333 53.333333 0 0 0-53.333334 53.333333v512a53.333333 53.333333 0 0 0 53.333334 53.333333h618.666666a53.333333 53.333333 0 0 0 53.333334-53.333333V256a53.333333 53.333333 0 0 0-53.333334-53.333333H202.666667z"
              fill="''' + getColor(0, color, colors, '#333333') + '''"
            />
          </svg>
        ''';
        break;
      case IconNames.weixin:
        svgXml = '''
          <svg viewBox="0 0 1024 1024" xmlns="http://www.w3.org/2000/svg">
            <path
              d="M1010.8 628c0-141.2-141.3-256.2-299.9-256.2-168 0-300.3 115.1-300.3 256.2 0 141.4 132.3 256.2 300.3 256.2 35.2 0 70.7-8.9 106-17.7l96.8 53-26.6-88.2c70.9-53.2 123.7-123.7 123.7-203.3zM618 588.8c-22.1 0-40-17.9-40-40s17.9-40 40-40 40 17.9 40 40c0 22-17.9 40-40 40z m194.3-0.3c-22.1 0-40-17.9-40-40s17.9-40 40-40 40 17.9 40 40-17.9 40-40 40z"
              fill="''' + getColor(0, color, colors, '#26DD76') + '''"
            />
            <path
              d="M366.3 106.9c-194.1 0-353.1 132.3-353.1 300.3 0 97 52.9 176.6 141.3 238.4l-35.3 106.2 123.4-61.9c44.2 8.7 79.6 17.7 123.7 17.7 11.1 0 22.1-0.5 33-1.4-6.9-23.6-10.9-48.3-10.9-74 0-154.3 132.5-279.5 300.2-279.5 11.5 0 22.8 0.8 34 2.1C692 212.6 539.9 106.9 366.3 106.9zM247.7 349.2c-26.5 0-48-21.5-48-48s21.5-48 48-48 48 21.5 48 48-21.5 48-48 48z m246.6 0c-26.5 0-48-21.5-48-48s21.5-48 48-48 48 21.5 48 48-21.5 48-48 48z"
              fill="''' + getColor(1, color, colors, '#26DD76') + '''"
            />
          </svg>
        ''';
        break;
      case IconNames.phone:
        svgXml = '''
          <svg viewBox="0 0 1024 1024" xmlns="http://www.w3.org/2000/svg">
            <path
              d="M287.03857813 75.91253333l53.11146667-16.01991146a125.1555552 125.1555552 0 0 1 150.27768853 68.53973333l41.05102187 91.24977813a125.1555552 125.1555552 0 0 1-28.80853333 142.90488854L434.63111147 425.984a11.37777813 11.37777813 0 0 0-3.54986667 7.05422187c-2.00248853 18.06791147 10.24 53.248 38.5024 102.1724448 20.48 35.49866667 39.0940448 60.48426667 54.8864 74.50168853 11.0592 9.73937813 17.11217813 11.8784 19.7063104 11.10471147l91.47733333-27.94382187a125.1555552 125.1555552 0 0 1 138.08071147 46.42133333l58.25422187 80.78222187a125.1555552 125.1555552 0 0 1-15.3827552 164.11306667l-40.3683552 38.22933333a170.66666667 170.66666667 0 0 1-163.24835627 40.45937813c-125.3376-35.0435552-237.70453333-140.76586667-338.3751104-315.11893333C173.8524448 473.13351147 138.4448 322.7648 171.12177813 196.608a170.66666667 170.66666667 0 0 1 115.9623104-120.69546667z m19.7063104 65.3539552a102.4 102.4 0 0 0-69.632 72.40817814c-27.39768853 106.13191147 3.95946667 239.3884448 96.6200896 399.9516448 92.5696 160.29013333 192.19342187 254.04302187 297.64266667 283.4887104a102.4 102.4 0 0 0 97.9399104-24.30293334l40.3228448-38.22933333a56.88888853 56.88888853 0 0 0 7.00871147-74.5472l-58.25422294-80.78222187a56.88888853 56.88888853 0 0 0-62.80533333-21.1171552l-91.70488853 28.03484374c-53.248 15.88337813-101.53528853-26.98808853-153.4179552-116.82702187C375.46666667 508.76871147 359.17368853 461.93777813 363.26968853 425.43786667c2.09351147-18.88711147 10.92266667-36.40888853 24.80355627-49.3795552l68.0391104-63.4424896a56.88888853 56.88888853 0 0 0 13.0616896-64.9443552l-41.00551147-91.24977814a56.88888853 56.88888853 0 0 0-68.31217813-31.1751104l-53.11146667 16.0199104z"
              fill="''' + getColor(0, color, colors, '#000000') + '''"
            />
          </svg>
        ''';
        break;
      case IconNames.pic_discount:
        svgXml = '''
          <svg viewBox="0 0 1024 1024" xmlns="http://www.w3.org/2000/svg">
            <path
              d="M651.68 443.84L542.72 804.8l43.2 54.72c15.36 28.32 48 38.4 71.04 21.6l48-21.12 252.96-126.72c28.32-15.36 38.4-48 21.6-71.04l-226.56-396.48c-16.8-23.04-43.2-54.72-75.84-64.8l-120.48-36.48 88.8 140.16c15.84 28.8 25.92 73.44 6.24 139.2zM72.32 782.72L411.2 884.96c27.36 8.16 48.96-3.36 57.12-30.72L598.4 421.76c8.16-27.36 8.64-69.12-8.16-92.16L486.08 161.12c-16.8-23.04-49.92-33.12-76.8-23.04L224 219.68c-26.88 9.6-43.68 46.56-52.32 73.92L41.6 725.6c-13.92 25.44-2.4 47.04 30.72 57.12z m331.2-485.28c32.64 10.08 48 38.4 38.4 71.04-8.16 27.36-38.4 48-71.04 38.4-27.36-8.16-48-38.4-38.4-71.04 9.6-33.12 37.92-48.48 71.04-38.4z"
              fill="''' + getColor(0, color, colors, '#E1730D') + '''"
            />
            <path
              d="M651.68 443.84L542.72 804.8l43.2 54.72c15.36 28.32 48 38.4 71.04 21.6l48-21.12 252.96-126.72c28.32-15.36 38.4-48 21.6-71.04l-226.56-396.48c-16.8-23.04-43.2-54.72-75.84-64.8l-120.48-36.48 88.8 140.16c15.84 28.8 25.92 73.44 6.24 139.2z"
              fill="''' + getColor(1, color, colors, '#F5CD2D') + '''"
            />
          </svg>
        ''';
        break;
      case IconNames.course_order:
        svgXml = '''
          <svg viewBox="0 0 1024 1024" xmlns="http://www.w3.org/2000/svg">
            <path
              d="M512 512m-421.875 0a421.875 421.875 0 1 0 843.75 0 421.875 421.875 0 1 0-843.75 0Z"
              fill="''' + getColor(0, color, colors, '#ED6B48') + '''"
            />
            <path
              d="M760.7796875 378.0546875L269.2109375 768.8796875 374.890625 911.09375c42.9890625 14.765625 89.1 22.78125 137.109375 22.78125 233.0015625 0 421.875-188.8734375 421.875-421.875l-173.0953125-133.9453125z"
              fill="''' + getColor(1, color, colors, '#CE523E') + '''"
            />
            <path
              d="M286.71875 270.2234375h344.08125v467.4375H286.71875z"
              fill="''' + getColor(2, color, colors, '#BFBFBF') + '''"
            />
            <path
              d="M533.4734375 397.2078125h233.71875v352.35h-233.71875z"
              fill="''' + getColor(3, color, colors, '#BFBFBF') + '''"
            />
            <path
              d="M488.2484375 690.1578125c0 19.575-16.03125 35.6484375-35.6484375 35.6484375-19.6171875 0-35.6484375-16.0734375-35.6484375-35.6484375 0-19.6171875 16.03125-35.6484375 35.6484375-35.6484375 19.6171875 0 35.6484375 16.0734375 35.6484375 35.6484375v-59.4H310.0484375c-6.5390625 0-11.8546875-5.3578125-11.8546875-11.8546875V333.8421875c0-6.5390625 5.3578125-11.896875 11.8546875-11.896875h285.0609375c6.496875 0 11.896875 5.3578125 11.896875 11.896875v44.1703125h47.503125V262.5453125c0-19.575-16.03125-35.6484375-35.6484375-35.6484375H286.3390625c-19.6171875 0-35.6484375 16.03125-35.6484375 35.6484375v475.115625c0 19.575 16.03125 35.6484375 35.6484375 35.6484375h203.090625c-0.84375-3.796875-1.18125-7.846875-1.18125-11.8546875v-71.296875zM444.1625 277.9015625c4.3875-4.3875 12.4453125-4.3875 16.8328125 0 2.1515625 2.2359375 3.459375 5.3578125 3.459375 8.4375s-1.3078125 6.159375-3.459375 8.4375c-2.2359375 2.1515625-5.315625 3.459375-8.4375 3.459375-3.0796875 0-6.159375-1.3078125-8.4375-3.459375-2.1515625-2.2359375-3.459375-5.315625-3.459375-8.4375 0.084375-3.2484375 1.35-6.2015625 3.5015625-8.4375z"
              fill="''' + getColor(4, color, colors, '#212121') + '''"
            />
            <path
              d="M737.6609375 369.4484375h-190.0546875c-19.6171875 0-35.6484375 16.03125-35.6484375 35.6484375v356.315625c0 19.575 16.03125 35.6484375 35.6484375 35.6484375h190.0546875c19.575 0 35.6484375-16.0734375 35.6484375-35.6484375V405.096875c0-19.575-16.03125-35.6484375-35.6484375-35.6484375z m-103.44375 50.9625c4.5140625-4.3875 12.3609375-4.3875 16.875 0 2.1515625 2.278125 3.459375 5.3578125 3.459375 8.4375s-1.18125 6.159375-3.459375 8.4375c-2.2359375 2.1515625-5.3578125 3.459375-8.4375 3.459375s-6.159375-1.3078125-8.4375-3.459375c-2.109375-2.278125-3.4171875-5.3578125-3.4171875-8.4375-0.0421875-3.20625 1.265625-6.2015625 3.4171875-8.4375z m-47.503125 0c4.3875-4.3875 12.4875-4.3875 16.8328125 0 2.1515625 2.278125 3.459375 5.3578125 3.459375 8.4375s-1.3078125 6.159375-3.459375 8.4375c-2.2359375 2.2359375-5.315625 3.459375-8.4375 3.459375-3.0796875 0-6.159375-1.18125-8.4375-3.459375-2.109375-2.278125-3.459375-5.3578125-3.459375-8.4375 0.0421875-3.0796875 1.35-6.2015625 3.5015625-8.4375z m64.3359375 325.6875c-2.2359375 2.1515625-5.3578125 3.459375-8.4375 3.459375s-6.159375-1.3078125-8.4375-3.459375c-2.109375-2.2359375-3.4171875-5.315625-3.4171875-8.4375 0-3.0796875 1.3078125-6.2015625 3.4171875-8.4375 4.4296875-4.3875 12.4875-4.3875 16.875 0 2.1515625 2.2359375 3.459375 5.3578125 3.459375 8.4375 0.0421875 3.121875-1.1390625 6.2015625-3.459375 8.4375z m74.75625-55.940625c0 6.496875-5.3578125 11.8546875-11.8546875 11.8546875h-142.509375c-6.5390625 0-11.896875-5.3578125-11.896875-11.8546875V476.3515625c0-6.5390625 5.315625-11.8546875 11.896875-11.8546875h142.509375c6.496875 0 11.8546875 5.315625 11.8546875 11.8546875v213.80625z"
              fill="''' + getColor(5, color, colors, '#212121') + '''"
            />
            <path
              d="M488.2484375 630.7578125h52.6078125v142.509375H488.2484375z"
              fill="''' + getColor(6, color, colors, '#212121') + '''"
            />
          </svg>
        ''';
        break;
      case IconNames.equipment_order:
        svgXml = '''
          <svg viewBox="0 0 1024 1024" xmlns="http://www.w3.org/2000/svg">
            <path
              d="M511.99997858 511.99997858m-421.87497858-1e-8a421.87497857 421.87497857 0 1 0 843.74995798 0 421.87497857 421.87497857 0 1 0-843.74995798 0Z"
              fill="''' + getColor(0, color, colors, '#F79D00') + '''"
            />
            <path
              d="M796.03574582 400.46045309l-234.64264472 23.46468668-328.51826477 23.46890461 200.28092761 479.1149761A423.60466607 423.60466607 0 0 0 511.99997858 933.87495798c232.99311346 0 421.87497857-188.88186593 421.8749794-421.8749794l-137.83921216-111.53952549z"
              fill="''' + getColor(1, color, colors, '#EA7E08') + '''"
            />
            <path
              d="M514.45529108 541.75060275c-58.0246842 0-105.0764013 47.05593503-105.07640049 105.09327548 0 58.03734045 47.05171628 105.09327631 105.07640048 105.09327631 58.05421545 0 105.11437006-47.05171628 105.11437007-105.09327631 0-58.03734045-47.06015378-105.09327631-105.11437007-105.09327548z m0 128.56639966a23.46890542 23.46890542 0 1 1 0.016875-46.93781003 23.46890542 23.46890542 0 0 1-0.016875 46.93781003z"
              fill="''' + getColor(2, color, colors, '#ED5564') + '''"
            />
            <path
              d="M232.87483633 400.46045309h563.16090949v46.93359129H232.87483633z"
              fill="''' + getColor(3, color, colors, '#434A54') + '''"
            />
            <path
              d="M596.59013071 400.46045309a11.72812417 11.72812417 0 0 0 23.45624917 0h-23.45624917zM549.65232068 400.46045309a11.74499918 11.74499918 0 0 0 23.48156167 0h-23.48156167zM502.73138564 400.46045309a11.73656168 11.73656168 0 0 0 23.46468668 0h-23.46468668zM455.80201312 400.46045309a11.72812417 11.72812417 0 0 0 23.45624836 0h-23.45624836zM408.86420309 400.46045309a11.74078043 11.74078043 0 0 0 23.47312335 0h-23.47312335z"
              fill="''' + getColor(4, color, colors, '#656D78') + '''"
            />
            <path
              d="M273.94858468 365.26764224a17.59640543 17.59640543 0 0 0-17.60062416 17.59640543v82.13062088a17.60062418 17.60062418 0 0 0 35.19702959 0V382.86404767a17.59218668 17.59218668 0 0 0-17.59640543-17.59640543z"
              fill="''' + getColor(5, color, colors, '#DA4453') + '''"
            />
            <path
              d="M309.14561428 318.32561347a17.60062418 17.60062418 0 0 0-17.59640542 17.59640542v176.01045969a17.59218668 17.59218668 0 0 0 35.19281086 0V335.92201889a17.59640543 17.59640543 0 0 0-17.59640544-17.59640543z"
              fill="''' + getColor(6, color, colors, '#ED5564') + '''"
            />
            <path
              d="M344.34264389 318.32561347a17.60062418 17.60062418 0 0 0-17.59640543 17.59640542v176.01045969a17.60062418 17.60062418 0 0 0 35.19702961 0V335.92201889c0-9.70312417-7.8721875-17.59640543-17.60062418-17.59640543zM754.97465454 365.26764224a17.61328042 17.61328042 0 0 1 17.60062417 17.59640543v82.13062088a17.61328042 17.61328042 0 0 1-17.60062417 17.59640543 17.60484292 17.60484292 0 0 1-17.59640542-17.59640543V382.86404767a17.60906167 17.60906167 0 0 1 17.59640542-17.59640543z"
              fill="''' + getColor(7, color, colors, '#DA4453') + '''"
            />
            <path
              d="M719.77762495 318.32561347a17.61749917 17.61749917 0 0 1 17.60062416 17.59640542v176.01045969a17.60906167 17.60906167 0 0 1-17.60062416 17.59218667 17.60484292 17.60484292 0 0 1-17.59640544-17.59218667V335.92201889c0-9.70312417 7.88484375-17.59640543 17.59640544-17.59640543z"
              fill="''' + getColor(8, color, colors, '#ED5564') + '''"
            />
            <path
              d="M684.58059534 318.32561347a17.61328042 17.61328042 0 0 1 17.60062417 17.59640542v176.01045969c0 9.70734292-7.8890625 17.59218668-17.60062417 17.59218667a17.60484292 17.60484292 0 0 1-17.59640543-17.59218667V335.92201889c0-9.70312417 7.880625-17.59640543 17.59640543-17.59640543zM514.45529108 763.67793496c-64.41609045 0-116.81718173-52.41796628-116.81718174-116.83405672s52.40531003-116.81718173 116.81718173-116.81718174 116.82983798 52.40109128 116.82983798 116.81718174-52.41374753 116.83405673-116.82983797 116.83405672z m0-210.19077053c-51.45609128 0-93.35671381 41.88796628-93.35671381 93.35671381s41.90062253 93.35671381 93.35671381 93.35671462c51.48984128 0 93.36093256-41.88374753 93.36093338-93.35671462s-41.87109128-93.35671381-93.36093339-93.35671381z"
              fill="''' + getColor(9, color, colors, '#DA4453') + '''"
            />
            <path
              d="M514.45529108 682.04090784c-19.40203042 0-35.20124835-15.79921793-35.20124835-35.20124835 0-19.40624917 15.79499918-35.19702961 35.20124835-35.19702961 19.42312418 0 35.19702961 15.78656167 35.1970296 35.19702961 0 19.40203042-15.77390543 35.20124835-35.1970296 35.20124835z m0-46.92093504a11.73656168 11.73656168 0 0 0-11.72390544 11.72390544 11.73656168 11.73656168 0 1 0 23.46468668 0 11.74078043 11.74078043 0 0 0-11.74078125-11.72390544z"
              fill="''' + getColor(10, color, colors, '#DA4453') + '''"
            />
          </svg>
        ''';
        break;
      case IconNames.top_up_order:
        svgXml = '''
          <svg viewBox="0 0 1024 1024" xmlns="http://www.w3.org/2000/svg">
            <path
              d="M512 512m-421.875 0a421.875 421.875 0 1 0 843.75 0 421.875 421.875 0 1 0-843.75 0Z"
              fill="''' + getColor(0, color, colors, '#D49BDD') + '''"
            />
            <path
              d="M717.17046875 331.6315625l-76.7390625 263.73515625-375.90328125 180.275625s70.8328125 95.47453125 145.62703125 145.850625C456.9790625 932.8203125 494.59765625 933.875 512 933.875c232.993125 0 421.875-188.881875 421.875-421.875l-216.70453125-180.3684375z"
              fill="''' + getColor(1, color, colors, '#CF4EDD') + '''"
            />
            <path
              d="M284.4575 375.7090625c-0.84375 0-1.6875-0.421875-2.109375-1.265625l-6.564375-11.68171875a2.3709375 2.3709375 0 0 1 0.9028125-3.25265625 2.3709375 2.3709375 0 0 1 3.25265625 0.9028125l6.564375 11.74078125a2.3709375 2.3709375 0 0 1-0.9028125 3.25265625 2.025 2.025 0 0 1-1.14328125 0.30375z"
              fill="''' + getColor(2, color, colors, '#00B7EE') + '''"
            />
            <path
              d="M275.3028125 373.11875c-0.84375 0-1.6875-0.421875-2.109375-1.265625a2.34140625 2.34140625 0 0 1 0.961875-3.25265625l11.74078125-6.564375a2.34140625 2.34140625 0 0 1 3.25265625 0.961875 2.34140625 2.34140625 0 0 1-0.961875 3.25265625l-11.74078125 6.564375a2.615625 2.615625 0 0 1-1.14328125 0.30375z"
              fill="''' + getColor(3, color, colors, '#00B7EE') + '''"
            />
            <path
              d="M711.60171875 278.5259375a2.44265625 2.44265625 0 0 1-2.34984375-1.805625l-5.7796875-21.6759375c-0.3628125-1.265625 0.421875-2.5903125 1.6875-2.94890625 1.265625-0.3628125 2.5903125 0.421875 2.94890625 1.6875l5.7796875 21.6759375c0.3628125 1.265625-0.421875 2.5903125-1.6875 2.94890625-0.1771875 0.118125-0.41765625 0.118125-0.5990625 0.118125z"
              fill="''' + getColor(4, color, colors, '#ACD598') + '''"
            />
            <path
              d="M697.87390625 270.636875a2.44265625 2.44265625 0 0 1-2.34984375-1.805625c-0.3628125-1.265625 0.421875-2.5903125 1.6875-2.94890625l21.6759375-5.83875c1.265625-0.3628125 2.5903125 0.421875 2.94890625 1.6875s-0.421875 2.5903125-1.6875 2.94890625l-21.6759375 5.83875a2.12625 2.12625 0 0 1-0.5990625 0.118125z"
              fill="''' + getColor(5, color, colors, '#ACD598') + '''"
            />
            <path
              d="M784.45953125 723.67578125a2.06296875 2.06296875 0 0 1-1.38375-0.4809375l-14.87109375-10.71984375a2.4046875 2.4046875 0 0 1-0.54-3.37078125 2.4046875 2.4046875 0 0 1 3.37078125-0.54l14.87109375 10.71984375a2.4046875 2.4046875 0 0 1 0.54 3.37078125 2.278125 2.278125 0 0 1-1.98703125 1.0209375z"
              fill="''' + getColor(6, color, colors, '#FFF100') + '''"
            />
            <path
              d="M771.69359375 725.78515625a2.06296875 2.06296875 0 0 1-1.38375-0.4809375 2.4046875 2.4046875 0 0 1-0.54-3.37078125l10.6565625-14.87109375a2.4046875 2.4046875 0 0 1 3.37078125-0.54 2.4046875 2.4046875 0 0 1 0.54 3.37078125l-10.6565625 14.87109375a2.514375 2.514375 0 0 1-1.98703125 1.0209375z"
              fill="''' + getColor(7, color, colors, '#FFF100') + '''"
            />
            <path
              d="M644.76828125 302.66984375a7.2478125 7.2478125 0 0 1-7.22671875-7.22671875c0-3.9740625 3.25265625-7.22671875 7.22671875-7.22671875s7.22671875 3.25265625 7.22671875 7.22671875a7.2478125 7.2478125 0 0 1-7.22671875 7.22671875z m0-11.559375c-2.40890625 0-4.336875 1.92796875-4.336875 4.336875s1.92796875 4.336875 4.336875 4.336875 4.336875-1.92796875 4.336875-4.336875a4.32 4.32 0 0 0-4.336875-4.336875z"
              fill="''' + getColor(8, color, colors, '#EB6877') + '''"
            />
            <path
              d="M750.3171875 774.55390625c-4.3959375 0-7.948125-3.5521875-7.948125-7.948125s3.5521875-7.948125 7.948125-7.948125 7.948125 3.5521875 7.948125 7.948125-3.5521875 7.948125-7.948125 7.948125z m0-13.246875c-2.88984375 0-5.29875 2.40890625-5.29875 5.29875s2.40890625 5.29875 5.29875 5.29875 5.29875-2.40890625 5.29875-5.29875-2.4046875-5.29875-5.29875-5.29875z"
              fill="''' + getColor(9, color, colors, '#7EDDDC') + '''"
            />
            <path
              d="M785.36234375 285.9340625c-5.6615625 0-10.29796875-4.63640625-10.29796875-10.29796875s4.63640625-10.29796875 10.29796875-10.29796875 10.29796875 4.63640625 10.29796875 10.29796875-4.63640625 10.29796875-10.29796875 10.29796875z m0-16.49953125c-3.37078125 0-6.2015625 2.77171875-6.2015625 6.2015625 0 3.4340625 2.77171875 6.2015625 6.2015625 6.2015625s6.2015625-2.77171875 6.2015625-6.2015625c0-3.4340625-2.83078125-6.2015625-6.2015625-6.2015625z"
              fill="''' + getColor(10, color, colors, '#FF8700') + '''"
            />
            <path
              d="M757.12203125 331.5725a5.11734375 5.11734375 0 1 0 10.2346875 0 5.11734375 5.11734375 0 1 0-10.2346875 0z"
              fill="''' + getColor(11, color, colors, '#D3D462') + '''"
            />
            <path
              d="M723.46484375 717.2928125a4.21453125 4.21453125 0 1 0 8.42484375 0 4.21453125 4.21453125 0 0 0-8.42484375 0z"
              fill="''' + getColor(12, color, colors, '#A657FF') + '''"
            />
            <path
              d="M363.87546875 260.58359375a2.40890625 2.40890625 0 1 0 4.82203125 0 2.40890625 2.40890625 0 0 0-4.82203125 0z"
              fill="''' + getColor(13, color, colors, '#FF455C') + '''"
            />
            <path
              d="M508.96671875 259.3053125a4.8178125 4.8178125 0 0 0 3.0459375-9.1378125 4.8178125 4.8178125 0 0 0-3.0459375 9.1378125z"
              fill="''' + getColor(14, color, colors, '#F78282') + '''"
            />
            <path
              d="M290.6 297.5525a3.61125 3.61125 0 1 0 7.21828125 0 3.61125 3.61125 0 0 0-7.21828125 0z"
              fill="''' + getColor(15, color, colors, '#B4DB61') + '''"
            />
            <path
              d="M251.8803125 278.1040625a8.42484375 8.42484375 0 0 1-6.02015625-2.46796875c-3.31171875-3.25265625-3.31171875-8.66953125-0.0590625-11.98125l0.0590625-0.0590625a8.46703125 8.46703125 0 0 1 14.44921875 6.02015625c0 2.2865625-0.9028125 4.3959375-2.46796875 6.02015625-1.68328125 1.6875-3.79265625 2.46796875-5.96109375 2.46796875z m-3.85171875-12.28078125a5.41265625 5.41265625 0 0 0 7.64859375 7.64859375c1.02515625-1.02515625 1.56515625-2.40890625 1.56515625-3.79265625 0-1.38375-0.60328125-2.83078125-1.56515625-3.79265625a5.3578125 5.3578125 0 0 0-7.64859375-0.06328125z"
              fill="''' + getColor(16, color, colors, '#FF8A8A') + '''"
            />
            <path
              d="M431.3121875 295.50640625a11.36953125 11.36953125 0 0 1-8.07046875-3.37078125 11.4834375 11.4834375 0 0 1 0-16.19578125l0.0590625-0.0590625c2.1684375-2.1684375 4.99921875-3.31171875 8.07046875-3.31171875s5.90203125 1.20234375 8.07046875 3.37078125a11.4834375 11.4834375 0 0 1 0 16.19578125 11.2471875 11.2471875 0 0 1-8.12953125 3.37078125z m-4.69546875-16.07765625a6.63609375 6.63609375 0 0 0 0.0590625 9.331875 6.64875 6.64875 0 0 0 9.39515625 0 6.64875 6.64875 0 0 0 0-9.39515625c-1.265625-1.265625-2.88984375-1.92796875-4.69546875-1.92796875s-3.493125 0.725625-4.75875 1.99125z"
              fill="''' + getColor(17, color, colors, '#B3D465') + '''"
            />
            <path
              d="M229.00203125 333.44140625a4.8178125 4.8178125 0 1 0 9.63140625 0 4.8178125 4.8178125 0 0 0-9.63140625 0z"
              fill="''' + getColor(18, color, colors, '#CC9EE1') + '''"
            />
            <path
              d="M787.77125 465.003125a2.109375 2.109375 0 0 0 4.21875 0 2.109375 2.109375 0 0 0-4.21875 0z"
              fill="''' + getColor(19, color, colors, '#D3A884') + '''"
            />
            <path
              d="M781.1478125 593.25734375a2.109375 2.109375 0 1 0 4.21875 0 2.109375 2.109375 0 0 0-4.21875 0z"
              fill="''' + getColor(20, color, colors, '#22B4FF') + '''"
            />
            <path
              d="M783.55671875 393.351875a4.5140625 4.5140625 0 1 0 9.028125 0 4.5140625 4.5140625 0 0 0-9.028125 0z"
              fill="''' + getColor(21, color, colors, '#F2ED62') + '''"
            />
            <path
              d="M604.30625 244.26546875a4.8178125 4.8178125 0 1 0 9.63140625 0 4.8178125 4.8178125 0 0 0-9.63140625 0z"
              fill="''' + getColor(22, color, colors, '#EBB4BE') + '''"
            />
            <path
              d="M749.83625 441.884375c-1.8646875 0-3.73359375-0.72140625-5.17640625-2.109375a7.36171875 7.36171875 0 0 1-0.0590625-10.29796875l0.0590625-0.0590625c1.38375-1.38375 3.189375-2.109375 5.17640625-2.109375 1.92796875 0 3.73359375 0.7846875 5.17640625 2.109375 2.83078125 2.83078125 2.83078125 7.4671875 0 10.29796875a7.2984375 7.2984375 0 0 1-5.17640625 2.1684375z m-3.42984375-10.71984375a4.79671875 4.79671875 0 0 0 0 6.86390625c1.8646875 1.8646875 4.99921875 1.8646875 6.86390625 0s1.8646875-4.99921875 0-6.86390625c-0.9028125-0.9028125-2.109375-1.44703125-3.4340625-1.44703125s-2.52703125 0.54421875-3.42984375 1.44703125z"
              fill="''' + getColor(23, color, colors, '#47C1C2') + '''"
            />
            <path
              d="M276.5684375 537.56140625v-24.688125a18.04359375 18.04359375 0 0 1 18.0646875-18.0646875h389.87578125a18.04359375 18.04359375 0 0 1 18.0646875 18.0646875v246.86859375a18.04359375 18.04359375 0 0 1-18.0646875 18.0646875H294.633125a18.04359375 18.04359375 0 0 1-18.0646875-18.0646875v-136.9828125"
              fill="''' + getColor(24, color, colors, '#22B4FF') + '''"
            />
            <path
              d="M672.464375 783.82671875H282.58859375a24.080625 24.080625 0 0 1-24.08484375-24.08484375v-136.9828125c0-3.31171875 2.7084375-6.02015625 6.02015625-6.02015625s6.02015625 2.7084375 6.02015625 6.02015625v136.9828125a12.0825 12.0825 0 0 0 12.04453125 12.04453125h389.87578125a12.0825 12.0825 0 0 0 12.04453125-12.04453125v-246.86859375a12.0825 12.0825 0 0 0-12.04453125-12.04453125H282.58859375a12.0825 12.0825 0 0 0-12.04453125 12.04453125v24.688125c0 3.31171875-2.7084375 6.02015625-6.02015625 6.02015625a6.03703125 6.03703125 0 0 1-6.02015625-6.02015625v-24.688125a24.080625 24.080625 0 0 1 24.08484375-24.08484375h389.87578125a24.080625 24.080625 0 0 1 24.08484375 24.08484375v246.86859375a24.114375 24.114375 0 0 1-24.08484375 24.08484375z"
              fill="''' + getColor(25, color, colors, '#222222') + '''"
            />
            <path
              d="M375.31671875 494.80859375H574.015625v282.99796875H375.31671875V494.80859375z"
              fill="''' + getColor(26, color, colors, '#FFDF00') + '''"
            />
            <path
              d="M580.04 783.82671875H369.2965625V488.7884375h210.7434375v295.03828125z m-198.703125-12.0403125h186.65859375V500.82875H381.336875v270.95765625z"
              fill="''' + getColor(27, color, colors, '#222222') + '''"
            />
            <path
              d="M381.336875 500.82875h9.635625v270.95765625h-9.635625V500.82875z m198.703125 0h9.635625v270.95765625h-9.635625V500.82875z"
              fill="''' + getColor(28, color, colors, '#FFFFFF') + '''"
            />
            <path
              d="M254.8925 579.70671875a9.635625 9.635625 0 1 0 19.27125 0 9.635625 9.635625 0 0 0-19.27125 0z"
              fill="''' + getColor(29, color, colors, '#222222') + '''"
            />
            <path
              d="M647.83953125 443.268125c-23.12296875-52.68375 36.79171875-145.11234375 71.65125-94.651875 30.28640625 43.8328125-48.29203125 147.87984375-71.65125 94.651875z"
              fill="''' + getColor(30, color, colors, '#EB6877') + '''"
            />
            <path
              d="M655.96484375 472.833125h-1.265625c-7.8890625-0.3628125-18.78609375-4.21453125-26.0128125-20.59171875-19.14890625-43.47421875 7.28578125-109.28671875 41.72765625-128.6128125 19.14890625-10.71984375 37.87171875-5.6615625 51.42234375 13.90921875 7.4671875 10.77890625 10.35703125 25.11 8.37 41.4871875-1.7465625 14.090625-6.98625 29.32453125-15.1115625 44.0775-13.7278125 24.9834375-37.27265625 49.730625-59.13 49.730625z m-16.25484375-25.4728125c3.85171875 8.7328125 8.91 13.12453125 15.5334375 13.42828125h0.72140625c14.27203125 0 34.56-18.12375 48.5915625-43.53328125 12.403125-22.5196875 20.89546875-53.4684375 7.408125-72.916875-9.99421875-14.44921875-22.03875-17.88328125-35.64421875-10.2346875-13.96828125 7.82578125-27.51890625 26.37140625-35.3446875 48.35109375-8.49234375 23.78109375-8.91421875 47.4440625-1.265625 64.90546875z"
              fill="''' + getColor(31, color, colors, '#222222') + '''"
            />
            <path
              d="M657.28953125 509.26203125c21.43546875 48.650625 122.11171875 65.20921875 109.5271875 9.87609375-10.89703125-48.0515625-131.203125-59.011875-109.5271875-9.87609375z"
              fill="''' + getColor(32, color, colors, '#EB6877') + '''"
            />
            <path
              d="M732.0753125 561.94578125c-37.39078125 0-85.50140625-23.18203125-101.2753125-59.06671875-7.22671875-16.3771875-2.7084375-27.03375 2.34984375-33.058125 14.33109375-17.161875 49.37203125-17.94234375 77.7346875-11.0784375 16.3771875 3.9740625 31.13015625 10.35703125 42.63046875 18.545625 13.42828125 9.51328125 22.03875 21.313125 24.92859375 34.0790625 5.2396875 23.18203125-3.67453125 40.46203125-24.56578125 47.3259375-6.50953125 2.2275-13.9134375 3.25265625-21.8025 3.25265625z m-90.31921875-63.94359375c7.70765625 17.40234375 25.46859375 33.058125 48.7096875 42.811875 21.49453125 9.03234375 44.37703125 11.5003125 59.6109375 6.50109375 14.87109375-4.9359375 20.47359375-16.07765625 16.55859375-33.2353125-5.2396875-23.000625-33.72046875-37.5721875-58.64484375-43.59234375-28.84359375-6.92296875-56.480625-3.9740625-65.69015625 7.104375-4.15546875 4.995-4.3959375 11.7365625-0.54421875 20.4103125z"
              fill="''' + getColor(33, color, colors, '#222222') + '''"
            />
            <path
              d="M590.09328125 313.63015625l187.56140625 323.58234375a16.891875 16.891875 0 0 1-6.2015625 23.12296875l-32.6953125 18.9084375a16.891875 16.891875 0 0 1-23.12296875-6.2015625l-187.50234375-323.58234375a16.891875 16.891875 0 0 1 6.2015625-23.12296875l32.6953125-18.9084375a16.81171875 16.81171875 0 0 1 23.06390625 6.2015625z"
              fill="''' + getColor(34, color, colors, '#358AFE') + '''"
            />
            <path
              d="M730.32875 687.48734375c-1.98703125 0-3.9740625-0.24046875-5.96109375-0.7846875a22.7221875 22.7221875 0 0 1-13.90921875-10.6565625l-0.24046875-0.421875-196.9565625-339.4153125c-6.32390625-10.9603125-2.52703125-25.04671875 8.37-31.370625l32.6953125-18.9084375a22.8403125 22.8403125 0 0 1 17.40234375-2.2865625 22.95 22.95 0 0 1 13.85015625 10.47515625l0.12234375 0.24046875 197.13375 339.778125c6.32390625 10.9603125 2.5903125 25.04671875-8.37 31.370625l-32.6953125 18.9084375a22.77703125 22.77703125 0 0 1-11.44125 3.07125z m-9.39515625-17.3390625a10.715625 10.715625 0 0 0 6.50109375 4.9359375 10.9434375 10.9434375 0 0 0 8.24765625-1.08421875l32.6953125-18.9084375c5.17640625-3.0121875 6.98625-9.6946875 3.9740625-14.87109375L575.28125 300.38328125a10.6059375 10.6059375 0 0 0-6.6234375-5.05828125 10.9434375 10.9434375 0 0 0-8.24765625 1.08421875l-32.6953125 18.9084375c-5.17640625 3.0121875-6.98625 9.6946875-3.9740625 14.87109375l197.13375 339.8371875 0.0590625 0.12234375z"
              fill="''' + getColor(35, color, colors, '#222222') + '''"
            />
            <path
              d="M642.59984375 404.37125l72.9759375 125.78203125-61.05375 37.4540625-73.03921875-125.78625 61.11703125-37.44984375z"
              fill="''' + getColor(36, color, colors, '#FFDF00') + '''"
            />
            <path
              d="M652.35359375 575.97734375L573.35328125 439.775l71.35171875-43.7146875 79.059375 136.20234375-71.41078125 43.7146875z m-62.6821875-132.1059375l66.95578125 115.3659375 50.8190625-31.13015625-67.01484375-115.3659375-50.76 31.13015625z"
              fill="''' + getColor(37, color, colors, '#222222') + '''"
            />
            <path
              d="M669.8740625 582.29703125l-7.1634375-12.52546875 51.2409375-31.49296875 7.1634375 12.52546875-51.2409375 31.49296875z m-80.62453125-138.3665625l51.60375-31.55203125 7.408125 13.246875-51.2409375 30.8896875-7.7709375-12.58453125z"
              fill="''' + getColor(38, color, colors, '#FFFFFF') + '''"
            />
            <path
              d="M285.419375 449.410625c-4.876875-4.455-10.2346875-5.17640625-16.07765625-2.2275-5.90203125 2.94890625-7.4671875 1.44703125-4.75875-4.57734375 2.7084375-5.96109375 1.7465625-11.31890625-2.88984375-16.01859375s-3.67453125-6.6234375 2.88984375-5.90203125c6.50109375 0.72140625 11.31890625-1.805625 14.33109375-7.64859375s5.17640625-5.53921875 6.50109375 0.9028125c1.3246875 6.44203125 5.2396875 10.175625 11.68171875 11.25984375 6.50109375 1.08421875 6.86390625 3.189375 1.14328125 6.50109375-5.720625 3.25265625-8.07046875 8.12953125-7.104375 14.630625 1.0884375 6.50953125-0.83953125 7.5346875-5.71640625 3.0796875z"
              fill="''' + getColor(39, color, colors, '#87FFFE') + '''"
            />
            <path
              d="M284.63890625 463.31984375c-4.21453125 0-7.948125-3.4340625-9.57234375-4.9359375-4.09640625-3.79265625-8.0071875-4.27359375-12.94734375-1.805625-2.52703125 1.265625-9.21375 4.63640625-13.7278125 0.29953125-4.5140625-4.336875-1.44703125-11.20078125-0.29953125-13.786875 2.2865625-5.11734375 1.62421875-8.97328125-2.2865625-13.00640625-1.98703125-1.98703125-7.22671875-7.34484375-4.5140625-13.00640625 2.77171875-5.6615625 10.175625-4.8178125 12.94734375-4.5140625 5.53921875 0.60328125 8.97328125-1.20234375 11.559375-6.2015625 1.265625-2.52703125 4.69546875-9.21375 10.9603125-8.3109375 6.2015625 0.84375 7.70765625 8.18859375 8.3109375 10.9603125 1.14328125 5.48015625 3.915 8.18859375 9.45421875 9.15046875 2.77171875 0.4809375 10.175625 1.6875 11.25984375 7.82578125 1.08421875 6.2015625-5.42109375 9.87609375-7.82578125 11.25984375-4.876875 2.77171875-6.564375 6.32390625-5.720625 11.863125 0.421875 2.77171875 1.56515625 10.2346875-3.9740625 13.1878125a6.4884375 6.4884375 0 0 1-3.62390625 1.0209375z m-16.7990625-20.2921875c4.21453125 0 8.3109375 1.3246875 12.16265625 3.915-0.0590625-7.28578125 2.83078125-13.3059375 8.61046875-17.7609375-6.92296875-2.1684375-11.74078125-6.80484375-14.1496875-13.6096875-4.21453125 5.90203125-10.0575 9.03234375-17.3390625 9.2728125 4.336875 5.83875 5.48015625 12.4621875 3.493125 19.4484375a20.2078125 20.2078125 0 0 1 7.2225-1.265625z"
              fill="''' + getColor(40, color, colors, '#222222') + '''"
            />
            <path
              d="M383.20578125 346.085c-10.175625-0.961875-17.52046875 3.189375-22.03875 12.3440625s-7.8890625 8.791875-10.175625-1.20234375c-2.2865625-9.99421875-8.4290625-15.71484375-18.6046875-17.161875-10.1165625-1.44703125-10.77890625-4.8178125-1.98703125-10.0575s12.285-12.8840625 10.5975-23.000625c-1.6875-10.1165625 1.20234375-11.74078125 8.91-4.99921875 7.70765625 6.74578125 16.07765625 7.70765625 25.11 2.94890625s11.559375-2.46796875 7.52625 6.92296875c-4.033125 9.39515625-2.40890625 17.6428125 4.9359375 24.80625 7.34484375 7.171875 5.90203125 10.36125-4.27359375 9.399375z"
              fill="''' + getColor(41, color, colors, '#57EBBF') + '''"
            />
            <path
              d="M344.1275 374.4434375c-0.3628125 0-0.7846875 0-1.20234375-0.0590625-6.98625-0.961875-8.7328125-9.6946875-9.51328125-13.36921875-1.7465625-8.55140625-6.32390625-13.00640625-14.87109375-14.44921875-3.73359375-0.60328125-12.403125-2.04609375-13.66875-9.03234375-1.20234375-6.92296875 6.44203125-11.31890625 9.75375-13.1878125 7.5853125-4.27359375 10.35703125-10.0575 9.03234375-18.72703125-0.54-3.73359375-1.8646875-12.52546875 4.336875-15.8371875 6.2015625-3.31171875 12.706875 2.7084375 15.5334375 5.2396875 6.38296875 5.90203125 12.706875 6.80484375 20.47359375 2.88984375 3.37078125-1.6875 11.25984375-5.6615625 16.318125-0.7846875 5.05828125 4.876875 1.44703125 12.94734375-0.12234375 16.43625-3.61125 7.948125-2.46796875 14.27203125 3.61125 20.53265625 2.649375 2.7084375 8.8509375 9.03234375 5.720625 15.35203125-3.07125 6.32390625-11.863125 5.29875-15.59671875 4.876875-8.61046875-0.961875-14.27203125 2.04609375-18.24609375 9.75375-1.56515625 3.20203125-5.29875 10.36546875-11.559375 10.36546875z m-23.304375-39.740625c13.1878125 2.2865625 21.616875 10.41609375 24.384375 23.54484375 6.260625-11.863125 16.55859375-17.3390625 29.86453125-15.9553125-9.331875-9.635625-11.3821875-21.195-5.90203125-33.48-11.98125 5.90203125-23.54484375 4.27359375-33.48-4.69546875 1.873125 13.365-3.24421875 23.9034375-14.866875 30.5859375z m181.24171875 142.34484375a6.05390625 6.05390625 0 0 1-5.720625-4.15546875l-28.90265625-87.30703125a6.00328125 6.00328125 0 0 1 3.85171875-7.5853125 6.00328125 6.00328125 0 0 1 7.5853125 3.85171875L507.78125 469.15859375a6.00328125 6.00328125 0 0 1-3.85171875 7.5853125c-0.60328125 0.24046875-1.265625 0.30375-1.8646875 0.30375z m-63.82546875-3.61546875c-1.8646875 0-3.73359375-0.9028125-4.9359375-2.5903125l-57.5015625-81.89015625a5.9821875 5.9821875 0 0 1 1.44703125-8.37 5.9821875 5.9821875 0 0 1 8.37 1.44703125l57.5015625 81.89015625c1.92796875 2.7084375 1.265625 6.50109375-1.44703125 8.37a5.6025 5.6025 0 0 1-3.4340625 1.14328125z m-72.55828125 6.32390625c-0.84375 0-1.7465625-0.18140625-2.5903125-0.60328125l-37.935-18.0646875a5.97796875 5.97796875 0 0 1-2.83078125-8.0071875 5.97796875 5.97796875 0 0 1 8.0071875-2.83078125l37.935 18.0646875a5.97796875 5.97796875 0 0 1 2.83078125 8.0071875 5.9990625 5.9990625 0 0 1-5.416875 3.4340625z"
              fill="''' + getColor(42, color, colors, '#222222') + '''"
            />
            <path
              d="M483.8778125 349.51484375c-4.99921875-2.1684375-9.39515625-1.3246875-13.246875 2.52703125-3.85171875 3.85171875-5.48015625 3.07125-4.9359375-2.34984375 0.54-5.42109375-1.62421875-9.331875-6.50109375-11.79984375s-4.63640625-4.27359375 0.66234375-5.42109375c5.29875-1.14328125 8.37-4.455 9.21375-9.8128125 0.84375-5.3578125 2.5903125-5.720625 5.3578125-1.02515625 2.77171875 4.69546875 6.80484375 6.6234375 12.16265625 5.720625 5.3578125-0.9028125 6.260625 0.72140625 2.649375 4.75875-3.61125 4.09640625-4.21453125 8.488125-1.6875 13.36921875 2.5903125 4.876875 1.3246875 6.2015625-3.67453125 4.033125z"
              fill="''' + getColor(43, color, colors, '#87FFFE') + '''"
            />
            <path
              d="M456.785 364.1496875c-0.961875 0-2.04609375-0.18140625-3.07125-0.72140625-5.3578125-2.52703125-4.63640625-9.39515625-4.3959375-11.62265625 0.421875-4.033125-0.9028125-6.38296875-4.455-8.18859375-2.04609375-1.02515625-8.18859375-4.09640625-7.408125-9.93515625 0.72140625-5.83875 7.4671875-7.28578125 9.6946875-7.76671875 3.915-0.84375 5.7796875-2.83078125 6.38296875-6.80484375 0.3628125-2.2275 1.38375-9.09140625 7.1634375-10.175625 5.7796875-1.08421875 9.2728125 4.876875 10.41609375 6.80484375 1.98703125 3.493125 4.455 4.63640625 8.37 3.9740625 2.2275-0.3628125 9.03234375-1.50609375 11.863125 3.67453125 2.83078125 5.17640625-1.7465625 10.29796875-3.25265625 11.98125-2.649375 3.0121875-3.0121875 5.720625-1.14328125 9.2728125 1.02515625 1.98703125 4.21453125 8.12953125 0.18140625 12.4621875-4.033125 4.27359375-10.35703125 1.50609375-12.403125 0.60328125-3.67453125-1.62421875-6.32390625-1.08421875-9.09140625 1.7465625-1.44703125 1.32046875-4.8178125 4.69546875-8.8509375 4.69546875z m-1.98703125-28.2403125c3.5521875 3.0121875 5.720625 6.98625 6.38296875 11.68171875 3.9740625-2.46796875 8.37-3.31171875 13.00640625-2.46796875a18.275625 18.275625 0 0 1 1.6875-13.1878125 18.27140625 18.27140625 0 0 1-11.98125-5.6615625 18.4528125 18.4528125 0 0 1-9.095625 9.635625zM435.77140625 603.1925a9.7790625 9.7790625 0 0 1 9.75375 9.87609375 9.7790625 9.7790625 0 0 1-9.87609375 9.75375c-5.42109375 0-9.75375-4.455-9.8128125-9.8128125a9.95625 9.95625 0 0 1 9.93515625-9.81703125z m78.39703125 0c5.42109375 0.0590625 9.8128125 4.455 9.75375 9.87609375s-4.455 9.8128125-9.87609375 9.75375a9.838125 9.838125 0 0 1-9.75375-9.8128125c-0.0590625-5.42109375 4.3959375-9.81703125 9.87609375-9.81703125z m-14.0315625 43.59234375c-4.3959375 13.90921875-19.26703125 21.6759375-33.17625 17.2209375a26.4178125 26.4178125 0 0 1-17.28-17.40234375c3.79265625 0.0590625 37.5721875 0.18140625 50.45625 0.18140625z"
              fill="''' + getColor(44, color, colors, '#222222') + '''"
            />
            <path
              d="M474.90875 667.07703125c-2.83078125 0-5.6615625-0.421875-8.488125-1.3246875a28.16015625 28.16015625 0 0 1-18.4865625-18.6046875 1.7803125 1.7803125 0 0 1 0.29953125-1.62421875 1.7971875 1.7971875 0 0 1 1.44703125-0.72140625c1.38375 0 6.44203125 0 13.06546875 0.0590625 12.285 0.0590625 29.143125 0.12234375 37.4540625 0.12234375 0.60328125 0 1.14328125 0.29953125 1.44703125 0.72140625 0.3628125 0.4809375 0.421875 1.08421875 0.24046875 1.62421875a28.3921875 28.3921875 0 0 1-26.97890625 19.74796875z m-22.70109375-18.6046875a24.6965625 24.6965625 0 0 0 15.29296875 13.90921875 24.58265625 24.58265625 0 0 0 18.78609375-1.62421875 24.20296875 24.20296875 0 0 0 11.25984375-12.10359375c-8.8509375 0-23.72203125-0.0590625-34.86375-0.12234375-4.39171875-0.0590625-8.06625-0.0590625-10.47515625-0.0590625z"
              fill="''' + getColor(45, color, colors, '#222222') + '''"
            />
            <path
              d="M474.90875 652.98640625c7.5853125 0 14.20875 2.1684375 17.7609375 5.48015625-10.1165625 9.09140625-25.46859375 9.09140625-35.52609375 0 3.5521875-3.25265625 10.175625-5.48015625 17.76515625-5.48015625z"
              fill="''' + getColor(46, color, colors, '#FF1834') + '''"
            />
          </svg>
        ''';
        break;
      case IconNames.zhifu_weixin:
        svgXml = '''
          <svg viewBox="0 0 1024 1024" xmlns="http://www.w3.org/2000/svg">
            <path
              d="M395.861333 585.941333a27.818667 27.818667 0 0 1-12.8 2.858667 28.16 28.16 0 0 1-24.789333-14.250667l-2.005333-3.797333L278.186667 407.04c-0.981333-1.962667-0.981333-3.797333-0.981334-5.717333 0-7.637333 5.930667-13.354667 13.866667-13.354667 2.986667 0 5.930667 0.938667 8.874667 2.858667l91.989333 62.848c6.869333 3.754667 14.805333 6.613333 23.68 6.613333 4.992 0 9.856-0.896 14.848-2.858667l431.232-184.661333C784.554667 185.173333 657.066667 128 512.554667 128 277.205333 128 85.333333 281.301333 85.333333 470.656c0 102.784 57.344 196.053333 147.328 258.901333a27.818667 27.818667 0 0 1 11.861334 21.930667 25.386667 25.386667 0 0 1-2.005334 8.533333c-6.912 25.685333-18.858667 67.626667-18.858666 69.504a33.706667 33.706667 0 0 0-2.005334 10.453334c0 7.68 5.973333 13.354667 13.866667 13.354666 2.986667 0 5.930667-0.938667 7.936-2.858666l92.928-52.352c6.869333-3.754667 14.805333-6.613333 22.741333-6.613334 3.925333 0 8.917333 0.896 12.8 1.92 43.52 12.373333 91.050667 19.072 139.52 19.072C746.794667 812.501333 938.666667 659.2 938.666667 469.845333c0-57.173333-17.792-111.36-48.469334-159.018666L398.805333 584.021333l-2.986666 1.92z"
              fill="''' + getColor(0, color, colors, '#09BB07') + '''"
            />
          </svg>
        ''';
        break;
      case IconNames.zhifu_zhifubao:
        svgXml = '''
          <svg viewBox="0 0 1024 1024" xmlns="http://www.w3.org/2000/svg">
            <path
              d="M896 650.666667l-247.04-83.072s18.986667-28.416 39.253333-84.138667c20.266667-55.722667 23.168-86.314667 23.168-86.314667l-159.914666-1.28V341.162667l193.706666-1.365334V301.226667h-193.706666V213.333333H456.533333v87.893334H275.882667v38.613333l180.693333-1.28v58.581333H311.637333v30.592h298.325334s-3.285333 24.832-14.72 55.722667a1254.485333 1254.485333 0 0 1-23.210667 57.941333s-140.074667-49.024-213.888-49.024-163.584 29.653333-172.288 115.712c-8.661333 86.016 41.813333 132.608 112.938667 149.76 71.125333 17.237333 136.789333-0.170667 193.962666-28.16 57.173333-27.946667 113.28-91.477333 113.28-91.477333l287.914667 139.818667A142.08 142.08 0 0 1 753.792 896H270.208A142.08 142.08 0 0 1 128 754.048V270.208A142.08 142.08 0 0 1 269.952 128h483.84A142.08 142.08 0 0 1 896 269.952v380.714667z m-360.064-48.128s-89.856 113.493333-195.754667 113.493333c-105.941333 0-128.170667-53.930667-128.170666-92.714667 0-38.741333 22.016-80.853333 112.170666-86.954666 90.069333-6.101333 211.84 66.176 211.84 66.176h-0.085333z"
              fill="''' + getColor(0, color, colors, '#02A9F1') + '''"
            />
          </svg>
        ''';
        break;
      case IconNames.live_copy_copy:
        svgXml = '''
          <svg viewBox="0 0 1280 1024" xmlns="http://www.w3.org/2000/svg">
            <path
              d="M553.18185822 290.06480649h146.44059855L852.46800514 137.21821805c11.27753682-11.27753682 29.56194975-11.27753682 40.83948656 0 11.27753682 11.27753682 11.27753682 29.56194975 0 40.83948537l-112.00710306 112.00606299h193.08414749c31.897921 0 57.7557906 25.85890847 57.75579059 57.75579059V809.86276035c0 31.89688214-25.8578696 57.75475052-57.75579059 57.75475053H281.32129182c-31.897921 0-57.7557906-25.8578696-57.7557906-57.75475053V347.819557c0-31.89688214 25.8578696-57.75475052 57.7557906-57.75475051h190.18159567l-112.006063-112.00710307c-11.27857569-11.27753682-11.27857569-29.56194975 0-40.83948537 11.27649675-11.27753682 29.56090967-11.27753682 40.83844651 0L553.18185822 290.06480649z m152.39436453 315.17221167a28.87789469 28.87789469 0 0 0 4.51080648-4.5097676c9.96348662-12.4543595 7.94355181-30.6264959-4.50976639-40.58894246l-117.4400314-93.95243993a28.87789469 28.87789469 0 0 0-18.04010807-6.32802145c-15.94740159 0-28.87685583 12.92945423-28.87685462 28.87789591v187.903841a28.87789469 28.87789469 0 0 0 6.32802024 18.04010808c9.96244775 12.4543595 28.13562303 14.47221415 40.58894245 4.50976639l117.4400314-93.95243994z"
              fill="''' + getColor(0, color, colors, '#973DF8') + '''"
            />
          </svg>
        ''';
        break;
      case IconNames.shipin_1_copy_111111:
        svgXml = '''
          <svg viewBox="0 0 1024 1024" xmlns="http://www.w3.org/2000/svg">
            <path
              d="M693.58083792 390.65038695c0 2.87994311-3.02921955 7.91407882-9.04518162 15.11454342-6.05843911 7.20046459-12.54407585 15.68009482-19.4556966 25.47165866-6.91162075 9.78185482-13.35478045 20.4266003-19.41321955 31.93545008s-9.04518163 23.30654341-9.04518163 35.39186726c0 12.09624652 2.98674252 23.74345008 9.04518163 34.96588325 6.05843911 11.23214222 12.50159882 21.43998103 19.41321955 30.64536178 6.91162075 9.21630341 13.39725748 16.842752 19.4556966 22.89026844 6.01596208 6.02688475 9.04518163 9.92020859 9.04518162 11.64841719v90.64478342c0 9.78185482-3.5838483 20.86350697-10.79523555 33.23767466-7.16769659 12.37295408-16.08544711 24.02137125-26.75203792 34.96588326-10.62411378 10.92266667-22.44243911 20.01032533-35.4137126 27.17923555-12.92758282 7.21017363-25.17310578 10.79523555-36.69287822 10.79523556H154.87127703c-15.53081837 0-29.78125748-2.73066667-42.70884028-8.192-12.97127348-5.46133333-24.31992415-13.09870459-34.13333334-22.86963674-9.77093215-9.79156385-17.40830341-21.29070459-22.86963674-34.53868563-5.46133333-13.23705837-8.192-27.62706489-8.192-43.15788327V314.68202667c0-11.50884978 2.60323555-23.45581985 7.76480236-35.82877393 5.20525748-12.37295408 12.50159882-23.73374103 22.01645512-34.10177896 9.5148563-10.35711525 20.73607585-18.98723555 33.66365867-25.8988563 12.97127348-6.9019117 27.17923555-10.35711525 42.75253096-10.35711526H582.22061037c15.53081837 0 30.07981037 2.73066667 43.6057126 8.20292267 13.52590222 5.46133333 25.30175052 12.94942815 35.37123555 22.44243911 10.06948503 9.50393363 18.00540918 20.86350697 23.7652954 34.10177895s8.61919763 27.33822103 8.61919763 42.303488v75.104256h-0.00121363z m268.500992-81.15177244v394.53885631c0 12.66179792-3.32777245 23.88301748-9.94084029 33.66365866-6.61306785 9.79156385-16.55512178 14.67763675-29.78125748 14.67763674-4.6081517 0-10.49546903-1.72820859-17.7068563-5.18341215a198.88719645 198.88719645 0 0 1-21.54678044-12.08532385c-7.21017363-4.59722903-13.99436325-9.20538075-20.30887823-13.81353244-6.31451497-4.59722903-10.92266667-8.34127645-13.8244551-11.21029689-7.46624948-6.3363603-18.85859082-17.27965867-34.0908563-32.81047705-15.27474252-15.54174103-30.63443911-33.09810725-46.20773453-52.66181689-15.53081837-19.57341867-29.1841517-39.71238875-41.00247703-60.43754192-11.7758483-20.71423052-17.66437925-39.71238875-17.66437925-56.98112474 0-17.25902697 6.31451497-36.97079941 18.98723555-59.12560829s27.90377245-43.88242015 45.73927348-65.18404741 36.56544711-41.0133997 56.10609778-59.13653097c19.58434133-18.1328403 35.96834133-31.80801897 49.23695407-41.00247703 5.16278045-3.45641718 12.20304592-7.62644859 21.11958282-12.52223052s16.85367467-7.33881837 23.76529541-7.33881837c15.53081837 0 25.60030341 4.32052148 30.2084551 12.94942814s6.91162075 19.28578845 6.91162074 31.93545008v1.72820859z m0 0"
              fill="''' + getColor(0, color, colors, '#F2482B') + '''"
            />
          </svg>
        ''';
        break;

    }

    return SvgPicture.string(svgXml, width: this.size, height: this.size);
  }
}
