import 'package:equatable/equatable.dart';

class RequestResult extends Equatable {
  final RequestResultType type;
  final dynamic data;
  final dynamic error;

  RequestResult._({
    this.type,
    this.data,
    this.error,
  });

  @override
  List<Object> get props => [type, data, error];

  @override
  bool get stringify => true;

  factory RequestResult.idle() {
    return RequestResult._(type: RequestResultType.IDLE);
  }

  factory RequestResult.loading() {
    return RequestResult._(type: RequestResultType.LOADING);
  }

  factory RequestResult.success(dynamic data) {
    return RequestResult._(type: RequestResultType.SUCCESS, data: data);
  }

  factory RequestResult.error(dynamic error) {
    return RequestResult._(type: RequestResultType.ERROR, error: error);
  }

  factory RequestResult.complete() {
    return RequestResult._(type: RequestResultType.COMPLETE);
  }

  bool isIdle() => type == RequestResultType.IDLE;
  bool isLoading() => type == RequestResultType.LOADING;
  bool isSuccess() => type == RequestResultType.SUCCESS;
  bool isError() => type == RequestResultType.ERROR;
  bool isComplete() => type == RequestResultType.COMPLETE;
}

enum RequestResultType { IDLE, LOADING, SUCCESS, ERROR, COMPLETE }
