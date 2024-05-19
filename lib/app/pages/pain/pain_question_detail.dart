import 'package:carousel_slider/carousel_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';
import './pain_reply_sheet.dart';
import './pain_comment_sheet.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_typedefs/rx_typedefs.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:sens_healthy/app/models/data_model.dart';
import 'package:sens_healthy/components/toast.dart';
import '../../../iconfont/icon_font.dart';
import '../../providers/api/pain_client_provider.dart';
import '../../models/pain_model.dart';
import 'package:carousel_slider/carousel_slider.dart';
import '../../controllers/global_controller.dart';
import '../../controllers/user_controller.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';
import '../../../components/gallery_photo_view_wrapper.dart';
import '../../../components/gallery_photo_view_item.dart';
import 'dart:async';
import 'package:shimmer/shimmer.dart';
import '../../controllers/notification_controller.dart';
import '../../providers/api/notification_client_provider.dart';

class CustomScrollPhysics extends ScrollPhysics {
  const CustomScrollPhysics({ScrollPhysics? parent}) : super(parent: parent);

  @override
  CustomScrollPhysics applyTo(ScrollPhysics? ancestor) {
    return CustomScrollPhysics(parent: buildParent(ancestor));
  }

  @override
  Simulation? createBallisticSimulation(
      ScrollMetrics position, double velocity) {
    // 如果已经滚动到底部，禁止底部回弹
    if (position.extentAfter == 0.0 && velocity > 0.0) {
      return super.createBallisticSimulation(position, 0.0);
    }
    return super.createBallisticSimulation(position, velocity);
  }
}

class PainQuestionDetailPage extends StatefulWidget {
  const PainQuestionDetailPage({super.key});

  @override
  State<PainQuestionDetailPage> createState() => _PainQuestionDetailPageState();
}

class _PainQuestionDetailPageState extends State<PainQuestionDetailPage> {
  final PainClientProvider painClientProvider = Get.put(PainClientProvider());
  final NotificationClientProvider notificationClientProvider =
      Get.put(NotificationClientProvider());

  final GlobalController globalController = Get.put(GlobalController());
  final UserController userController = Get.put(UserController());
  final NotificationController notificationController =
      Get.put(NotificationController());

  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  final GlobalKey _replyTitleKey = GlobalKey();

  bool _readyLoad = false;
  bool _readyLoadReply = false;

  String dataId = '';

  String painNotificationId = '';

  PainQuestionTypeModel painQuestionDetail = PainQuestionTypeModel(
      id: '',
      user_id: '',
      avatar: null,
      name: null,
      has_major: 0,
      pain_type: '',
      description: '',
      injury_history: '',
      question_time: '',
      like_num: 0,
      like_user_ids: null,
      reply_num: 0,
      collect_num: 0,
      collect_user_ids: null,
      anonymity: 0,
      image_data: null,
      location: null,
      status: 0,
      created_at: '',
      updated_at: '');

  int _currentPageNo = 1;
  DataPaginationInModel<List<PainReplyTypeModel>> painReplyDataPagination =
      DataPaginationInModel(
          data: [], pageNo: 1, pageSize: 10, totalPage: 0, totalCount: 0);

  void handleGoBack() {
    Get.back();
  }

  void _onLoading() async {
    // monitor network fetch
    String result;
    try {
      result = await getPainReplies();
      print('最终的加载结果是: $result');
      if (result == 'success') {
        _refreshController.loadComplete();
      } else {
        _refreshController.loadNoData();
      }
    } catch (e) {
      _refreshController.loadFailed();
    }
  }

  Future<String?> checkUserId() async {
    Completer<String?> completer = Completer();
    if (userController.userInfo.id.isEmpty) {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? userId = prefs.getString('user_id');
      if (userId != null) {
        completer.complete(userId);
      } else {
        completer.completeError('error');
      }
    } else {
      completer.complete(userController.userInfo.id);
    }
    return completer.future;
  }

  void getDetailData() async {
    if (painNotificationId.isNotEmpty) {
      await notificationClientProvider
          .readOnePainNotificationByIdAction(painNotificationId);
      final String? userId = await checkUserId();
      final int? painNotificationsNum =
          await loadPainNotificationCounts(userId!);
      if (painNotificationsNum != null) {
        notificationController.setPainNotiicationNum(painNotificationsNum);
      }
    }
    painClientProvider.getQuestionByIdAction(dataId).then((result) {
      if (result.code == 200) {
        final painQuestionNew = result.data!;
        setState(() {
          painQuestionDetail = painQuestionNew;

          getPainReplies(page: 1);
        });
      }
    });
  }

  /* 点赞、收藏 状态 */
  bool _likeLoading = false;
  bool _collectLoading = false;

  /* 点赞方法 */
  void handleClickLike() {
    if (_likeLoading || _collectLoading) {
      return;
    }
    final List<String> likeIdsList = painQuestionDetail.like_user_ids != null
        ? painQuestionDetail.like_user_ids!.split(',').toSet().toList()
        : [];
    updatePainQuestionLike(painQuestionDetail.id,
        likeIdsList.contains(userController.userInfo.id) ? 0 : 1);
  }

  void updatePainQuestionLike(String id, int status) {
    setState(() {
      _likeLoading = true;
    });
    painClientProvider.updateQuestionLikeAction(id, status).then((result) {
      if (result.code == 200) {
        painClientProvider.getQuestionByIdAction(id).then((result1) {
          if (result1.code == 200) {
            final painQuestionNew = result1.data!;
            setState(() {
              painQuestionDetail = painQuestionNew;
              showToast(status == 1 ? '已点赞' : '已取消点赞');
              Future.delayed(const Duration(seconds: 2), () {
                setState(() {
                  _likeLoading = false;
                });
              });
            });
          } else {
            showToast(result1.message);
            Future.delayed(const Duration(seconds: 2), () {
              setState(() {
                _likeLoading = false;
              });
            });
          }
        }).catchError((e1) {
          showToast('操作失败，请稍后再试');
          Future.delayed(const Duration(seconds: 2), () {
            setState(() {
              _likeLoading = false;
            });
          });
        });
      } else {
        showToast(result.message);
        Future.delayed(const Duration(seconds: 2), () {
          setState(() {
            _likeLoading = false;
          });
        });
      }
    }).catchError((e) {
      showToast('操作失败，请稍后再试');
      Future.delayed(const Duration(seconds: 2), () {
        setState(() {
          _likeLoading = false;
        });
      });
    });
  }

  /* 答复点赞方法 */
  void handleClickLikeReply(PainReplyTypeModel dataItemReply) {
    if (_likeLoading || _collectLoading) {
      return;
    }
    final List<String> likeIdsListReply = dataItemReply.like_user_ids != null
        ? dataItemReply.like_user_ids!.split(',').toSet().toList()
        : [];
    updatePainReplyLike(
        dataItemReply.id,
        likeIdsListReply.contains(userController.userInfo.id) ? 0 : 1,
        painReplyDataPagination.pageNo);
  }

  void updatePainReplyLike(String id, int status, int pageNo) {
    setState(() {
      _likeLoading = true;
    });
    painClientProvider.updateReplyLikeAction(id, status, pageNo).then((result) {
      if (result.code == 200) {
        painClientProvider.getReplyByIdAction(id).then((result1) {
          if (result1.code == 200) {
            final painReplyNew = result1.data!;
            final index = painReplyDataPagination.data
                .indexWhere((item) => item.id == id);
            painReplyNew.expand_num =
                painReplyDataPagination.data[index].expand_num;
            setState(() {
              painReplyDataPagination.data[index] = painReplyNew;
              showToast(status == 1 ? '已点赞' : '已取消点赞');
              Future.delayed(const Duration(seconds: 2), () {
                setState(() {
                  _likeLoading = false;
                });
              });
            });
          } else {
            showToast(result1.message);
            Future.delayed(const Duration(seconds: 2), () {
              setState(() {
                _likeLoading = false;
              });
            });
          }
        }).catchError((e1) {
          showToast('操作失败，请稍后再试');
          Future.delayed(const Duration(seconds: 2), () {
            setState(() {
              _likeLoading = false;
            });
          });
        });
      } else {
        showToast(result.message);
        Future.delayed(const Duration(seconds: 2), () {
          setState(() {
            _likeLoading = false;
          });
        });
      }
    }).catchError((e) {
      showToast('操作失败，请稍后再试');
      Future.delayed(const Duration(seconds: 2), () {
        setState(() {
          _likeLoading = false;
        });
      });
    });
  }

  /* 评论点赞方法 */
  void handleClickCommentReply(
      PainReplyTypeModel dataItemReply, PainCommentTypeModel dataItemComment) {
    if (_likeLoading || _collectLoading) {
      return;
    }
    final List<String> likeIdsListComment =
        dataItemComment.like_user_ids != null
            ? dataItemComment.like_user_ids!.split(',').toSet().toList()
            : [];
    updatePainCommentLike(
        dataItemComment.id,
        likeIdsListComment.contains(userController.userInfo.id) ? 0 : 1,
        painReplyDataPagination.pageNo,
        dataItemReply.id);
  }

