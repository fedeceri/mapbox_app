import 'package:flutter/material.dart';
import 'package:mapbox_maps/src/views/fullscreenmap.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Material App',
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Center(
          child: Container(
            child: FullScreenMap()
          ),
        ),
      ),
    );
  }
}
