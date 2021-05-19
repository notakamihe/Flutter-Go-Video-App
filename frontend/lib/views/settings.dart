import "package:flutter/material.dart";
import 'package:frontend/views/change_password.dart';
import 'package:frontend/views/edit_profile.dart';
import 'package:frontend/views/login.dart';

class SettingsView extends StatefulWidget {
  @override
  _SettingsViewState createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  void logOut(ctx) {
    Navigator.push(ctx, MaterialPageRoute(builder: (ctx) => LoginView()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: Colors.amber,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FlatButton(
                onPressed: () => logOut(context),
                child: Text(
                  "LOG OUT", 
                  style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold, letterSpacing: 2),
                ),
                color: Colors.amber
              ),
              FlatButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => EditProfileView()));
                },
                child: Text(
                  "EDIT PROFILE", 
                  style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold, letterSpacing: 2),
                ),
                color: Colors.amber
              ),
              FlatButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => ChangePasswordView()));
                },
                child: Text(
                  "CHANGE PASSWORD", 
                  style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold, letterSpacing: 2),
                ),
                color: Colors.amber
              ),
            ],
          )
        ),
      )
    );
  }
}