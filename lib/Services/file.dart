import 'package:velocity_x/velocity_x.dart';
import 'package:image_picker/image_picker.dart';

class FileManagement {
  final ImagePicker _imagePicker = ImagePicker();

  Future<XFile?> getPhoto(
      {required ImageSource source,
      CameraDevice device = CameraDevice.rear}) async {
    try {
      XFile? xfile = await _imagePicker.pickImage(
        source: source,
        preferredCameraDevice: device,
        imageQuality: 100,
      );

      return xfile;
    } catch (e) {
      Vx.log("Error while getting photo $e");
      // throw("Error while getting photo $e");
      rethrow;
    }
  }
}
