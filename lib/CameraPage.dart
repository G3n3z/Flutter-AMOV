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
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;
  late final Object? args = ModalRoute.of(context)?.settings.arguments;
  late final CameraDescription? cameraDescription = args is CameraDescription ? args as CameraDescription : null;
  late CameraController controller;

  Future<void> initCamera() async {
    WidgetsFlutterBinding.ensureInitialized();
    // Obtain a list of the available cameras on the device.
    // Obtain a list of the available cameras on the device.
    final cameras = await availableCameras();

    // Get a specific camera from the list of available cameras.
    final firstCamera = cameras.first;
    controller = CameraController(firstCamera, ResolutionPreset.high);

    try {
      await controller.initialize().then((_) {
        if (!mounted) return;
        setState(() {});
      });
    } on CameraException catch (e) {
      debugPrint("camera error $e");
    }
  }


  @override
  void initState() {
    super.initState();
    //initCamera();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // if(cameraDescription != null) {
    //   _controller = CameraController(
    //     // Get a specific camera from the list of available cameras.
    //     cameraDescription!,
    //     // Define the resolution to use.
    //     ResolutionPreset.medium,
    //   );
    // }
    // // Next, initialize the controller. This returns a Future.
    // _initializeControllerFuture = _controller.initialize();
    controller = CameraController(widget.cameraDescription!, ResolutionPreset.max);
    controller.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    }).catchError((Object e) {
      if (e is CameraException) {
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
    // try {
    //   // Ensure that the camera is initialized.
    //   //await _initializeControllerFuture;
    //
    //   // Attempt to take a picture and get the file `image`
    //   // where it was saved.
    //   if (!controller.value.isInitialized) {
    //     print('Error: select a camera first.');
    //     return null;
    //   }
    //   final image = await controller.takePicture();
    //
    //   if (!mounted) return;
    //   print(image.path);
    //   // If the picture was taken, display it on a new screen.
    //
    // } catch (e) {
    //   // If an error occurs, log the error to the console.
    //   print("Errooooo");
    //   print(e);
    // }
    await controller.setFlashMode(FlashMode.off);
    if (!controller.value.isInitialized) {print("FAil condition 1");}
    //if (controller.value.isTakingPicture) {print("Fail condition 2");}
    try {
      await controller.setFlashMode(FlashMode.off);
      XFile picture = await controller.takePicture();
      print(picture.path);
    } on CameraException catch (e) {
      debugPrint('Error occured while taking picture: $e');
    }
  }
}
