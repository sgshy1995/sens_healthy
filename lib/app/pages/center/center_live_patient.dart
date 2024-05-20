import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:indexed/indexed.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sens_healthy/app/models/appointment_model.dart';
import 'package:sens_healthy/components/loading.dart';
import 'package:sens_healthy/components/toast.dart';

import '../../../iconfont/icon_font.dart';
import 'package:tencent_trtc_cloud/trtc_cloud.dart';
import 'package:tencent_trtc_cloud/trtc_cloud_def.dart';
import 'package:tencent_trtc_cloud/trtc_cloud_listener.dart';
import 'package:tencent_trtc_cloud/trtc_cloud_video_view.dart';
import 'package:tencent_trtc_cloud/tx_audio_effect_manager.dart';
import 'package:tencent_trtc_cloud/tx_beauty_manager.dart';
import 'package:tencent_trtc_cloud/tx_device_manager.dart';
import '../../models/appointment_model.dart';

import '../../controllers/global_controller.dart';
import '../../controllers/user_controller.dart';
import '../../providers/api/appointment_client_provider.dart';
// import 'package:tencent_trtc_cloud/web/Simulation_js.dart';
// import 'package:tencent_trtc_cloud/web/trtc_cloud_js.dart';
// import 'package:tencent_trtc_cloud/web/trtc_cloud_listener_web.dart';
// import 'package:tencent_trtc_cloud/web/trtc_cloud_web.dart';

class CenterLivePatientPage extends StatefulWidget {
  const CenterLivePatientPage({super.key});

  @override
  State<CenterLivePatientPage> createState() => _CenterLivePatientPageState();
}

class _CenterLivePatientPageState extends State<CenterLivePatientPage> {
  final UserController userController = Get.put(UserController());
  final GlobalController globalController = Get.put(GlobalController());
  final AppointmentClientProvider appointmentClientProvider =
      Get.put(AppointmentClientProvider());
  GlobalKey firstElementKey = GlobalKey();
  GlobalKey secondElementKey = GlobalKey();

  Future<bool> checkCameraAndMicrophonePermissions() async {
    PermissionStatus cameraStatus = await Permission.camera.status;
    PermissionStatus microphoneStatus = await Permission.microphone.status;
    if (cameraStatus == PermissionStatus.granted &&
        microphoneStatus == PermissionStatus.granted) {
      return true;
    } else {
      return false;
    }
  }

  Future<String?> getCheckPermissions() async {
    Completer<String?> completer = Completer();
    final bool permissionCheckResult =
        await checkCameraAndMicrophonePermissions();
    if (permissionCheckResult) {
      completer.complete('success');
    } else {
      Map<Permission, PermissionStatus> statuses = await [
        Permission.camera,
        Permission.microphone,
      ].request();
      print(statuses[Permission.camera]);
      print(statuses[Permission.microphone]);
      if (GetPlatform.isIOS) {
        completer.complete('success');
      } else if (statuses[Permission.camera] == PermissionStatus.granted &&
          statuses[Permission.microphone] == PermissionStatus.granted) {
        completer.complete('success');
      } else {
        showToast('授权失败, 请检查');
        completer.completeError('error');
      }
    }
    return completer.future;
  }

  void handleBack() {
    final String timeNow = DateTime.now().millisecondsSinceEpoch.toString();
    setState(() {
      closingId = timeNow;
    });
    Get.back();
  }

  DateTime? timeEnter;

  String timeLength = '00:00:00';

  String formatDuration(Duration duration) {
    int seconds = duration.inSeconds;
    int hours = seconds ~/ 3600;
    seconds %= 3600;
    int minutes = seconds ~/ 60;
    seconds %= 60;
    return "${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}";
  }

  Timer? timer;

  void startTimer() {
    timeEnter = DateTime.now();
    try {
      timer?.cancel(); // 取消定时器
    } catch (e) {}
    timer = Timer.periodic(const Duration(seconds: 1), (timerIn) {
      final DateTime timeNow = DateTime.now();
      Duration duration = timeNow.difference(timeEnter!);
      final String formattedDuration = formatDuration(duration);
      setState(() {
        timeLength = formattedDuration;
      });
    });
  }

  late String roomId;

  RoomTypeModel? roomInfo;

  bool _readyLoad = false;

  bool ifOpenCamera = true;
  bool ifOpenMicrophone = true;
  String cameraType = 'front';

