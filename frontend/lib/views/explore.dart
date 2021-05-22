import 'dart:convert';

import "package:flutter/material.dart";
import 'package:frontend/components/video.dart';
import 'package:frontend/models/video.dart';
import 'package:http/http.dart' as http;

class ExploreView extends StatefulWidget {
  @override
  _ExploreViewState createState() => _ExploreViewState();
}

class _ExploreViewState extends State<ExploreView> {
  int batchSize = 8;
  List<Video> videos = [];

  @override
  void initState() {
    super.initState();
    this.loadVideos();
  }
  Future<void> loadVideos() async {
    setState(() {this.videos = [];});

    try {
      var response = await http.get(Uri.http("localhost:8000", "/api/videos/random/$batchSize"));
      List<dynamic> resArray = await json.decode(response.body);

      setState(() {
        this.videos = resArray.map((x) => Video.fromJson(x)).toList();
      });
    } catch (e) {
      print(e);
    }
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
                    VideoComponent(video: video,)
                ],
              ),
            )
          ),
        ),
      ),
    );
  }
}