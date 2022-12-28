import 'package:camera/camera.dart';
import 'package:ementa_cantina/CameraInst.dart';
import 'package:ementa_cantina/Model/EmentaDia.dart';
import 'package:flutter/material.dart';



class CameraPage extends StatefulWidget {
  CameraPage({Key? key}) : super(key: key);

  CameraDescription? cameraDescription;
  CameraPage.camera(CameraDescription this.cameraDescription);
  @override
  State<CameraPage> createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  late Future<void> _initializeControllerFuture;
  late final Object? args = ModalRoute.of(context)?.settings.arguments;
  late final CameraDescription? cameraDescription = args is CameraDescription ? args as CameraDescription : null;
  late CameraController controller;


  @override
  void initState() {
    super.initState();
    //initCamera();
    controller = CameraController(CameraInstance.getInstance()!.camera!, ResolutionPreset.max);
    _initializeControllerFuture = controller.initialize().then((_) {
        if (!mounted) {
          return;
        }
        setState(() {});
      }).catchError((Object e) {
        if (e is CameraException) {
          print("ERRO INITIALIZE");
          switch (e.code) {
            case 'CameraAccessDenied':
            // Handle access errors here.
              break;
            default:
            // Handle other errors here.
              break;
          }
        }
      });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // body: FutureBuilder<void>(
      //   future: _initializeControllerFuture,
      //   builder: (context, snapshot) {
      //     if (snapshot.connectionState == ConnectionState.done) {
      //       // If the Future is complete, display the preview.
      //       return CameraPreview(_controller);
      //     } else {
      //       // Otherwise, display a loading indicator.
      //       return const Center(child: CircularProgressIndicator());
      //     }
      //   },
      // ),
      body: CameraPreview(controller)

      ,floatingActionButton:
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FloatingActionButton(
              onPressed: () {takePicture();},
              child: const Icon(Icons.camera_alt),
          )],
        ),
    );
  }

  Future<void> takePicture() async{
    try {
    //   // Ensure that the camera is initialized.
      await _initializeControllerFuture;
      final image = await controller.takePicture();
      if (!mounted) return;
      Navigator.of(context).pop(image.path);
      // If the picture was taken, display it on a new screen.

    } catch (e) {
      // If an error occurs, log the error to the console.
      print("Errooooo");
      print(e);
    }

  }
}
