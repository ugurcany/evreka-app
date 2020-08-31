import 'dart:io';

import 'package:domain/domain.dart';
import 'package:image_picker/image_picker.dart';

class DeviceRepositoryImpl implements DeviceRepository {
  final _imagePicker = ImagePicker();

  @override
  Future<File> getImageFrom(ImageSrc source) async {
    PickedFile image = await _imagePicker.getImage(
      source: _convertImageSrc(source),
      maxHeight: 500,
      maxWidth: 500,
      imageQuality: 50,
    );
    if (image == null) return null;
    return File(image.path);
  }

  ImageSource _convertImageSrc(ImageSrc source) {
    switch (source) {
      case ImageSrc.CAMERA:
        return ImageSource.camera;
      case ImageSrc.GALLERY:
        return ImageSource.gallery;
      default:
        return null;
    }
  }
}
