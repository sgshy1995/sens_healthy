import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../app/pages/pain/pain.dart';
import '../app/pages/recovery/recovery.dart';
import '../app/pages/store/store.dart';
import '../app/pages/mine/mine.dart';
import '../components/keepAliveWrapper.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    RxInt currentIndex = 0.obs;
    const List<Widget> pages = [
      KeepAliveWrapper(child: PainPage()),
      KeepAliveWrapper(child: RecoveryPage()),
      KeepAliveWrapper(child: StorePage()),
      KeepAliveWrapper(child: MinePage())
    ];
    return Obx(() => Scaffold(
          bottomNavigationBar: BottomNavigationBar(
            fixedColor: Colors.red, //选中的颜色
            type: BottomNavigationBarType.fixed, //如果底部有4个或者4个以上的菜单的时候就需要配置这个参数
            currentIndex: currentIndex.value,
            onTap: (v) {
              print('ontap$v');
              currentIndex.value = v;
            },
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.home), label: "首页"),
              BottomNavigationBarItem(icon: Icon(Icons.home), label: "康复"),
              BottomNavigationBarItem(icon: Icon(Icons.home), label: "商城"),
              BottomNavigationBarItem(icon: Icon(Icons.home), label: "我的")
            ],
          ),
          body: pages[currentIndex.value],
        ));
  }
}
