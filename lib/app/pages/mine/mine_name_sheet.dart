import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter/services.dart';
import '../../controllers/global_controller.dart';
import '../../controllers/user_controller.dart';
import '../../providers/api/user_client_provider.dart';
import 'package:uuid/uuid.dart';
import '../../../iconfont/icon_font.dart';
import '../../../components/toast.dart';
import '../../../components/loading.dart';

class MineNameSheetPage extends StatefulWidget {
  const MineNameSheetPage({super.key});

  @override
  State<MineNameSheetPage> createState() => _MineNameSheetPageState();
}

class _MineNameSheetPageState extends State<MineNameSheetPage> {
  final UserClientProvider userClientProvider = Get.put(UserClientProvider());
  final GlobalController globalController = Get.put(GlobalController());
  final UserController userController = Get.put(UserController());

  bool publishCheck = false;
  String? nameValue;

  final TextEditingController _textController = TextEditingController();

  void changeNameContent(String? value) {
    setState(() {
      nameValue = value;
    });
    checkIfCanPublish();
  }

  void handleGoBack() {
    Get.back();
  }

  void checkIfCanPublish() {
    bool publishCheckGet = true;

    //昵称是否填写
    if (nameValue == null || nameValue!.isEmpty) {
      publishCheckGet = false;
    }

    if (publishCheck != publishCheckGet) {
      setState(() {
        publishCheck = publishCheckGet;
      });
    }
  }

  void handlePublish() {
    if (!publishCheck) {
      return;
    }

    showLoading('请稍后...');

    userClientProvider.updateUserByJwtAction({'name': nameValue}).then((value) {
      if (value.code == 200) {
        userClientProvider.getUserInfoByJWTAction().then((resultIn) {
          if (resultIn.code == 200 && resultIn.data != null) {
            userController.setUserInfo(resultIn.data!);
            hideLoading();
            Get.back();
          } else {
            hideLoading();
            showToast('获取用户信息失败');
          }
        }).catchError((e1) {
          hideLoading();
          showToast('操作失败, 请稍后再试');
        });
      } else if (value.code == 403) {
        hideLoading();
        showToast('您的昵称可能包含违规或敏感词汇，或不符合社区规定，请修改后重试');
      } else {
        hideLoading();
        showToast('请求错误，请稍后再试');
      }
    }).catchError((e) {
      hideLoading();
      showToast('请求错误，请稍后再试');
    });
  }

  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    nameValue = userController.userInfo.name;
    if (userController.userInfo.name != null) {
      _textController.text = userController.userInfo.name!;
    }
    checkIfCanPublish();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final EdgeInsets mediaQuerySafeInfo = MediaQuery.of(context).padding;
    final Size mediaQuerySizeInfo = MediaQuery.of(context).size;
    final double itemWidthAndHeight =
        (mediaQuerySizeInfo.width - 16 - 16 - 8 - 8 - 8 - 8) / 5;

    return GestureDetector(
      child: Container(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                    child: TextField(
                  autofocus: true, // 设置为 true，使 TextField 自动获取焦点
                  focusNode: _focusNode,
                  onTapOutside: (PointerDownEvent p) {
                    // 点击外部区域时取消焦点
                    _focusNode.unfocus();
                  },
                  controller: _textController,
                  maxLines: 1,
                  textAlignVertical: TextAlignVertical.center,
                  style: const TextStyle(
                    fontSize: 15, // 设置字体大小为20像素
                  ),
                  decoration: InputDecoration(
                    hintStyle: TextStyle(
                        color: Theme.of(context).hintColor, fontSize: 15),
                    fillColor: const Color.fromRGBO(250, 250, 250, 1),
                    filled: true, // 使用图标
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.black26),
                      borderRadius: BorderRadius.circular(4), // 设置圆角大小
                    ),
                    border: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.black26),
                      borderRadius: BorderRadius.circular(10), // 设置圆角大小
                    ),
                    focusedBorder: OutlineInputBorder(
                      // 聚焦状态下边框样式
                      borderSide: const BorderSide(color: Colors.black26),
                      borderRadius: BorderRadius.circular(4), // 设置圆角大小
                    ),
                    hintText: '请输入您想要设置的昵称',
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 12.0, horizontal: 12.0), // 增加垂直内边距来增加高度
                  ),
                  keyboardType: TextInputType.text,
                  inputFormatters: [LengthLimitingTextInputFormatter(8)],
                  onChanged: changeNameContent,
                )),
                Padding(
                  padding: const EdgeInsets.only(left: 18),
                  child: publishCheck
                      ? InkWell(
                          onTap: handlePublish,
                          child: const SizedBox(
                            width: 36,
                            height: 24,
                            child: Center(
                              child: Text(
                                '确定',
                                style: TextStyle(
                                    color: Color.fromRGBO(211, 66, 67, 1),
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        )
                      : const SizedBox(
                          width: 36,
                          height: 24,
                          child: Center(
                            child: Text(
                              '确定',
                              style: TextStyle(
                                  color: Color.fromRGBO(211, 66, 67, 0.3),
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                )
              ],
            ),
            const SizedBox(
              height: 12,
            ),
            const Text('您需要确保昵称/姓名合法合规',
                style: TextStyle(color: Colors.black26, fontSize: 14))
          ],
        ),
      ),
    );
  }
}
