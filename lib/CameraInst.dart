import 'package:camera/camera.dart';
class CameraInstance{
    CameraDescription? camera;
    static CameraInstance instance = CameraInstance();

    CameraInstance();

    CameraInstance.camera(this.camera);

  static CameraInstance? getInstance({CameraDescription? camera}){
      if (camera != null) {
        instance = CameraInstance.camera(camera);
        return instance;
      }
      return instance;
    }
}