  int? viewId;

  bool isSwapped = true;

  bool ifShowTools = true;

  String closingId = '';

  void setDelayed() {
    final String timeNow = DateTime.now().millisecondsSinceEpoch.toString();
    setState(() {
      closingId = timeNow;
    });
    final String closingIdGet = timeNow;
    Future.delayed(const Duration(seconds: 5), () {
      if (closingIdGet == closingId) {
        setState(() {
          ifShowTools = false;
        });
      }
    });
  }

  void onShowTools() {
    if (ifShowTools) {
      setState(() {
        ifShowTools = false;
      });
    } else {
      setState(() {
        ifShowTools = true;
      });
      setDelayed();
    }
  }

  void handleChangeShowIndex() {
    final String timeNow = DateTime.now().millisecondsSinceEpoch.toString();
    setState(() {
      closingId = timeNow;
      isSwapped = !isSwapped;
    });
  }

  void handleSetViewId(int viewIdGet) {
    setState(() {
      viewId = viewIdGet;
    });
  }

  TRTCCloud? trtcCloud;
  TXDeviceManager? txDeviceManager;
  TXBeautyManager? txBeautyManager;
  TXAudioEffectManager? txAudioManager;

  bool onUserVideoAvailable = false;
  bool onUserEnterRoom = false;
  bool onUserAudioAvailable = false;

  Future<String?> initTrtc() async {
    Completer<String?> completer = Completer();
    // 创建 TRTCCloud 单例
    final TRTCCloud? trtcCloudGet = await TRTCCloud.sharedInstance();

    setState(() {
      trtcCloud = trtcCloudGet;
      // 获取设备管理模块
      txDeviceManager = trtcCloud!.getDeviceManager();
      // 获取美颜管理对象
      txBeautyManager = trtcCloud!.getBeautyManager();
      // 获取音效管理类
      txAudioManager = trtcCloud!.getAudioEffectManager();
    });

    //设置事件监听
    trtcCloud!.registerListener(onRtcListener);

    completer.complete('success');
    return completer.future;
  }

  bool ifShouDong = false;

  void onRtcListener(type, param) {
    //进房回调事件
    if (type == TRTCCloudListener.onEnterRoom) {
      if (param > 0) {
        showToast('您已进入房间');
      }
    }
    // 远端用户进房
    if (type == TRTCCloudListener.onRemoteUserEnterRoom) {
      //param参数为远端用户userId
      onUserEnterRoom = true;
    }
    // 远端用户进房
    if (type == TRTCCloudListener.onRemoteUserLeaveRoom) {
      //param参数为远端用户userId
      onUserEnterRoom = false;
      onUserVideoAvailable = false;
      onUserAudioAvailable = false;
    }
    //远端用户是否存在可播放的主路画面（一般用于摄像头）
    if (type == TRTCCloudListener.onUserVideoAvailable) {
      //param['userId']表示远端用户id
      //param['visible']画面是否开启
      if (param['available'] && !onUserVideoAvailable) {
        setState(() {
          onUserVideoAvailable = true;
        });
      } else if (!param['available']) {
        setState(() {
          onUserVideoAvailable = false;
        });
      }
    }
    //远端用户是否存在可播放的音频数据
    if (type == TRTCCloudListener.onUserAudioAvailable) {
      //param['userId']表示远端用户id
      //param['visible']画面是否开启
      if (param['available'] && !onUserAudioAvailable) {
        setState(() {
          onUserAudioAvailable = true;
        });
      } else if (!param['available']) {
        setState(() {
          onUserAudioAvailable = false;
        });
      }
    }
    // 本地用户退房
    if (type == TRTCCloudListener.onExitRoom) {
      //被动退房
      if (!ifShouDong) {
        showLoading('请稍后...');
        appointmentClientProvider
            .getOneRoomByIdAction(roomId)
            .then((resultOuter) {
          hideLoading();
          if (resultOuter.data == null) {
            showToast('直播间已关闭, 3秒后自动退出');
            Future.delayed(const Duration(seconds: 3), () {
              Get.back();
            });
          }
        }).catchError((e) {
          showToast('请求错误, 即将退出');
          Future.delayed(const Duration(seconds: 1), () {
            Get.back();
          });
        });
      }
    }
  }

