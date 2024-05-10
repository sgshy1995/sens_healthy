import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:sens_healthy/components/loading.dart';
import 'package:sens_healthy/components/toast.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';
import 'dart:math';
import '../../../../iconfont/icon_font.dart';

class MyAssetPickerTextDelegate extends AssetPickerTextDelegate {
  @override
  String get languageCode => 'zh'; // 强制修改语言代码为汉语
}

class Line extends CustomPainter {
  final Offset startPoint;
  final Offset endPoint;
  final double strokeWidth;
  final Color strokeColor;

  Line(this.startPoint, this.endPoint,
      {this.strokeWidth = 3,
      this.strokeColor = const Color.fromRGBO(254, 32, 52, 1)});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = strokeColor
      ..strokeWidth = strokeWidth;

    canvas.drawLine(startPoint, endPoint, paint);
  }

  @override
  bool shouldRepaint(Line oldDelegate) {
    return startPoint != oldDelegate.startPoint ||
        endPoint != oldDelegate.endPoint;
  }
}

class MineProfessinalSpinePage extends StatefulWidget {
  const MineProfessinalSpinePage({super.key});

  @override
  State<MineProfessinalSpinePage> createState() =>
      _MineProfessinalSpinePageState();
}

class _MineProfessinalSpinePageState extends State<MineProfessinalSpinePage>
    with SingleTickerProviderStateMixin {
  final GlobalKey _globalKeyRepaintBoundary = GlobalKey();
  late final AnimationController _controller;
  final Tween<double> _tween = Tween(begin: 0, end: 1);
  bool ifShowInfos = true;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
  }

  void handleHideOrShowTap() {
    if (_controller.isCompleted) {
      _controller.reverse();
      setState(() {
        ifShowInfos = true;
      });
    } else {
      _controller.forward();
      Future.delayed(const Duration(milliseconds: 300), () {
        setState(() {
          ifShowInfos = false;
        });
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String? localImage;

  //是否显示辅助线
  bool showLine2 = false;
  void handleChangeShowLine2() {
    setState(() {
      showLine2 = !showLine2;
      spineLine2PointsList = [
        Offset((Get.width - 3) / 2 - 60, 44),
        Offset(
            (Get.width - 3) / 2 - 60,
            Get.height -
                (Get.context!.mediaQueryPadding.top + 12 + 12 + 36 + 2) -
                Get.context!.mediaQueryPadding.bottom -
                100)
      ];
    });
    angel = getAngel();
  }

  //是否显示a1~a2
  bool showLineA = false;
  void handleChangeShowLineA() {
    setState(() {
      showLineA = !showLineA;
      spineLineA1PointsList = [
        const Offset(64, 160),
        Offset(Get.width - 64, 160)
      ];
      spineLineA2PointsList = [
        const Offset(64, 196),
        Offset(Get.width - 64, 196)
      ];
    });
    cobb1 = getCobb1();
  }

  //是否显示b1~b2
  bool showLineB = false;
  void handleChangeShowLineB() {
    setState(() {
      showLineB = !showLineB;
      spineLineB1PointsList = [
        const Offset(64, 228),
        Offset(Get.width - 64, 228)
      ];
      spineLineB2PointsList = [
        const Offset(64, 260),
        Offset(Get.width - 64, 260)
      ];
    });
    cobb2 = getCobb2();
  }

  //是否显示c1~c2
  bool showLineC = false;
  void handleChangeShowLineC() {
    setState(() {
      showLineC = !showLineC;
      spineLineC1PointsList = [
        const Offset(64, 292),
        Offset(Get.width - 64, 292)
      ];
      spineLineC2PointsList = [
        const Offset(64, 324),
        Offset(Get.width - 64, 324)
      ];
    });
    cobb3 = getCobb3();
  }

  //是否显示d1~d2
  bool showLineD = false;
  void handleChangeShowLineD() {
    setState(() {
      showLineD = !showLineD;
      spineLineD1PointsList = [
        const Offset(64, 356),
        Offset(Get.width - 64, 356)
      ];
      spineLineD2PointsList = [
        const Offset(64, 388),
        Offset(Get.width - 64, 388)
      ];
    });
    cobb4 = getCobb4();
  }

  //中垂线
  List<Offset> spineLine1PointsList = [
    Offset((Get.width - 3) / 2, 44),
    Offset(
        (Get.width - 3) / 2,
        Get.height -
            (Get.context!.mediaQueryPadding.top + 12 + 12 + 36 + 2) -
            Get.context!.mediaQueryPadding.bottom -
            100)
  ];

  //辅助线
  List<Offset> spineLine2PointsList = [
    Offset((Get.width - 3) / 2 - 60, 44),
    Offset(
        (Get.width - 3) / 2 - 60,
        Get.height -
            (Get.context!.mediaQueryPadding.top + 12 + 12 + 36 + 2) -
            Get.context!.mediaQueryPadding.bottom -
            100)
  ];

  //骨盆线
  List<Offset> spineLine3PointsList = [
    Offset(
        24,
        Get.height -
            (Get.context!.mediaQueryPadding.top + 12 + 12 + 36 + 2) -
            Get.context!.mediaQueryPadding.bottom -
            160),
    Offset(
        Get.width - 24,
        Get.height -
            (Get.context!.mediaQueryPadding.top + 12 + 12 + 36 + 2) -
            Get.context!.mediaQueryPadding.bottom -
            160)
  ];

  //a1~a2
  List<Offset> spineLineA1PointsList = [
    const Offset(64, 160),
    Offset(Get.width - 64, 160)
  ];
  List<Offset> spineLineA2PointsList = [
    const Offset(64, 196),
    Offset(Get.width - 64, 196)
  ];

  //b1~b2
  List<Offset> spineLineB1PointsList = [
    const Offset(64, 228),
    Offset(Get.width - 64, 228)
  ];
  List<Offset> spineLineB2PointsList = [
    const Offset(64, 260),
    Offset(Get.width - 64, 260)
  ];

  //c1~c2
  List<Offset> spineLineC1PointsList = [
    const Offset(64, 292),
    Offset(Get.width - 64, 292)
  ];
  List<Offset> spineLineC2PointsList = [
    const Offset(64, 324),
    Offset(Get.width - 64, 324)
  ];

  //d1~d2
  List<Offset> spineLineD1PointsList = [
    const Offset(64, 356),
    Offset(Get.width - 64, 356)
  ];
  List<Offset> spineLineD2PointsList = [
    const Offset(64, 388),
    Offset(Get.width - 64, 388)
  ];

  void handleGoBack() {
    Get.back();
  }

  //是否在拖动线段 方法
  bool isDraggingOnLine(Offset startPoint, Offset endPoint, Offset touchPoint) {
    final double distanceToStart = (touchPoint - startPoint).distance;
    final double distanceToEnd = (touchPoint - endPoint).distance;
    final double lineLength = (endPoint - startPoint).distance;
    const double tolerance = 2;
    return distanceToStart + distanceToEnd >= lineLength - tolerance &&
        distanceToStart + distanceToEnd <= lineLength + tolerance;
  }

  //弧度转角度
  double radiansToDegrees(double radians) {
    return (radians * 180 / pi).abs();
  }

  //线段夹角转-弧度
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

  //是否在拖动中垂线
  bool isDraggingLine1 = false;
  //是否在拖动辅助线起点
  bool isDraggingLine2Point1 = false;
  //是否在拖动辅助线终点
  bool isDraggingLine2Point2 = false;
  //是否在拖动辅助线
  bool isDraggingLine2 = false;
  //是否在拖动骨盆线
  bool isDraggingLine3 = false;

  //是否在拖动a1起点
  bool isDraggingA1LinePoint1 = false;
  //是否在拖动a1终点
  bool isDraggingA1LinePoint2 = false;
  //是否在拖动a1
  bool isDraggingA1Line = false;
  //是否在拖动a2起点
  bool isDraggingA2LinePoint1 = false;
  //是否在拖动a2终点
  bool isDraggingA2LinePoint2 = false;
  //是否在拖动a2
  bool isDraggingA2Line = false;

  //是否在拖动b1起点
  bool isDraggingB1LinePoint1 = false;
  //是否在拖动b1终点
  bool isDraggingB1LinePoint2 = false;
  //是否在拖动b1
  bool isDraggingB1Line = false;
  //是否在拖动b2起点
  bool isDraggingB2LinePoint1 = false;
  //是否在拖动b2终点
  bool isDraggingB2LinePoint2 = false;
  //是否在拖动b2
  bool isDraggingB2Line = false;

  //是否在拖动c1起点
  bool isDraggingC1LinePoint1 = false;
  //是否在拖动c1终点
  bool isDraggingC1LinePoint2 = false;
  //是否在拖动c1
  bool isDraggingC1Line = false;
  //是否在拖动c2起点
  bool isDraggingC2LinePoint1 = false;
  //是否在拖动c2终点
  bool isDraggingC2LinePoint2 = false;
  //是否在拖动c2
  bool isDraggingC2Line = false;

  //是否在拖动d1起点
  bool isDraggingD1LinePoint1 = false;
  //是否在拖动d1终点
  bool isDraggingD1LinePoint2 = false;
  //是否在拖动d1
  bool isDraggingD1Line = false;
  //是否在拖动d2起点
  bool isDraggingD2LinePoint1 = false;
  //是否在拖动d2终点
  bool isDraggingD2LinePoint2 = false;
  //是否在拖动d2
  bool isDraggingD2Line = false;

  handleOnPanStart(DragStartDetails detail) {
    //拖动中垂线
    if (isDraggingOnLine(spineLine1PointsList[0], spineLine1PointsList[1],
        detail.localPosition)) {
      if (!isDraggingLine1) {
        setState(() {
          isDraggingLine1 = true;
        });
      }
    }
    //拖动辅助线起点
    else if ((detail.localPosition - spineLine2PointsList[0]).distance <= 32 &&
        showLine2) {
      if (!isDraggingLine2Point1) {
        setState(() {
          isDraggingLine2Point1 = true;
        });
      }
    }
    //拖动辅助线终点
    else if ((detail.localPosition - spineLine2PointsList[1]).distance <= 32 &&
        showLine2) {
      if (!isDraggingLine2Point2) {
        setState(() {
          isDraggingLine2Point2 = true;
        });
      }
    }
    //拖动辅助线
    else if (isDraggingOnLine(spineLine2PointsList[0], spineLine2PointsList[1],
            detail.localPosition) &&
        showLine2) {
      if (!isDraggingLine2) {
        setState(() {
          isDraggingLine2 = true;
        });
      }
    }
    //拖动骨盆线
    else if (isDraggingOnLine(spineLine3PointsList[0], spineLine3PointsList[1],
        detail.localPosition)) {
      if (!isDraggingLine3) {
        setState(() {
          isDraggingLine3 = true;
        });
      }
    }
    //拖动a1线起点
    else if ((detail.localPosition - spineLineA1PointsList[0]).distance <= 32 &&
        showLineA) {
      if (!isDraggingA1LinePoint1) {
        setState(() {
          isDraggingA1LinePoint1 = true;
        });
      }
    }
    //拖动a1线终点
    else if ((detail.localPosition - spineLineA1PointsList[1]).distance <= 32 &&
        showLineA) {
      if (!isDraggingA1LinePoint2) {
        setState(() {
          isDraggingA1LinePoint2 = true;
        });
      }
    }
    //拖动a1线
    else if (isDraggingOnLine(spineLineA1PointsList[0],
            spineLineA1PointsList[1], detail.localPosition) &&
        showLineA) {
      if (!isDraggingA1Line) {
        setState(() {
          isDraggingA1Line = true;
        });
      }
    }
    //拖动a2线起点
    else if ((detail.localPosition - spineLineA2PointsList[0]).distance <= 32 &&
        showLineA) {
      if (!isDraggingA2LinePoint1) {
        setState(() {
          isDraggingA2LinePoint1 = true;
        });
      }
    }
    //拖动a2线终点
    else if ((detail.localPosition - spineLineA2PointsList[1]).distance <= 32 &&
        showLineA) {
      if (!isDraggingA2LinePoint2) {
        setState(() {
          isDraggingA2LinePoint2 = true;
        });
      }
    }
    //拖动a2线
    else if (isDraggingOnLine(spineLineA2PointsList[0],
            spineLineA2PointsList[1], detail.localPosition) &&
        showLineA) {
      if (!isDraggingA2Line) {
        setState(() {
          isDraggingA2Line = true;
        });
      }
    }

    //拖动b1线起点
    else if ((detail.localPosition - spineLineB1PointsList[0]).distance <= 32 &&
        showLineB) {
      if (!isDraggingB1LinePoint1) {
        setState(() {
          isDraggingB1LinePoint1 = true;
        });
      }
    }
    //拖动b1线终点
    else if ((detail.localPosition - spineLineB1PointsList[1]).distance <= 32 &&
        showLineB) {
      if (!isDraggingB1LinePoint2) {
        setState(() {
          isDraggingB1LinePoint2 = true;
        });
      }
    }
    //拖动b1线
    else if (isDraggingOnLine(spineLineB1PointsList[0],
            spineLineB1PointsList[1], detail.localPosition) &&
        showLineB) {
      if (!isDraggingB1Line) {
        setState(() {
          isDraggingB1Line = true;
        });
      }
    }
    //拖动b2线起点
    else if ((detail.localPosition - spineLineB2PointsList[0]).distance <= 32 &&
        showLineB) {
      if (!isDraggingB2LinePoint1) {
        setState(() {
          isDraggingB2LinePoint1 = true;
        });
      }
    }
    //拖动b2线终点
    else if ((detail.localPosition - spineLineB2PointsList[1]).distance <= 32 &&
        showLineB) {
      if (!isDraggingB2LinePoint2) {
        setState(() {
          isDraggingB2LinePoint2 = true;
        });
      }
    }
    //拖动b2线
    else if (isDraggingOnLine(spineLineB2PointsList[0],
            spineLineB2PointsList[1], detail.localPosition) &&
        showLineB) {
      if (!isDraggingB2Line) {
        setState(() {
          isDraggingB2Line = true;
        });
      }
    }

    //拖动c1线起点
    else if ((detail.localPosition - spineLineC1PointsList[0]).distance <= 32 &&
        showLineC) {
      if (!isDraggingC1LinePoint1) {
        setState(() {
          isDraggingC1LinePoint1 = true;
        });
      }
    }
    //拖动c1线终点
    else if ((detail.localPosition - spineLineC1PointsList[1]).distance <= 32 &&
        showLineC) {
      if (!isDraggingC1LinePoint2) {
        setState(() {
          isDraggingC1LinePoint2 = true;
        });
      }
    }
    //拖动c1线
    else if (isDraggingOnLine(spineLineC1PointsList[0],
            spineLineC1PointsList[1], detail.localPosition) &&
        showLineC) {
      if (!isDraggingC1Line) {
        setState(() {
          isDraggingC1Line = true;
        });
      }
    }
    //拖动c2线起点
    else if ((detail.localPosition - spineLineC2PointsList[0]).distance <= 32 &&
        showLineC) {
      if (!isDraggingC2LinePoint1) {
        setState(() {
          isDraggingC2LinePoint1 = true;
        });
      }
    }
    //拖动c2线终点
    else if ((detail.localPosition - spineLineC2PointsList[1]).distance <= 32 &&
        showLineC) {
      if (!isDraggingC2LinePoint2) {
        setState(() {
          isDraggingC2LinePoint2 = true;
        });
      }
    }
    //拖动c2线
    else if (isDraggingOnLine(spineLineC2PointsList[0],
            spineLineC2PointsList[1], detail.localPosition) &&
        showLineC) {
      if (!isDraggingC2Line) {
        setState(() {
          isDraggingC2Line = true;
        });
      }
    }

    //拖动d1线起点
    else if ((detail.localPosition - spineLineD1PointsList[0]).distance <= 32 &&
        showLineD) {
      if (!isDraggingD1LinePoint1) {
        setState(() {
          isDraggingD1LinePoint1 = true;
        });
      }
    }
    //拖动d1线终点
    else if ((detail.localPosition - spineLineD1PointsList[1]).distance <= 32 &&
        showLineD) {
      if (!isDraggingD1LinePoint2) {
        setState(() {
          isDraggingD1LinePoint2 = true;
        });
      }
    }
    //拖动d1线
    else if (isDraggingOnLine(spineLineD1PointsList[0],
            spineLineD1PointsList[1], detail.localPosition) &&
        showLineD) {
      if (!isDraggingD1Line) {
        setState(() {
          isDraggingD1Line = true;
        });
      }
    }
    //拖动d2线起点
    else if ((detail.localPosition - spineLineD2PointsList[0]).distance <= 32 &&
        showLineD) {
      if (!isDraggingD2LinePoint1) {
        setState(() {
          isDraggingD2LinePoint1 = true;
        });
      }
    }
    //拖动d2线终点
    else if ((detail.localPosition - spineLineD2PointsList[1]).distance <= 32 &&
        showLineD) {
      if (!isDraggingD2LinePoint2) {
        setState(() {
          isDraggingD2LinePoint2 = true;
        });
      }
    }
    //拖动d2线
    else if (isDraggingOnLine(spineLineD2PointsList[0],
            spineLineD2PointsList[1], detail.localPosition) &&
        showLineD) {
      if (!isDraggingD2Line) {
        setState(() {
          isDraggingD2Line = true;
        });
      }
    }
  }

  void handleOnPanEnd(DragEndDetails detail) {
    setState(() {
      isDraggingLine1 = false;
      isDraggingLine2Point1 = false;
      isDraggingLine2Point2 = false;
      isDraggingLine2 = false;
      isDraggingLine3 = false;
      //a1~a2
      isDraggingA1LinePoint1 = false;
      isDraggingA1LinePoint2 = false;
      isDraggingA1Line = false;
      isDraggingA2LinePoint1 = false;
      isDraggingA2LinePoint2 = false;
      isDraggingA2Line = false;
      //b1~b2
      isDraggingB1LinePoint1 = false;
      isDraggingB1LinePoint2 = false;
      isDraggingB1Line = false;
      isDraggingB2LinePoint1 = false;
      isDraggingB2LinePoint2 = false;
      isDraggingB2Line = false;
      //c1~c2
      isDraggingC1LinePoint1 = false;
      isDraggingC1LinePoint2 = false;
      isDraggingC1Line = false;
      isDraggingC2LinePoint1 = false;
      isDraggingC2LinePoint2 = false;
      isDraggingC2Line = false;
      //d1~d2
      isDraggingD1LinePoint1 = false;
      isDraggingD1LinePoint2 = false;
      isDraggingD1Line = false;
      isDraggingD2LinePoint1 = false;
      isDraggingD2LinePoint2 = false;
      isDraggingD2Line = false;
    });
  }

  void handleOnPanUpdate(DragUpdateDetails detail) {
    if (isDraggingLine1) {
      setState(() {
        spineLine1PointsList[0] += detail.delta;
        spineLine1PointsList[1] += detail.delta;
      });
    } else if (isDraggingLine2Point1) {
      setState(() {
        spineLine2PointsList[0] += detail.delta;
        angel = getAngel();
      });
    } else if (isDraggingLine2Point2) {
      setState(() {
        spineLine2PointsList[1] += detail.delta;
        angel = getAngel();
      });
    } else if (isDraggingLine2) {
      setState(() {
        spineLine2PointsList[0] += detail.delta;
        spineLine2PointsList[1] += detail.delta;
      });
    } else if (isDraggingLine3) {
      setState(() {
        spineLine3PointsList[0] += detail.delta;
        spineLine3PointsList[1] += detail.delta;
      });
    }

    //a1起点
    else if (isDraggingA1LinePoint1) {
      setState(() {
        spineLineA1PointsList[0] += detail.delta;
        cobb1 = getCobb1();
      });
    }
    //a1终点
    else if (isDraggingA1LinePoint2) {
      setState(() {
        spineLineA1PointsList[1] += detail.delta;
        cobb1 = getCobb1();
      });
    }
    //a1线
    else if (isDraggingA1Line) {
      setState(() {
        spineLineA1PointsList[0] += detail.delta;
        spineLineA1PointsList[1] += detail.delta;
      });
    }
    //a2起点
    else if (isDraggingA2LinePoint1) {
      setState(() {
        spineLineA2PointsList[0] += detail.delta;
        cobb1 = getCobb1();
      });
    }
    //a2终点
    else if (isDraggingA2LinePoint2) {
      setState(() {
        spineLineA2PointsList[1] += detail.delta;
        cobb1 = getCobb1();
      });
    }
    //a2线
    else if (isDraggingA2Line) {
      setState(() {
        spineLineA2PointsList[0] += detail.delta;
        spineLineA2PointsList[1] += detail.delta;
      });
    }

    //b1起点
    else if (isDraggingB1LinePoint1) {
      setState(() {
        spineLineB1PointsList[0] += detail.delta;
        cobb2 = getCobb2();
      });
    }
    //b1终点
    else if (isDraggingB1LinePoint2) {
      setState(() {
        spineLineB1PointsList[1] += detail.delta;
        cobb2 = getCobb2();
      });
    }
    //b1线
    else if (isDraggingB1Line) {
      setState(() {
        spineLineB1PointsList[0] += detail.delta;
        spineLineB1PointsList[1] += detail.delta;
      });
    }
    //b2起点
    else if (isDraggingB2LinePoint1) {
      setState(() {
        spineLineB2PointsList[0] += detail.delta;
        cobb2 = getCobb2();
      });
    }
    //b2终点
    else if (isDraggingB2LinePoint2) {
      setState(() {
        spineLineB2PointsList[1] += detail.delta;
        cobb2 = getCobb2();
      });
    }
    //b2线
    else if (isDraggingB2Line) {
      setState(() {
        spineLineB2PointsList[0] += detail.delta;
        spineLineB2PointsList[1] += detail.delta;
      });
    }

    //c1起点
    else if (isDraggingC1LinePoint1) {
      setState(() {
        spineLineC1PointsList[0] += detail.delta;
        cobb3 = getCobb3();
      });
    }
    //c1终点
    else if (isDraggingC1LinePoint2) {
      setState(() {
        spineLineC1PointsList[1] += detail.delta;
        cobb3 = getCobb3();
      });
    }
    //c1线
    else if (isDraggingC1Line) {
      setState(() {
        spineLineC1PointsList[0] += detail.delta;
        spineLineC1PointsList[1] += detail.delta;
      });
    }
    //c2起点
    else if (isDraggingC2LinePoint1) {
      setState(() {
        spineLineC2PointsList[0] += detail.delta;
        cobb3 = getCobb3();
      });
    }
    //c2终点
    else if (isDraggingC2LinePoint2) {
      setState(() {
        spineLineC2PointsList[1] += detail.delta;
        cobb3 = getCobb3();
      });
    }
    //c2线
    else if (isDraggingC2Line) {
      setState(() {
        spineLineC2PointsList[0] += detail.delta;
        spineLineC2PointsList[1] += detail.delta;
      });
    }

    //d1起点
    else if (isDraggingD1LinePoint1) {
      setState(() {
        spineLineD1PointsList[0] += detail.delta;
        cobb4 = getCobb4();
      });
    }
    //d1终点
    else if (isDraggingD1LinePoint2) {
      setState(() {
        spineLineD1PointsList[1] += detail.delta;
        cobb4 = getCobb4();
      });
    }
    //d1线
    else if (isDraggingD1Line) {
      setState(() {
        spineLineD1PointsList[0] += detail.delta;
        spineLineD1PointsList[1] += detail.delta;
      });
    }
    //d2起点
    else if (isDraggingD2LinePoint1) {
      setState(() {
        spineLineD2PointsList[0] += detail.delta;
        cobb4 = getCobb4();
      });
    }
    //d2终点
    else if (isDraggingD2LinePoint2) {
      setState(() {
        spineLineD2PointsList[1] += detail.delta;
        cobb4 = getCobb4();
      });
    }
    //d2线
    else if (isDraggingD2Line) {
      setState(() {
        spineLineD2PointsList[0] += detail.delta;
        spineLineD2PointsList[1] += detail.delta;
      });
    }
  }

  //angel角度
  double angel = 0;

  double getAngel() {
    final double angel1 = getAngleBetweenLines(
        spineLine1PointsList[0],
        spineLine1PointsList[1],
        spineLine2PointsList[0],
        spineLine2PointsList[1]);
    final double angel2 = radiansToDegrees(angel1);
    final double angel3 =
        double.parse((angel2 <= 90 ? angel2 : 180 - angel2).toStringAsFixed(2));
    return angel3;
  }

  //cobb角度
  double cobb1 = 0;
  double cobb2 = 0;
  double cobb3 = 0;
  double cobb4 = 0;

  double getCobb1() {
    final double angel1 = getAngleBetweenLines(
        spineLineA1PointsList[0],
        spineLineA1PointsList[1],
        spineLineA2PointsList[0],
        spineLineA2PointsList[1]);
    final double angel2 = radiansToDegrees(angel1);
    final double angel3 =
        double.parse((angel2 <= 90 ? angel2 : 180 - angel2).toStringAsFixed(2));
    return angel3;
  }

  double getCobb2() {
    final double angel1 = getAngleBetweenLines(
        spineLineB1PointsList[0],
        spineLineB1PointsList[1],
        spineLineB2PointsList[0],
        spineLineB2PointsList[1]);
    final double angel2 = radiansToDegrees(angel1);
    final double angel3 =
        double.parse((angel2 <= 90 ? angel2 : 180 - angel2).toStringAsFixed(2));
    return angel3;
  }

  double getCobb3() {
    final double angel1 = getAngleBetweenLines(
        spineLineC1PointsList[0],
        spineLineC1PointsList[1],
        spineLineC2PointsList[0],
        spineLineC2PointsList[1]);
    final double angel2 = radiansToDegrees(angel1);
    final double angel3 =
        double.parse((angel2 <= 90 ? angel2 : 180 - angel2).toStringAsFixed(2));
    return angel3;
  }

  double getCobb4() {
    final double angel1 = getAngleBetweenLines(
        spineLineD1PointsList[0],
        spineLineD1PointsList[1],
        spineLineD2PointsList[0],
        spineLineD2PointsList[1]);
    final double angel2 = radiansToDegrees(angel1);
    final double angel3 =
        double.parse((angel2 <= 90 ? angel2 : 180 - angel2).toStringAsFixed(2));
    return angel3;
  }

  //保存图片
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
  }

  void handleUseCamera() async {}

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
          Column(children: [
            Container(
              color: Colors.white,
              padding:
                  EdgeInsets.fromLTRB(12, mediaQuerySafeInfo.top + 12, 12, 12),
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
                    const Text('脊柱角度测量',
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
                                fit: BoxFit.fitWidth,
                              )
                            : null,
                        color: (localImage != null || assetEntityGet != null)
                            ? Colors.white
                            : const Color.fromRGBO(33, 33, 33, 1),
                      ),
                      child: Stack(children: [
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
                        localImage != null || assetEntityGet != null
                            ? CustomPaint(
                                painter: Line(spineLine3PointsList[0],
                                    spineLine3PointsList[1],
                                    strokeWidth: 2,
                                    strokeColor:
                                        const Color.fromRGBO(38, 221, 118, 1)),
                              )
                            : const SizedBox.shrink(),
                        localImage != null || assetEntityGet != null
                            ? CustomPaint(
                                painter: Line(spineLine1PointsList[0],
                                    spineLine1PointsList[1],
                                    strokeWidth: 2,
                                    strokeColor:
                                        const Color.fromRGBO(254, 31, 51, 1)),
                              )
                            : const SizedBox.shrink(),
                        showLine2
                            ? CustomPaint(
                                painter: Line(spineLine2PointsList[0],
                                    spineLine2PointsList[1],
                                    strokeWidth: 2,
                                    strokeColor:
                                        const Color.fromRGBO(254, 31, 51, 1)),
                              )
                            : const SizedBox.shrink(),
                        //a1
                        showLineA
                            ? CustomPaint(
                                painter: Line(spineLineA1PointsList[0],
                                    spineLineA1PointsList[1],
                                    strokeWidth: 2,
                                    strokeColor:
                                        const Color.fromRGBO(0, 127, 245, 1)),
                              )
                            : const SizedBox.shrink(),
                        //a2
                        showLineA
                            ? CustomPaint(
                                painter: Line(spineLineA2PointsList[0],
                                    spineLineA2PointsList[1],
                                    strokeWidth: 2,
                                    strokeColor:
                                        const Color.fromRGBO(0, 127, 245, 1)),
                              )
                            : const SizedBox.shrink(),
                        //b1
                        showLineB
                            ? CustomPaint(
                                painter: Line(spineLineB1PointsList[0],
                                    spineLineB1PointsList[1],
                                    strokeWidth: 2,
                                    strokeColor:
                                        const Color.fromRGBO(0, 89, 186, 1)),
                              )
                            : const SizedBox.shrink(),
                        //b2
                        showLineB
                            ? CustomPaint(
                                painter: Line(spineLineB2PointsList[0],
                                    spineLineB2PointsList[1],
                                    strokeWidth: 2,
                                    strokeColor:
                                        const Color.fromRGBO(0, 89, 186, 1)),
                              )
                            : const SizedBox.shrink(),
                        //c1
                        showLineC
                            ? CustomPaint(
                                painter: Line(spineLineC1PointsList[0],
                                    spineLineC1PointsList[1],
                                    strokeWidth: 2,
                                    strokeColor:
                                        const Color.fromRGBO(0, 63, 124, 1)),
                              )
                            : const SizedBox.shrink(),
                        //c2
                        showLineC
                            ? CustomPaint(
                                painter: Line(spineLineC2PointsList[0],
                                    spineLineC2PointsList[1],
                                    strokeWidth: 2,
                                    strokeColor:
                                        const Color.fromRGBO(0, 63, 124, 1)),
                              )
                            : const SizedBox.shrink(),
                        //d1
                        showLineD
                            ? CustomPaint(
                                painter: Line(spineLineD1PointsList[0],
                                    spineLineD1PointsList[1],
                                    strokeWidth: 2,
                                    strokeColor:
                                        const Color.fromRGBO(0, 40, 74, 1)),
                              )
                            : const SizedBox.shrink(),
                        //d2
                        showLineD
                            ? CustomPaint(
                                painter: Line(spineLineD2PointsList[0],
                                    spineLineD2PointsList[1],
                                    strokeWidth: 2,
                                    strokeColor:
                                        const Color.fromRGBO(0, 40, 74, 1)),
                              )
                            : const SizedBox.shrink(),
                        localImage != null || assetEntityGet != null
                            ? Positioned(
                                top: spineLine3PointsList[0].dy - 26,
                                left: spineLine3PointsList[0].dx - 20,
                                child: const Text(
                                  '骨盆线',
                                  style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                      color: Color.fromRGBO(38, 221, 118, 1)),
                                ))
                            : const SizedBox.shrink(),
                        localImage != null || assetEntityGet != null
                            ? Positioned(
                                top: spineLine1PointsList[0].dy - 26,
                                left: spineLine1PointsList[0].dx - 20,
                                child: const Text(
                                  '中垂线',
                                  style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                      color: Color.fromRGBO(254, 31, 51, 1)),
                                ))
                            : const SizedBox.shrink(),
                        showLine2
                            ? Positioned(
                                top: spineLine2PointsList[0].dy - 26,
                                left: spineLine2PointsList[0].dx - 20,
                                child: const Text(
                                  '辅助线',
                                  style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                      color: Color.fromRGBO(254, 31, 51, 1)),
                                ))
                            : const SizedBox.shrink(),
                        //a1
                        showLineA
                            ? Positioned(
                                top: spineLineA1PointsList[0].dy - 10,
                                left: spineLineA1PointsList[0].dx - 32,
                                child: const Text(
                                  'A1',
                                  style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                      color: Color.fromRGBO(0, 127, 245, 1)),
                                ))
                            : const SizedBox.shrink(),
                        showLineA
                            ? Positioned(
                                top: spineLineA1PointsList[1].dy - 10,
                                left: spineLineA1PointsList[1].dx + 14,
                                child: const Text(
                                  'A1',
                                  style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                      color: Color.fromRGBO(0, 127, 245, 1)),
                                ))
                            : const SizedBox.shrink(),
                        //a2
                        showLineA
                            ? Positioned(
                                top: spineLineA2PointsList[0].dy - 10,
                                left: spineLineA2PointsList[0].dx - 32,
                                child: const Text(
                                  'A2',
                                  style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                      color: Color.fromRGBO(0, 127, 245, 1)),
                                ))
                            : const SizedBox.shrink(),
                        showLineA
                            ? Positioned(
                                top: spineLineA2PointsList[1].dy - 10,
                                left: spineLineA2PointsList[1].dx + 14,
                                child: const Text(
                                  'A2',
                                  style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                      color: Color.fromRGBO(0, 127, 245, 1)),
                                ))
                            : const SizedBox.shrink(),
                        //b1
                        showLineB
                            ? Positioned(
                                top: spineLineB1PointsList[0].dy - 10,
                                left: spineLineB1PointsList[0].dx - 32,
                                child: const Text(
                                  'B1',
                                  style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                      color: Color.fromRGBO(0, 89, 186, 1)),
                                ))
                            : const SizedBox.shrink(),
                        showLineB
                            ? Positioned(
                                top: spineLineB1PointsList[1].dy - 10,
                                left: spineLineB1PointsList[1].dx + 14,
                                child: const Text(
                                  'B1',
                                  style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                      color: Color.fromRGBO(0, 89, 186, 1)),
                                ))
                            : const SizedBox.shrink(),
                        //b2
                        showLineB
                            ? Positioned(
                                top: spineLineB2PointsList[0].dy - 10,
                                left: spineLineB2PointsList[0].dx - 32,
                                child: const Text(
                                  'B2',
                                  style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                      color: Color.fromRGBO(0, 89, 186, 1)),
                                ))
                            : const SizedBox.shrink(),
                        showLineB
                            ? Positioned(
                                top: spineLineB2PointsList[1].dy - 10,
                                left: spineLineB2PointsList[1].dx + 14,
                                child: const Text(
                                  'B2',
                                  style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                      color: Color.fromRGBO(0, 89, 186, 1)),
                                ))
                            : const SizedBox.shrink(),
                        //c1
                        showLineC
                            ? Positioned(
                                top: spineLineC1PointsList[0].dy - 10,
                                left: spineLineC1PointsList[0].dx - 32,
                                child: const Text(
                                  'C1',
                                  style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                      color: Color.fromRGBO(0, 63, 124, 1)),
                                ))
                            : const SizedBox.shrink(),
                        showLineC
                            ? Positioned(
                                top: spineLineC1PointsList[1].dy - 10,
                                left: spineLineC1PointsList[1].dx + 14,
                                child: const Text(
                                  'C1',
                                  style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                      color: Color.fromRGBO(0, 63, 124, 1)),
                                ))
                            : const SizedBox.shrink(),
                        //c2
                        showLineC
                            ? Positioned(
                                top: spineLineC2PointsList[0].dy - 10,
                                left: spineLineC2PointsList[0].dx - 32,
                                child: const Text(
                                  'C2',
                                  style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                      color: Color.fromRGBO(0, 63, 124, 1)),
                                ))
                            : const SizedBox.shrink(),
                        showLineC
                            ? Positioned(
                                top: spineLineC2PointsList[1].dy - 10,
                                left: spineLineC2PointsList[1].dx + 14,
                                child: const Text(
                                  'C2',
                                  style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                      color: Color.fromRGBO(0, 63, 124, 1)),
                                ))
                            : const SizedBox.shrink(),
                        //d1
                        showLineD
                            ? Positioned(
                                top: spineLineD1PointsList[0].dy - 10,
                                left: spineLineD1PointsList[0].dx - 32,
                                child: const Text(
                                  'D1',
                                  style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                      color: Color.fromRGBO(0, 40, 74, 1)),
                                ))
                            : const SizedBox.shrink(),
                        showLineD
                            ? Positioned(
                                top: spineLineD1PointsList[1].dy - 10,
                                left: spineLineD1PointsList[1].dx + 14,
                                child: const Text(
                                  'D1',
                                  style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                      color: Color.fromRGBO(0, 40, 74, 1)),
                                ))
                            : const SizedBox.shrink(),
                        //d2
                        showLineD
                            ? Positioned(
                                top: spineLineD2PointsList[0].dy - 10,
                                left: spineLineD2PointsList[0].dx - 32,
                                child: const Text(
                                  'D2',
                                  style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                      color: Color.fromRGBO(0, 40, 74, 1)),
                                ))
                            : const SizedBox.shrink(),
                        showLineD
                            ? Positioned(
                                top: spineLineD2PointsList[1].dy - 10,
                                left: spineLineD2PointsList[1].dx + 14,
                                child: const Text(
                                  'D2',
                                  style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                      color: Color.fromRGBO(0, 40, 74, 1)),
                                ))
                            : const SizedBox.shrink(),
                        showLine2
                            ? Positioned(
                                top: spineLine2PointsList[0].dy - 6,
                                left: spineLine2PointsList[0].dx - 6,
                                child: Container(
                                  width: 12,
                                  height: 12,
                                  decoration: BoxDecoration(
                                      color: const Color.fromRGBO(
                                          255, 255, 255, 1),
                                      borderRadius: const BorderRadius.all(
                                        Radius.circular(6),
                                      ),
                                      border: Border.all(
                                          width: 2,
                                          color: const Color.fromRGBO(
                                              254, 31, 51, 1))),
                                ))
                            : const SizedBox.shrink(),
                        showLine2
                            ? Positioned(
                                top: spineLine2PointsList[1].dy - 6,
                                left: spineLine2PointsList[1].dx - 6,
                                child: Container(
                                  width: 12,
                                  height: 12,
                                  decoration: BoxDecoration(
                                      color: const Color.fromRGBO(
                                          255, 255, 255, 1),
                                      borderRadius: const BorderRadius.all(
                                        Radius.circular(6),
                                      ),
                                      border: Border.all(
                                          width: 2,
                                          color: const Color.fromRGBO(
                                              254, 31, 51, 1))),
                                ))
                            : const SizedBox.shrink(),
                        //a1
                        showLineA
                            ? Positioned(
                                top: spineLineA1PointsList[0].dy - 6,
                                left: spineLineA1PointsList[0].dx - 6,
                                child: Container(
                                  width: 12,
                                  height: 12,
                                  decoration: BoxDecoration(
                                      color: const Color.fromRGBO(
                                          255, 255, 255, 1),
                                      borderRadius: const BorderRadius.all(
                                        Radius.circular(6),
                                      ),
                                      border: Border.all(
                                          width: 2,
                                          color: const Color.fromRGBO(
                                              0, 127, 245, 1))),
                                ))
                            : const SizedBox.shrink(),
                        showLineA
                            ? Positioned(
                                top: spineLineA1PointsList[1].dy - 6,
                                left: spineLineA1PointsList[1].dx - 6,
                                child: Container(
                                  width: 12,
                                  height: 12,
                                  decoration: BoxDecoration(
                                      color: const Color.fromRGBO(
                                          255, 255, 255, 1),
                                      borderRadius: const BorderRadius.all(
                                        Radius.circular(6),
                                      ),
                                      border: Border.all(
                                          width: 2,
                                          color: const Color.fromRGBO(
                                              0, 127, 245, 1))),
                                ))
                            : const SizedBox.shrink(),
                        //a2
                        showLineA
                            ? Positioned(
                                top: spineLineA2PointsList[0].dy - 6,
                                left: spineLineA2PointsList[0].dx - 6,
                                child: Container(
                                  width: 12,
                                  height: 12,
                                  decoration: BoxDecoration(
                                      color: const Color.fromRGBO(
                                          255, 255, 255, 1),
                                      borderRadius: const BorderRadius.all(
                                        Radius.circular(6),
                                      ),
                                      border: Border.all(
                                          width: 2,
                                          color: const Color.fromRGBO(
                                              0, 127, 245, 1))),
                                ))
                            : const SizedBox.shrink(),
                        showLineA
                            ? Positioned(
                                top: spineLineA2PointsList[1].dy - 6,
                                left: spineLineA2PointsList[1].dx - 6,
                                child: Container(
                                  width: 12,
                                  height: 12,
                                  decoration: BoxDecoration(
                                      color: const Color.fromRGBO(
                                          255, 255, 255, 1),
                                      borderRadius: const BorderRadius.all(
                                        Radius.circular(6),
                                      ),
                                      border: Border.all(
                                          width: 2,
                                          color: const Color.fromRGBO(
                                              0, 127, 245, 1))),
                                ))
                            : const SizedBox.shrink(),
                        //b1
                        showLineB
                            ? Positioned(
                                top: spineLineB1PointsList[0].dy - 6,
                                left: spineLineB1PointsList[0].dx - 6,
                                child: Container(
                                  width: 12,
                                  height: 12,
                                  decoration: BoxDecoration(
                                      color: const Color.fromRGBO(
                                          255, 255, 255, 1),
                                      borderRadius: const BorderRadius.all(
                                        Radius.circular(6),
                                      ),
                                      border: Border.all(
                                          width: 2,
                                          color: const Color.fromRGBO(
                                              0, 89, 186, 1))),
                                ))
                            : const SizedBox.shrink(),
                        showLineB
                            ? Positioned(
                                top: spineLineB1PointsList[1].dy - 6,
                                left: spineLineB1PointsList[1].dx - 6,
                                child: Container(
                                  width: 12,
                                  height: 12,
                                  decoration: BoxDecoration(
                                      color: const Color.fromRGBO(
                                          255, 255, 255, 1),
                                      borderRadius: const BorderRadius.all(
                                        Radius.circular(6),
                                      ),
                                      border: Border.all(
                                          width: 2,
                                          color: const Color.fromRGBO(
                                              0, 89, 186, 1))),
                                ))
                            : const SizedBox.shrink(),
                        //b2
                        showLineB
                            ? Positioned(
                                top: spineLineB2PointsList[0].dy - 6,
                                left: spineLineB2PointsList[0].dx - 6,
                                child: Container(
                                  width: 12,
                                  height: 12,
                                  decoration: BoxDecoration(
                                      color: const Color.fromRGBO(
                                          255, 255, 255, 1),
                                      borderRadius: const BorderRadius.all(
                                        Radius.circular(6),
                                      ),
                                      border: Border.all(
                                          width: 2,
                                          color: const Color.fromRGBO(
                                              0, 89, 186, 1))),
                                ))
                            : const SizedBox.shrink(),
                        showLineB
                            ? Positioned(
                                top: spineLineB2PointsList[1].dy - 6,
                                left: spineLineB2PointsList[1].dx - 6,
                                child: Container(
                                  width: 12,
                                  height: 12,
                                  decoration: BoxDecoration(
                                      color: const Color.fromRGBO(
                                          255, 255, 255, 1),
                                      borderRadius: const BorderRadius.all(
                                        Radius.circular(6),
                                      ),
                                      border: Border.all(
                                          width: 2,
                                          color: const Color.fromRGBO(
                                              0, 89, 186, 1))),
                                ))
                            : const SizedBox.shrink(),
                        //c1
                        showLineC
                            ? Positioned(
                                top: spineLineC1PointsList[0].dy - 6,
                                left: spineLineC1PointsList[0].dx - 6,
                                child: Container(
                                  width: 12,
                                  height: 12,
                                  decoration: BoxDecoration(
                                      color: const Color.fromRGBO(
                                          255, 255, 255, 1),
                                      borderRadius: const BorderRadius.all(
                                        Radius.circular(6),
                                      ),
                                      border: Border.all(
                                          width: 2,
                                          color: const Color.fromRGBO(
                                              0, 63, 124, 1))),
                                ))
                            : const SizedBox.shrink(),
                        showLineC
                            ? Positioned(
                                top: spineLineC1PointsList[1].dy - 6,
                                left: spineLineC1PointsList[1].dx - 6,
                                child: Container(
                                  width: 12,
                                  height: 12,
                                  decoration: BoxDecoration(
                                      color: const Color.fromRGBO(
                                          255, 255, 255, 1),
                                      borderRadius: const BorderRadius.all(
                                        Radius.circular(6),
                                      ),
                                      border: Border.all(
                                          width: 2,
                                          color: const Color.fromRGBO(
                                              0, 63, 124, 1))),
                                ))
                            : const SizedBox.shrink(),
                        //c2
                        showLineC
                            ? Positioned(
                                top: spineLineC2PointsList[0].dy - 6,
                                left: spineLineC2PointsList[0].dx - 6,
                                child: Container(
                                  width: 12,
                                  height: 12,
                                  decoration: BoxDecoration(
                                      color: const Color.fromRGBO(
                                          255, 255, 255, 1),
                                      borderRadius: const BorderRadius.all(
                                        Radius.circular(6),
                                      ),
                                      border: Border.all(
                                          width: 2,
                                          color: const Color.fromRGBO(
                                              0, 63, 124, 1))),
                                ))
                            : const SizedBox.shrink(),
                        showLineC
                            ? Positioned(
                                top: spineLineC2PointsList[1].dy - 6,
                                left: spineLineC2PointsList[1].dx - 6,
                                child: Container(
                                  width: 12,
                                  height: 12,
                                  decoration: BoxDecoration(
                                      color: const Color.fromRGBO(
                                          255, 255, 255, 1),
                                      borderRadius: const BorderRadius.all(
                                        Radius.circular(6),
                                      ),
                                      border: Border.all(
                                          width: 2,
                                          color: const Color.fromRGBO(
                                              0, 63, 124, 1))),
                                ))
                            : const SizedBox.shrink(),
                        //d1
                        showLineD
                            ? Positioned(
                                top: spineLineD1PointsList[0].dy - 6,
                                left: spineLineD1PointsList[0].dx - 6,
                                child: Container(
                                  width: 12,
                                  height: 12,
                                  decoration: BoxDecoration(
                                      color: const Color.fromRGBO(
                                          255, 255, 255, 1),
                                      borderRadius: const BorderRadius.all(
                                        Radius.circular(6),
                                      ),
                                      border: Border.all(
                                          width: 2,
                                          color: const Color.fromRGBO(
                                              0, 40, 74, 1))),
                                ))
                            : const SizedBox.shrink(),
                        showLineD
                            ? Positioned(
                                top: spineLineD1PointsList[1].dy - 6,
                                left: spineLineD1PointsList[1].dx - 6,
                                child: Container(
                                  width: 12,
                                  height: 12,
                                  decoration: BoxDecoration(
                                      color: const Color.fromRGBO(
                                          255, 255, 255, 1),
                                      borderRadius: const BorderRadius.all(
                                        Radius.circular(6),
                                      ),
                                      border: Border.all(
                                          width: 2,
                                          color: const Color.fromRGBO(
                                              0, 40, 74, 1))),
                                ))
                            : const SizedBox.shrink(),
                        //d2
                        showLineD
                            ? Positioned(
                                top: spineLineD2PointsList[0].dy - 6,
                                left: spineLineD2PointsList[0].dx - 6,
                                child: Container(
                                  width: 12,
                                  height: 12,
                                  decoration: BoxDecoration(
                                      color: const Color.fromRGBO(
                                          255, 255, 255, 1),
                                      borderRadius: const BorderRadius.all(
                                        Radius.circular(6),
                                      ),
                                      border: Border.all(
                                          width: 2,
                                          color: const Color.fromRGBO(
                                              0, 40, 74, 1))),
                                ))
                            : const SizedBox.shrink(),
                        showLineD
                            ? Positioned(
                                top: spineLineD2PointsList[1].dy - 6,
                                left: spineLineD2PointsList[1].dx - 6,
                                child: Container(
                                  width: 12,
                                  height: 12,
                                  decoration: BoxDecoration(
                                      color: const Color.fromRGBO(
                                          255, 255, 255, 1),
                                      borderRadius: const BorderRadius.all(
                                        Radius.circular(6),
                                      ),
                                      border: Border.all(
                                          width: 2,
                                          color: const Color.fromRGBO(
                                              0, 40, 74, 1))),
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
                            : const SizedBox.shrink(),
                        (showLine2 ||
                                showLineA ||
                                showLineB ||
                                showLineC ||
                                showLineD)
                            ? Positioned(
                                right: 12,
                                top: 12,
                                child: AnimatedBuilder(
                                  animation: _tween.animate(_controller),
                                  builder: (context, child) {
                                    double value = _tween.evaluate(_controller);
                                    return Transform.translate(
                                      offset: Offset(value * 300, 0),
                                      child: child,
                                    );
                                  },
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      GestureDetector(
                                        onTap: handleHideOrShowTap,
                                        child: Container(
                                          width: 20,
                                          height: 20,
                                          color: Colors.transparent,
                                          child: Center(
                                            child: IconFont(
                                              IconNames.xiangyou,
                                              size: 20,
                                              color: '#fff',
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 6,
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          showLine2
                                              ? Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.end,
                                                  children: [
                                                    Container(
                                                      height: 32,
                                                      padding: const EdgeInsets
                                                          .fromLTRB(
                                                          12, 0, 12, 0),
                                                      decoration: const BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          10)),
                                                          color: Colors.white),
                                                      child: Center(
                                                        child: Text(
                                                          'angel: $angel°',
                                                          style: const TextStyle(
                                                              color:
                                                                  Colors.black,
                                                              fontSize: 14,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                      ),
                                                    ),
                                                    const SizedBox(
                                                      height: 12,
                                                    ),
                                                  ],
                                                )
                                              : const SizedBox.shrink(),
                                          showLineA
                                              ? Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.end,
                                                  children: [
                                                    Container(
                                                      height: 32,
                                                      padding: const EdgeInsets
                                                          .fromLTRB(
                                                          12, 0, 12, 0),
                                                      decoration: const BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          10)),
                                                          color: Colors.white),
                                                      child: Center(
                                                        child: Text(
                                                          'cobb1: $cobb1°',
                                                          style: const TextStyle(
                                                              color:
                                                                  Colors.black,
                                                              fontSize: 14,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                      ),
                                                    ),
                                                    const SizedBox(
                                                      height: 12,
                                                    ),
                                                  ],
                                                )
                                              : const SizedBox.shrink(),
                                          showLineB
                                              ? Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.end,
                                                  children: [
                                                    Container(
                                                      height: 32,
                                                      padding: const EdgeInsets
                                                          .fromLTRB(
                                                          12, 0, 12, 0),
                                                      decoration: const BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          10)),
                                                          color: Colors.white),
                                                      child: Center(
                                                        child: Text(
                                                          'cobb2: $cobb2°',
                                                          style: const TextStyle(
                                                              color:
                                                                  Colors.black,
                                                              fontSize: 14,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                      ),
                                                    ),
                                                    const SizedBox(
                                                      height: 12,
                                                    ),
                                                  ],
                                                )
                                              : const SizedBox.shrink(),
                                          showLineC
                                              ? Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.end,
                                                  children: [
                                                    Container(
                                                      height: 32,
                                                      padding: const EdgeInsets
                                                          .fromLTRB(
                                                          12, 0, 12, 0),
                                                      decoration: const BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          10)),
                                                          color: Colors.white),
                                                      child: Center(
                                                        child: Text(
                                                          'cobb3: $cobb3°',
                                                          style: const TextStyle(
                                                              color:
                                                                  Colors.black,
                                                              fontSize: 14,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                      ),
                                                    ),
                                                    const SizedBox(
                                                      height: 12,
                                                    ),
                                                  ],
                                                )
                                              : const SizedBox.shrink(),
                                          showLineD
                                              ? Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.end,
                                                  children: [
                                                    Container(
                                                      height: 32,
                                                      padding: const EdgeInsets
                                                          .fromLTRB(
                                                          12, 0, 12, 0),
                                                      decoration: const BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          10)),
                                                          color: Colors.white),
                                                      child: Center(
                                                        child: Text(
                                                          'cobb4: $cobb4°',
                                                          style: const TextStyle(
                                                              color:
                                                                  Colors.black,
                                                              fontSize: 14,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                      ),
                                                    ),
                                                    const SizedBox(
                                                      height: 12,
                                                    ),
                                                  ],
                                                )
                                              : const SizedBox.shrink(),
                                        ],
                                      )
                                    ],
                                  ),
                                ))
                            : const SizedBox.shrink()
                      ]))),
            ))
          ]),
          //(localImage != null)
          localImage != null || assetEntityGet != null
              ? Positioned(
                  left: 12,
                  bottom: mediaQuerySafeInfo.bottom + 12,
                  child: GestureDetector(
                    onTap: saveImage,
                    child: Container(
                      width: 44,
                      height: 44,
                      decoration: const BoxDecoration(
                          color: Color.fromRGBO(0, 0, 0, 1),
                          borderRadius: BorderRadius.all(Radius.circular(22))),
                      child: Center(
                        child: IconFont(
                          IconNames.baocun,
                          size: 24,
                          color: 'rgb(255, 255, 255)',
                        ),
                      ),
                    ),
                  ))
              : const SizedBox.shrink(),
          localImage != null || assetEntityGet != null
              ? Positioned(
                  right: 12,
                  bottom: mediaQuerySafeInfo.bottom + 12,
                  child: GestureDetector(
                    onTap: handleChangeShowLine2,
                    child: Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(22)),
                          color: showLine2 ? Colors.white : Colors.black),
                      child: Center(
                        child: IconFont(
                          IconNames.fuzhuxian,
                          size: 24,
                          color: showLine2 ? '#000' : '#fff',
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
                    onTap: handleChangeShowLineA,
                    child: Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(22)),
                          color: !showLineA
                              ? Colors.black
                              : const Color.fromRGBO(0, 127, 245, 1)),
                      child: const Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'A',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            'cobb1',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ))
              : const SizedBox.shrink(),
          localImage != null || assetEntityGet != null
              ? Positioned(
                  right: 12 + 44 + 12 + 44 + 12,
                  bottom: mediaQuerySafeInfo.bottom + 12,
                  child: GestureDetector(
                    onTap: handleChangeShowLineB,
                    child: Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(22)),
                          color: !showLineB
                              ? Colors.black
                              : const Color.fromRGBO(0, 89, 186, 1)),
                      child: const Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'B',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            'cobb2',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ))
              : const SizedBox.shrink(),
          localImage != null || assetEntityGet != null
              ? Positioned(
                  right: 12 + 44 + 12 + 44 + 12 + 44 + 12,
                  bottom: mediaQuerySafeInfo.bottom + 12,
                  child: GestureDetector(
                    onTap: handleChangeShowLineC,
                    child: Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(22)),
                          color: !showLineC
                              ? Colors.black
                              : const Color.fromRGBO(0, 63, 124, 1)),
                      child: const Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'C',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            'cobb3',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ))
              : const SizedBox.shrink(),
          localImage != null || assetEntityGet != null
              ? Positioned(
                  right: 12 + 44 + 12 + 44 + 12 + 44 + 12 + 44 + 12,
                  bottom: mediaQuerySafeInfo.bottom + 12,
                  child: GestureDetector(
                    onTap: handleChangeShowLineD,
                    child: Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(22)),
                          color: !showLineD
                              ? Colors.black
                              : const Color.fromRGBO(0, 40, 74, 1)),
                      child: const Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'D',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            'cobb4',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ))
              : const SizedBox.shrink(),
          localImage != null || assetEntityGet != null
              ? Positioned(
                  right: 12,
                  bottom: mediaQuerySafeInfo.bottom + 12 + 44 + 12,
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
          !ifShowInfos
              ? Positioned(
                  top: (mediaQuerySafeInfo.top + 12 + 12 + 36) + 2 + 12,
                  right: 0,
                  child: GestureDetector(
                    onTap: handleHideOrShowTap,
                    child: Container(
                      width: 20,
                      height: 20,
                      color: Colors.transparent,
                      child: Center(
                        child: IconFont(
                          IconNames.xiangzuo,
                          size: 20,
                          color: '#fff',
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