  void updatePainCommentLike(
      String id, int status, int pageNo, String replyId) {
    setState(() {
      _likeLoading = true;
    });
    painClientProvider
        .updateCommentLikeAction(id, status, pageNo)
        .then((result) {
      if (result.code == 200) {
        painClientProvider.getCommentByIdAction(id).then((result1) {
          if (result1.code == 200) {
            final painCommentNew = result1.data!;
            final index = painReplyDataPagination.data
                .indexWhere((item) => item.id == replyId);
            final indexIn = painReplyDataPagination.data[index].comments!
                .indexWhere((item) => item.id == id);
            setState(() {
              painReplyDataPagination.data[index].comments![indexIn] =
                  painCommentNew;
              showToast(status == 1 ? '已点赞' : '已取消点赞');
              Future.delayed(const Duration(seconds: 2), () {
                setState(() {
                  _likeLoading = false;
                });
              });
            });
          } else {
            showToast(result1.message);
            Future.delayed(const Duration(seconds: 2), () {
              setState(() {
                _likeLoading = false;
              });
            });
          }
        }).catchError((e1) {
          showToast('操作失败，请稍后再试');
          Future.delayed(const Duration(seconds: 2), () {
            setState(() {
              _likeLoading = false;
            });
          });
        });
      } else {
        showToast(result.message);
        Future.delayed(const Duration(seconds: 2), () {
          setState(() {
            _likeLoading = false;
          });
        });
      }
    }).catchError((e) {
      showToast('操作失败，请稍后再试');
      Future.delayed(const Duration(seconds: 2), () {
        setState(() {
          _likeLoading = false;
        });
      });
    });
  }

  /* 收藏方法 */
  void handleClickCollect() {
    if (_likeLoading || _collectLoading) {
      return;
    }
    final List<String> collectIdsList =
        painQuestionDetail.collect_user_ids != null
            ? painQuestionDetail.collect_user_ids!.split(',').toSet().toList()
            : [];
    updatePainQuestionCollect(painQuestionDetail.id,
        collectIdsList.contains(userController.userInfo.id) ? 0 : 1);
  }

  void updatePainQuestionCollect(String id, int status) {
    setState(() {
      _collectLoading = true;
    });
    painClientProvider.updateQuestionCollectAction(id, status).then((result) {
      if (result.code == 200) {
        painClientProvider.getQuestionByIdAction(id).then((result1) {
          if (result1.code == 200) {
            final painQuestionNew = result1.data!;
            setState(() {
              painQuestionDetail = painQuestionNew;
              showToast(status == 1 ? '已收藏' : '已取消收藏');
              Future.delayed(const Duration(seconds: 2), () {
                setState(() {
                  _collectLoading = false;
                });
              });
            });
          } else {
            showToast(result1.message);
            Future.delayed(const Duration(seconds: 2), () {
              setState(() {
                _collectLoading = false;
              });
            });
          }
        }).catchError((e1) {
          showToast('操作失败，请稍后再试');
          Future.delayed(const Duration(seconds: 2), () {
            setState(() {
              _collectLoading = false;
            });
          });
        });
      } else {
        showToast(result.message);
        Future.delayed(const Duration(seconds: 2), () {
          setState(() {
            _collectLoading = false;
          });
        });
      }
    }).catchError((e) {
      showToast('操作失败，请稍后再试');
      Future.delayed(const Duration(seconds: 2), () {
        setState(() {
          _collectLoading = false;
        });
      });
    });
  }

  /* 展开更多方法 */
  void handleExpandMore(PainReplyTypeModel replyItem) {
    final index = painReplyDataPagination.data
        .indexWhere((item) => item.id == replyItem.id);
    setState(() {
      painReplyDataPagination.data[index].expand_num += 5;
    });
  }

  Future<String> getPainReplies({int? page}) {
    Completer<String> completer = Completer();
    painClientProvider
        .getPainRepliesByCustomAction(
            questionId: painQuestionDetail.id,
            pageNo: page ?? _currentPageNo + 1)
        .then((value) {
      final valueGet = value.data.data;
      valueGet.map((e) {
        e.expand_num = 3;
      });
      final pageNo = value.data.pageNo;
      final pageSize = value.data.pageSize;
      final totalPage = value.data.totalPage;
      final totalCount = value.data.totalCount;
      setState(() {
        _readyLoad = true;
        _currentPageNo = pageNo;
        if (pageNo == 1) {
          painReplyDataPagination.data = valueGet;
        } else {
          painReplyDataPagination.data.addAll(valueGet);
        }
        painReplyDataPagination.pageNo = pageNo;
        painReplyDataPagination.pageSize = pageSize;
        painReplyDataPagination.totalPage = totalPage;
        painReplyDataPagination.totalCount = totalCount;
        _readyLoadReply = true;
      });
      completer.complete(pageNo == totalPage ? 'no-data' : 'success');
      if (page != null) {
        if (pageNo != totalPage) {
          _refreshController.loadComplete();
        } else {
          _refreshController.loadNoData();
        }
      }
    }).catchError((e) {
      completer.completeError(e);
    });

    return completer.future;
  }

  @override
  void initState() {
    super.initState();
    dataId = Get.arguments['questionId'];
    if (Get.arguments['painNotificationId'] != null) {
      painNotificationId = Get.arguments['painNotificationId'];
    }
    getDetailData();
  }

  @override
  void dispose() {
    super.dispose();
    _refreshController.dispose();
  }

  String getShowTime(String time) {
    // 获取当前时间
    DateTime nowTime = DateTime.now();
    // 格式化日期
    String formattedDate = DateFormat('yyyy-MM-dd').format(nowTime);
    String formattedYearDate = DateFormat('yyyy').format(nowTime);
    // 获取解析的时间
    DateTime parsedTime = DateTime.parse(time);
    // 格式化日期
    String formattedDateQuestion = DateFormat('yyyy-MM-dd').format(parsedTime);
    String formattedYearDateQuestion = DateFormat('yyyy').format(parsedTime);
    final String showTime;
    if (formattedDate == formattedDateQuestion) {
      String formattedMinutesDateQuestion =
          DateFormat('HH:mm').format(parsedTime);
      showTime = '$formattedMinutesDateQuestion 今天';
    } else if (formattedYearDate == formattedYearDateQuestion) {
      String formattedMonthsAndMinutesDateQuestion =
          DateFormat('HH:mm MM/dd').format(parsedTime);
      showTime = formattedMonthsAndMinutesDateQuestion;
    } else {
      String formattedYearsAndMonthsAndMinutesDateQuestion =
          DateFormat('HH:mm yy/MM/dd').format(parsedTime);
      showTime = formattedYearsAndMonthsAndMinutesDateQuestion;
    }
    return showTime;
  }

  Future<int?> loadPainNotificationCounts(String userId) {
    Completer<int?> completer = Completer();
    notificationClientProvider
        .findManyPainNotifications(userId: userId, read: 0)
        .then((result) {
      completer.complete(result.data.totalCount);
    }).catchError((e) {
      completer.completeError(e);
    });
    return completer.future;
  }

