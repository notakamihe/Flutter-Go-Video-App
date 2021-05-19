import "package:flutter/material.dart";
import 'package:video_player/video_player.dart';
import 'package:frontend/views/video_detail.dart';

class VideoView extends StatefulWidget {
  @override
  _VideoViewState createState() => _VideoViewState();
}

class _VideoViewState extends State<VideoView> {
  VideoPlayerController _controller;
  Future<void> _initializeVideoPlayerFuture;

  @override
  void initState() {
     _controller = VideoPlayerController.network(
      'https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4',
    );

    _initializeVideoPlayerFuture = _controller.initialize();

    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (_controller.value.isPlaying) {
          _controller.pause();
        } else {
          _controller.play();
        }
      },
      onLongPress: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => VideoDetailView()));
      },
      child: Container(
        width: MediaQuery.of(context).size.width * 0.45,
        margin: EdgeInsets.all(8),
        child: Column(
          children: [
            Container(
              height: MediaQuery.of(context).size.width * 0.45,
              child: FutureBuilder(
                future: _initializeVideoPlayerFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    return AspectRatio(
                      aspectRatio: 1,
                      child: VideoPlayer(_controller, ),
                    );
                  } else {
                    return Center(child: CircularProgressIndicator());
                  }
                },
              )
            ),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.yellow.shade100,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(7), 
                  bottomRight: Radius.circular(7)
                )
              ),
              child: Row(
                children: [
                  Padding(padding: EdgeInsets.only(right: 8)),
                  Row(
                    children: [
                      Text("3K"),
                      Padding(padding: EdgeInsets.only(right: 4)),
                      Icon(Icons.remove_red_eye, size: 16,),
                    ],
                  ),
                  Padding(padding: EdgeInsets.only(right: 12)),
                  Row(
                    children: [
                      Text("1K"),
                      Padding(padding: EdgeInsets.only(right: 4)),
                      Icon(Icons.favorite, size: 16,),
                    ],
                  ),
                ],
              ),
            )
          ]
        ),
      ),
    );
  }
}