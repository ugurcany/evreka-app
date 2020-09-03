import 'dart:io';

import 'package:domain/domain.dart';

abstract class UserRepository {
  Future<bool> isLoggedIn();

  Future<bool> isMe(String userId);
  Future<User> getUserFromLocal();
  Future<bool> saveUserToLocal(User user);
  Future<bool> deleteUserFromLocal();
  Future<User> getUserFromRemote();

  Future<User> getOtherUser(String userId);

  Future<User> updateUser(User userDelta);

  Future<String> uploadAvatarAndGetUrl(File image);
  Future deleteAvatar();
}