  Future<String?> initRoom() {
    Completer<String?> completer = Completer();
    appointmentClientProvider.getOneRoomByIdAction(roomId).then((resultOuter) {
      if (resultOuter.code == 200 && resultOuter.data != null) {
        final RoomTypeModel roomInfoGet = resultOuter.data!;
        setState(() {
          roomInfo = roomInfoGet;
        });
        appointmentClientProvider
            .enterRoomAction(roomId, 'patient')
            .then((result) {
          if (result.code == 200) {
            setState(() {
              _readyLoad = true;
            });
            final RoomEnterTypeModel roomEnterInfo = result.data!;
            initVideoAndAudio();
            //进入音视频房间
            trtcCloud!
                .enterRoom(
                    TRTCParams(
                        sdkAppId: roomEnterInfo.app_id, //应用Id
                        userId: userController.userInfo.id, // 用户Id
                        userSig: roomEnterInfo.sign, // 用户签名
                        strRoomId: roomInfo!.room_no), //房间Id
                    TRTCCloudDef.TRTC_APP_SCENE_VIDEOCALL)
                .then((value) {
              startTimer();

              completer.complete('success');
              // 开启麦克风采集，并设置当前场景为：语音模式（高噪声抑制能力、强弱网络抗性）
              trtcCloud!
                  .startLocalAudio(TRTCCloudDef.TRTC_AUDIO_QUALITY_SPEECH);
            }).catchError((e) {
              showToast('进入房间失败');
              completer.completeError('error');
            });
          } else {
            showToast(result.message);
            completer.completeError('error');
          }
        }).catchError((e) {
          showToast('获取信息失败, 请稍后再试');
          completer.completeError('error');
        });
      } else {
        showToast(resultOuter.message);
      }
    }).catchError((eOuter) {
      showToast('获取信息失败');
    });
    return completer.future;
  }

  void initVideoAndAudio() {
    // 参数：
    // frontCamera	true：前置摄像头；false：后置摄像头
    // viewId TRTCCloudVideoView生成的viewId
    // 设置本地画面的预览模式：开启左右镜像，设置画面为填充模式
    trtcCloud!.setLocalRenderParams(TRTCRenderParams(
        fillMode: TRTCCloudDef.TRTC_VIDEO_RENDER_MODE_FILL,
        mirrorType: TRTCCloudDef.TRTC_VIDEO_MIRROR_TYPE_AUTO));
  }

  void handleChangeIfOpenCamera() {
    final String timeNow = DateTime.now().millisecondsSinceEpoch.toString();
    setState(() {
      closingId = timeNow;
      ifOpenCamera = !ifOpenCamera;
    });

    if (!ifOpenCamera) {
      trtcCloud!.stopLocalPreview();
      showToast('您已关闭摄像头');
    } else {
      trtcCloud!.startLocalPreview(cameraType == 'front', viewId);
      showToast('您已开启摄像头');
    }
  }

  void handleChangeIfOpenMicrophone() {
    final String timeNow = DateTime.now().millisecondsSinceEpoch.toString();
    setState(() {
      closingId = timeNow;
      ifOpenMicrophone = !ifOpenMicrophone;
    });

    if (!ifOpenMicrophone) {
      trtcCloud!.stopLocalAudio();
      showToast('您已关闭麦克风');
    } else {
      trtcCloud!.startLocalAudio(TRTCCloudDef.TRTC_AUDIO_QUALITY_SPEECH);
      showToast('您已开启麦克风');
    }
  }

  void handleChangeCameraType() {
    final String timeNow = DateTime.now().millisecondsSinceEpoch.toString();
    setState(() {
      closingId = timeNow;
      cameraType = cameraType == 'front' ? 'backend' : 'front';
    });
    txDeviceManager!.switchCamera(cameraType == 'front');
  }

  bool ifRemoteAudioEnable = true;

  void handleChangeIfRemoteAudioEnable() {
    final String timeNow = DateTime.now().millisecondsSinceEpoch.toString();
    setState(() {
      closingId = timeNow;
      ifRemoteAudioEnable = !ifRemoteAudioEnable;
    });
    if (!ifRemoteAudioEnable) {
      showToast('您已将对方设置为静音');
      trtcCloud!.muteAllRemoteAudio(true);
    } else {
      showToast('您已取消静音');
      trtcCloud!.muteAllRemoteAudio(false);
    }
  }

  bool isDraggingWhole = false;

