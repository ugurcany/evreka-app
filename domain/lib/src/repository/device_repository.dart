import 'dart:io';

import 'package:domain/src/entity/image_src.dart';

abstract class DeviceRepository {
  Future<File> getImageFrom(ImageSrc source);
}
