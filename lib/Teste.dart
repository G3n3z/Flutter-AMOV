// A screen that allows users to take a picture using a given camera.

import 'dart:developer';



import 'package:camera/camera.dart';


import 'package:flutter/material.dart';

import 'package:flutter/scheduler.dart';

import 'package:flutter/services.dart';



// A screen that allows users to take a picture using a given camera.

class TakePictureScreen extends StatefulWidget {

  const TakePictureScreen({

    super.key,

    required this.camera,

  });



  final CameraDescription camera;



  @override

  TakePictureScreenState createState() => TakePictureScreenState();

}



class TakePictureScreenState extends State<TakePictureScreen> {

  late CameraController _controller;

  late Future<void> _initializeControllerFuture;



  @override

  void initState() {

    super.initState();



    _controller = CameraController(

      widget.camera,

      ResolutionPreset.max,

    );



    // bloquear protrait

    SystemChrome.setPreferredOrientations([

      DeviceOrientation.portraitDown,

      DeviceOrientation.portraitUp,

    ]);



    _initializeControllerFuture = _controller.initialize().then((_) {

      if (!mounted) {

        return;

      }

      setState(() {});

    }).catchError((Object e) {

      if (e is CameraException) {

        switch (e.code) {

          case 'CameraAccessDenied':

            SchedulerBinding.instance.scheduleFrameCallback((timeStamp) {



            });



            break;

          default:

            break;

        }

      }

    });

  }



  @override

  void dispose() {

    _controller.dispose();

    SystemChrome.setPreferredOrientations([

      DeviceOrientation.landscapeRight,

      DeviceOrientation.landscapeLeft,

      DeviceOrientation.portraitUp,

      DeviceOrientation.portraitDown,

    ]);

    super.dispose();

  }



  @override

  Widget build(BuildContext context) {

    return Scaffold(

      extendBody: true,

      body: FutureBuilder<void>(

        future: _initializeControllerFuture,

        builder: (context, snapshot) {

          if (snapshot.connectionState == ConnectionState.done) {

            final scale = 1 /

                (_controller.value.aspectRatio *

                    MediaQuery.of(context).size.aspectRatio);

            return Transform.scale(

              scale: scale,

              alignment: Alignment.topCenter,

              child: CameraPreview(

                _controller,

              ),

            );

          }



          return const Center(child: CircularProgressIndicator());

        },

      ),

      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,

      floatingActionButton: FloatingActionButton(

        onPressed: _onTakePicture,

        child: const Icon(Icons.camera_alt),

      ),

    );

  }



  /// Quanto é tirada uma foto

  Future<void> _onTakePicture() async {

    try {

      await _initializeControllerFuture;

      final image = await _controller.takePicture();

      if (!mounted) return;



      // retornar o path da imagem para o ecra anterior ("Imagem")

      Navigator.pop(

        context,

        image.path,

      );

    } catch (e) {

      log(e.toString());

    }

  }

}

