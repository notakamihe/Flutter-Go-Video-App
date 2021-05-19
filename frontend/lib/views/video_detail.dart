import 'dart:async';

import "package:flutter/material.dart";
import 'package:frontend/views/user_detail.dart';
import 'package:video_player/video_player.dart';

class VideoDetailView extends StatefulWidget {
  @override
  _VideoDetailViewState createState() => _VideoDetailViewState();
}

class _VideoDetailViewState extends State<VideoDetailView> {
  VideoPlayerController _controller;
  Future<void> _initializeVideoPlayerFuture;

  String currentTime = "";
  String duration = "";

  bool _isPlaying = false;
  double _volume = 100;

  bool isLiked = false;

  @override
  void initState() {
     _controller = VideoPlayerController.network(
      'https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4',
    );

    _initializeVideoPlayerFuture = _controller.initialize();

    if (this._isPlaying) {
      this._controller.pause();
    } else {
      this._controller.play();
    }

    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();

    super.dispose();
  }

  void togglePlay() {
    setState(() {
      this._isPlaying = !this._isPlaying;

      if (this._isPlaying) {
        this._controller.pause();
      } else {
        this._controller.play();
      }
    });
  }

  void setDuration(duration) {
    String minutes = (duration.inMinutes % 60).toString();
    String seconds = (duration.inSeconds % 60).toString();

    if (mounted) {
      setState(() {
        this.duration = minutes.padLeft(2, '0') + ":" + seconds.padLeft(2, '0');
      });

      Timer.periodic(new Duration(seconds: 1), (timer) {
        this.setCurrentTime(this._controller.value.position);
      });
    }
  }

  void setCurrentTime(duration) {
    String minutes = (duration.inMinutes % 60).toString();
    String seconds = (duration.inSeconds % 60).toString();

    if (mounted) {
      setState(() {
        this.currentTime = minutes.padLeft(2, '0') + ":" + seconds.padLeft(2, '0');
      });
    }
  }

