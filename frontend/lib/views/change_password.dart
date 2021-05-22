import 'dart:convert';

import "package:flutter/material.dart";
import 'package:frontend/components/error.dart';
import 'package:frontend/models/user.dart';
import 'package:frontend/services/user_service.dart';
import 'package:http/http.dart' as http;

class ChangePasswordView extends StatefulWidget {
  @override
  _ChangePasswordViewState createState() => _ChangePasswordViewState();
}

class _ChangePasswordViewState extends State<ChangePasswordView> {
  TextEditingController _oldPasswordField = TextEditingController();
  TextEditingController _newPasswordField = TextEditingController();

  String error;

  void handleChangePassword() async {
    setState(() {this.error = null;});

    var response = await http.put(
      Uri.http("localhost:8000", "/api/users/${UserService.user?.id}/password"),
      body: jsonEncode(<String, dynamic>{
        "old": _oldPasswordField.text,
        "new": _newPasswordField.text,
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
        title: Text("Change your password", style: TextStyle(color: Colors.black),), 
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
                          controller: _oldPasswordField,
                          obscureText: true,
                          decoration: InputDecoration(
                            labelText: "Old",
                            hintText: "Enter your old password",
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
                          controller: _newPasswordField,
                          obscureText: true,
                          decoration: InputDecoration(
                            labelText: "New",
                            hintText: "Enter your new password",
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
                      onPressed: handleChangePassword,
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