import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:sens_healthy/components/loading.dart';
import 'package:sens_healthy/components/toast.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';
import 'package:wechat_camera_picker/wechat_camera_picker.dart';
import 'dart:math';
import '../../../../iconfont/icon_font.dart';

class MyAssetPickerTextDelegate extends AssetPickerTextDelegate {
  @override
  String get languageCode => 'zh'; // 强制修改语言代码为汉语
}

class MyCameraPickerTextDelegate extends CameraPickerTextDelegate {
  @override
  String get languageCode => 'zh'; // 强制修改语言代码为汉语
}

class Line extends CustomPainter {
  final Offset startPoint;
  final Offset endPoint;
  final Color paintColor;

  Line(this.startPoint, this.endPoint, {required this.paintColor});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = paintColor
      ..strokeWidth = 3;

    canvas.drawLine(startPoint, endPoint, paint);
  }

  @override
  bool shouldRepaint(Line oldDelegate) {
    return startPoint != oldDelegate.startPoint ||
        endPoint != oldDelegate.endPoint;
  }
}

// 定义回调函数类型
typedef AngleDegreeCallback = void Function(double angleDegree);

class AnglePainter extends CustomPainter {
  final Offset startPoint1;
  final Offset endPoint1;
  final Offset startPoint2;
  final Offset endPoint2;

  late AngleDegreeCallback angleDegreeCallback;

  AnglePainter(this.startPoint1, this.endPoint1, this.startPoint2,
      this.endPoint2, this.angleDegreeCallback);

