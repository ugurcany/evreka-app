import 'dart:async';
import 'dart:developer';

import 'package:domain/domain.dart';

abstract class Presenter {
  Map<String, StreamSubscription> _streamSubscriptions = Map();

  dispose() {
    _streamSubscriptions.forEach((key, sub) => sub?.cancel());
    _streamSubscriptions.clear();
  }

  subscribe<U extends Usecase>(
    U usecase, {
    Function(RequestResult) callback,
    dynamic params,
  }) {
    final entry = usecase.listen(
      params: params,
      onData: (requestResult) => _onData(requestResult, callback),
      onError: (id, error) => _onError(id, error, callback),
      onComplete: (id) => _onComplete(id, callback),
    );
    _streamSubscriptions[entry.key] = entry.value;
  }

  _onData(RequestResult requestResult, Function(RequestResult) callback) {
    callback?.call(requestResult);
  }

  _onError(String id, dynamic error, Function(RequestResult) callback) {
    log(error.toString());
    _streamSubscriptions.remove(id);
    callback?.call(RequestResult.error(error));
  }

  _onComplete(String id, Function(RequestResult) callback) {
    _streamSubscriptions.remove(id);
    callback?.call(RequestResult.complete());
  }
}
