import "package:flutter/material.dart";
import 'package:frontend/views/create_video.dart';
import 'video_detail.dart';

class VideosView extends StatefulWidget {
  @override
  _VideosViewState createState() => _VideosViewState();
}

class _VideosViewState extends State<VideosView> {
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
            children: [
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
                        elevation: 10,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(7), 
                            topRight: Radius.circular(7)
                        ),
                        child: Container(
                          width: double.infinity,
                          padding: EdgeInsets.all(12),
                          child: Text(
                            "This is the title of another amazing video by me.",
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
                              Text("3K"),
                              Padding(padding: EdgeInsets.only(right: 4)),
                              Icon(Icons.remove_red_eye),
                            ],
                          ),
                          Padding(padding: EdgeInsets.symmetric(horizontal: 6)),
                          Row(
                            children: [
                              Text("1K"),
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
                        elevation: 10,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(7), 
                            topRight: Radius.circular(7)
                        ),
                        child: Container(
                          width: double.infinity,
                          padding: EdgeInsets.all(12),
                          child: Text(
                            "This is the title of another amazing video by me.",
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
                              Text("3K"),
                              Padding(padding: EdgeInsets.only(right: 4)),
                              Icon(Icons.remove_red_eye),
                            ],
                          ),
                          Padding(padding: EdgeInsets.symmetric(horizontal: 6)),
                          Row(
                            children: [
                              Text("1K"),
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
                        elevation: 10,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(7), 
                            topRight: Radius.circular(7)
                        ),
                        child: Container(
                          width: double.infinity,
                          padding: EdgeInsets.all(12),
                          child: Text(
                            "This is the title of another amazing video by me.",
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
                              Text("3K"),
                              Padding(padding: EdgeInsets.only(right: 4)),
                              Icon(Icons.remove_red_eye),
                            ],
                          ),
                          Padding(padding: EdgeInsets.symmetric(horizontal: 6)),
                          Row(
                            children: [
                              Text("1K"),
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
                        elevation: 10,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(7), 
                            topRight: Radius.circular(7)
                        ),
                        child: Container(
                          width: double.infinity,
                          padding: EdgeInsets.all(12),
                          child: Text(
                            "This is the title of another amazing video by me.",
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
                              Text("3K"),
                              Padding(padding: EdgeInsets.only(right: 4)),
                              Icon(Icons.remove_red_eye),
                            ],
                          ),
                          Padding(padding: EdgeInsets.symmetric(horizontal: 6)),
                          Row(
                            children: [
                              Text("1K"),
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
            ],
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