  @override
  void paint(Canvas canvas, Size size) {
    final intersection =
        getIntersectionPoint(startPoint1, endPoint1, startPoint2, endPoint2);
    final angle =
        getAngleBetweenLines(startPoint1, endPoint1, startPoint2, endPoint2);

    //向外传出夹角
    final double angleDegree = radiansToDegrees(angle);
    angleDegreeCallback(angleDegree);

    final angelLine1 = calculateAngle(
        startPoint1.dx, startPoint1.dy, endPoint1.dx, endPoint1.dy);

    final paint = Paint()
      ..color = Colors.red
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0;

    if (intersection != null) {
      final rect = Rect.fromCircle(center: intersection, radius: 20);
      final startAngle =
          getStartAngle(startPoint1, endPoint1, startPoint2, endPoint2);
      final sweepAngle = angle.abs();

      canvas.drawArc(
          rect,
          angle > 0 ? (pi + angelLine1) : (pi + angle + angelLine1),
          sweepAngle,
          false,
          paint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }

  //弧度转角度
  double radiansToDegrees(double radians) {
    return (radians * 180 / pi).abs();
  }

  //获取线段和水平线夹角-弧度
  double calculateAngle(double x1, double y1, double x2, double y2) {
    double dx = x2 - x1;
    double dy = y2 - y1;

    double angleInRadians = atan2(dy, dx);
    double angleInRadiansAbs = angleInRadians.abs();
    double angleInRadiansLimited =
        angleInRadiansAbs > pi ? 2 * pi - angleInRadiansAbs : angleInRadians;

    return angleInRadiansLimited;
  }

  Offset? getIntersectionPoint(
      Offset start1, Offset end1, Offset start2, Offset end2) {
    final x1 = start1.dx;
    final y1 = start1.dy;
    final x2 = end1.dx;
    final y2 = end1.dy;
    final x3 = start2.dx;
    final y3 = start2.dy;
    final x4 = end2.dx;
    final y4 = end2.dy;

    final determinant = (x1 - x2) * (y3 - y4) - (y1 - y2) * (x3 - x4);
    if (determinant == 0) {
      return null; // Lines are parallel
    }

    final intersectionX =
        ((x1 * y2 - y1 * x2) * (x3 - x4) - (x1 - x2) * (x3 * y4 - y3 * x4)) /
            determinant;
    final intersectionY =
        ((x1 * y2 - y1 * x2) * (y3 - y4) - (y1 - y2) * (x3 * y4 - y3 * x4)) /
            determinant;

    return Offset(intersectionX, intersectionY);
  }

  double getAngleBetweenLines(
      Offset start1, Offset end1, Offset start2, Offset end2) {
    final vector1 = end1 - start1;
    final vector2 = end2 - start2;
    final crossProduct = vector1.dx * vector2.dy - vector1.dy * vector2.dx;
    final dotProduct = vector1.dx * vector2.dx + vector1.dy * vector2.dy;
    final length1 = sqrt(vector1.dx * vector1.dx + vector1.dy * vector1.dy);
    final length2 = sqrt(vector2.dx * vector2.dx + vector2.dy * vector2.dy);
    final cosTheta = dotProduct / (length1 * length2);
    final theta = acos(cosTheta);
    return crossProduct.isNegative ? -theta : theta;
  }

  double getStartAngle(Offset start1, Offset end1, Offset start2, Offset end2) {
    final vector1 = end1 - start1;
    final vector2 = end2 - start2;
    final crossProduct = vector1.dx * vector2.dy - vector1.dy * vector2.dx;
    return crossProduct.isNegative ? 0 : pi;
  }
}

class Line1 extends Line {
  Line1(super.startPoint, super.endPoint, {required super.paintColor});
}

class Line2 extends Line {
  Line2(super.startPoint, super.endPoint, {required super.paintColor});
}

class MineProfessinalJointPage extends StatefulWidget {
  const MineProfessinalJointPage({super.key});

  @override
  State<MineProfessinalJointPage> createState() =>
      _MineProfessinalJointPageState();
}

class _MineProfessinalJointPageState extends State<MineProfessinalJointPage> {
  final GlobalKey _globalKeyRepaintBoundary = GlobalKey();
  final GlobalKey _customPaintState1 = GlobalKey();
  final GlobalKey _customPaintState2 = GlobalKey();

  String? localImage;

  bool ifDrawing = false;

  bool isDraggingStartPoint1 = false;
  bool isDraggingStartPoint2 = false;
  bool isDraggingStartPoint3 = false;
  bool isDraggingWhole = false;

  List<Offset> startPointsList = [];

  void handleGoBack() {
    Get.back();
  }

  void handleTapContainer(TapUpDetails detail) {
    if (ifDrawing) {
      if (startPointsList.length < 3) {
        setState(() {
          startPointsList.add(detail.localPosition);
        });
        if (startPointsList.length == 3) {
          setState(() {
            ifDrawing = false;
          });
        }
      } else {
        setState(() {
          ifDrawing = false;
        });
      }
    }
  }

  handleOnPanStart(DragStartDetails detail) {
    if (startPointsList.length == 3) {
      //拖动第一个点
      if ((detail.localPosition - startPointsList[0]).distance <= 32) {
        if (!isDraggingStartPoint1) {
          setState(() {
            isDraggingStartPoint1 = true;
          });
        }
      }
      //拖动第二个点
      else if ((detail.localPosition - startPointsList[1]).distance <= 32) {
        if (!isDraggingStartPoint2) {
          setState(() {
            isDraggingStartPoint2 = true;
          });
        }
      }
      //拖动第三个点
      else if ((detail.localPosition - startPointsList[2]).distance <= 32) {
        if (!isDraggingStartPoint3) {
          setState(() {
            isDraggingStartPoint3 = true;
          });
        }
      }
      //拖动线段
      else if (isDraggingOnLine(
              startPointsList[0], startPointsList[1], detail.localPosition) ||
          isDraggingOnLine(
              startPointsList[1], startPointsList[2], detail.localPosition)) {
        if (!isDraggingWhole) {
          setState(() {
            isDraggingWhole = true;
          });
        }
      }
    }
  }

  void handleOnPanEnd(DragEndDetails detail) {
    setState(() {
      isDraggingStartPoint1 = false;
      isDraggingStartPoint2 = false;
      isDraggingStartPoint3 = false;
      isDraggingWhole = false;
    });
  }

  void handleOnPanUpdate(DragUpdateDetails detail) {
    if (isDraggingStartPoint1) {
      setState(() {
        startPointsList[0] += detail.delta;
      });
    } else if (isDraggingStartPoint2) {
      setState(() {
        startPointsList[1] += detail.delta;
      });
    } else if (isDraggingStartPoint3) {
      setState(() {
        startPointsList[2] += detail.delta;
      });
    } else if (isDraggingWhole) {
      setState(() {
        startPointsList[0] += detail.delta;
        startPointsList[1] += detail.delta;
        startPointsList[2] += detail.delta;
      });
    }
  }

  bool isDraggingOnLine(Offset startPoint, Offset endPoint, Offset touchPoint) {
    final double distanceToStart = (touchPoint - startPoint).distance;
    final double distanceToEnd = (touchPoint - endPoint).distance;
    final double lineLength = (endPoint - startPoint).distance;
    const double tolerance = 20;
    return distanceToStart + distanceToEnd >= lineLength - tolerance &&
        distanceToStart + distanceToEnd <= lineLength + tolerance;
  }

  double? angleDegree;

  void angleDegreeCallback(double angleDegreeGet) {
    double roundedAngleDegreeGet =
        double.parse(angleDegreeGet.toStringAsFixed(2));
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      // 在下一帧更新界面
      setState(() {
        // 更新界面的操作
        angleDegree = roundedAngleDegreeGet;
      });
    });
  }