  double moveBottom = Get.context!.mediaQueryPadding.bottom + 12 + 44 + 12 + 12;
  double moveRight = 0;

  ///小窗拖动
  void handleTapContainerSwapped(TapUpDetails detail) {
    if (!isSwapped) {
      return;
    }
  }

  handleOnPanStartSwapped(DragStartDetails detail) {
    if (!isSwapped) {
      return;
    }
    //拖动线段
    if (!isDraggingWhole) {
      setState(() {
        isDraggingWhole = true;
      });
    }
  }

  void handleOnPanEndSwapped(DragEndDetails detail) {
    if (!isSwapped) {
      return;
    }
    setState(() {
      isDraggingWhole = false;
    });
    if (moveBottom <
        Get.context!.mediaQueryPadding.bottom + 12 + 44 + 12 + 12) {
      setState(() {
        moveBottom = Get.context!.mediaQueryPadding.bottom + 12 + 44 + 12 + 12;
      });
    } else if (moveBottom >
        Get.context!.mediaQuerySize.height -
            (Get.context!.mediaQueryPadding.top +
                12 +
                Get.context!.mediaQuerySize.width / 5 * 2 / 3 * 4 +
                12 +
                30 +
                12 +
                12)) {
      setState(() {
        moveBottom = Get.context!.mediaQuerySize.height -
            (Get.context!.mediaQueryPadding.top +
                12 +
                Get.context!.mediaQuerySize.width / 5 * 2 / 3 * 4 +
                12 +
                30 +
                12 +
                12);
      });
    }

    if (moveRight < 0) {
      setState(() {
        moveRight = 0 - Get.context!.mediaQuerySize.width / 5 * 2;
        ifHiddenSmall = true;
      });
    } else if (moveRight >
        Get.context!.mediaQuerySize.width -
            Get.context!.mediaQuerySize.width / 5 * 2) {
      setState(() {
        moveRight = Get.context!.mediaQuerySize.width;
        ifHiddenSmall = true;
      });
    } else {
      if (moveRight <= Get.context!.mediaQuerySize.width / 2) {
        setState(() {
          moveRight = 0;
        });
      } else {
        setState(() {
          moveRight = Get.context!.mediaQuerySize.width -
              Get.context!.mediaQuerySize.width / 5 * 2;
        });
      }
    }
  }

  void handleOnPanUpdateSwapped(DragUpdateDetails detail) {
    if (!isSwapped) {
      return;
    }
    if (isDraggingWhole) {
      setState(() {
        moveBottom -= detail.delta.dy;
        moveRight -= detail.delta.dx;
      });
    }
  }

  ///大窗拖动
  void handleTapContainerNotSwapped(TapUpDetails detail) {
    if (isSwapped) {
      return;
    }
  }

  handleOnPanStartNotSwapped(DragStartDetails detail) {
    if (isSwapped) {
      return;
    }
    //拖动线段
    if (!isDraggingWhole) {
      setState(() {
        isDraggingWhole = true;
      });
    }
  }

  void handleOnPanEndNotSwapped(DragEndDetails detail) {
    if (isSwapped) {
      return;
    }
    setState(() {
      isDraggingWhole = false;
    });
    if (moveBottom <
        Get.context!.mediaQueryPadding.bottom + 12 + 44 + 12 + 12) {
      setState(() {
        moveBottom = Get.context!.mediaQueryPadding.bottom + 12 + 44 + 12 + 12;
      });
    } else if (moveBottom >
        Get.context!.mediaQuerySize.height -
            (Get.context!.mediaQueryPadding.top +
                12 +
                Get.context!.mediaQuerySize.width / 5 * 2 / 3 * 4 +
                12 +
                30 +
                12 +
                12)) {
      setState(() {
        moveBottom = Get.context!.mediaQuerySize.height -
            (Get.context!.mediaQueryPadding.top +
                12 +
                Get.context!.mediaQuerySize.width / 5 * 2 / 3 * 4 +
                12 +
                30 +
                12 +
                12);
      });
    }

    if (moveRight < 0) {
      setState(() {
        moveRight = 0 - Get.context!.mediaQuerySize.width / 5 * 2;
        ifHiddenSmall = true;
      });
    } else if (moveRight >
        Get.context!.mediaQuerySize.width -
            Get.context!.mediaQuerySize.width / 5 * 2) {
      setState(() {
        moveRight = Get.context!.mediaQuerySize.width;
        ifHiddenSmall = true;
      });
    } else {
      if (moveRight <= Get.context!.mediaQuerySize.width / 2) {
        setState(() {
          moveRight = 0;
        });
      } else {
        setState(() {
          moveRight = Get.context!.mediaQuerySize.width -
              Get.context!.mediaQuerySize.width / 5 * 2;
        });
      }
    }
  }

