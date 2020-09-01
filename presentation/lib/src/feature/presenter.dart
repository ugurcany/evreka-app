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

    //ALREADY HAVE THE SAME SUBSRCIPTION --> CANCEL IT FIRST
    if (_streamSubscriptions.containsKey(entry.key))
      _streamSubscriptions[entry.key].cancel();

    _streamSubscriptions[entry.key] = entry.value;
  }

  _onData(RequestResult requestResult, Function(RequestResult) callback) {
    callback?.call(requestResult);
  }

  _onError(String key, dynamic error, Function(RequestResult) callback) {
    log(error.toString());
    _streamSubscriptions.remove(key);
    callback?.call(RequestResult.error(error));
  }

  _onComplete(String key, Function(RequestResult) callback) {
    _streamSubscriptions.remove(key);
    callback?.call(RequestResult.complete());
  }
}
