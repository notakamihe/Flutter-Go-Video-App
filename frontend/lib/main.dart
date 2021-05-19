import "package:flutter/material.dart";
import 'package:frontend/views/start.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build (BuildContext context) {
    return MaterialApp(
      title: "Reminder App",
      home: StartView(),
    );
  }
}