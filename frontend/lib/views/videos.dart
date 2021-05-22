import 'dart:convert';

import "package:flutter/material.dart";
import 'package:frontend/models/video.dart';
import 'package:frontend/services/user_service.dart';
import 'package:frontend/utils/utils.dart';
import 'package:frontend/views/create_video.dart';
import 'video_detail.dart';
import 'package:http/http.dart' as http;

class VideosView extends StatefulWidget {
  @override
  _VideosViewState createState() => _VideosViewState();
}

class _VideosViewState extends State<VideosView> {
  List<Video> videos = [];

  @override
  void initState() {
    this.getData();

    super.initState();
  }

  void getData() async {
    try {
      var response = await http.get(Uri.http("localhost:8000", "/api/videos/user/${UserService.user?.id}"));
      List<dynamic> resArray = await json.decode(response.body);

      if (resArray != null) {
        setState(() {
          this.videos = resArray.map((x) => Video.fromJson(x)).toList();
        });
      }

    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Your Videos"), 
        backgroundColor: Colors.amber, 
        automaticallyImplyLeading: false,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.symmetric(vertical: 16),
          child: Column(
            children: videos.map((v) => 
              InkWell(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => VideoDetailView(video: v,)));
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.95,
                    margin: EdgeInsets.symmetric(vertical: 4),
                    child: Column(
                      children: [
                        Material(
                          elevation: 10,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(7), 
                              topRight: Radius.circular(7)
                          ),
                          child: Container(
                            width: double.infinity,
                            padding: EdgeInsets.all(12),
                            child: Text(
                              v.title,
                              style: TextStyle(fontSize: 16, color: Colors.amber, fontWeight: FontWeight.w500),
                              maxLines: 5,
                            ),
                          ),
                        ),
                        Container(
                          width: double.infinity,
                          height: MediaQuery.of(context).size.width * 0.95 * .5625,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: v.thumbnailUrl.isNotEmpty ?
                                NetworkImage(
                                  "http://localhost:8000/uploads/${Utils.normalizeUrl(v.thumbnailUrl)}"
                                ) :
                                AssetImage("assets/images/thumbnail-placeholder.png"), 
                              fit: BoxFit.cover
                            ),
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(15), 
                              bottomRight: Radius.circular(15)
                            )
                          )
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Padding(padding: EdgeInsets.only(top: 48)),
                            Row(
                              children: [
                                Text(v.views.toString()),
                                Padding(padding: EdgeInsets.only(right: 4)),
                                Icon(Icons.remove_red_eye),
                              ],
                            ),
                            Padding(padding: EdgeInsets.symmetric(horizontal: 6)),
                            Row(
                              children: [
                                Text(v.likes.length.toString()),
                                Padding(padding: EdgeInsets.only(right: 4)),
                                Icon(Icons.favorite),
                              ],
                            ),
                          ],
                        )
                      ]
                    ),
                  ),
                ),
              ).toList()
          )
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => CreateVideo()));
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.amber,
      ),
    );
  }
}