  void handleStartOrStopDraw() {
    setState(() {
      isDraggingStartPoint1 = false;
      isDraggingStartPoint2 = false;
      isDraggingStartPoint3 = false;
      isDraggingWhole = false;

      startPointsList = [];
      angleDegree = null;
    });
    setState(() {
      ifDrawing = !ifDrawing;
    });
  }

  AssetEntity? assetEntityGet;

  void handleChooseImage() async {
    Get.back();

    final List<AssetEntity>? resultGet = await AssetPicker.pickAssets(
      context,
      pickerConfig: AssetPickerConfig(
          textDelegate: MyAssetPickerTextDelegate(),
          requestType: RequestType.image,
          themeColor: const Color.fromRGBO(211, 66, 67, 1),
          maxAssets: 1),
    );

    if (resultGet != null) {
      handleGenerateAssetEntities(resultGet);
    }
  }

  void handleUseCamera() async {
    Get.back();

    final AssetEntity? resultGet = await CameraPicker.pickFromCamera(
      context,
      pickerConfig: CameraPickerConfig(
          textDelegate: MyCameraPickerTextDelegate(),
          enableRecording: false,
          theme: CameraPicker.themeData(const Color.fromRGBO(211, 66, 67, 1))),
    );

    if (resultGet != null) {
      handleGenerateAssetEntities([resultGet]);
    }
  }

  void handleGenerateAssetEntities(List<AssetEntity> resultGet) async {
    final AssetEntity assetEntity = resultGet[0];
    if (GetPlatform.isAndroid) {
      setState(() {
        assetEntityGet = assetEntity;
      });
    }
    // 在此处处理异步操作，例如网络请求、文件读写等
    final fileGet = await assetEntity.file;
    final localPath = fileGet!.path;
    if (GetPlatform.isIOS) {
      setState(() {
        localImage = localPath;
      });
    }
  }

  void saveImage() async {
    showLoading('请稍后...');
    RenderObject? boundary =
        _globalKeyRepaintBoundary.currentContext!.findRenderObject();
    RenderRepaintBoundary repaintBoundary =
        boundary as RenderRepaintBoundary; // 转换为RenderRepaintBoundary
    final image = await repaintBoundary.toImage(pixelRatio: 2.0);

    ByteData? byteData = await image.toByteData(format: ImageByteFormat.png);
    Uint8List pngBytes = byteData!.buffer.asUint8List();

    final result = await ImageGallerySaver.saveImage(pngBytes, quality: 100);
    hideLoading();
    if (result['isSuccess']) {
      showToast('保存成功');
    } else {
      showToast('保存失败，请重试');
    }
  }

  String paintColorString = '#fff';
  Color paintColor = Colors.black;