  void setVolume(double value) {
    setState(() {
      this._volume = value;
      this._controller.setVolume(this._volume / 100);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Video by User"),
        backgroundColor: Colors.amber, 
      ),
      body: SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: [
              Container(
                child: FutureBuilder(
                  future: _initializeVideoPlayerFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      Future.delayed(Duration.zero, () async {
                        this.setDuration(this._controller.value.duration);
                      });

                      return AspectRatio(
                        aspectRatio: _controller.value.aspectRatio,
                        child: Stack(
                          children: [
                            VideoPlayer(_controller, ),
                            Align(
                              child: Container(
                                margin: EdgeInsets.only(top: 8, right: 8),
                                padding: EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  color: Colors.black.withAlpha(100),
                                  borderRadius: BorderRadius.circular(16)
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Icon(Icons.remove_red_eye, size: 14, color: Colors.white,),
                                    Padding(padding: EdgeInsets.only(right: 4)),
                                    Text("3K", style: TextStyle(color: Colors.white, fontSize: 14),),
                                  ],
                                ),
                              ),
                              alignment: Alignment.topRight,
                            )
                          ],
                          alignment: Alignment.center,
                        )
                      );
                    } else {
                      return Center(child: CircularProgressIndicator());
                    }
                  },
                )
              ),
              Container(
                padding: EdgeInsets.all(16),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Text(
                              "$currentTime ", 
                              style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold,color: Colors.amber
                              )
                            ),
                            Text("| $duration", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                          ]
                        ),
                        Row(
                          children: [
                            Container(
                              child: IconButton(
                                icon: Icon(Icons.replay, color: Colors.white,) ,
                                padding: EdgeInsets.zero,
                                constraints: BoxConstraints(),
                                onPressed: () {_controller.seekTo(Duration.zero);}
                              ),
                              decoration: BoxDecoration(
                                color: Colors.amber,
                                borderRadius: BorderRadius.circular(100)
                              ),
                              padding: EdgeInsets.all(6),
                            ),
                            Padding(padding: EdgeInsets.symmetric(horizontal: 4),),
                            Container(
                              child: IconButton(
                                icon: Icon(Icons.fast_rewind, color: Colors.white,) ,
                                padding: EdgeInsets.zero,
                                constraints: BoxConstraints(),
                                onPressed: () async {
                                  _controller.seekTo(await _controller.position - Duration(seconds: 10));
                                }
                              ),
                              decoration: BoxDecoration(
                                color: Colors.amber,
                                borderRadius: BorderRadius.circular(100)
                              ),
                              padding: EdgeInsets.all(6),
                            ),
                            Padding(padding: EdgeInsets.symmetric(horizontal: 4),),
                            _controller.value.isPlaying ?
                            Container(
                              child: IconButton(
                                icon: Icon(Icons.pause, color: Colors.white,) ,
                                padding: EdgeInsets.zero,
                                constraints: BoxConstraints(),
                                onPressed: togglePlay
                              ),
                              decoration: BoxDecoration(
                                color: Colors.amber,
                                borderRadius: BorderRadius.circular(100)
                              ),
                              padding: EdgeInsets.all(6),
                            ) : 
                            Container(
                              child: IconButton(
                                icon: Icon(Icons.play_arrow, color: Colors.white,) ,
                                padding: EdgeInsets.zero,
                                constraints: BoxConstraints(),
                                onPressed: togglePlay
                              ),
                              decoration: BoxDecoration(
                                color: Colors.amber,
                                borderRadius: BorderRadius.circular(100)
                              ),
                              padding: EdgeInsets.all(6),
                            ),
                            Padding(padding: EdgeInsets.symmetric(horizontal: 4),),
                            Container(
                              child: IconButton(
                                icon: Icon(Icons.fast_forward, color: Colors.white,) ,
                                padding: EdgeInsets.zero,
                                constraints: BoxConstraints(),
                                onPressed: () async {
                                  _controller.seekTo(await _controller.position + Duration(seconds: 10));
                                }
                              ),
                              decoration: BoxDecoration(
                                color: Colors.amber,
                                borderRadius: BorderRadius.circular(100)
                              ),
                              padding: EdgeInsets.all(6),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Icon(Icons.volume_mute),
                        Expanded(
                          flex: 1,
                          child: Slider(
                            min: 0,
                            max: 100,
                            value: _volume,
                            onChanged: (v) => setVolume(v),
                            activeColor: Colors.amber,
                          ),
                        ),
                        Icon(Icons.volume_up),
                      ],
                    )
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 32),
                child: Column(
                  children: [
                    Text(
                      "This is the title of my video.",
                      style: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                    Padding(padding: EdgeInsets.symmetric(vertical: 12)),
                    Container(
                      height: 270,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: Text('''It is a long established fact that a reader will be distracted by the readable content of a page when looking at its layout. The point of using Lorem Ipsum is that it has a more-or-less normal distribution of letters, as opposed to using 'Content here, content here', making it look like readable English. Many desktop publishing packages and web page editors now use Lorem Ipsum as their default model text, and a search for 'lorem ipsum' will uncover many web sites still in their infancy. Various versions have evolved over the years, sometimes by accident, sometimes on purpose (injected humour and the like).''',
                          style: TextStyle(fontSize: 18, color: Colors.black.withAlpha(180)),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    Padding(padding: EdgeInsets.symmetric(vertical: 12)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          flex: 1,
                          child: InkWell(
                            onTap: () {
                              Navigator.push(context, MaterialPageRoute(builder: (context) => UserDetailView()));
                            },
                            child: Text(
                              "John Doe from MO", 
                              style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500, fontSize: 18),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                        IconButton(
                          icon: Icon(this.isLiked ? Icons.favorite : Icons.favorite_outline, color: Colors.amber,), 
                          onPressed: () {
                            setState(() {
                              this.isLiked = !this.isLiked;
                            });
                          }),
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
        )
      )
    );
  }
}