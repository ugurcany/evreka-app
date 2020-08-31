// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'splash_presenter.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$SplashPresenter on SplashPresenterBase, Store {
  final _$loginResultAtom = Atom(name: 'SplashPresenterBase.loginResult');

  @override
  RequestResult get loginResult {
    _$loginResultAtom.reportRead();
    return super.loginResult;
  }

  @override
  set loginResult(RequestResult value) {
    _$loginResultAtom.reportWrite(value, super.loginResult, () {
      super.loginResult = value;
    });
  }

  final _$SplashPresenterBaseActionController =
      ActionController(name: 'SplashPresenterBase');

  @override
  dynamic isLoggedIn() {
    final _$actionInfo = _$SplashPresenterBaseActionController.startAction(
        name: 'SplashPresenterBase.isLoggedIn');
    try {
      return super.isLoggedIn();
    } finally {
      _$SplashPresenterBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic logInWithGoogle() {
    final _$actionInfo = _$SplashPresenterBaseActionController.startAction(
        name: 'SplashPresenterBase.logInWithGoogle');
    try {
      return super.logInWithGoogle();
    } finally {
      _$SplashPresenterBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
loginResult: ${loginResult}
    ''';
  }
}
