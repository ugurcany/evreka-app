import 'dart:developer';
import 'dart:io';

import 'package:domain/domain.dart';
import 'package:domain/src/entity/image_src.dart';
import 'package:get_it/get_it.dart';

class SetAvatarUsecase extends Usecase {
  final _deviceRepository = GetIt.I<DeviceRepository>();
  final _userRepository = GetIt.I<UserRepository>();

  @override
  Stream<RequestResult> invoke([dynamic params]) async* {
    ImageSrc source = params as ImageSrc;
    if (source == null) {
      yield RequestResult.loading();

      try {
        //DELETE AVATAR FROM STORAGE
        //IGNORE IF FAILS
        await _userRepository.deleteAvatar();
      } catch (e) {
        log(e.toString());
      }

      User user = await _userRepository.updateUser(User(avatarUrl: ""));

      yield RequestResult.success(user);
    } else {
      //GET IMAGE FROM SELECTED SOURCE & UPLOAD IT
      File image = await _deviceRepository.getImageFrom(source);
      if (image != null) {
        yield RequestResult.loading();

        String avatarUrl = await _userRepository.uploadAvatarAndGetUrl(image);
        User user =
            await _userRepository.updateUser(User(avatarUrl: avatarUrl));

        yield RequestResult.success(user);
      }
    }
  }

  @override
  String get key => "SET_AVATAR";
}
