import 'dart:async';

import 'package:cloud_functions/cloud_functions.dart';
import 'package:domain/domain.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:url_launcher/url_launcher.dart';

class AuthRepositoryImpl implements AuthRepository {
  final _googleSignIn = GoogleSignIn();
  final _firebaseAuth = FirebaseAuth.instance;
  final _cloudFunctions = CloudFunctions.instance;

  @override
  Future<bool> isLoggedIn() async =>
      (await _firebaseAuth.currentUser()) != null;

  @override
  Future authenticateWithGoogle() async {
    //LOG INTO GOOGLE
    final GoogleSignInAccount googleAccount = await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth =
        await googleAccount.authentication;

    //LOG INTO FIREBASE
    await _logIntoFirebase(GoogleAuthProvider.providerId, {
      "access_token": googleAuth.accessToken,
      "id_token": googleAuth.idToken,
    });
  }

  @override
  Future authenticateWithGitHubPart1() async {
    await _showAuthUrlOnBrowser(GithubAuthProvider.providerId);
  }

  @override
  Future authenticateWithGitHubPart2(Uri link) async {
    //RETRIEVE CODE FROM GITHUB DEEP LINK
    String code = link.queryParameters["code"];
    if (code == null || code.isEmpty)
      throw Exception("GitHub auth code is invalid!");

    //GET ACCESS TOKEN AND LOG INTO FIREBASE
    await _getAccessTokenAndLogin(
      GithubAuthProvider.providerId,
      {"code": code},
    );
  }

  @override
  Future authenticateWithTwitterPart1() async {
    await _showAuthUrlOnBrowser(TwitterAuthProvider.providerId);
  }

  @override
  Future authenticateWithTwitterPart2(Uri link) async {
    //RETRIEVE TOKEN AND VERIFIER FROM TWITTER DEEP LINK
    String token = link.queryParameters["oauth_token"];
    String verifier = link.queryParameters["oauth_verifier"];
    if (token == null || token.isEmpty || verifier == null || verifier.isEmpty)
      throw Exception("Twitter auth token / verifier is invalid!");

    //GET ACCESS TOKEN AND LOG INTO FIREBASE
    await _getAccessTokenAndLogin(
      TwitterAuthProvider.providerId,
      {"token": token, "verifier": verifier},
    );
  }

  @override
  Future logOut() async {
    FirebaseUser user = await _firebaseAuth.currentUser();

    //LOG OUT FROM FIREBASE
    await _firebaseAuth.signOut();

    //LOG OUT FROM THE PROVIDER WE USED TO LOG IN
    for (var authType in user.providerData)
      if (authType.providerId == GoogleAuthProvider.providerId)
        await _googleSignIn.signOut();
  }

  Future _showAuthUrlOnBrowser(String providerId) async {
    //DETERMINE AUTH URL FUNCTION BASED ON PROVIDER
    String functionOnCloud;
    switch (providerId) {
      case TwitterAuthProvider.providerId:
        functionOnCloud = "twitter-getAuthUrl";
        break;
      case GithubAuthProvider.providerId:
        functionOnCloud = "github-getAuthUrl";
        break;
      default:
        throw Exception("Invalid provider!");
    }

    //GET PROVIDER'S AUTH URL
    HttpsCallableResult response = await _cloudFunctions
        .getHttpsCallable(functionName: functionOnCloud)
        .call();

    //OPEN URL ON BROWSER
    String url = response.data;
    if (await canLaunch(url))
      await launch(
        url,
        forceSafariVC: false,
        forceWebView: false,
      );
    else
      throw Exception("Cannot launch auth URL!");
  }

  Future _getAccessTokenAndLogin(String providerId, Map params) async {
    //DETERMINE ACCESS TOKEN FUNCTION BASED ON PROVIDER
    String functionOnCloud;
    switch (providerId) {
      case TwitterAuthProvider.providerId:
        functionOnCloud = "twitter-getAccessToken";
        break;
      case GithubAuthProvider.providerId:
        functionOnCloud = "github-getAccessToken";
        break;
      default:
        throw Exception("Invalid provider!");
    }

    //GET ACCESS TOKEN FROM PROVIDER
    HttpsCallableResult response = await _cloudFunctions
        .getHttpsCallable(functionName: functionOnCloud)
        .call(params);

    //LOG INTO FIREBASE WITH TOKEN DATA
    await _logIntoFirebase(
      providerId,
      Uri.splitQueryString(response.data),
    );
  }

  Future _logIntoFirebase(String providerId, Map tokenData) async {
    //CREATE PROVIDER CREDENTIALS FROM TOKEN DATA
    AuthCredential authCredential;
    switch (providerId) {
      case GoogleAuthProvider.providerId:
        authCredential = GoogleAuthProvider.getCredential(
          accessToken: tokenData["access_token"],
          idToken: tokenData["id_token"],
        );
        break;
      case TwitterAuthProvider.providerId:
        authCredential = TwitterAuthProvider.getCredential(
          authToken: tokenData["oauth_token"],
          authTokenSecret: tokenData["oauth_token_secret"],
        );
        break;
      case GithubAuthProvider.providerId:
        authCredential = GithubAuthProvider.getCredential(
          token: tokenData["access_token"],
        );
        break;
      default:
        throw Exception("Invalid provider!");
    }

    //LOG INTO FIREBASE WITH PROVIDER CREDENTIALS
    await _firebaseAuth.signInWithCredential(authCredential);
  }
}
