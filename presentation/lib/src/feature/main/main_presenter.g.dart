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

  final _$containersResultAtom =
      Atom(name: 'MainPresenterBase.containersResult');

  @override
  RequestResult get containersResult {
    _$containersResultAtom.reportRead();
    return super.containersResult;
  }

  @override
  set containersResult(RequestResult value) {
    _$containersResultAtom.reportWrite(value, super.containersResult, () {
      super.containersResult = value;
    });
  }

  final _$relocationResultAtom =
      Atom(name: 'MainPresenterBase.relocationResult');

  @override
  RequestResult get relocationResult {
    _$relocationResultAtom.reportRead();
    return super.relocationResult;
  }

  @override
  set relocationResult(RequestResult value) {
    _$relocationResultAtom.reportWrite(value, super.relocationResult, () {
      super.relocationResult = value;
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
  dynamic createContainers(double lat, double lng) {
    final _$actionInfo = _$MainPresenterBaseActionController.startAction(
        name: 'MainPresenterBase.createContainers');
    try {
      return super.createContainers(lat, lng);
    } finally {
      _$MainPresenterBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic getContainers(double lat, double lng, double radius) {
    final _$actionInfo = _$MainPresenterBaseActionController.startAction(
        name: 'MainPresenterBase.getContainers');
    try {
      return super.getContainers(lat, lng, radius);
    } finally {
      _$MainPresenterBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic relocateContainer(String containerId, double lat, double lng) {
    final _$actionInfo = _$MainPresenterBaseActionController.startAction(
        name: 'MainPresenterBase.relocateContainer');
    try {
      return super.relocateContainer(containerId, lat, lng);
    } finally {
      _$MainPresenterBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
userResult: ${userResult},
logoutResult: ${logoutResult},
containersResult: ${containersResult},
relocationResult: ${relocationResult}
    ''';
  }
}
