import 'dart:convert';

import "package:flutter/material.dart";
import 'package:frontend/components/error.dart';
import 'package:frontend/services/user_service.dart';
import 'package:frontend/views/start.dart';
import 'package:frontend/views/tabs.dart';
import 'package:frontend/views/videos.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class LoginView extends StatefulWidget {
  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  TextEditingController _emailField = TextEditingController();
  TextEditingController _passwordField = TextEditingController();

  String error;

  handleLogin() async {
    setState(() {
      this.error = null;
    });

    var response = await http.post(
      Uri.http("localhost:8000", "/api/login"),
      body: jsonEncode(<String, dynamic>{
        "email": _emailField.text,
        "password": _passwordField.text
      })
    );

    if (response.statusCode != 200 && response.statusCode != 201) {
      switch (response.statusCode) {
        case 400:
        case 401:
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
    var prefs = await SharedPreferences.getInstance();
    
    prefs.setString("token", json["token"]);
    
    UserService.setUser().then((value) => {
      Navigator.push(context, MaterialPageRoute(builder: (context) => TabsView()))
    });  
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: Colors.white,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            children: [
              Expanded(
                flex: 3,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Error(message: error,),
                      Padding(padding: EdgeInsets.symmetric(vertical: 16)),
                      Theme(
                        data: Theme.of(context).copyWith(primaryColor: Colors.amber),
                        child: TextFormField(
                          controller: _emailField,
                          decoration: InputDecoration(
                            fillColor: Colors.yellow.shade100,
                            alignLabelWithHint: true,
                            labelText: "Email",
                            filled: true,
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(8)),
                              borderSide: BorderSide(color: Colors.transparent)
                            ),
                            hintText: "Enter your email address",
                            hintStyle: TextStyle(color: Colors.black.withAlpha(80)),
                          ),
                          textAlign: TextAlign.center
                        ),
                      ),
                      Padding(padding: EdgeInsets.symmetric(vertical: 8)),
                      Theme(
                        data: Theme.of(context).copyWith(primaryColor: Colors.amber),
                        child: TextFormField(
                          controller: _passwordField,
                          obscureText: true,
                          decoration: InputDecoration(
                            fillColor: Colors.yellow.shade100,
                            labelText: "Password",
                            filled: true,
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(8)),
                              borderSide: BorderSide(color: Colors.transparent)
                            ),
                            hintText: "Enter your password",
                            hintStyle: TextStyle(color: Colors.black.withAlpha(80)),
                            
                          ),
                          textAlign: TextAlign.center
                        ),
                      )
                    ],
                )
              ),
              Expanded(
                flex: 1,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    RaisedButton(
                      onPressed: () => handleLogin(), 
                      child: Text(
                        "Log in",
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)
                      ),
                      color: Colors.amber,
                      padding: EdgeInsets.all(12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
                    ),
                    Padding(padding: EdgeInsets.only(bottom: 8)),
                    MaterialButton(
                      onPressed: () {Navigator.push(context, MaterialPageRoute(builder: (context) => StartView()));}, 
                      child: Text(
                        "BACK",
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black.withAlpha(128))
                      ),
                    )
                  ],
                )
              ),
            ],
          )
        ),
      ),
      resizeToAvoidBottomInset: false,
    );
  }
}