  @override
  Widget build(BuildContext context) {
    final EdgeInsets mediaQuerySafeInfo = MediaQuery.of(context).padding;
    final Size mediaQuerySizeInfo = MediaQuery.of(context).size;

    final String name = painQuestionDetail.anonymity == 1
        ? '匿名用户'
        : painQuestionDetail.name != null
            ? painQuestionDetail.name!
            : '赴康云用户';

    String showQuestionTime = '';

    if (_readyLoad) {
      showQuestionTime = getShowTime(painQuestionDetail.question_time);
    }

    final String painType = painQuestionDetail.pain_type;
    final String description = painQuestionDetail.description;
    final String location = painQuestionDetail.location ?? '未知地点';
    final String injuryHistory = painQuestionDetail.injury_history;

    List<String> imagesList = [];
    if (painQuestionDetail.image_data != null) {
      imagesList = painQuestionDetail.image_data!.split(',').toSet().toList();
    }
    final List<GalleryExampleItem> galleryItems = imagesList.map((e) {
      return GalleryExampleItem(
          id: '$e-detail',
          resource: '${globalController.cdnBaseUrl}/$e',
          isSvg: false);
    }).toList();

    final double itemWidthOnly = mediaQuerySizeInfo.width - 24;

    final List<String> likeIdsList = painQuestionDetail.like_user_ids != null
        ? painQuestionDetail.like_user_ids!.split(',').toSet().toList()
        : [];
    final bool readyLike = likeIdsList.contains(userController.userInfo.id);

    final List<String> collectIdsList =
        painQuestionDetail.collect_user_ids != null
            ? painQuestionDetail.collect_user_ids!.split(',').toSet().toList()
            : [];
    final bool readyCollect =
        collectIdsList.contains(userController.userInfo.id);

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

    void handleReportItem() {
      Get.back();
    }

    void handleCancelItem() {
      Get.back();
    }

    void handleShare() {
      if (!_readyLoad) {
        return;
      }
    }

    void scrollToReplyTitle() {
      // 滚动至指定元素位置
      final RenderObject object =
          _replyTitleKey.currentContext!.findRenderObject()!;
      _refreshController.position!.ensureVisible(
        object,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }

    void showReplyBottomSheet() {
      scrollToReplyTitle();
      showModalBottomSheet<String?>(
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
                    padding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).viewInsets.bottom != 0
                            ? MediaQuery.of(context).viewInsets.bottom
                            : mediaQuerySafeInfo.bottom),
                    child: PainReplySheetPage(
                      questionId: painQuestionDetail.id,
                    ) // Your form widget here
                    ));
          }).then((result) {
        if (result == 'success') {
          getDetailData();
        }
      });
    }

    void showCommentBottomSheet(PainReplyTypeModel replyItem,
        {PainCommentTypeModel? commentItem}) {
      showModalBottomSheet<String?>(
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
                    padding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).viewInsets.bottom != 0
                            ? MediaQuery.of(context).viewInsets.bottom
                            : mediaQuerySafeInfo.bottom),
                    child: PainCommentSheetPage(
                        questionId: painQuestionDetail.id,
                        replyOrCommentCotent: commentItem != null
                            ? commentItem.comment_content
                            : replyItem.reply_content,
                        replyId: replyItem.id,
                        commentId: commentItem?.id,
                        commentToUserId: commentItem != null
                            ? commentItem.user_id
                            : replyItem.user_id) // Your form widget here
                    ));
          }).then((result) {
        if (result == 'success') {
          painClientProvider.getReplyByIdAction(replyItem.id).then((result1) {
            if (result1.code == 200) {
              final painReplyNew = result1.data!;
              final index = painReplyDataPagination.data
                  .indexWhere((item) => item.id == replyItem.id);
              painReplyNew.expand_num =
                  painReplyDataPagination.data[index].expand_num + 1;
              setState(() {
                painReplyDataPagination.data[index] = painReplyNew;
              });
            } else {
              showToast(result1.message);
            }
          }).catchError((e1) {
            showToast('操作失败，请稍后再试');
          });
        }
      });
    }

    void showMoreItems() {
      if (!_readyLoad) {
        return;
      }
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
                          onTap: handleReportItem,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                width: 24,
                                height: 24,
                                margin: const EdgeInsets.only(right: 12),
                                child: Center(
                                  child: IconFont(
                                    IconNames.tanhao,
                                    size: 24,
                                    color: '#000',
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 56,
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text('举报',
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
                          onTap: handleCancelItem,
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
          });
    }

    Widget skeleton() {
      return Column(
        children: [
          const SizedBox(
            height: 12,
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 0, 12, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: const BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.all(Radius.circular(22))),
                    margin: const EdgeInsets.only(right: 12),
                    child: Shimmer.fromColors(
                      baseColor: const Color.fromRGBO(229, 229, 229, 1),
                      highlightColor: Colors.grey[100]!,
                      child: Container(
                        width: 44,
                        height: 44,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(bottom: 6),
                          child: Container(
                            width: 44,
                            height: 14,
                            decoration: const BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(6))),
                            margin: const EdgeInsets.only(right: 12),
                            child: Shimmer.fromColors(
                              baseColor: const Color.fromRGBO(229, 229, 229, 1),
                              highlightColor: Colors.grey[100]!,
                              child: Container(
                                width: 44,
                                height: 14,
                                decoration: const BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(6)),
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Container(
                          width: 60,
                          height: 14,
                          decoration: const BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(6))),
                          margin: const EdgeInsets.only(right: 12),
                          child: Shimmer.fromColors(
                            baseColor: const Color.fromRGBO(229, 229, 229, 1),
                            highlightColor: Colors.grey[100]!,
                            child: Container(
                              width: 60,
                              height: 14,
                              decoration: const BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(6)),
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ])
                ]),
                const SizedBox(
                  height: 24,
                ),
                Container(
                  width: 60,
                  height: 20,
                  decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(6))),
                  margin: const EdgeInsets.only(right: 12),
                  child: Shimmer.fromColors(
                    baseColor: const Color.fromRGBO(229, 229, 229, 1),
                    highlightColor: Colors.grey[100]!,
                    child: Container(
                      width: 60,
                      height: 14,
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(6)),
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 12,
                ),
                Container(
                  width: mediaQuerySizeInfo.width - 24,
                  height: 80,
                  decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(6))),
                  margin: const EdgeInsets.only(right: 12),
                  child: Shimmer.fromColors(
                    baseColor: const Color.fromRGBO(229, 229, 229, 1),
                    highlightColor: Colors.grey[100]!,
                    child: Container(
                      width: 60,
                      height: 14,
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(6)),
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 12,
                ),
                Container(
                  width: 60,
                  height: 20,
                  decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(6))),
                  margin: const EdgeInsets.only(right: 12),
                  child: Shimmer.fromColors(
                    baseColor: const Color.fromRGBO(229, 229, 229, 1),
                    highlightColor: Colors.grey[100]!,
                    child: Container(
                      width: 60,
                      height: 14,
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(6)),
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 12,
                ),
                Container(
                  width: mediaQuerySizeInfo.width - 24,
                  height: 80,
                  decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(6))),
                  margin: const EdgeInsets.only(right: 12),
                  child: Shimmer.fromColors(
                    baseColor: const Color.fromRGBO(229, 229, 229, 1),
                    highlightColor: Colors.grey[100]!,
                    child: Container(
                      width: 60,
                      height: 14,
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(6)),
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 12,
                ),
                Container(
                  width: 60,
                  height: 20,
                  decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(6))),
                  margin: const EdgeInsets.only(right: 12),
                  child: Shimmer.fromColors(
                    baseColor: const Color.fromRGBO(229, 229, 229, 1),
                    highlightColor: Colors.grey[100]!,
                    child: Container(
                      width: 60,
                      height: 14,
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(6)),
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 12,
                ),
                Container(
                  width: mediaQuerySizeInfo.width - 24,
                  height: 80,
                  decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(6))),
                  margin: const EdgeInsets.only(right: 12),
                  child: Shimmer.fromColors(
                    baseColor: const Color.fromRGBO(229, 229, 229, 1),
                    highlightColor: Colors.grey[100]!,
                    child: Container(
                      width: 60,
                      height: 14,
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(6)),
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 12,
                ),
                Container(
                  width: 60,
                  height: 20,
                  decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(6))),
                  margin: const EdgeInsets.only(right: 12),
                  child: Shimmer.fromColors(
                    baseColor: const Color.fromRGBO(229, 229, 229, 1),
                    highlightColor: Colors.grey[100]!,
                    child: Container(
                      width: 60,
                      height: 14,
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(6)),
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 12,
                ),
                Container(
                  width: mediaQuerySizeInfo.width - 24,
                  height: 200,
                  decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(6))),
                  margin: const EdgeInsets.only(right: 12),
                  child: Shimmer.fromColors(
                    baseColor: const Color.fromRGBO(229, 229, 229, 1),
                    highlightColor: Colors.grey[100]!,
                    child: Container(
                      width: 60,
                      height: 14,
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(6)),
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 24,
                ),
                Container(
                  width: 60,
                  height: 20,
                  decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(6))),
                  margin: const EdgeInsets.only(right: 12),
                  child: Shimmer.fromColors(
                    baseColor: const Color.fromRGBO(229, 229, 229, 1),
                    highlightColor: Colors.grey[100]!,
                    child: Container(
                      width: 60,
                      height: 14,
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(6)),
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 24,
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 12,
          ),
          Padding(
              padding: const EdgeInsets.fromLTRB(12, 0, 0, 0),
              child: SingleChildScrollView(
                physics: const NeverScrollableScrollPhysics(),
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 44,
                          height: 44,
                          decoration: const BoxDecoration(
                              color: Colors.transparent,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(22))),
                          margin: const EdgeInsets.only(right: 12),
                          child: Shimmer.fromColors(
                            baseColor: const Color.fromRGBO(229, 229, 229, 1),
                            highlightColor: Colors.grey[100]!,
                            child: Container(
                              width: 44,
                              height: 44,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              margin: const EdgeInsets.only(bottom: 6),
                              child: Container(
                                width: 44,
                                height: 14,
                                decoration: const BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(6))),
                                margin: const EdgeInsets.only(right: 12),
                                child: Shimmer.fromColors(
                                  baseColor:
                                      const Color.fromRGBO(229, 229, 229, 1),
                                  highlightColor: Colors.grey[100]!,
                                  child: Container(
                                    width: 44,
                                    height: 14,
                                    decoration: const BoxDecoration(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(6)),
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              width: 60,
                              height: 14,
                              decoration: const BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(6))),
                              margin: const EdgeInsets.only(right: 12),
                              child: Shimmer.fromColors(
                                baseColor:
                                    const Color.fromRGBO(229, 229, 229, 1),
                                highlightColor: Colors.grey[100]!,
                                child: Container(
                                  width: 60,
                                  height: 14,
                                  decoration: const BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(6)),
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              width: mediaQuerySizeInfo.width - 24 - 44 - 12,
                              height: 100,
                              decoration: const BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(6))),
                              margin: const EdgeInsets.only(top: 12),
                              child: Shimmer.fromColors(
                                baseColor:
                                    const Color.fromRGBO(229, 229, 229, 1),
                                highlightColor: Colors.grey[100]!,
                                child: Container(
                                  width: 60,
                                  height: 14,
                                  decoration: const BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(6)),
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              width: 60,
                              height: 14,
                              decoration: const BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(6))),
                              margin:
                                  const EdgeInsets.only(top: 12, bottom: 12),
                              child: Shimmer.fromColors(
                                baseColor:
                                    const Color.fromRGBO(229, 229, 229, 1),
                                highlightColor: Colors.grey[100]!,
                                child: Container(
                                  width: 60,
                                  height: 14,
                                  decoration: const BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(6)),
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                            Row(
                              children: [
                                Container(
                                  width: 32,
                                  height: 32,
                                  decoration: const BoxDecoration(
                                      color: Colors.transparent,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(16))),
                                  margin: const EdgeInsets.only(right: 12),
                                  child: Shimmer.fromColors(
                                    baseColor:
                                        const Color.fromRGBO(229, 229, 229, 1),
                                    highlightColor: Colors.grey[100]!,
                                    child: Container(
                                      width: 32,
                                      height: 32,
                                      decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  width: 130,
                                  height: 32,
                                  decoration: const BoxDecoration(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(6))),
                                  margin: const EdgeInsets.only(top: 0),
                                  child: Shimmer.fromColors(
                                    baseColor:
                                        const Color.fromRGBO(229, 229, 229, 1),
                                    highlightColor: Colors.grey[100]!,
                                    child: Container(
                                      width: 60,
                                      height: 14,
                                      decoration: const BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(6)),
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            )
                          ],
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 44,
                          height: 44,
                          decoration: const BoxDecoration(
                              color: Colors.transparent,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(22))),
                          margin: const EdgeInsets.only(right: 12),
                          child: Shimmer.fromColors(
                            baseColor: const Color.fromRGBO(229, 229, 229, 1),
                            highlightColor: Colors.grey[100]!,
                            child: Container(
                              width: 44,
                              height: 44,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              margin: const EdgeInsets.only(bottom: 6),
                              child: Container(
                                width: 44,
                                height: 14,
                                decoration: const BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(6))),
                                margin: const EdgeInsets.only(right: 12),
                                child: Shimmer.fromColors(
                                  baseColor:
                                      const Color.fromRGBO(229, 229, 229, 1),
                                  highlightColor: Colors.grey[100]!,
                                  child: Container(
                                    width: 44,
                                    height: 14,
                                    decoration: const BoxDecoration(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(6)),
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              width: 60,
                              height: 14,
                              decoration: const BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(6))),
                              margin: const EdgeInsets.only(right: 12),
                              child: Shimmer.fromColors(
                                baseColor:
                                    const Color.fromRGBO(229, 229, 229, 1),
                                highlightColor: Colors.grey[100]!,
                                child: Container(
                                  width: 60,
                                  height: 14,
                                  decoration: const BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(6)),
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              width: mediaQuerySizeInfo.width - 24 - 44 - 12,
                              height: 100,
                              decoration: const BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(6))),
                              margin: const EdgeInsets.only(top: 12),
                              child: Shimmer.fromColors(
                                baseColor:
                                    const Color.fromRGBO(229, 229, 229, 1),
                                highlightColor: Colors.grey[100]!,
                                child: Container(
                                  width: 60,
                                  height: 14,
                                  decoration: const BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(6)),
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              width: 60,
                              height: 14,
                              decoration: const BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(6))),
                              margin:
                                  const EdgeInsets.only(top: 12, bottom: 12),
                              child: Shimmer.fromColors(
                                baseColor:
                                    const Color.fromRGBO(229, 229, 229, 1),
                                highlightColor: Colors.grey[100]!,
                                child: Container(
                                  width: 60,
                                  height: 14,
                                  decoration: const BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(6)),
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                            Row(
                              children: [
                                Container(
                                  width: 32,
                                  height: 32,
                                  decoration: const BoxDecoration(
                                      color: Colors.transparent,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(16))),
                                  margin: const EdgeInsets.only(right: 12),
                                  child: Shimmer.fromColors(
                                    baseColor:
                                        const Color.fromRGBO(229, 229, 229, 1),
                                    highlightColor: Colors.grey[100]!,
                                    child: Container(
                                      width: 32,
                                      height: 32,
                                      decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  width: 130,
                                  height: 32,
                                  decoration: const BoxDecoration(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(6))),
                                  margin: const EdgeInsets.only(top: 0),
                                  child: Shimmer.fromColors(
                                    baseColor:
                                        const Color.fromRGBO(229, 229, 229, 1),
                                    highlightColor: Colors.grey[100]!,
                                    child: Container(
                                      width: 60,
                                      height: 14,
                                      decoration: const BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(6)),
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            )
                          ],
                        )
                      ],
                    )
                  ],
                ),
              ))
        ],
      );
    }

    return Scaffold(
      body: Column(
        children: [
          Container(
            padding:
                EdgeInsets.fromLTRB(12, mediaQuerySafeInfo.top + 12, 12, 12),
            child: SizedBox(
              height: 36,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      InkWell(
                        onTap: handleGoBack,
                        child: SizedBox(
                          width: 24,
                          height: 24,
                          child: Center(
                            child: IconFont(
                              IconNames.fanhui,
                              size: 24,
                              color: '#000',
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 44,
                        height: 32,
                      )
                    ],
                  ),
                  const Text('问答详情',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.bold)),
                  Row(
                    children: [
                      Container(
                        width: 24,
                        height: 24,
                        margin: const EdgeInsets.only(right: 12),
                        child: InkWell(
                          onTap: handleShare,
                          child: Center(
                            child: IconFont(
                              IconNames.fenxiang,
                              size: 24,
                              color: '#000',
                            ),
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: showMoreItems,
                        child: SizedBox(
                          width: 24,
                          height: 24,
                          child: Center(
                            child: IconFont(
                              IconNames.gengduo,
                              size: 24,
                              color: '#000',
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
          const Divider(
            height: 2,
            color: Color.fromRGBO(233, 234, 235, 1),
          ),
          _readyLoad
              ? Expanded(
                  child: Padding(
                      padding: const EdgeInsets.fromLTRB(12, 0, 12, 0),
                      child: RefreshConfiguration(
                          headerTriggerDistance: 60.0,
                          enableScrollWhenRefreshCompleted:
                              true, //这个属性不兼容PageView和TabBarView,如果你特别需要TabBarView左右滑动,你需要把它设置为true
                          child: SmartRefresher(
                              physics: const CustomScrollPhysics(), // 禁止回弹效果
                              enablePullDown: false,
                              enablePullUp: true,
                              footer: CustomFooter(
                                builder:
                                    (BuildContext context, LoadStatus? mode) {
                                  Widget? body;
                                  if (painQuestionDetail.id.isEmpty ||
                                      painQuestionDetail.reply_num == 0) {
                                    body = null;
                                  } else if (mode == LoadStatus.idle) {
                                    body = const Text(
                                      "上拉加载",
                                      style: TextStyle(
                                          color: Color.fromRGBO(73, 69, 79, 1),
                                          fontSize: 14),
                                    );
                                  } else if (mode == LoadStatus.loading) {
                                    body = const Center(
                                      child: SizedBox(
                                        width: 24,
                                        height: 24,
                                        child: CircularProgressIndicator(
                                            color:
                                                Color.fromRGBO(33, 33, 33, 1),
                                            strokeWidth: 2),
                                      ),
                                    );
                                  } else if (mode == LoadStatus.failed) {
                                    body = const Text("加载失败，请重试",
                                        style: TextStyle(
                                            color:
                                                Color.fromRGBO(73, 69, 79, 1),
                                            fontSize: 14));
                                  } else if (mode == LoadStatus.canLoading) {
                                    body = const Text("继续加载更多",
                                        style: TextStyle(
                                            color:
                                                Color.fromRGBO(73, 69, 79, 1),
                                            fontSize: 14));
                                  } else {
                                    body = const Text("没有更多内容了~",
                                        style: TextStyle(
                                            color:
                                                Color.fromRGBO(73, 69, 79, 1),
                                            fontSize: 14));
                                  }
                                  return Padding(
                                    padding: const EdgeInsets.only(
                                        top: 24, bottom: 24),
                                    child: Center(child: body),
                                  );
                                },
                              ),
                              controller: _refreshController,
                              onLoading: _onLoading,
                              child: CustomScrollView(slivers: [
                                SliverToBoxAdapter(
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 12),
                                    child: Column(
                                      children: [
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              width: 44,
                                              height: 44,
                                              margin: const EdgeInsets.only(
                                                  right: 12),
                                              child: (painQuestionDetail
                                                              .anonymity ==
                                                          1 ||
                                                      painQuestionDetail
                                                              .avatar ==
                                                          null)
                                                  ? const CircleAvatar(
                                                      radius: 22,
                                                      backgroundImage: AssetImage(
                                                          'assets/images/avatar.webp'),
                                                    )
                                                  : CircleAvatar(
                                                      radius: 22,
                                                      backgroundImage:
                                                          CachedNetworkImageProvider(
                                                              '${globalController.cdnBaseUrl}/${painQuestionDetail.avatar}'),
                                                    ),
                                            ),
                                            Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Container(
                                                  margin: const EdgeInsets.only(
                                                      bottom: 0),
                                                  child: Text(
                                                    name,
                                                    style: const TextStyle(
                                                        fontSize: 15,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        color: Color.fromRGBO(
                                                            0, 0, 0, 1)),
                                                  ),
                                                ),
                                                Row(
                                                  children: [
                                                    Text(
                                                      showQuestionTime,
                                                      style: const TextStyle(
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.normal,
                                                          color: Color.fromRGBO(
                                                              102,
                                                              102,
                                                              102,
                                                              1)),
                                                    ),
                                                    const Padding(
                                                      padding:
                                                          EdgeInsets.fromLTRB(
                                                              6, 0, 6, 0),
                                                      child: Text(
                                                        '·',
                                                        style: TextStyle(
                                                            fontSize: 14,
                                                            fontWeight:
                                                                FontWeight
                                                                    .normal,
                                                            color:
                                                                Color.fromRGBO(
                                                                    102,
                                                                    102,
                                                                    102,
                                                                    1)),
                                                      ),
                                                    ),
                                                    Text(
                                                      location,
                                                      style: const TextStyle(
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.normal,
                                                          color: Color.fromRGBO(
                                                              102,
                                                              102,
                                                              102,
                                                              1)),
                                                    ),
                                                  ],
                                                )
                                              ],
                                            )
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                SliverToBoxAdapter(
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 24),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text('伤痛类型',
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold)),
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              0, 12, 0, 12),
                                          child: Text(painType,
                                              textAlign: TextAlign.justify,
                                              style: const TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 15)),
                                        ),
                                        const Text('问题描述',
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold)),
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              0, 12, 0, 12),
                                          child: Text(description,
                                              textAlign: TextAlign.justify,
                                              style: const TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 15)),
                                        ),
                                        const Text('诊疗史',
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold)),
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              0, 12, 0, 12),
                                          child: Text(injuryHistory,
                                              textAlign: TextAlign.justify,
                                              style: const TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 15)),
                                        ),
                                        (imagesList.isNotEmpty &&
                                                imagesList[0].isNotEmpty
                                            ? const Text('影像资料',
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 15,
                                                    fontWeight:
                                                        FontWeight.bold))
                                            : const SizedBox.shrink()),
                                        Padding(
                                          padding: (imagesList.isNotEmpty &&
                                                  imagesList[0].isNotEmpty)
                                              ? const EdgeInsets.fromLTRB(
                                                  0, 12, 0, 12)
                                              : const EdgeInsets.all(0),
                                          child: (imagesList.isNotEmpty &&
                                                  imagesList[0].isNotEmpty)
                                              ? GridView.builder(
                                                  gridDelegate:
                                                      SliverGridDelegateWithMaxCrossAxisExtent(
                                                          // 交叉轴子项数量
                                                          mainAxisSpacing:
                                                              8, // 主轴间距
                                                          crossAxisSpacing:
                                                              0, // 交叉轴间距
                                                          childAspectRatio: 1,
                                                          mainAxisExtent:
                                                              itemWidthOnly /
                                                                  4 *
                                                                  3,
                                                          maxCrossAxisExtent:
                                                              itemWidthOnly),
                                                  physics:
                                                      const NeverScrollableScrollPhysics(),
                                                  padding:
                                                      EdgeInsets.zero, // 设置为零边距
                                                  shrinkWrap: true,
                                                  itemCount: imagesList.length,
                                                  itemBuilder:
                                                      (BuildContext context,
                                                          int index) {
                                                    return GestureDetector(
                                                      onTap: () =>
                                                          open(context, index),
                                                      child: Hero(
                                                        tag: galleryItems[index]
                                                            .id,
                                                        child: Container(
                                                          color: Colors.white,
                                                          child:
                                                              CachedNetworkImage(
                                                            imageUrl:
                                                                '${globalController.cdnBaseUrl}/${imagesList[index]}',
                                                            fit: BoxFit.cover,
                                                          ),
                                                        ),
                                                      ),
                                                    );
                                                  })
                                              : const SizedBox.shrink(),
                                        ),
                                        Padding(
                                          key: _replyTitleKey,
                                          padding: const EdgeInsets.fromLTRB(
                                              0, 24, 0, 24),
                                          child: Text(
                                              '全部答伤 · ${painQuestionDetail.reply_num}',
                                              style: const TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold)),
                                        ),
                                        (painQuestionDetail.reply_num == 0
                                            ? SizedBox(
                                                width:
                                                    mediaQuerySizeInfo.width -
                                                        24,
                                                height: 120,
                                                child: Center(
                                                  child: Column(
                                                    children: [
                                                      SizedBox(
                                                        width: 100,
                                                        height: 100,
                                                        child: Image.asset(
                                                          'assets/images/empty.png',
                                                          fit: BoxFit.contain,
                                                        ),
                                                      ),
                                                      const Text(
                                                        '暂无答伤内容',
                                                        style: TextStyle(
                                                            color:
                                                                Color.fromRGBO(
                                                                    224,
                                                                    222,
                                                                    223,
                                                                    1),
                                                            fontSize: 14),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              )
                                            : Container())
                                      ],
                                    ),
                                  ),
                                ),
                                SliverList(
                                    delegate: SliverChildBuilderDelegate(
                                  childCount:
                                      painReplyDataPagination.data.length,
                                  (context, i) {
                                    final PainReplyTypeModel itemData =
                                        painReplyDataPagination.data[i];
                                    final String name = itemData.name != null
                                        ? itemData.name!
                                        : '赴康云用户';
                                    final String locationReply =
                                        itemData.location ?? '未知地点';
                                    final String showReplyTime =
                                        getShowTime(itemData.reply_time);

                                    final String replyContent =
                                        itemData.reply_content;

                                    List<String> imagesReplyList = [];
                                    if (itemData.image_data != null) {
                                      imagesReplyList = itemData.image_data!
                                          .split(',')
                                          .toSet()
                                          .toList();
                                    }
                                    final List<GalleryExampleItem>
                                        galleryReplyItems =
                                        imagesReplyList.map((e) {
                                      return GalleryExampleItem(
                                          id: e,
                                          resource:
                                              '${globalController.cdnBaseUrl}/$e',
                                          isSvg: false);
                                    }).toList();

                                    final double itemWidthOnlyReply =
                                        (mediaQuerySizeInfo.width -
                                                24 -
                                                44 -
                                                12 -
                                                8 -
                                                8) /
                                            3;

                                    void openReply(
                                        BuildContext context, final int index) {
                                      Navigator.push(
                                        context,
                                        PageRouteBuilder(
                                            pageBuilder: (context, animation,
                                                    secondaryAnimation) =>
                                                GalleryPhotoViewWrapper(
                                                  galleryItems:
                                                      galleryReplyItems,
                                                  backgroundDecoration:
                                                      const BoxDecoration(
                                                    color: Colors.black,
                                                  ),
                                                  initialIndex: index,
                                                  scrollDirection:
                                                      Axis.horizontal,
                                                ),
                                            transitionsBuilder: (context,
                                                animation,
                                                secondaryAnimation,
                                                child) {
                                              return FadeTransition(
                                                opacity: animation,
                                                child: child,
                                              );
                                            }),
                                      );
                                    }

                                    final List<String> likeIdsListReply =
                                        itemData.like_user_ids != null
                                            ? itemData.like_user_ids!
                                                .split(',')
                                                .toSet()
                                                .toList()
                                            : [];
                                    final bool readyLikeReply = likeIdsListReply
                                        .contains(userController.userInfo.id);

                                    return Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        (i != 0
                                            ? Container(
                                                margin: const EdgeInsets.only(
                                                    bottom: 24),
                                                child: const Divider(
                                                  height: 2,
                                                  color: Color.fromRGBO(
                                                      233, 234, 235, 1),
                                                ),
                                              )
                                            : const SizedBox(
                                                height: 0,
                                              )),
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Stack(
                                              children: [
                                                Container(
                                                  width: 56,
                                                  height: 56,
                                                  padding:
                                                      const EdgeInsets.only(
                                                          right: 12, top: 0),
                                                  child: Align(
                                                    alignment:
                                                        Alignment.topLeft,
                                                    child: SizedBox(
                                                      width: 44,
                                                      height: 44,
                                                      child: itemData.avatar ==
                                                              null
                                                          ? const CircleAvatar(
                                                              radius: 22,
                                                              backgroundImage:
                                                                  AssetImage(
                                                                      'assets/images/avatar.webp'),
                                                            )
                                                          : CircleAvatar(
                                                              radius: 22,
                                                              backgroundImage:
                                                                  CachedNetworkImageProvider(
                                                                      '${globalController.cdnBaseUrl}/${itemData.avatar}'),
                                                            ),
                                                    ),
                                                  ),
                                                ),
                                                (itemData.authenticate == 2
                                                    ? Positioned(
                                                        bottom: 4,
                                                        right: 6,
                                                        child: Container(
                                                          width: 24,
                                                          height: 24,
                                                          margin:
                                                              const EdgeInsets
                                                                  .only(
                                                                  left: 0),
                                                          child: IconFont(
                                                              IconNames
                                                                  .guanfangrenzheng,
                                                              size: 24),
                                                        ))
                                                    : const SizedBox.shrink())
                                              ],
                                            ),
                                            Expanded(
                                                child: Stack(
                                              children: [
                                                Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                      children: [
                                                        Text(
                                                          name,
                                                          style:
                                                              const TextStyle(
                                                                  fontSize: 14,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                  color: Color
                                                                      .fromRGBO(
                                                                          0,
                                                                          0,
                                                                          0,
                                                                          1)),
                                                        ),
                                                        (itemData.identity == 1
                                                            ? Container(
                                                                decoration: BoxDecoration(
                                                                    border: Border.all(
                                                                        color: const Color
                                                                            .fromRGBO(
                                                                            238,
                                                                            123,
                                                                            48,
                                                                            1),
                                                                        width:
                                                                            1),
                                                                    borderRadius:
                                                                        const BorderRadius
                                                                            .all(
                                                                            Radius.circular(2))),
                                                                padding:
                                                                    const EdgeInsets
                                                                        .fromLTRB(
                                                                        2,
                                                                        0,
                                                                        2,
                                                                        0),
                                                                margin:
                                                                    const EdgeInsets
                                                                        .only(
                                                                        left:
                                                                            12),
                                                                child: const Text(
                                                                    '已认证',
                                                                    style: TextStyle(
                                                                        color: Color.fromRGBO(
                                                                            238,
                                                                            123,
                                                                            48,
                                                                            1),
                                                                        fontSize:
                                                                            10)),
                                                              )
                                                            : const SizedBox
                                                                .shrink())
                                                      ],
                                                    ),
                                                    Row(
                                                      children: [
                                                        Text(
                                                          showReplyTime,
                                                          style: const TextStyle(
                                                              fontSize: 14,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .normal,
                                                              color: Color
                                                                  .fromRGBO(
                                                                      102,
                                                                      102,
                                                                      102,
                                                                      1)),
                                                        ),
                                                        const Padding(
                                                          padding: EdgeInsets
                                                              .fromLTRB(
                                                                  6, 0, 6, 0),
                                                          child: Text(
                                                            '·',
                                                            style: TextStyle(
                                                                fontSize: 14,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .normal,
                                                                color: Color
                                                                    .fromRGBO(
                                                                        102,
                                                                        102,
                                                                        102,
                                                                        1)),
                                                          ),
                                                        ),
                                                        Text(
                                                          locationReply,
                                                          style: const TextStyle(
                                                              fontSize: 14,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .normal,
                                                              color: Color
                                                                  .fromRGBO(
                                                                      102,
                                                                      102,
                                                                      102,
                                                                      1)),
                                                        ),
                                                      ],
                                                    ),
                                                    Container(
                                                      margin:
                                                          const EdgeInsets.only(
                                                              top: 12),
                                                      child: RichText(
                                                          maxLines: 3,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          textAlign:
                                                              TextAlign.left,
                                                          text: TextSpan(
                                                            children: [
                                                              TextSpan(
                                                                text:
                                                                    replyContent,
                                                                style: const TextStyle(
                                                                    color: Color
                                                                        .fromRGBO(
                                                                            0,
                                                                            0,
                                                                            0,
                                                                            1),
                                                                    fontSize:
                                                                        15,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .normal),
                                                              )
                                                            ],
                                                          )),
                                                    ),
                                                    Padding(
                                                      padding: (imagesReplyList
                                                                  .isNotEmpty &&
                                                              imagesReplyList[0]
                                                                  .isNotEmpty)
                                                          ? const EdgeInsets
                                                              .fromLTRB(
                                                              0, 12, 0, 0)
                                                          : const EdgeInsets
                                                              .all(0),
                                                      child: (imagesReplyList
                                                                  .isNotEmpty &&
                                                              imagesReplyList[0]
                                                                  .isNotEmpty)
                                                          ? GridView.builder(
                                                              gridDelegate:
                                                                  SliverGridDelegateWithMaxCrossAxisExtent(
                                                                      // 交叉轴子项数量
                                                                      mainAxisSpacing:
                                                                          8, // 主轴间距
                                                                      crossAxisSpacing:
                                                                          8, // 交叉轴间距
                                                                      childAspectRatio:
                                                                          1,
                                                                      mainAxisExtent:
                                                                          itemWidthOnlyReply,
                                                                      maxCrossAxisExtent:
                                                                          itemWidthOnlyReply),
                                                              physics:
                                                                  const NeverScrollableScrollPhysics(),
                                                              padding: EdgeInsets
                                                                  .zero, // 设置为零边距
                                                              shrinkWrap: true,
                                                              itemCount:
                                                                  imagesReplyList
                                                                      .length,
                                                              itemBuilder:
                                                                  (BuildContext
                                                                          context,
                                                                      int
                                                                          index) {
                                                                return GestureDetector(
                                                                  onTap: () =>
                                                                      openReply(
                                                                          context,
                                                                          index),
                                                                  child: Hero(
                                                                    tag: galleryReplyItems[
                                                                            index]
                                                                        .id,
                                                                    child:
                                                                        Container(
                                                                      color: Colors
                                                                          .white,
                                                                      child:
                                                                          CachedNetworkImage(
                                                                        imageUrl:
                                                                            '${globalController.cdnBaseUrl}/${imagesReplyList[index]}',
                                                                        fit: BoxFit
                                                                            .cover,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                );
                                                              })
                                                          : const SizedBox
                                                              .shrink(),
                                                    ),
                                                    Container(
                                                      margin:
                                                          const EdgeInsets.only(
                                                              top: 12),
                                                      child: Text(
                                                          '${itemData.comment_num}回复',
                                                          style: const TextStyle(
                                                              color: Color
                                                                  .fromRGBO(
                                                                      211,
                                                                      66,
                                                                      67,
                                                                      1),
                                                              fontSize: 15,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold)),
                                                    ),
                                                    Container(
                                                      margin:
                                                          const EdgeInsets.only(
                                                              top: 12,
                                                              bottom: 24),
                                                      child: Row(
                                                        children: [
                                                          Container(
                                                            width: 32,
                                                            height: 32,
                                                            margin:
                                                                const EdgeInsets
                                                                    .only(
                                                                    right: 12),
                                                            child: painQuestionDetail
                                                                        .avatar ==
                                                                    null
                                                                ? const CircleAvatar(
                                                                    radius: 16,
                                                                    backgroundImage:
                                                                        AssetImage(
                                                                            'assets/images/avatar.webp'),
                                                                  )
                                                                : CircleAvatar(
                                                                    radius: 16,
                                                                    backgroundImage:
                                                                        CachedNetworkImageProvider(
                                                                            '${globalController.cdnBaseUrl}/${painQuestionDetail.avatar}'),
                                                                  ),
                                                          ),
                                                          GestureDetector(
                                                            onTap: () =>
                                                                showCommentBottomSheet(
                                                                    itemData),
                                                            child: Container(
                                                              height: 32,
                                                              padding:
                                                                  const EdgeInsets
                                                                      .fromLTRB(
                                                                      8,
                                                                      0,
                                                                      8,
                                                                      0),
                                                              decoration:
                                                                  const BoxDecoration(
                                                                color: Color
                                                                    .fromRGBO(
                                                                        242,
                                                                        242,
                                                                        242,
                                                                        1),
                                                              ),
                                                              child: Row(
                                                                children: [
                                                                  Container(
                                                                    margin: const EdgeInsets
                                                                        .only(
                                                                        right:
                                                                            4),
                                                                    width: 20,
                                                                    height: 20,
                                                                    child:
                                                                        IconFont(
                                                                      IconNames
                                                                          .bianji,
                                                                      size: 20,
                                                                      color:
                                                                          'rgb(102,102,102)',
                                                                    ),
                                                                  ),
                                                                  const Text(
                                                                    '回复这条答伤',
                                                                    style: TextStyle(
                                                                        color: Color.fromRGBO(
                                                                            102,
                                                                            102,
                                                                            102,
                                                                            1),
                                                                        fontSize:
                                                                            14),
                                                                  )
                                                                ],
                                                              ),
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                    itemData.comments != null
                                                        ? Column(
                                                            children: itemData
                                                                .comments!
                                                                .sublist(
                                                                    0,
                                                                    itemData.comments!.length >
                                                                            itemData
                                                                                .expand_num
                                                                        ? itemData
                                                                            .expand_num
                                                                        : itemData
                                                                            .comments!
                                                                            .length)
                                                                .map(
                                                                    (itemDataIn) {
                                                              final String
                                                                  nameComment =
                                                                  itemDataIn.name !=
                                                                          null
                                                                      ? itemDataIn
                                                                          .name!
                                                                      : '赴康云用户';
                                                              final String
                                                                  locationComment =
                                                                  itemDataIn
                                                                          .location ??
                                                                      '未知地点';
                                                              final String
                                                                  showCommentTime =
                                                                  getShowTime(
                                                                      itemDataIn
                                                                          .comment_time);

                                                              final String
                                                                  commentContent =
                                                                  itemDataIn
                                                                      .comment_content;

                                                              List<String>
                                                                  imagesCommentList =
                                                                  [];
                                                              if (itemDataIn
                                                                      .image_data !=
                                                                  null) {
                                                                imagesCommentList =
                                                                    itemDataIn
                                                                        .image_data!
                                                                        .split(
                                                                            ',')
                                                                        .toSet()
                                                                        .toList();
                                                              }
                                                              final List<
                                                                      GalleryExampleItem>
                                                                  galleryCommentItems =
                                                                  imagesCommentList
                                                                      .map((e) {
                                                                return GalleryExampleItem(
                                                                    id: e,
                                                                    resource:
                                                                        '${globalController.cdnBaseUrl}/$e',
                                                                    isSvg:
                                                                        false);
                                                              }).toList();

                                                              final double
                                                                  itemWidthOnlyComment =
                                                                  (mediaQuerySizeInfo
                                                                              .width -
                                                                          24 -
                                                                          44 -
                                                                          12 -
                                                                          32 -
                                                                          12 -
                                                                          8 -
                                                                          8) /
                                                                      3;

                                                              void openComment(
                                                                  BuildContext
                                                                      context,
                                                                  final int
                                                                      index) {
                                                                Navigator.push(
                                                                  context,
                                                                  PageRouteBuilder(
                                                                      pageBuilder: (context,
                                                                              animation,
                                                                              secondaryAnimation) =>
                                                                          GalleryPhotoViewWrapper(
                                                                            galleryItems:
                                                                                galleryCommentItems,
                                                                            backgroundDecoration:
                                                                                const BoxDecoration(
                                                                              color: Colors.black,
                                                                            ),
                                                                            initialIndex:
                                                                                index,
                                                                            scrollDirection:
                                                                                Axis.horizontal,
                                                                          ),
                                                                      transitionsBuilder: (context,
                                                                          animation,
                                                                          secondaryAnimation,
                                                                          child) {
                                                                        return FadeTransition(
                                                                          opacity:
                                                                              animation,
                                                                          child:
                                                                              child,
                                                                        );
                                                                      }),
                                                                );
                                                              }

                                                              final List<String>
                                                                  likeIdsListComment =
                                                                  itemDataIn.like_user_ids !=
                                                                          null
                                                                      ? itemDataIn
                                                                          .like_user_ids!
                                                                          .split(
                                                                              ',')
                                                                          .toSet()
                                                                          .toList()
                                                                      : [];
                                                              final bool
                                                                  readyLikeComment =
                                                                  likeIdsListComment.contains(
                                                                      userController
                                                                          .userInfo
                                                                          .id);

                                                              return Column(
                                                                children: [
                                                                  (itemDataIn.id !=
                                                                          itemData
                                                                              .comments![0]
                                                                              .id
                                                                      ? Container(
                                                                          margin: const EdgeInsets
                                                                              .only(
                                                                              bottom: 12),
                                                                          child:
                                                                              const Divider(
                                                                            height:
                                                                                2,
                                                                            color: Color.fromRGBO(
                                                                                233,
                                                                                234,
                                                                                235,
                                                                                1),
                                                                          ),
                                                                        )
                                                                      : const SizedBox(
                                                                          height:
                                                                              0,
                                                                        )),
                                                                  Row(
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                    children: [
                                                                      Stack(
                                                                        children: [
                                                                          Container(
                                                                            width:
                                                                                56,
                                                                            height:
                                                                                56,
                                                                            padding:
                                                                                const EdgeInsets.only(right: 12, top: 0),
                                                                            child:
                                                                                Align(
                                                                              alignment: Alignment.topLeft,
                                                                              child: SizedBox(
                                                                                width: 44,
                                                                                height: 44,
                                                                                child: itemDataIn.avatar == null
                                                                                    ? const CircleAvatar(
                                                                                        radius: 22,
                                                                                        backgroundImage: AssetImage('assets/images/avatar.webp'),
                                                                                      )
                                                                                    : CircleAvatar(
                                                                                        radius: 22,
                                                                                        backgroundImage: CachedNetworkImageProvider('${globalController.cdnBaseUrl}/${itemDataIn.avatar}'),
                                                                                      ),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                          (itemDataIn.authenticate == 2
                                                                              ? Positioned(
                                                                                  bottom: 4,
                                                                                  right: 6,
                                                                                  child: Container(
                                                                                    width: 24,
                                                                                    height: 24,
                                                                                    margin: const EdgeInsets.only(left: 0),
                                                                                    child: IconFont(IconNames.guanfangrenzheng, size: 24),
                                                                                  ))
                                                                              : const SizedBox.shrink())
                                                                        ],
                                                                      ),
                                                                      Expanded(
                                                                          child:
                                                                              Column(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.start,
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.start,
                                                                        children: [
                                                                          Row(
                                                                            children: [
                                                                              Text(
                                                                                nameComment,
                                                                                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color.fromRGBO(0, 0, 0, 1)),
                                                                              ),
                                                                              (itemDataIn.identity == 1
                                                                                  ? Container(
                                                                                      decoration: BoxDecoration(border: Border.all(color: const Color.fromRGBO(238, 123, 48, 1), width: 1), borderRadius: const BorderRadius.all(Radius.circular(2))),
                                                                                      padding: const EdgeInsets.fromLTRB(2, 0, 2, 0),
                                                                                      margin: const EdgeInsets.only(left: 12),
                                                                                      child: const Text('已认证', style: TextStyle(color: Color.fromRGBO(238, 123, 48, 1), fontSize: 10)),
                                                                                    )
                                                                                  : const SizedBox.shrink())
                                                                            ],
                                                                          ),
                                                                          Row(
                                                                            children: [
                                                                              Text(
                                                                                showCommentTime,
                                                                                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.normal, color: Color.fromRGBO(102, 102, 102, 1)),
                                                                              ),
                                                                              const Padding(
                                                                                padding: EdgeInsets.fromLTRB(6, 0, 6, 0),
                                                                                child: Text(
                                                                                  '·',
                                                                                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.normal, color: Color.fromRGBO(102, 102, 102, 1)),
                                                                                ),
                                                                              ),
                                                                              Text(
                                                                                locationComment,
                                                                                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.normal, color: Color.fromRGBO(102, 102, 102, 1)),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                          Container(
                                                                            margin:
                                                                                const EdgeInsets.only(top: 12),
                                                                            child: itemDataIn.comment_id == null
                                                                                ? RichText(
                                                                                    maxLines: 3,
                                                                                    overflow: TextOverflow.ellipsis,
                                                                                    textAlign: TextAlign.left,
                                                                                    text: TextSpan(
                                                                                      children: [
                                                                                        TextSpan(
                                                                                          text: commentContent,
                                                                                          style: const TextStyle(color: Color.fromRGBO(0, 0, 0, 1), fontSize: 15, fontWeight: FontWeight.normal),
                                                                                        )
                                                                                      ],
                                                                                    ))
                                                                                : RichText(
                                                                                    maxLines: 3,
                                                                                    overflow: TextOverflow.ellipsis,
                                                                                    textAlign: TextAlign.left,
                                                                                    text: TextSpan(
                                                                                      children: [
                                                                                        const TextSpan(
                                                                                          text: '回复',
                                                                                          style: TextStyle(color: Color.fromRGBO(102, 102, 102, 1), fontSize: 15, fontWeight: FontWeight.normal),
                                                                                        ),
                                                                                        TextSpan(
                                                                                          text: ' @${itemDataIn.to_name ?? '赴康云用户'} ',
                                                                                          style: const TextStyle(color: Color.fromRGBO(0, 0, 0, 1), fontSize: 15, fontWeight: FontWeight.bold),
                                                                                        ),
                                                                                        const TextSpan(
                                                                                          text: '说：',
                                                                                          style: TextStyle(color: Color.fromRGBO(102, 102, 102, 1), fontSize: 15, fontWeight: FontWeight.normal),
                                                                                        ),
                                                                                        const WidgetSpan(
                                                                                          child: SizedBox(width: 2), // 设置间距为10
                                                                                        ),
                                                                                        TextSpan(
                                                                                          text: commentContent,
                                                                                          style: const TextStyle(color: Color.fromRGBO(0, 0, 0, 1), fontSize: 15, fontWeight: FontWeight.normal),
                                                                                        )
                                                                                      ],
                                                                                    )),
                                                                          ),
                                                                          Padding(
                                                                            padding: (imagesCommentList.isNotEmpty && imagesCommentList[0].isNotEmpty)
                                                                                ? const EdgeInsets.fromLTRB(0, 12, 0, 0)
                                                                                : const EdgeInsets.all(0),
                                                                            child: (imagesCommentList.isNotEmpty && imagesCommentList[0].isNotEmpty)
                                                                                ? GridView.builder(
                                                                                    gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                                                                                        // 交叉轴子项数量
                                                                                        mainAxisSpacing: 8, // 主轴间距
                                                                                        crossAxisSpacing: 8, // 交叉轴间距
                                                                                        childAspectRatio: 1,
                                                                                        mainAxisExtent: itemWidthOnlyComment,
                                                                                        maxCrossAxisExtent: itemWidthOnlyComment),
                                                                                    physics: const NeverScrollableScrollPhysics(),
                                                                                    padding: EdgeInsets.zero, // 设置为零边距
                                                                                    shrinkWrap: true,
                                                                                    itemCount: imagesCommentList.length,
                                                                                    itemBuilder: (BuildContext context, int index) {
                                                                                      return GestureDetector(
                                                                                        onTap: () => openComment(context, index),
                                                                                        child: Hero(
                                                                                          tag: galleryCommentItems[index].id,
                                                                                          child: Container(
                                                                                            color: Colors.white,
                                                                                            child: CachedNetworkImage(
                                                                                              imageUrl: '${globalController.cdnBaseUrl}/${imagesCommentList[index]}',
                                                                                              fit: BoxFit.cover,
                                                                                            ),
                                                                                          ),
                                                                                        ),
                                                                                      );
                                                                                    })
                                                                                : const SizedBox.shrink(),
                                                                          ),
                                                                          Container(
                                                                              margin: const EdgeInsets.only(top: 12, bottom: 12),
                                                                              child: Row(
                                                                                children: [
                                                                                  GestureDetector(
                                                                                    onTap: () => showCommentBottomSheet(itemData, commentItem: itemDataIn),
                                                                                    child: const Text('回复', style: TextStyle(color: Color.fromRGBO(211, 66, 67, 1), fontSize: 15, fontWeight: FontWeight.bold)),
                                                                                  ),
                                                                                  Container(
                                                                                    margin: const EdgeInsets.only(left: 24),
                                                                                    child: Row(
                                                                                      children: [
                                                                                        InkWell(
                                                                                          onTap: () => handleClickCommentReply(itemData, itemDataIn),
                                                                                          child: Container(
                                                                                            margin: const EdgeInsets.only(right: 4),
                                                                                            width: 18,
                                                                                            height: 18,
                                                                                            child: readyLikeComment
                                                                                                ? IconFont(
                                                                                                    IconNames.dianzan_1,
                                                                                                    size: 18,
                                                                                                    color: 'rgb(211,66,67)',
                                                                                                  )
                                                                                                : IconFont(
                                                                                                    IconNames.dianzan,
                                                                                                    size: 18,
                                                                                                    color: '#000',
                                                                                                  ),
                                                                                          ),
                                                                                        ),
                                                                                        Text(
                                                                                          '${itemDataIn.like_num > 99 ? '99+' : itemDataIn.like_num}',
                                                                                          style: const TextStyle(color: Color.fromRGBO(0, 0, 0, 1), fontSize: 14, fontWeight: FontWeight.normal),
                                                                                        )
                                                                                      ],
                                                                                    ),
                                                                                  )
                                                                                ],
                                                                              )),
                                                                        ],
                                                                      ))
                                                                    ],
                                                                  )
                                                                ],
                                                              );
                                                            }).toList(),
                                                          )
                                                        : const SizedBox
                                                            .shrink(),
                                                    (itemData.comments !=
                                                                null &&
                                                            itemData.comments!
                                                                    .length >
                                                                itemData
                                                                    .expand_num
                                                        ? Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .only(
                                                                    bottom: 12),
                                                            child:
                                                                GestureDetector(
                                                              onTap: () =>
                                                                  handleExpandMore(
                                                                      itemData),
                                                              child: Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center,
                                                                children: [
                                                                  Text(
                                                                      '展开剩余${itemData.comments!.length - itemData.expand_num}条',
                                                                      style: const TextStyle(
                                                                          color: Color.fromRGBO(
                                                                              211,
                                                                              66,
                                                                              67,
                                                                              1),
                                                                          fontSize:
                                                                              15,
                                                                          fontWeight:
                                                                              FontWeight.bold)),
                                                                  Container(
                                                                    width: 18,
                                                                    height: 18,
                                                                    margin: const EdgeInsets
                                                                        .only(
                                                                        left:
                                                                            4),
                                                                    child:
                                                                        IconFont(
                                                                      IconNames
                                                                          .xiala,
                                                                      size: 14,
                                                                      color:
                                                                          'rgb(211,66,67)',
                                                                    ),
                                                                  )
                                                                ],
                                                              ),
                                                            ),
                                                          )
                                                        : const SizedBox
                                                            .shrink())
                                                  ],
                                                ),
                                                Positioned(
                                                    right: 12,
                                                    top: 0,
                                                    child: Container(
                                                      margin:
                                                          const EdgeInsets.only(
                                                              left: 0),
                                                      child: Row(
                                                        children: [
                                                          InkWell(
                                                            onTap: () =>
                                                                handleClickLikeReply(
                                                                    itemData),
                                                            child: Container(
                                                              margin:
                                                                  const EdgeInsets
                                                                      .only(
                                                                      right: 4),
                                                              width: 18,
                                                              height: 18,
                                                              child:
                                                                  readyLikeReply
                                                                      ? IconFont(
                                                                          IconNames
                                                                              .dianzan_1,
                                                                          size:
                                                                              18,
                                                                          color:
                                                                              'rgb(211,66,67)',
                                                                        )
                                                                      : IconFont(
                                                                          IconNames
                                                                              .dianzan,
                                                                          size:
                                                                              18,
                                                                          color:
                                                                              '#000',
                                                                        ),
                                                            ),
                                                          ),
                                                          Text(
                                                            '${itemData.like_num > 99 ? '99+' : itemData.like_num}',
                                                            style: const TextStyle(
                                                                color: Color
                                                                    .fromRGBO(
                                                                        0,
                                                                        0,
                                                                        0,
                                                                        1),
                                                                fontSize: 14,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .normal),
                                                          ),
                                                        ],
                                                      ),
                                                    ))
                                              ],
                                            ))
                                          ],
                                        ),
                                      ],
                                    );
                                  },
                                ))
                              ])))),
                )
              : Expanded(
                  child: SingleChildScrollView(
                    physics: const NeverScrollableScrollPhysics(),
                    child: skeleton(),
                  ),
                ),
          _readyLoad
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Divider(
                      height: 2,
                      color: Color.fromRGBO(232, 232, 232, 1),
                    ),
                    Container(
                      decoration: const BoxDecoration(color: Colors.white),
                      padding: EdgeInsets.fromLTRB(
                          12, 18, 12, mediaQuerySafeInfo.bottom + 18),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                  child: GestureDetector(
                                onTap: showReplyBottomSheet,
                                child: Container(
                                  height: 36,
                                  padding:
                                      const EdgeInsets.fromLTRB(12, 0, 12, 0),
                                  decoration: const BoxDecoration(
                                      color: Color.fromRGBO(242, 242, 242, 1)),
                                  child: const Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      '我想说...',
                                      style: TextStyle(
                                          color:
                                              Color.fromRGBO(102, 102, 102, 1),
                                          fontSize: 15),
                                    ),
                                  ),
                                ),
                              )),
                              Row(
                                children: [
                                  InkWell(
                                    onTap: scrollToReplyTitle,
                                    child: Container(
                                      width: 36,
                                      margin: const EdgeInsets.only(
                                          right: 18, left: 18),
                                      child: Column(
                                        children: [
                                          Container(
                                            margin: const EdgeInsets.only(
                                                bottom: 0),
                                            child: IconFont(
                                              IconNames.xiaoxi,
                                              size: 20,
                                              color: '#000',
                                            ),
                                          ),
                                          Text(
                                            painQuestionDetail.reply_num > 99
                                                ? '99+'
                                                : '${painQuestionDetail.reply_num}',
                                            style: const TextStyle(
                                                color: Colors.black,
                                                fontSize: 14),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                  InkWell(
                                    onTap: handleClickLike,
                                    child: Container(
                                      width: 36,
                                      margin: const EdgeInsets.only(right: 18),
                                      child: Column(
                                        children: [
                                          Container(
                                            margin: const EdgeInsets.only(
                                                bottom: 0),
                                            child: IconFont(
                                              readyLike
                                                  ? IconNames.dianzan_1
                                                  : IconNames.dianzan,
                                              size: 20,
                                              color: readyLike
                                                  ? 'rgb(211,66,67)'
                                                  : '#000',
                                            ),
                                          ),
                                          Text(
                                            painQuestionDetail.like_num > 99
                                                ? '99+'
                                                : '${painQuestionDetail.like_num}',
                                            style: const TextStyle(
                                                color: Colors.black,
                                                fontSize: 14),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                  InkWell(
                                    onTap: handleClickCollect,
                                    child: Container(
                                      width: 36,
                                      margin: const EdgeInsets.only(right: 0),
                                      child: Column(
                                        children: [
                                          Container(
                                            margin: const EdgeInsets.only(
                                                bottom: 0),
                                            child: IconFont(
                                              readyCollect
                                                  ? IconNames.shoucang_1
                                                  : IconNames.shoucang,
                                              size: 20,
                                              color: readyCollect
                                                  ? 'rgb(252,189,84)'
                                                  : '#000',
                                            ),
                                          ),
                                          Text(
                                            painQuestionDetail.collect_num > 99
                                                ? '99+'
                                                : '${painQuestionDetail.collect_num}',
                                            style: const TextStyle(
                                                color: Colors.black,
                                                fontSize: 14),
                                          )
                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              )
                            ],
                          )
                        ],
                      ),
                    )
                  ],
                )
              : const SizedBox.shrink()
        ],
      ),
    );
  }
}
