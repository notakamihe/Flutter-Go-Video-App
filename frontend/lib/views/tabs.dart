import "package:flutter/material.dart";
import 'package:frontend/views/explore.dart';
import 'package:frontend/views/settings.dart';
import 'package:frontend/views/videos.dart';

class TabsView extends StatefulWidget {
  @override
  _TabsViewState createState() => _TabsViewState();
}

class _TabsViewState extends State<TabsView> {
  int _currentIdx = 0;
  
  static List<Widget> bottomTabWidgets = <Widget>[
    VideosView(),
    ExploreView(),
    SettingsView()
  ];

  void _onItemTapped (int index) {
    setState(() {
      this._currentIdx = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: bottomTabWidgets[_currentIdx],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIdx,
        selectedItemColor: Colors.amber,
        onTap: _onItemTapped,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.video_library),
            label: "Videos"
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.explore),
            label: "Explore"
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: "Account"
          ),
        ],
      ),
    );
  }
}