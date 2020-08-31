import 'dart:async';

import 'package:uuid/uuid.dart';

abstract class Usecase {
  final _uuid = Uuid();

  String _id;

  Stream invoke([dynamic params]);

  Future getFirst([dynamic params]) async => await invoke(params).first;

  MapEntry<String, StreamSubscription> listen({
    dynamic params,
    Function onData,
    Function onError,
    Function onComplete,
  }) {
    _id = _uuid.v1();
    return MapEntry(
      _id,
      invoke(params).listen(
        (requestResult) => onData?.call(requestResult),
        onError: (error) => onError?.call(_id, error),
        onDone: () => onComplete?.call(_id),
        cancelOnError: true,
      ),
    );
  }
}
