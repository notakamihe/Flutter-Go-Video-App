import "package:flutter/material.dart";
import 'package:frontend/views/video_detail.dart';

class UserDetailView extends StatefulWidget {
  @override
  _UserDetailViewState createState() => _UserDetailViewState();
}

class _UserDetailViewState extends State<UserDetailView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("John Doe from MO", style: TextStyle(color: Colors.black),), 
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
                        "John Doe from MO",
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
                            Text("3", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),),
                          ],
                        ),
                      ),
                      Padding(padding: EdgeInsets.only(bottom: 16)),
                    ],
                  ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => VideoDetailView()));
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
                              "This is the title of another amazing video by me.",
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
                              image: AssetImage("assets/images/thumbnail-placeholder.png"), 
                              fit: BoxFit.fill
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
                                Text("3K", style: TextStyle(color: Colors.white)),
                                Padding(padding: EdgeInsets.only(right: 4)),
                                Icon(Icons.remove_red_eye, color: Colors.white),
                              ],
                            ),
                            Padding(padding: EdgeInsets.symmetric(horizontal: 6)),
                            Row(
                              children: [
                                Text("1K", style: TextStyle(color: Colors.white),),
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
                InkWell(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => VideoDetailView()));
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
                              "This is the title of another amazing video by me.",
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
                              image: AssetImage("assets/images/thumbnail-placeholder.png"), 
                              fit: BoxFit.fill
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
                                Text("3K", style: TextStyle(color: Colors.white)),
                                Padding(padding: EdgeInsets.only(right: 4)),
                                Icon(Icons.remove_red_eye, color: Colors.white),
                              ],
                            ),
                            Padding(padding: EdgeInsets.symmetric(horizontal: 6)),
                            Row(
                              children: [
                                Text("1K", style: TextStyle(color: Colors.white),),
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
                InkWell(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => VideoDetailView()));
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
                              "This is the title of another amazing video by me.",
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
                              image: AssetImage("assets/images/thumbnail-placeholder.png"), 
                              fit: BoxFit.fill
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
                                Text("3K", style: TextStyle(color: Colors.white)),
                                Padding(padding: EdgeInsets.only(right: 4)),
                                Icon(Icons.remove_red_eye, color: Colors.white),
                              ],
                            ),
                            Padding(padding: EdgeInsets.symmetric(horizontal: 6)),
                            Row(
                              children: [
                                Text("1K", style: TextStyle(color: Colors.white),),
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
              ]
            )
          )
        )
      )
    );
  }
}