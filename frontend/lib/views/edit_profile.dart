import "package:flutter/material.dart";
import 'package:frontend/components/error.dart';

class EditProfileView extends StatefulWidget {
  @override
  _EditProfileViewState createState() => _EditProfileViewState();
}

class _EditProfileViewState extends State<EditProfileView> {
  TextEditingController _nameField = TextEditingController();
  TextEditingController _emailField = TextEditingController();

  String error;

  void handleEditProfile() {
    setState(() {
      this.error = null;
    });
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