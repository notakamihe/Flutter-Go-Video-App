import "package:flutter/material.dart";
import 'package:frontend/components/video.dart';

class ExploreView extends StatefulWidget {
  @override
  _ExploreViewState createState() => _ExploreViewState();
}

class _ExploreViewState extends State<ExploreView> {
  int batchSize = 10;
  List<VideoView> videos = [];

  @override
  void initState() {
    super.initState();
    this.loadVideos();
  }

  Future<void> loadVideos() async {
    setState(() {
      this.videos = [];

      for (int i = 0; i < batchSize; i++) {
        this.videos = [...this.videos, new VideoView()];
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: loadVideos,
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 48),
            child: Center(
              child: Wrap(
                children: [
                  for (var video in videos) 
                    video
                ],
              ),
            )
          ),
        ),
      ),
    );
  }
}