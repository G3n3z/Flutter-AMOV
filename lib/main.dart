import 'package:ementa_cantina/CameraInst.dart';
import 'package:ementa_cantina/CameraPage.dart';
import 'package:flutter/material.dart';

import 'DetailsPage.dart';
import 'MyHomePage.dart';
import 'dart:io';
import 'package:camera/camera.dart';

Future<void> main()async {

  // Get a specific camera from the list of available cameras.


  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      initialRoute:"Home",
      routes:{
        "Home": (BuildContext context) => MyHomePage(title: "Home"),
        "DetailsPage": (BuildContext context) => DetailsPage(),
        "CameraPage" : (BuildContext context) => CameraPage()
      },
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),

    );
  }
}

