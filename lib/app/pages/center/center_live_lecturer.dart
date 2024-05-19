import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sens_healthy/app/models/appointment_model.dart';
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

class CenterLiveLecturerPage extends StatefulWidget {
  const CenterLiveLecturerPage({super.key});

  @override
  State<CenterLiveLecturerPage> createState() => _CenterLiveLecturerPageState();
}

class _CenterLiveLecturerPageState extends State<CenterLiveLecturerPage> {
  final UserController userController = Get.put(UserController());
  final GlobalController globalController = Get.put(GlobalController());
  final AppointmentClientProvider appointmentClientProvider =
      Get.put(AppointmentClientProvider());

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
      if (statuses[Permission.camera] == PermissionStatus.granted &&
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

  void handleSetViewId(int viewIdGet) {
    setState(() {
      viewId = viewIdGet;
    });
  }

  TRTCCloud? trtcCloud;
  TXDeviceManager? txDeviceManager;
  TXBeautyManager? txBeautyManager;
  TXAudioEffectManager? txAudioManager;

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

    completer.complete('success');
    return completer.future;
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
            .enterRoomAction(roomId, 'lecturer')
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
              showToast('已成功进入房间');
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
    setState(() {
      ifOpenCamera = !ifOpenCamera;
    });

    if (!ifOpenCamera) {
      trtcCloud!.stopLocalPreview();
    } else {
      trtcCloud!.startLocalPreview(cameraType == 'front', viewId);
    }
  }

  void handleChangeIfOpenMicrophone() {
    setState(() {
      ifOpenMicrophone = !ifOpenMicrophone;
    });

    if (!ifOpenMicrophone) {
      trtcCloud!.stopLocalAudio();
    } else {
      trtcCloud!.startLocalAudio(TRTCCloudDef.TRTC_AUDIO_QUALITY_SPEECH);
    }
  }

  void handleChangeCameraType() {
    setState(() {
      cameraType = cameraType == 'front' ? 'backend' : 'front';
    });
    txDeviceManager!.switchCamera(cameraType == 'front');
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
  }

  @override
  void dispose() {
    if (timer != null) {
      timer?.cancel();
    }
    if (trtcCloud != null) {
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
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(color: Colors.white),
          ),
          _readyLoad
              ? Positioned(
                  bottom: mediaQuerySafeInfo.bottom + 12 + 44 + 12,
                  right: 0,
                  child: Container(
                    width: mediaQuerySizeInfo.width / 5 * 2,
                    height: mediaQuerySizeInfo.width / 5 * 2 / 3 * 4,
                    decoration: const BoxDecoration(
                        color: Color.fromRGBO(33, 33, 33, 1)),
                    child: ifOpenCamera
                        ? TRTCCloudVideoView(onViewCreated: (int viewIdGet) {
                            handleSetViewId(viewIdGet);
                            trtcCloud!.startLocalPreview(true, viewIdGet);
                          })
                        : Center(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
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
                                      color: Color.fromRGBO(224, 222, 223, 1),
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold),
                                )
                              ],
                            ),
                          ),
                  ))
              : const SizedBox.shrink(),
          _readyLoad
              ? Positioned(
                  bottom: mediaQuerySafeInfo.bottom + 12,
                  left: 0,
                  right: 0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height: 44,
                        padding: const EdgeInsets.fromLTRB(12, 0, 12, 0),
                        decoration: const BoxDecoration(
                            color: Color.fromRGBO(33, 33, 33, 1),
                            borderRadius:
                                BorderRadius.all(Radius.circular(22))),
                        child: Row(
                          children: [
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
                                        : const Color.fromRGBO(88, 88, 88, 1)),
                                child: Center(
                                  child: ifOpenCamera
                                      ? IconFont(
                                          IconNames.shexiangtoukaiqi,
                                          size: 20,
                                          color: '#333',
                                        )
                                      : IconFont(
                                          IconNames.shexiangtouguanbi,
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
                              onTap: handleChangeIfOpenMicrophone,
                              child: Container(
                                width: 32,
                                height: 32,
                                decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(16)),
                                    color: ifOpenMicrophone
                                        ? Colors.white
                                        : const Color.fromRGBO(88, 88, 88, 1)),
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
                                    size: 20,
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
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(16)),
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
          Positioned(
              bottom: mediaQuerySafeInfo.bottom + 12 + 10,
              right: 12,
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
              )),
          Positioned(
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
                          borderRadius: BorderRadius.all(Radius.circular(12))),
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
              ))
        ],
      ),
    );
  }
}
