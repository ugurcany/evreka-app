import 'dart:async';

abstract class AuthRepository {
  Future<bool> isLoggedIn();

  Future authenticateWithGoogle();

  Future authenticateWithGitHubPart1();
  Future authenticateWithGitHubPart2(Uri link);

  Future authenticateWithTwitterPart1();
  Future authenticateWithTwitterPart2(Uri link);

  Future logOut();
}
