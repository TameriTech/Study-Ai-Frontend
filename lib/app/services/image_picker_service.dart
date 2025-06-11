import 'dart:io';

import 'package:image_picker/image_picker.dart';

class ImagePickerService {
  final ImagePicker _imagePicker;

  ImagePickerService({ImagePicker? imagePicker})
      : _imagePicker = imagePicker ?? ImagePicker();

  Future<File?> pickFromGallery() async {
    final image = await _imagePicker.pickImage(source: ImageSource.gallery);
    if (image == null) return null;

    return File(image.path);
  }

  Future<File?> pickFromCamera({int? imageQuality}) async {
    final image = await _imagePicker.pickImage(
      source: ImageSource.camera,
      imageQuality: imageQuality,
    );
    if (image == null) return null;

    return File(image.path);
  }
}
