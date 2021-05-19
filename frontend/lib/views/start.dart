import "package:flutter/material.dart";
import 'package:frontend/views/login.dart';
import 'package:frontend/views/register.dart';

class StartView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: Colors.amber,
        child: Center(
          child: Column(
            children: [
              Expanded(
                child: Center(
                  child: Wrap(
                    children: [ 
                      Text(
                        "Welcome to RECORDED.tv", 
                        style: TextStyle(
                          color: Colors.white, 
                          fontSize: 50,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ]
                  ),
                ),
                flex: 2,
              ),
              Expanded(
                flex: 1,
                child: Column(
                  children: [
                    MaterialButton(
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => RegisterView()));
                      },
                      child: Text(
                        "Register", 
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.amber)
                      ),
                      color: Colors.white,
                      padding: EdgeInsets.all(12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
                    ),
                    Padding(padding: EdgeInsets.all(8)),
                    MaterialButton(
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => LoginView()));
                      },
                      child: Text(
                        "Login", 
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.amber)
                      ),
                      color: Colors.white,
                      padding: EdgeInsets.all(12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      )
    );
  }
}