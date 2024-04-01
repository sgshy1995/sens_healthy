import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter/services.dart';
import '../../controllers/global_controller.dart';
import '../../controllers/user_controller.dart';
import '../../providers/api/pain_client_provider.dart';
import '../../models/data_model.dart';
import '../../models/pain_model.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';
import 'package:wechat_camera_picker/wechat_camera_picker.dart';
import 'package:uuid/uuid.dart';
import '../../../components/gallery_photo_view_wrapper.dart';
import '../../../components/gallery_photo_view_item.dart';
import '../../../iconfont/icon_font.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../components/toast.dart';
import '../../../components/loading.dart';

class MyAssetPickerTextDelegate extends AssetPickerTextDelegate {
  @override
  String get languageCode => 'zh'; // 强制修改语言代码为汉语
}

class PainCommentSheetPage extends StatefulWidget {
  final String questionId;
  final String replyOrCommentCotent;
  final String replyId;
  final String commentToUserId;
  final String? commentId;
  const PainCommentSheetPage({
    super.key,
    required this.questionId,
    required this.replyOrCommentCotent,
    required this.replyId,
    required this.commentToUserId,
    this.commentId,
  });

  @override
  State<PainCommentSheetPage> createState() => _PainCommentSheetPageState();
}

class _PainCommentSheetPageState extends State<PainCommentSheetPage> {
  final PainClientProvider painClientProvider =
      GetInstance().find<PainClientProvider>();
  final GlobalController globalController =
      GetInstance().find<GlobalController>();
  final UserController userController = GetInstance().find<UserController>();

  bool publishCheck = false;
  String? painCommentValue;
  bool inputEnabled = true;
  List<AssetEntity> imageDataList = [];
  List<GalleryExampleItem> galleryItems = [];
  List<PainFileUploadTypeModel> finalImagesList = [];

  bool _uploading = false;
  final TextEditingController _textController = TextEditingController();

  void changeReplyContent(String? value) {
    setState(() {
      painCommentValue = value;
    });
    checkIfCanPublish();
  }

  void handleChooseImages() async {
    setState(() {
      inputEnabled = false;
    });
    Get.back();

    final List<AssetEntity>? resultGet = await AssetPicker.pickAssets(
      context,
      pickerConfig: AssetPickerConfig(
          textDelegate: MyAssetPickerTextDelegate(),
          requestType: RequestType.image,
          themeColor: const Color.fromRGBO(211, 66, 67, 1),
          maxAssets: 9 - imageDataList.length),
    );

    setState(() {
      inputEnabled = true;
    });

    if (resultGet != null) {
      setState(() {
        publishCheck = false;
      });

      Future.delayed(const Duration(milliseconds: 500), () async {
        setState(() {
          imageDataList.addAll(resultGet);
          _uploading = true;
        });

        List<PainFileUploadTypeModel> finalImagesListGet = [];
        await Future.forEach(resultGet, (assetEntity) async {
          // 在此处处理异步操作，例如网络请求、文件读写等
          final String uuidGet = const Uuid().v4();
          final String id = '${assetEntity.id}-$uuidGet';
          final mimeType = await assetEntity.mimeTypeAsync;
          final fileType = mimeType != null ? mimeType.split('/')[1] : 'jpg';
          final filename = 'picture.$fileType';
          final file = await assetEntity.file;
          final localPath = file!.path;
          finalImagesListGet.add(PainFileUploadTypeModel(
              id: id,
              file: file,
              localPath: localPath,
              filename: filename,
              fileType: fileType,
              mimeType: mimeType!,
              status: 0));
          // 在这里执行您的异步任务
        });

        setState(() {
          finalImagesList.addAll(finalImagesListGet);
        });

        // 同时执行多个异步任务
        final needUploadImagesList =
            finalImagesList.where((item) => item.status == 0).toList();
        final List<Future<DataFinalModel<String?>>> futures =
            needUploadImagesList.map((item) {
          return painClientProvider.painCommentImageDataUploadAction(
              item.file, item.filename);
        }).toList();

        // 等待所有异步任务完成
        final List<DataFinalModel<String?>?> results =
            await Future.wait(futures);
        bool rejectCheck = false;
        results.asMap().forEach((index, result) {
          final id = needUploadImagesList[index].id;
          final idIndexGet =
              finalImagesList.indexWhere((item) => item.id == id);
          // 注意：这里将上传失败的图片也作为违规图片处理
          if (result == null) {
            rejectCheck = false;
            setState(() {
              finalImagesList[idIndexGet].status = 2;
            });
          } else if (result.code == 200) {
            setState(() {
              finalImagesList[idIndexGet].status = 1;
              finalImagesList[idIndexGet].realKey = result.data;
            });
          } else {
            rejectCheck = false;
            setState(() {
              finalImagesList[idIndexGet].status = 2;
            });
          }
        });

        List<GalleryExampleItem> galleryItemsGet = [];

        finalImagesList.asMap().forEach((index, item) {
          print('实际添加的url');
          print(item.status == 1
              ? '${globalController.cdnBaseUrl}/${item.realKey!}'
              : item.localPath);
          galleryItemsGet.add(GalleryExampleItem(
              id: item.id,
              resource: item.status == 1
                  ? '${globalController.cdnBaseUrl}/${item.realKey!}'
                  : item.localPath,
              isSvg: false,
              canBeDownloaded: false,
              imageType: item.status == 1 ? 'network' : 'local'));
        });

        setState(() {
          galleryItems = [...galleryItemsGet];
          _uploading = false;
        });

        if (rejectCheck) {
          showToast('您的图片包含敏感内容或违反相关法律法规，请重新上传');
        }

        checkIfCanPublish();
      });
    }
  }

