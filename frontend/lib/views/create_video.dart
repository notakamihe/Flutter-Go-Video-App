import 'dart:developer';
import 'dart:io';

import "package:flutter/material.dart";
import 'package:frontend/components/error.dart';
import 'package:image_picker/image_picker.dart';

class CreateVideo extends StatefulWidget {
  @override
  _CreateVideoState createState() => _CreateVideoState();
}

class _CreateVideoState extends State<CreateVideo> {
  TextEditingController _titleField = TextEditingController();
  TextEditingController _descriptionField = TextEditingController();

  File _video;
  File _image;
  
  final picker = ImagePicker();

  String error;

  void handleCreateVideo() {
    setState(() {
      this.error = null;

      if (_video == null) {
        this.error = "Must provide video file";
        return;
      }
    });
  }

  Future getVideo() async {
    final video = await picker.getVideo(source: ImageSource.gallery);

    setState(() {
      if (video != null) {
        this._video = File(video.path);
      }
    });
  }
  
  Future getImage() async {
    final image = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      if (image != null) {
        this._image = File(image.path);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text("Video creation", style: TextStyle(color: Colors.black),), 
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: Colors.amber,
        child: Container(
          padding: EdgeInsets.all(32),
          child: Column(
            children: [
              Expanded(
                flex: 3,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Error(message: error,),
                      Theme(
                        data: Theme.of(context).copyWith(primaryColor: Colors.white),
                        child: TextFormField(
                          controller: _titleField,
                          decoration: InputDecoration(
                            labelText: "Title",
                            hintText: "Enter the title of your video",
                            hintStyle: TextStyle(color: Colors.white.withAlpha(128)),
                            labelStyle: TextStyle(fontSize: 16)
                          ),
                          style: TextStyle(fontSize: 18),
                          cursorColor: Colors.black,
                        )
                      ),
                      Padding(padding: EdgeInsets.symmetric(vertical: 8)),
                      Theme(
                        data: Theme.of(context).copyWith(primaryColor: Colors.white),
                        child: TextFormField(
                          controller: _descriptionField,
                          keyboardType: TextInputType.multiline,
                          minLines: 1,
                          maxLines: 7,
                          decoration: InputDecoration(
                            labelText: "Description",
                            hintText: "Provide additional information (optional)",
                            hintStyle: TextStyle(color: Colors.white.withAlpha(128)),
                            labelStyle: TextStyle(fontSize: 16)
                          ),
                          style: TextStyle(fontSize: 16),
                          cursorColor: Colors.black,
                        )
                      ),
                      Padding(padding: EdgeInsets.symmetric(vertical: 24)),
                      FlatButton(
                        onPressed: getVideo,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.video_library, color: _video != null ? Colors.amber : Colors.black),
                            Padding(padding: EdgeInsets.only(right: 16)),
                            Text("Select video", 
                              style: TextStyle(
                                fontSize: 18, 
                                fontWeight: FontWeight.bold, 
                                color: _video != null ? Colors.amber : Colors.black
                              )
                            ),
                          ]
                        ),
                        color: _video != null ? Colors.white : Colors.yellow.shade300,
                        padding: EdgeInsets.all(16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      Padding(padding: EdgeInsets.symmetric(vertical: 8)),
                      FlatButton(
                        onPressed: getImage,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.image, color: _image != null ? Colors.amber : Colors.black),
                            Padding(padding: EdgeInsets.only(right: 16)),
                            Text(
                              "Select thumbnail", 
                              style: TextStyle(
                                fontSize: 18, 
                                fontWeight: FontWeight.bold,
                                color: _image != null ? Colors.amber : Colors.black
                              )
                            ),
                          ]
                        ),
                        color: _image != null ? Colors.white : Colors.yellow.shade300,
                        padding: EdgeInsets.all(16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Center(
                  child: Material(
                    child: IconButton(
                      icon: Icon(Icons.add, color: Colors.amber,), 
                      onPressed: handleCreateVideo,
                    ),
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(100),
                    elevation: 10,
                  ),
                )
              )
            ],
          ),
        )
      )
    );
  }
}