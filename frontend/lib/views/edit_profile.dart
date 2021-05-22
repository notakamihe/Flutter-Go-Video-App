import 'dart:convert';

import "package:flutter/material.dart";
import 'package:frontend/components/error.dart';
import 'package:frontend/models/user.dart';
import 'package:frontend/services/user_service.dart';
import 'package:http/http.dart' as http;

class EditProfileView extends StatefulWidget {
  @override
  _EditProfileViewState createState() => _EditProfileViewState();
}

class _EditProfileViewState extends State<EditProfileView> {
  TextEditingController _nameField = TextEditingController();
  TextEditingController _emailField = TextEditingController();

  String error;

  @override
  void initState() {
    this._nameField.text = UserService.user.name;
    this._emailField.text = UserService.user.email;

    super.initState();
  }

  void handleEditProfile() async {
    setState(() {this.error = null;});

    var response = await http.put(
      Uri.http("localhost:8000", "/api/users/${UserService.user?.id}"),
      body: jsonEncode(<String, dynamic>{
        "name": _nameField.text,
        "email": _emailField.text,
      })
    );

    if (response.statusCode != 200 && response.statusCode != 201) {
      switch (response.statusCode) {
        case 400:
          setState(() {this.error = response.body.trim();});
          break;
        default:
          print(response.body);
          setState(() {this.error = "Server error";});
          break;
      }

      return;
    }
    
    var json = await jsonDecode(response.body);
    UserService.user = User.fromJson(json);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text("Edit your profile", style: TextStyle(color: Colors.black),), 
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
                          controller: _nameField,
                          decoration: InputDecoration(
                            labelText: "Name",
                            hintText: "Enter your new name",
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
                          controller: _emailField,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            labelText: "Email",
                            hintText: "Enter a new email address",
                            hintStyle: TextStyle(color: Colors.white.withAlpha(128)),
                            labelStyle: TextStyle(fontSize: 16)
                          ),
                          style: TextStyle(fontSize: 18),
                          cursorColor: Colors.black,
                        )
                      ),
                      Padding(padding: EdgeInsets.symmetric(vertical: 24)),
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Center(
                  child: Material(
                    child: IconButton(
                      icon: Icon(Icons.edit, color: Colors.amber,), 
                      onPressed: handleEditProfile,
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