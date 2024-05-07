import 'package:flutter/material.dart';
import 'package:chewie/chewie.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter/services.dart';

// 定义回调函数类型
typedef VideoPlayCallback = void Function(String durationString);

// 定义回调函数类型
typedef VideoIsInitializedCallback = void Function();

class VideoPlayerModule extends StatefulWidget {
  final VideoPlayCallback? videoPlayCallback;
  final VideoIsInitializedCallback? videoIsInitializedCallback;
  final String url;
  final bool autoPlay;
  final bool looping;
  final Duration? seekDuration;
  const VideoPlayerModule(
      {super.key,
      this.seekDuration,
      this.videoPlayCallback,
      this.videoIsInitializedCallback,
      required this.url,
      this.looping = false,
      this.autoPlay = false});

  @override
  State<VideoPlayerModule> createState() => VideoPlayerModuleState();
}

class VideoPlayerModuleState extends State<VideoPlayerModule> {
  VideoPlayerController? videoPlayerController;
  ChewieController? _chewieController;
  Chewie? playerWidget;

  bool ifFirstIsInitialized = false;

  void initVideo({String? newUrl}) async {
    setState(() {
      videoPlayerController =
          VideoPlayerController.networkUrl(Uri.parse(newUrl ?? widget.url));
      // 添加监听器
      videoPlayerController!.addListener(_videoListener);
    });
    await videoPlayerController?.initialize().then((_) {
      // 预加载视频
      if (widget.seekDuration != null) {
        videoPlayerController!.seekTo(widget.seekDuration!); //初始位置
      }
      videoPlayerController!.setLooping(true); // 设置循环播放
      videoPlayerController!.pause(); // 暂停播放
    });
    setState(() {
      _chewieController = ChewieController(
        deviceOrientationsAfterFullScreen: [
          DeviceOrientation.portraitUp,
          DeviceOrientation.portraitDown,
        ],
        videoPlayerController: videoPlayerController!,
        autoPlay: widget.autoPlay,
        looping: widget.looping,
        playbackSpeeds: const [0.5, 1, 1.5, 2, 3],
        placeholder: Container(
          color: const Color.fromRGBO(0, 0, 0, 1),
        ),
      );
      // 添加监听器
      _chewieController!.addListener(_chewieListener);
      playerWidget = Chewie(
        controller: _chewieController!,
      );
    });
  }

  void updateVideoUrl(String newUrl) {
    videoPlayerController!.pause();
    videoPlayerController!.seekTo(const Duration(seconds: 0));
    videoPlayerController!.removeListener(() {});

    setState(() {
      _chewieController!.removeListener(() {});
      _chewieController!.dispose();
    });

    initVideo(newUrl: newUrl);
  }

  // Chewie状态变化的监听器
  void _chewieListener() {
    // if (_chewieController!.isFullScreen) {
    //   // 当Chewie进入全屏模式时执行的操作
    //   print('Chewie is in full screen mode');
    // } else {
    //   // 当Chewie退出全屏模式时执行的操作
    //   print('Chewie is not in full screen mode');
    //   SystemChrome.setPreferredOrientations([
    //     DeviceOrientation.portraitUp, // 竖屏
    //     DeviceOrientation.portraitDown,
    //   ]);
    // }
  }

  // Video状态变化的监听器
  void _videoListener() {
    Duration currentTime = videoPlayerController!.value.position;
    String formattedDuration =
        '${currentTime.inHours.toString().padLeft(2, '0')}:${(currentTime.inMinutes % 60).toString().padLeft(2, '0')}:${(currentTime.inSeconds % 60).toString().padLeft(2, '0')}';
    print(formattedDuration); // Output: 1:12:13
    if (widget.videoPlayCallback != null) {
      widget.videoPlayCallback!(formattedDuration);
    }

    if (videoPlayerController!.value.isInitialized && !ifFirstIsInitialized) {
      print('isInitialized');
      if (widget.videoIsInitializedCallback != null) {
        widget.videoIsInitializedCallback!();
      }
      setState(() {
        ifFirstIsInitialized = true;
      });
    }

    // if (_chewieController!.isFullScreen) {
    //   // 当Chewie进入全屏模式时执行的操作
    //   print('Chewie is in full screen mode');
    // } else {
    //   // 当Chewie退出全屏模式时执行的操作
    //   print('Chewie is not in full screen mode');
    //   SystemChrome.setPreferredOrientations([
    //     DeviceOrientation.portraitUp, // 竖屏
    //     DeviceOrientation.portraitDown,
    //   ]);
    // }
  }

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    initVideo();
  }

  @override
  void dispose() {
    videoPlayerController?.dispose();
    _chewieController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: _chewieController != null &&
                _chewieController!.videoPlayerController.value.isInitialized
            ? Chewie(
                controller: _chewieController!,
              )
            : Container(
                color: const Color.fromRGBO(0, 0, 0, 1),
                child: const Center(
                  child: SizedBox(
                    width: 32,
                    height: 32,
                    child: CircularProgressIndicator(
                        color: Color.fromRGBO(200, 200, 200, 1),
                        strokeWidth: 4),
                  ),
                ),
              ));
  }
}