  void handleOnPanUpdateNotSwapped(DragUpdateDetails detail) {
    if (isSwapped) {
      return;
    }
    if (isDraggingWhole) {
      setState(() {
        moveBottom -= detail.delta.dy;
        moveRight -= detail.delta.dx;
      });
    }
  }

  bool ifHiddenSmall = false;

  void handleShowSmall() {
    setState(() {
      moveBottom = Get.context!.mediaQueryPadding.bottom + 12 + 44 + 12 + 12;
      moveRight = 0;
      ifHiddenSmall = false;
    });
  }

  @override
  void initState() {
    super.initState();
    roomId = Get.arguments['roomId'];
    getCheckPermissions().then((value) {
      if (value == 'success') {
        initTrtc().then((valueIn) {
          initRoom();
        });
      }
    });
    setDelayed();
  }

  @override
  void dispose() {
    if (timer != null) {
      timer?.cancel();
    }
    if (trtcCloud != null) {
      //移除事件监听
      ifShouDong = true;
      trtcCloud!.unRegisterListener(onRtcListener);
      trtcCloud!.stopLocalPreview();
      trtcCloud!.stopLocalAudio();
      trtcCloud!.exitRoom();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final EdgeInsets mediaQuerySafeInfo = MediaQuery.of(context).padding;
    final Size mediaQuerySizeInfo = MediaQuery.of(context).size;

    return Scaffold(
      body: GestureDetector(
        onTap: onShowTools,
        child: Indexer(
          children: [
            Container(
              width: double.infinity,
              height: double.infinity,
              decoration: const BoxDecoration(color: Colors.white),
            ),
            Indexed(
              index: isSwapped ? 1 : 10,
              child: AnimatedPositioned(
                  duration: const Duration(milliseconds: 300),
                  key: firstElementKey,
                  top: isSwapped ? 0 : null,
                  left: isSwapped ? 0 : null,
                  bottom: isSwapped ? null : moveBottom,
                  right: isSwapped ? null : moveRight,
                  child: Stack(
                    children: [
                      GestureDetector(
                        onPanStart: handleOnPanStartNotSwapped,
                        onPanEnd: handleOnPanEndNotSwapped,
                        onPanUpdate: handleOnPanUpdateNotSwapped,
                        onTapUp: handleTapContainerNotSwapped,
                        child: Container(
                          width: isSwapped
                              ? mediaQuerySizeInfo.width
                              : mediaQuerySizeInfo.width / 5 * 2,
                          height: isSwapped
                              ? mediaQuerySizeInfo.height
                              : mediaQuerySizeInfo.width / 5 * 2 / 3 * 4,
                          decoration: const BoxDecoration(
                              color: Color.fromRGBO(33, 33, 33, 1)),
                          child: !onUserVideoAvailable ||
                                  roomInfo == null ||
                                  !onUserEnterRoom
                              ? Center(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        width: 64,
                                        height: 64,
                                        child: Image.asset(
                                          'assets/images/empty_video.png',
                                          fit: BoxFit.contain,
                                        ),
                                      ),
                                      Text(
                                        !onUserEnterRoom
                                            ? '等待医师进入房间'
                                            : '等待医师开启画面',
                                        style: const TextStyle(
                                            color: Color.fromRGBO(
                                                224, 222, 223, 1),
                                            fontSize: 13,
                                            fontWeight: FontWeight.bold),
                                      )
                                    ],
                                  ),
                                )
                              :
                              // 参数：
                              // userId 指定远端用户的 userId
                              // streamType 指定要观看 userId 的视频流类型：
                              //* 高清大画面：TRTCCloudDef.TRTC_VIDEO_STREAM_TYPE_BIG
                              //* 低清大画面：TRTCCloudDef.TRTC_VIDEO_STREAM_TYPE_SMALL
                              // viewId TRTCCloudVideoView生成的viewId
                              TRTCCloudVideoView(onViewCreated: (viewId) {
                                  trtcCloud!.startRemoteView(
                                      roomInfo!.lecturer_user_id,
                                      TRTCCloudDef.TRTC_VIDEO_STREAM_TYPE_BIG,
                                      viewId);
                                }),
                        ),
                      ),
                      (onUserEnterRoom && !onUserAudioAvailable)
                          ? Positioned(
                              top: isSwapped ? mediaQuerySafeInfo.top + 12 : 12,
                              right: 12,
                              child: SizedBox(
                                width: 18,
                                height: 18,
                                child: Center(
                                  child: IconFont(
                                    IconNames.jingyinline,
                                    size: 18,
                                    color: 'rgb(234,71,56)',
                                  ),
                                ),
                              ))
                          : const SizedBox.shrink()
                    ],
                  )),
            ),
            Indexed(
              index: isSwapped ? 10 : 1,
              child: _readyLoad
                  ? AnimatedPositioned(
                      duration: const Duration(milliseconds: 300),
                      key: secondElementKey,
                      top: isSwapped ? null : 0,
                      left: isSwapped ? null : 0,
                      bottom: isSwapped ? moveBottom : null,
                      right: isSwapped ? moveRight : null,
                      child: GestureDetector(
                        onPanStart: handleOnPanStartSwapped,
                        onPanEnd: handleOnPanEndSwapped,
                        onPanUpdate: handleOnPanUpdateSwapped,
                        onTapUp: handleTapContainerSwapped,
                        child: Container(
                          width: !isSwapped
                              ? mediaQuerySizeInfo.width
                              : mediaQuerySizeInfo.width / 5 * 2,
                          height: !isSwapped
                              ? mediaQuerySizeInfo.height
                              : mediaQuerySizeInfo.width / 5 * 2 / 3 * 4,
                          decoration: const BoxDecoration(
                              color: Color.fromRGBO(100, 100, 100, 1)),
                          child: ifOpenCamera
                              ? TRTCCloudVideoView(
                                  onViewCreated: (int viewIdGet) {
                                  handleSetViewId(viewIdGet);
                                  trtcCloud!.startLocalPreview(true, viewIdGet);
                                })
                              : Center(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        width: 64,
                                        height: 64,
                                        child: Image.asset(
                                          'assets/images/empty_video.png',
                                          fit: BoxFit.contain,
                                        ),
                                      ),
                                      const Text(
                                        '隐私模式',
                                        style: TextStyle(
                                            color: Color.fromRGBO(
                                                224, 222, 223, 1),
                                            fontSize: 13,
                                            fontWeight: FontWeight.bold),
                                      )
                                    ],
                                  ),
                                ),
                        ),
                      ))
                  : const SizedBox.shrink(),
            ),
            Indexed(
              index: 3,
              child: Positioned(
                  top: 0,
                  left: 0,
                  child: Container(
                    width: mediaQuerySizeInfo.width,
                    height: mediaQuerySizeInfo.height,
                    color: Colors.transparent,
                  )),
            ),
            Indexed(
              index: 4,
              child: _readyLoad && ifShowTools
                  ? Positioned(
                      bottom: mediaQuerySafeInfo.bottom + 12,
                      left: 0,
                      right: 0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            height: 56,
                            padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                            decoration: const BoxDecoration(
                                color: Color.fromRGBO(33, 33, 33, 1),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(28))),
                            child: Row(
                              children: [
                                GestureDetector(
                                  onTap: handleChangeShowIndex,
                                  child: Container(
                                    width: 32,
                                    height: 32,
                                    decoration: BoxDecoration(
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(16)),
                                        color: Colors.transparent,
                                        border: Border.all(
                                            width: 1, color: Colors.white)),
                                    child: Center(
                                      child: IconFont(
                                        IconNames.qiehuanquanping,
                                        size: 19,
                                        color: '#fff',
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 12,
                                ),
                                GestureDetector(
                                  onTap: handleChangeIfRemoteAudioEnable,
                                  child: Container(
                                    width: 32,
                                    height: 32,
                                    decoration: BoxDecoration(
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(16)),
                                        color: ifRemoteAudioEnable
                                            ? Colors.white
                                            : const Color.fromRGBO(
                                                88, 88, 88, 1)),
                                    child: Center(
                                      child: IconFont(
                                        IconNames.yangshengqi,
                                        size: 20,
                                        color: '#333',
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 12,
                                ),
                                GestureDetector(
                                  onTap: handleChangeIfOpenCamera,
                                  child: Container(
                                    width: 32,
                                    height: 32,
                                    decoration: BoxDecoration(
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(16)),
                                        color: ifOpenCamera
                                            ? Colors.white
                                            : const Color.fromRGBO(
                                                88, 88, 88, 1)),
                                    child: Center(
                                      child: ifOpenCamera
                                          ? IconFont(
                                              IconNames.shexiangtoukaiqi,
                                              size: 19,
                                              color: '#333',
                                            )
                                          : IconFont(
                                              IconNames.shexiangtouguanbi,
                                              size: 19,
                                              color: '#333',
                                            ),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 12,
                                ),
                                GestureDetector(
                                  onTap: handleChangeIfOpenMicrophone,
                                  child: Container(
                                    width: 32,
                                    height: 32,
                                    decoration: BoxDecoration(
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(16)),
                                        color: ifOpenMicrophone
                                            ? Colors.white
                                            : const Color.fromRGBO(
                                                88, 88, 88, 1)),
                                    child: Center(
                                      child: ifOpenMicrophone
                                          ? IconFont(
                                              IconNames.maikefengline,
                                              size: 20,
                                              color: '#333',
                                            )
                                          : IconFont(
                                              IconNames.jingyinline,
                                              size: 20,
                                              color: '#333',
                                            ),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 12,
                                ),
                                GestureDetector(
                                  onTap: handleChangeCameraType,
                                  child: Container(
                                    width: 32,
                                    height: 32,
                                    decoration: BoxDecoration(
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(16)),
                                        color: Colors.transparent,
                                        border: Border.all(
                                            width: 1, color: Colors.white)),
                                    child: Center(
                                      child: IconFont(
                                        IconNames.fanzhuanxiangji,
                                        size: 19,
                                        color: '#fff',
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 12,
                                ),
                                GestureDetector(
                                  onTap: handleBack,
                                  child: Container(
                                    width: 32,
                                    height: 32,
                                    decoration: const BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(16)),
                                        color: Color.fromRGBO(255, 34, 49, 1)),
                                    child: Center(
                                      child: IconFont(
                                        IconNames.guaduan,
                                        size: 20,
                                        color: '#fff',
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ))
                  : const SizedBox.shrink(),
            ),
            ifShowTools
                ? Positioned(
                    top: mediaQuerySafeInfo.top + 12,
                    left: mediaQuerySizeInfo.width / 2 - 32,
                    child: Container(
                      height: 24,
                      padding: const EdgeInsets.fromLTRB(6, 0, 6, 0),
                      decoration: const BoxDecoration(
                          color: Color.fromRGBO(33, 33, 33, 1),
                          borderRadius: BorderRadius.all(Radius.circular(12))),
                      child: Center(
                        child: Text(
                          timeLength,
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ))
                : const SizedBox.shrink(),
            ifHiddenSmall
                ? Indexed(
                    index: 6,
                    child: Positioned(
                        bottom: mediaQuerySafeInfo.bottom +
                            12 +
                            44 +
                            12 +
                            12 +
                            mediaQuerySizeInfo.width / 5 * 2 / 3 * 4 +
                            24,
                        left: mediaQuerySizeInfo.width - 20,
                        child: GestureDetector(
                          onTap: handleShowSmall,
                          child: Container(
                            width: 40,
                            height: 40,
                            decoration: const BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20))),
                            child: Row(
                              children: [
                                SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: Center(
                                    child: IconFont(
                                      IconNames.xiangzuo,
                                      size: 18,
                                      color: '#000',
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 20,
                                  width: 20,
                                )
                              ],
                            ),
                          ),
                        )),
                  )
                : const SizedBox.shrink(),
            Indexed(
                index: 7,
                child: Positioned(
                    top: mediaQuerySafeInfo.top + 12,
                    left: 12,
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: handleBack,
                          child: Container(
                            width: 24,
                            height: 24,
                            decoration: const BoxDecoration(
                                color: Color.fromRGBO(0, 0, 0, 0.5),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(12))),
                            child: Center(
                              child: IconFont(
                                IconNames.fanhui,
                                size: 16,
                                color: 'rgb(255,255,255)',
                              ),
                            ),
                          ),
                        )
                      ],
                    ))),
          ],
        ),
      ),
    );
  }
}
