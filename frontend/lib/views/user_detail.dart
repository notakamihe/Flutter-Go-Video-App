import 'dart:convert';

import "package:flutter/material.dart";
import 'package:frontend/models/user.dart';
import 'package:frontend/models/video.dart';
import 'package:frontend/services/user_service.dart';
import 'package:frontend/utils/utils.dart';
import 'package:frontend/views/video_detail.dart';
import 'package:http/http.dart' as http;

class UserDetailView extends StatefulWidget {
  final User user;

  UserDetailView({Key key, this.user}): super(key: key);

  @override
  _UserDetailViewState createState() => _UserDetailViewState();
}

class _UserDetailViewState extends State<UserDetailView> {
  List<Video> videos = [];

  @override
  void initState() {
    this.getData();

    super.initState();
  }

  void getData() async {
    try {
      var response = await http.get(Uri.http("localhost:8000", "/api/videos/user/${widget.user?.id}"));
      List<dynamic> resArray = await json.decode(response.body);

      if (resArray != null) {
        setState(() {
          this.videos = resArray.map((x) => Video.fromJson(x)).toList();
        });

        print(resArray);
      }

    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.user?.name, style: TextStyle(color: Colors.black),), 
        backgroundColor: Colors.yellow.shade600,
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: Colors.amber,
        child: SingleChildScrollView(
          child: Container(
            child: Column(
              children: [
                Padding(padding: EdgeInsets.only(top: 48)),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 36),
                  child: Column(
                    children: [  
                      Text(
                        widget.user?.name,
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.w300, fontSize: 24),
                      ),
                      Padding(padding: EdgeInsets.only(top: 24)),
                      Padding(padding: EdgeInsets.only(bottom: 40)),
                      Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.video_library, color: Colors.white,),
                            Padding(padding: EdgeInsets.only(right: 12),),
                            Text(
                              videos.length.toString(),
                              style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                      Padding(padding: EdgeInsets.only(bottom: 16)),
                    ],
                  ),
                ),
                Column(
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
                              elevation: 20,
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(7), 
                                  topRight: Radius.circular(7)
                              ),
                              child: Container(
                                width: double.infinity,
                                padding: EdgeInsets.all(12),
                                color: Colors.yellow.shade600,
                                child: Text(
                                  v.title,
                                  style: TextStyle(fontSize: 16, color: Colors.black, fontWeight: FontWeight.bold),
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
                                    Text(v.views.toString(), style: TextStyle(color: Colors.white)),
                                    Padding(padding: EdgeInsets.only(right: 4)),
                                    Icon(Icons.remove_red_eye, color: Colors.white),
                                  ],
                                ),
                                Padding(padding: EdgeInsets.symmetric(horizontal: 6)),
                                Row(
                                  children: [
                                    Text(v.likes.length.toString(), style: TextStyle(color: Colors.white),),
                                    Padding(padding: EdgeInsets.only(right: 4)),
                                    Icon(Icons.favorite, color: Colors.white),
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
              ]
            )
          )
        )
      )
    );
  }
}