import 'dart:async';

import "package:flutter/material.dart";
import 'package:frontend/models/user.dart';
import 'package:frontend/models/video.dart';
import 'package:frontend/services/user_service.dart';
import 'package:frontend/utils/utils.dart';
import 'package:frontend/views/tabs.dart';
import 'package:frontend/views/user_detail.dart';
import 'package:video_player/video_player.dart';
import 'package:http/http.dart' as http;

class VideoDetailView extends StatefulWidget {
  final Video video;

  VideoDetailView({Key key, this.video}): super(key: key);

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
      'http://localhost:8000/uploads/${Utils.normalizeUrl(widget.video.fileUrl)}'
    );

    _initializeVideoPlayerFuture = _controller.initialize();

    if (this._isPlaying) {
      this._controller.pause();
    } else {
      this._controller.play();
    }

    this.isLiked = widget.video.likes.contains(UserService.user?.id);

    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();

    super.dispose();
  }

  void handleDeleteVideo() async {
    await showDialog(
      context: context,
      builder: (context) => new AlertDialog(
        title: Text('Delete video?'),
        content: Text("Confirm the deletion of this this video."),
        actions: [
          FlatButton(
            onPressed: () async {
              await http.delete(Uri.http("localhost:8000", "/api/videos/${widget.video.id}"));
              Navigator.push(context, MaterialPageRoute(builder: (context) => TabsView()));
            },
            child: Text('Confirm'),
          ),
          FlatButton(
            onPressed: () {Navigator.of(context, rootNavigator: true).pop();},
            child: Text('Cancel'),
          ),
        ],
      ),
    );
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

  void toggleLike() async {
    var response = await http.put(Uri.http("localhost:8000", "/api/videos/${widget.video?.id}/toggle-like/${UserService.user?.id}"));

    this.isLiked = !this.isLiked;
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
                                    Text(widget.video.views.toString(), style: TextStyle(color: Colors.white, fontSize: 14),),
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
                      widget.video?.title,
                      style: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                    Padding(padding: EdgeInsets.symmetric(vertical: 12)),
                    ConstrainedBox(
                      constraints: new BoxConstraints(
                        maxHeight: 270
                      ),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: Text(
                          widget.video?.description,
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
                              Navigator.push(context, MaterialPageRoute(builder: (context) => UserDetailView(
                                user: User.fromJson(widget.video.user))
                            ));
                            },
                            child: Text(
                              widget.video?.user["name"], 
                              style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500, fontSize: 18),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                        Row(
                          children: [
                            IconButton(
                              icon: Icon(this.isLiked ? Icons.favorite : Icons.favorite_outline, color: Colors.amber,), 
                              onPressed: toggleLike),
                            UserService.isAuthenticatedJSON(widget.video.user) ?
                            IconButton(
                              icon: Icon(Icons.delete), 
                              onPressed: handleDeleteVideo,
                            ) : Container(),
                          ]
                        ),
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