  void handleChangeColor() {
    setState(() {
      paintColorString = paintColorString == '#000' ? '#fff' : '#000';
      paintColor = paintColor == Colors.black ? Colors.white : Colors.black;
    });
    State<StatefulWidget>? customPaintState1 = _customPaintState1.currentState;
    customPaintState1?.setState(() {});
    State<StatefulWidget>? customPaintState2 = _customPaintState2.currentState;
    customPaintState2?.setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final EdgeInsets mediaQuerySafeInfo = MediaQuery.of(context).padding;
    final Size mediaQuerySizeInfo = MediaQuery.of(context).size;

    void handleShowPicturesOrCanmera() {
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
                          onTap: handleChooseImage,
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
          }).then((value) {});
    }

    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: [
              Container(
                color: Colors.white,
                padding: EdgeInsets.fromLTRB(
                    12, mediaQuerySafeInfo.top + 12, 12, 12),
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
                      const Text('关节角度测量',
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
                  child: GestureDetector(
                onPanStart: handleOnPanStart,
                onPanEnd: handleOnPanEnd,
                onPanUpdate: handleOnPanUpdate,
                onTapUp: handleTapContainer,
                child: RepaintBoundary(
                  key: _globalKeyRepaintBoundary,
                  child: Container(
                    width: double.infinity,
                    height: mediaQuerySizeInfo.height -
                        (mediaQuerySafeInfo.top + 12 + 12 + 36) -
                        2,
                    decoration: BoxDecoration(
                      image: localImage != null
                          ? DecorationImage(
                              image: AssetImage(localImage!),
                              fit: BoxFit.contain,
                            )
                          : null,
                      color: (localImage != null || assetEntityGet != null)
                          ? Colors.white
                          : const Color.fromRGBO(33, 33, 33, 1),
                    ),
                    child: Stack(
                      children: [
                        assetEntityGet != null
                            ? SizedBox(
                                width: double.infinity,
                                height: mediaQuerySizeInfo.height -
                                    (mediaQuerySafeInfo.top + 12 + 12 + 36) -
                                    2,
                                child: AssetEntityImage(
                                  assetEntityGet!,
                                  isOriginal: true,
                                  fit: BoxFit.fitWidth,
                                ),
                              )
                            : const SizedBox.shrink(),
                        startPointsList.length >= 2
                            ? CustomPaint(
                                key: _customPaintState1,
                                painter: Line(
                                    startPointsList[0], startPointsList[1],
                                    paintColor: paintColor),
                              )
                            : const SizedBox.shrink(),
                        startPointsList.length >= 3
                            ? CustomPaint(
                                key: _customPaintState2,
                                painter: Line(
                                    startPointsList[1], startPointsList[2],
                                    paintColor: paintColor),
                              )
                            : const SizedBox.shrink(),
                        startPointsList.length >= 3
                            ? CustomPaint(
                                painter: AnglePainter(
                                    startPointsList[0],
                                    startPointsList[1],
                                    startPointsList[2],
                                    startPointsList[1],
                                    angleDegreeCallback),
                              )
                            : const SizedBox.shrink(),
                        startPointsList.isNotEmpty
                            ? Positioned(
                                top: startPointsList[0].dy - 6,
                                left: startPointsList[0].dx - 6,
                                child: Container(
                                  width: 12,
                                  height: 12,
                                  decoration: BoxDecoration(
                                      color: paintColor == Colors.black
                                          ? Colors.white
                                          : Colors.black,
                                      borderRadius: const BorderRadius.all(
                                        Radius.circular(6),
                                      ),
                                      border: Border.all(
                                          width: 2, color: paintColor)),
                                ))
                            : const SizedBox.shrink(),
                        startPointsList.length >= 2
                            ? Positioned(
                                top: startPointsList[1].dy - 6,
                                left: startPointsList[1].dx - 6,
                                child: Container(
                                  width: 12,
                                  height: 12,
                                  decoration: BoxDecoration(
                                      color: paintColor == Colors.black
                                          ? Colors.white
                                          : Colors.black,
                                      borderRadius: const BorderRadius.all(
                                        Radius.circular(6),
                                      ),
                                      border: Border.all(
                                          width: 2, color: paintColor)),
                                ))
                            : const SizedBox.shrink(),
                        startPointsList.length >= 3
                            ? Positioned(
                                top: startPointsList[2].dy - 6,
                                left: startPointsList[2].dx - 6,
                                child: Container(
                                  width: 12,
                                  height: 12,
                                  decoration: BoxDecoration(
                                      color: paintColor == Colors.black
                                          ? Colors.white
                                          : Colors.black,
                                      borderRadius: const BorderRadius.all(
                                        Radius.circular(6),
                                      ),
                                      border: Border.all(
                                          width: 2, color: paintColor)),
                                ))
                            : const SizedBox.shrink(),
                        angleDegree != null
                            ? Positioned(
                                top: 24,
                                left: 0,
                                right: 0,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      height: 32,
                                      padding: const EdgeInsets.fromLTRB(
                                          12, 0, 12, 0),
                                      decoration: const BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10))),
                                      child: Center(
                                        child: Text(
                                          '当前测量角度: $angleDegree°',
                                          style: const TextStyle(
                                              color: Colors.black,
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    )
                                  ],
                                ))
                            : const SizedBox.shrink(),
                        localImage == null && assetEntityGet == null
                            ? Center(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      width: 100,
                                      height: 100,
                                      child: Image.asset(
                                        'assets/images/empty_image.png',
                                        fit: BoxFit.contain,
                                      ),
                                    ),
                                    const Text(
                                      '请先选择照片',
                                      style: TextStyle(
                                          color:
                                              Color.fromRGBO(224, 222, 223, 1),
                                          fontSize: 14),
                                    ),
                                    GestureDetector(
                                      onTap: handleShowPicturesOrCanmera,
                                      child: Container(
                                        width: 44,
                                        height: 44,
                                        decoration: const BoxDecoration(
                                            color: Color.fromRGBO(
                                                224, 222, 223, 1),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(22))),
                                        margin: const EdgeInsets.only(top: 24),
                                        child: Center(
                                          child: IconFont(
                                            IconNames.tianjia,
                                            size: 24,
                                            color: '#333',
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              )
                            : const SizedBox.shrink()
                      ],
                    ),
                  ),
                ),
              ))
            ],
          ),
          localImage != null || assetEntityGet != null
              ? Positioned(
                  right: 12,
                  bottom: mediaQuerySafeInfo.bottom + 12,
                  child: GestureDetector(
                    onTap: handleShowPicturesOrCanmera,
                    child: Container(
                      width: 44,
                      height: 44,
                      decoration: const BoxDecoration(
                          color: Color.fromRGBO(0, 0, 0, 1),
                          borderRadius: BorderRadius.all(Radius.circular(22))),
                      child: Center(
                        child: IconFont(
                          IconNames.tupian,
                          size: 24,
                          color: 'rgb(255, 255, 255)',
                        ),
                      ),
                    ),
                  ))
              : const SizedBox.shrink(),
          localImage != null || assetEntityGet != null
              ? Positioned(
                  right: 12 + 44 + 12,
                  bottom: mediaQuerySafeInfo.bottom + 12,
                  child: GestureDetector(
                    onTap: handleStartOrStopDraw,
                    child: Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                          color: ifDrawing
                              ? const Color.fromRGBO(211, 66, 67, 1)
                              : const Color.fromRGBO(0, 0, 0, 1),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(22))),
                      child: Center(
                        child: IconFont(
                          IconNames.huizhiguiji,
                          size: 24,
                          color: 'rgb(255, 255, 255)',
                        ),
                      ),
                    ),
                  ))
              : const SizedBox.shrink(),
          (localImage != null || assetEntityGet != null)
              ? Positioned(
                  right: 12 + 44 + 12 + 44 + 12,
                  bottom: mediaQuerySafeInfo.bottom + 12,
                  child: GestureDetector(
                    onTap: handleChangeColor,
                    child: Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(22)),
                          color: paintColor),
                      child: Center(
                        child: IconFont(
                          IconNames.tuse,
                          size: 24,
                          color: paintColorString,
                        ),
                      ),
                    ),
                  ))
              : const SizedBox.shrink(),
          ((localImage != null || assetEntityGet != null) &&
                  startPointsList.length == 3)
              ? Positioned(
                  left: 12,
                  bottom: mediaQuerySafeInfo.bottom + 12,
                  child: GestureDetector(
                    onTap: saveImage,
                    child: Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                          color: ifDrawing
                              ? const Color.fromRGBO(211, 66, 67, 1)
                              : const Color.fromRGBO(0, 0, 0, 1),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(22))),
                      child: Center(
                        child: IconFont(
                          IconNames.baocun,
                          size: 24,
                          color: 'rgb(255, 255, 255)',
                        ),
                      ),
                    ),
                  ))
              : const SizedBox.shrink()
        ],
      ),
    );
  }
}
