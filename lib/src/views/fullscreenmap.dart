
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:mapbox_gl/mapbox_gl.dart';

class FullScreenMap extends StatefulWidget {
  @override
  _FullScreenMapState createState() => _FullScreenMapState();
}

class _FullScreenMapState extends State<FullScreenMap> {
  static const String ACCESS_TOKEN = 'pk.eyJ1IjoiZmVkZWNlIiwiYSI6ImNrcDNtbDNnbDA1MWEydW93cHVxbWJ4MzMifQ.tDP_7idI4SRx3E4gpjtT7g';

  final center = LatLng(36.718908, -4.414302);

  MapboxMapController mapController;
  final oscuro = 'mapbox://styles/fedece/ckp9zgtp6248617vxbh4tmsq8';
  final streets = 'mapbox://styles/fedece/ckp9zlebx0n3r18pelxzn4beg';
  String selectedStyle = 'mapbox://styles/fedece/ckp9zgtp6248617vxbh4tmsq8';

  void _onMapCreated(MapboxMapController controller){
    mapController = controller;
    _onStyleLoaded();
  }

  void _onStyleLoaded() {
    addImageFromAsset("assetImage", "assets/custom-icon.png");
    addImageFromUrl(
        "networkImage", Uri.parse("https://via.placeholder.com/50"));
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: crearMapa(),
      floatingActionButton: botonesFlotantes(),
    );
  }

  Column botonesFlotantes() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        FloatingActionButton(
          onPressed: (){
            mapController.addSymbol(SymbolOptions(
              geometry: center,
              textField: 'Un punto de interés',
              iconImage: 'networkImage',
              textOffset: Offset(0, 2),
            ));
          },
          child: Icon(Icons.local_cafe),
        ),
        SizedBox(height: 5,),
        FloatingActionButton(
          onPressed: (){
            mapController.animateCamera(CameraUpdate.zoomIn());
          },
          child: Icon(Icons.zoom_in),
        ),
        SizedBox(height: 5,),
        FloatingActionButton(
          onPressed: (){
            mapController.animateCamera(CameraUpdate.zoomOut());
          },
          child: Icon(Icons.zoom_out),
        ),
        SizedBox(height: 5,),
        //Cambiar estilo
        FloatingActionButton(
          child: Icon(Icons.add_to_home_screen),
            onPressed: (){
            if(selectedStyle == oscuro){
              selectedStyle = streets;
            }else{
              selectedStyle = oscuro;
            }
            _onStyleLoaded();
            setState(() {
              print(selectedStyle);

            });
            }
        )
      ],
    );
  }

  MapboxMap crearMapa() {
    return MapboxMap(
      //accessToken: ACCESS_TOKEN,
      styleString: selectedStyle,
      onMapCreated: _onMapCreated,
      initialCameraPosition: CameraPosition(target: center, zoom: 14.0),
    );
  }



  /// Adds an asset image to the currently displayed style
  Future<void> addImageFromAsset(String name, String assetName) async {
    final ByteData bytes = await rootBundle.load(assetName);
    final Uint8List list = bytes.buffer.asUint8List();
    return mapController.addImage(name, list);
  }

  /// Adds a network image to the currently displayed style
  Future<void> addImageFromUrl(String name, Uri uri) async {
    var response = await http.get(uri);
    return mapController.addImage(name, response.bodyBytes);
  }
}
