import 'package:flutter/material.dart';
import 'package:chewie/chewie.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter/services.dart';

class VideoPlayerModule extends StatefulWidget {
  final String url;
  final bool autoPlay;
  final bool looping;
  const VideoPlayerModule(
      {super.key,
      required this.url,
      this.looping = false,
      this.autoPlay = false});

  @override
  State<VideoPlayerModule> createState() => _VideoPlayerModuleState();
}

class _VideoPlayerModuleState extends State<VideoPlayerModule> {
  VideoPlayerController? videoPlayerController;
  ChewieController? _chewieController;
  Chewie? playerWidget;

  void initVideo() async {
    setState(() {
      videoPlayerController =
          VideoPlayerController.networkUrl(Uri.parse(widget.url));
    });
    await videoPlayerController?.initialize().then((_) {
      // 预加载视频
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
