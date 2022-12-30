import 'package:ementa_cantina/Helpers/CameraInst.dart';
import 'package:ementa_cantina/Pages/CameraPage.dart';
import 'package:flutter/material.dart';

import 'Pages/DetailsPage.dart';
import 'Pages/MyHomePage.dart';
import 'dart:io';
import 'package:camera/camera.dart';

Future<void> main()async {

  // Get a specific camera from the list of available cameras.
  WidgetsFlutterBinding.ensureInitialized();
  // Obtain a list of the available cameras on the device.
  // Obtain a list of the available cameras on the device.
  final cameras = await availableCameras();

  // Get a specific camera from the list of available cameras.
  final firstCamera = cameras.first;
  CameraInstance.getInstance(camera: firstCamera);

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
        "Home": (BuildContext context) => MyHomePage(title: "Ementa Semanal"),
        "DetailsPage": (BuildContext context) => DetailsPage(),
        "CameraPage" : (BuildContext context) => CameraPage()
      },
      theme: ThemeData(

        primarySwatch: Colors.blue,
      ),

    );
  }
}

