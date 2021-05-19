import "package:flutter/material.dart";
import 'package:frontend/components/error.dart';

class ChangePasswordView extends StatefulWidget {
  @override
  _ChangePasswordViewState createState() => _ChangePasswordViewState();
}

class _ChangePasswordViewState extends State<ChangePasswordView> {
  TextEditingController _oldPasswordField = TextEditingController();
  TextEditingController _newPasswordField = TextEditingController();

  String error;

  void handleChangePassword() {
    setState(() {
      this.error = null;
    });
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