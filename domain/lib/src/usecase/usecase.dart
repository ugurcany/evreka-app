import 'dart:async';

abstract class Usecase {
  String get key;

  Stream invoke([dynamic params]);

  Future getFirst([dynamic params]) async => await invoke(params).first;

  MapEntry<String, StreamSubscription> listen({
    dynamic params,
    Function onData,
    Function onError,
    Function onComplete,
  }) {
    return MapEntry(
      key,
      invoke(params).listen(
        (requestResult) => onData?.call(requestResult),
        onError: (error) => onError?.call(key, error),
        onDone: () => onComplete?.call(key),
        cancelOnError: true,
      ),
    );
  }
}
