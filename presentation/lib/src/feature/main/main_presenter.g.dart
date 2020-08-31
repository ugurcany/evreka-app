// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'main_presenter.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$MainPresenter on MainPresenterBase, Store {
  final _$userResultAtom = Atom(name: 'MainPresenterBase.userResult');

  @override
  RequestResult get userResult {
    _$userResultAtom.reportRead();
    return super.userResult;
  }

  @override
  set userResult(RequestResult value) {
    _$userResultAtom.reportWrite(value, super.userResult, () {
      super.userResult = value;
    });
  }

  final _$logoutResultAtom = Atom(name: 'MainPresenterBase.logoutResult');

  @override
  RequestResult get logoutResult {
    _$logoutResultAtom.reportRead();
    return super.logoutResult;
  }

  @override
  set logoutResult(RequestResult value) {
    _$logoutResultAtom.reportWrite(value, super.logoutResult, () {
      super.logoutResult = value;
    });
  }

  final _$MainPresenterBaseActionController =
      ActionController(name: 'MainPresenterBase');

  @override
  dynamic getUser() {
    final _$actionInfo = _$MainPresenterBaseActionController.startAction(
        name: 'MainPresenterBase.getUser');
    try {
      return super.getUser();
    } finally {
      _$MainPresenterBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic logOut() {
    final _$actionInfo = _$MainPresenterBaseActionController.startAction(
        name: 'MainPresenterBase.logOut');
    try {
      return super.logOut();
    } finally {
      _$MainPresenterBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
userResult: ${userResult},
logoutResult: ${logoutResult}
    ''';
  }
}
