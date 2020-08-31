import 'package:firebase_auth/firebase_auth.dart';

extension FirebaseUserExt on FirebaseUser {
  String get validEmail {
    String email = this.email;
    if (email == null || email.isEmpty) {
      //CHECK PROVIDER DATA FOR A VALID EMAIL
      final providerData = this.providerData.firstWhere(
            (provider) => provider.email != null && provider.email.isNotEmpty,
            orElse: () => null,
          );
      email = providerData?.email ?? "";
    }
    return email;
  }

  String get validDisplayName {
    String displayName = this.displayName;
    if (displayName == null || displayName.isEmpty) {
      //CHECK PROVIDER DATA FOR A VALID DISPLAY NAME
      final providerData = this.providerData.firstWhere(
            (provider) =>
                provider.displayName != null && provider.displayName.isNotEmpty,
            orElse: () => null,
          );
      displayName = providerData?.displayName ?? "";
    }
    return displayName;
  }

  String get validPhotoUrl {
    String photoUrl = this.photoUrl;
    if (photoUrl == null || photoUrl.isEmpty) {
      //CHECK PROVIDER DATA FOR A VALID PHOTO URL
      final providerData = this.providerData.firstWhere(
            (provider) =>
                provider.photoUrl != null && provider.photoUrl.isNotEmpty,
            orElse: () => null,
          );
      photoUrl = providerData?.photoUrl ?? "";
    }
    return photoUrl;
  }

  String get authProvider {
    //CHECK PROVIDER DATA FOR A PROVIDER OTHER THAN FIREBASE
    String providerId = this
        .providerData
        .firstWhere(
          (provider) => !provider.providerId.contains("firebase"),
          orElse: () => null,
        )
        ?.providerId;
    return providerId;
  }
}
