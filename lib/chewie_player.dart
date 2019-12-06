import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import 'video_info.dart';

class ChewiePlayer extends StatefulWidget {
  final VideoInfo video;

  const ChewiePlayer({Key key, @required this.video}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ChewiePlayerState();
}

class _ChewiePlayerState extends State<ChewiePlayer> {
  ChewieController chewieController;
  VideoPlayerController videoPlayerController;

  @override
  void initState() {
    super.initState();
    videoPlayerController =
        VideoPlayerController.network(widget.video.videoUrl);
    chewieController = ChewieController(
      videoPlayerController: videoPlayerController,
      autoPlay: true,
      autoInitialize: true,
      aspectRatio: widget.video.aspectRatio,
      placeholder: Center(
        child: Image.network(widget.video.coverUrl),
      ),
    );
  }

  @override
  void dispose() {
    if (chewieController != null) chewieController.dispose();
    if (videoPlayerController != null) videoPlayerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: <Widget>[
          Chewie(
            controller: chewieController,
          ),
          Container(
            padding: EdgeInsets.all(30),
            child: IconButton(
              icon: Icon(
                Icons.close,
                color: Colors.white,
              ),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ],
      ),
    );
  }
}
