import 'package:domain/src/entity/request_result.dart';
import 'package:domain/src/repository/auth_repository.dart';
import 'package:domain/src/usecase/usecase.dart';
import 'package:get_it/get_it.dart';

class IsLoggedInUsecase extends Usecase {
  final _authRepository = GetIt.I<AuthRepository>();

  @override
  Stream<RequestResult> invoke([dynamic params]) async* {
    yield RequestResult.loading();

    bool isLoggedIn = await _authRepository.isLoggedIn();

    yield RequestResult.success(isLoggedIn);
  }
}
