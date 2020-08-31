import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:data/src/entity/firebase_user_ext.dart';
import 'package:data/src/entity/user_ext.dart';
import 'package:data/src/helper/local_db.dart';
import 'package:domain/domain.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as path;

class UserRepositoryImpl implements UserRepository {
  static const _loggedInUser = "loggedin_user";

  final _firebaseAuth = FirebaseAuth.instance;
  final _firestore = Firestore.instance;
  final _firebaseStorage = FirebaseStorage.instance;

  @override
  Future<bool> isMe(String userId) async {
    FirebaseUser userFromAuth = await _firebaseAuth.currentUser();
    return userFromAuth.uid == userId;
  }

  @override
  Future<User> getUserFromLocal() async {
    return await LocalDb.get(
      _loggedInUser,
      deserializer: (json) => User.fromJson(json),
    );
  }

  @override
  Future<bool> saveUserToLocal(User user) async {
    return await LocalDb.put(_loggedInUser, user);
  }

  @override
  Future<bool> deleteUserFromLocal() async {
    return await LocalDb.delete(_loggedInUser);
  }

  @override
  Future<User> getUserFromRemote() async {
    //DEFINE USER DATA PATH ON FIRESTORE
    FirebaseUser userFromAuth = await _firebaseAuth.currentUser();
    DocumentReference userRef = _userDocRef(userFromAuth.uid);

    User user;
    //CHECK WHETHER USER DATA EXISTS ON REMOTE
    DocumentSnapshot userDoc = await userRef.get();
    if (userDoc.exists) {
      //UTILIZE USER DATA FROM FIRESTORE
      user = User.fromJson(userDoc.data);
    } else {
      //CREATE USER DATA ON FIRESTORE
      user = User(
        id: userFromAuth.uid,
        name: userFromAuth.validDisplayName,
        email: userFromAuth.validEmail,
        avatarUrl: userFromAuth.validPhotoUrl,
        authProvider: userFromAuth.authProvider,
      );
      await userRef.setData(user.toJson());
    }

    //SAVE REMOTE USER DATA TO LOCAL DB
    await saveUserToLocal(user);

    return user;
  }

  @override
  Future<User> getOtherUser(String userId) async {
    DocumentReference userRef = _userDocRef(userId);
    DocumentSnapshot userDoc = await userRef.get();
    if (userDoc.exists)
      return User.fromJson(userDoc.data);
    else
      throw Exception("User not found!");
  }

  @override
  Future<User> updateUser(User userDelta) async {
    //DEFINE USER DATA PATH ON FIRESTORE
    User userFromLocal = await getUserFromLocal();
    DocumentReference userRef = _userDocRef(userFromLocal.id);

    //UPDATE USER ON FIRESTORE
    await userRef.updateData(userDelta.toJson());

    //SAVE UPDATED USER DATA TO LOCAL DB
    User updatedUser = userFromLocal.copyWithDelta(userDelta);
    await saveUserToLocal(updatedUser);

    return updatedUser;
  }

  @override
  Future<String> uploadAvatarAndGetUrl(File image) async {
    //GET EXTENSION OF IMAGE FILE
    String imageExt = path.extension(image.path);

    //DEFINE AVATAR PATH ON STORAGE
    FirebaseUser userFromAuth = await _firebaseAuth.currentUser();
    StorageReference avatarRef =
        _userStorageRef(userFromAuth.uid).child("avatar$imageExt");

    //UPLOAD AVATAR IMAGE FILE
    await avatarRef.putFile(image).onComplete;

    //GET AVATAR URL
    return await avatarRef.getDownloadURL();
  }

  @override
  Future deleteAvatar() async {
    //DEFINE AVATAR PATH ON STORAGE
    User userFromLocal = await getUserFromLocal();
    StorageReference avatarRef =
        await _firebaseStorage.getReferenceFromUrl(userFromLocal.avatarUrl);

    //DELETE AVATAR IMAGE FILE
    await avatarRef.delete();
  }

  DocumentReference _userDocRef(String userId) =>
      _firestore.collection("users").document(userId);

  StorageReference _userStorageRef(String userId) =>
      _firebaseStorage.ref().child("users").child(userId);
}