  void handleDeleteIndexImage(int index) {
    setState(() {
      imageDataList.removeAt(index);
      galleryItems.removeAt(index);
      finalImagesList.removeAt(index);
    });
  }

  //销毁前，删除不必要的图片
  void beforeDisposeRemoveUnnecessaryImages(
      List<PainFileUploadTypeModel> finalImagesListGet) {
    final List<PainFileUploadTypeModel> listGet =
        finalImagesListGet.where((item) => item.status == 1).toList();
    final List<String> idsGet = listGet.map((item) => item.realKey!).toList();
    painClientProvider.removeUnnecessaryImagesAction(idsGet);
  }

  void handleUseCamera() async {
    Get.back();
  }

  void handleGoBack() {
    Get.back();
  }

  void checkIfCanPublish() {
    bool publishCheckGet = true;
    //上传列表有未上传或违规的文件
    if (finalImagesList.isNotEmpty &&
        finalImagesList.where((item) => item.status != 1).isNotEmpty) {
      publishCheckGet = false;
    }

    //评论内容是否填写
    if (painCommentValue == null || painCommentValue!.isEmpty) {
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

    final String imageDataString = finalImagesList.isNotEmpty
        ? finalImagesList.map((item) => item.realKey).toList().join(',')
        : '';

    Map<String, dynamic> form = {
      'question_id': widget.questionId,
      'reply_id': widget.replyId,
      'comment_id': widget.commentId,
      'comment_to_user_id': widget.commentToUserId,
      'comment_content': painCommentValue,
      'image_data': imageDataString
    };

    if (imageDataString.isEmpty) {
      form.remove('image_data');
    }

    if (widget.commentId == null || widget.commentId!.isEmpty) {
      form.remove('comment_id');
    }

    showLoading('发布中...');

    painClientProvider.painCommentCreateAction(form).then((value) {
      print('code');
      print(value.code);
      if (value.code == 200) {
        setState(() {
          imageDataList = [];
          galleryItems = [];
          finalImagesList = [];
        });
        hideLoading();
        Get.back<String>(result: 'success');
      } else if (value.code == 403) {
        hideLoading();
        showToast('您的内容可能包含违规或敏感词汇，或不符合社区规定，请修改后重试');
      } else {
        hideLoading();
        showToast('请求错误，请稍后再试');
      }
    }).catchError((e) {
      hideLoading();
      showToast('请求错误，请稍后再试');
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    beforeDisposeRemoveUnnecessaryImages(finalImagesList);
    // TODO: implement dispose
    super.dispose();
    _textController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final EdgeInsets mediaQuerySafeInfo = MediaQuery.of(context).padding;
    final Size mediaQuerySizeInfo = MediaQuery.of(context).size;
    final double itemWidthAndHeight =
        (mediaQuerySizeInfo.width - 16 - 16 - 8 - 8 - 8 - 8) / 5;

    void handleShowPicturesOrCanmera() {
      if (_uploading || imageDataList.length >= 9) {
        return;
      }

      setState(() {
        inputEnabled = false;
      });

      showModalBottomSheet(
          backgroundColor: const Color.fromRGBO(255, 255, 255, 1),
          isScrollControlled: true,
          context: context,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              top: Radius.zero, // 设置顶部边缘为直角
            ),
          ),
          builder: (BuildContext context) {
            return SingleChildScrollView(
                child: Padding(
                    padding: EdgeInsets.fromLTRB(
                        24, 0, 24, mediaQuerySafeInfo.bottom),
                    child: Column(
                      children: [
                        InkWell(
                          onTap: handleChooseImages,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                width: 24,
                                height: 24,
                                margin: const EdgeInsets.only(right: 12),
                                child: Center(
                                  child: IconFont(
                                    IconNames.tupian,
                                    size: 24,
                                    color: '#000',
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 56,
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text('从相册选择照片',
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold)),
                                ),
                              )
                            ],
                          ),
                        ),
                        const Divider(
                          height: 2,
                          color: Color.fromRGBO(200, 200, 200, 1),
                        ),
                        InkWell(
                          onTap: handleUseCamera,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                width: 24,
                                height: 24,
                                margin: const EdgeInsets.only(right: 12),
                                child: Center(
                                  child: IconFont(
                                    IconNames.xiangji,
                                    size: 24,
                                    color: '#000',
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 56,
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text('拍照',
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold)),
                                ),
                              )
                            ],
                          ),
                        ),
                        const Divider(
                          height: 2,
                          color: Color.fromRGBO(200, 200, 200, 1),
                        ),
                        InkWell(
                          onTap: handleGoBack,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                width: 24,
                                height: 24,
                                margin: const EdgeInsets.only(right: 12),
                                child: Center(
                                  child: IconFont(
                                    IconNames.guanbi,
                                    size: 20,
                                    color: '#000',
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 56,
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text('取消',
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold)),
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    ) // Your form widget here
                    ));
          }).then((value) {
        setState(() {
          inputEnabled = true;
        });
      });
    }

    void open(BuildContext context, final int index) {
      Navigator.push(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              GalleryPhotoViewWrapper(
            galleryItems: galleryItems,
            backgroundDecoration: const BoxDecoration(
              color: Colors.black,
            ),
            initialIndex: index,
            scrollDirection: Axis.horizontal,
          ),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
          transitionDuration: const Duration(milliseconds: 200),
        ),
      );
    }

    return GestureDetector(
      child: Container(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RichText(
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.left,
                text: TextSpan(
                  children: [
                    const TextSpan(
                      text: '对',
                      style: TextStyle(
                          color: Color.fromRGBO(102, 102, 102, 1),
                          fontSize: 15,
                          fontWeight: FontWeight.normal),
                    ),
                    TextSpan(
                      text:
                          ' "${widget.replyOrCommentCotent.length > 6 ? ('${widget.replyOrCommentCotent.substring(0, 6)}...') : widget.replyOrCommentCotent}" ',
                      style: const TextStyle(
                          color: Color.fromRGBO(0, 0, 0, 1),
                          fontSize: 15,
                          fontWeight: FontWeight.bold),
                    ),
                    const TextSpan(
                      text: '发表评论：',
                      style: TextStyle(
                          color: Color.fromRGBO(102, 102, 102, 1),
                          fontSize: 15,
                          fontWeight: FontWeight.normal),
                    )
                  ],
                )),
            const SizedBox(
              height: 12,
            ),
            Row(
              children: [
                Expanded(
                    child: TextField(
                  autofocus: true, // 设置为 true，使 TextField 自动获取焦点
                  enabled: inputEnabled,
                  controller: _textController,
                  maxLines: 6,
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
                    hintText: '请输入您的解答或建议...',
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 12.0, horizontal: 12.0), // 增加垂直内边距来增加高度
                  ),
                  keyboardType: TextInputType.text,
                  inputFormatters: [LengthLimitingTextInputFormatter(200)],
                  onChanged: changeReplyContent,
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
                                '评论',
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
                              '评论',
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
            ((finalImagesList.isNotEmpty)
                ? GridView.builder(
                    gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                        // 交叉轴子项数量
                        mainAxisSpacing: 8, // 主轴间距
                        crossAxisSpacing: 8, // 交叉轴间距
                        childAspectRatio: 1,
                        mainAxisExtent: itemWidthAndHeight,
                        maxCrossAxisExtent: itemWidthAndHeight),
                    physics: const NeverScrollableScrollPhysics(),
                    padding: EdgeInsets.zero, // 设置为零边距
                    shrinkWrap: true,
                    itemCount: finalImagesList.length,
                    itemBuilder: (BuildContext context, int index) {
                      return GestureDetector(
                        onTap: () => open(context, index),
                        child: Hero(
                          tag: finalImagesList[index].id,
                          child: galleryItems.length <= index
                              ? Container(
                                  decoration: BoxDecoration(
                                      color: const Color.fromRGBO(
                                          229, 229, 229, 1),
                                      border: Border.all(
                                          color: const Color.fromRGBO(
                                              229, 229, 229, 1),
                                          width: 2)),
                                  child: const Center(
                                    child: SizedBox(
                                      width: 24,
                                      height: 24,
                                      child: CircularProgressIndicator(
                                          color: Color.fromRGBO(0, 0, 0, 1),
                                          strokeWidth: 2),
                                    ),
                                  ),
                                )
                              : galleryItems[index].imageType == 'network'
                                  ? Container(
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          border: Border.all(
                                              color: const Color.fromRGBO(
                                                  255, 255, 255, 1),
                                              width: 2)),
                                      child: Stack(
                                        fit: StackFit.expand,
                                        children: [
                                          CachedNetworkImage(
                                            imageUrl:
                                                galleryItems[index].resource,
                                            fit: BoxFit.cover,
                                          ),
                                          Positioned(
                                              top: 6,
                                              right: 6,
                                              child: Container(
                                                width: 24,
                                                height: 24,
                                                decoration: const BoxDecoration(
                                                    color: Color.fromRGBO(
                                                        0, 0, 0, 0.7),
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                4))),
                                                child: GestureDetector(
                                                  onTap: () =>
                                                      handleDeleteIndexImage(
                                                          index),
                                                  child: Center(
                                                    child: IconFont(
                                                      IconNames.guanbi,
                                                      size: 12,
                                                      color: '#fff',
                                                    ),
                                                  ),
                                                ),
                                              ))
                                        ],
                                      ),
                                    )
                                  : Container(
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          border: Border.all(
                                              color: const Color.fromRGBO(
                                                  208, 64, 55, 1),
                                              width: 2)),
                                      child: Stack(
                                        fit: StackFit.expand,
                                        children: [
                                          Image.asset(
                                            galleryItems[index].resource,
                                            fit: BoxFit.cover,
                                          ),
                                          Positioned(
                                              top: 6,
                                              right: 6,
                                              child: Container(
                                                width: 24,
                                                height: 24,
                                                decoration: const BoxDecoration(
                                                    color: Color.fromRGBO(
                                                        208, 64, 55, 1),
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                4))),
                                                child: GestureDetector(
                                                  onTap: () =>
                                                      handleDeleteIndexImage(
                                                          index),
                                                  child: Center(
                                                    child: IconFont(
                                                      IconNames.guanbi,
                                                      size: 12,
                                                      color: '#fff',
                                                    ),
                                                  ),
                                                ),
                                              ))
                                        ],
                                      ),
                                    ),
                        ),
                      );
                    })
                : const SizedBox.shrink()),
            (finalImagesList.isNotEmpty
                ? const SizedBox(
                    height: 12,
                  )
                : const SizedBox.shrink()),
            SizedBox(
              width: 28,
              height: 28,
              child: _uploading
                  ? Center(
                      child: IconFont(
                        IconNames.tupian,
                        size: 28,
                        color: 'rgb(221,221,221)',
                      ),
                    )
                  : imageDataList.length < 9
                      ? InkWell(
                          onTap: handleShowPicturesOrCanmera,
                          child: Center(
                            child: IconFont(
                              IconNames.tupian,
                              size: 28,
                              color: '#000',
                            ),
                          ),
                        )
                      : const SizedBox.shrink(),
            ),
            const SizedBox(
              height: 12,
            ),
            const Text('为了您的回答更具权威性，建议上传相关影像资料',
                style: TextStyle(color: Colors.black26, fontSize: 14))
          ],
        ),
      ),
    );
  }
}
