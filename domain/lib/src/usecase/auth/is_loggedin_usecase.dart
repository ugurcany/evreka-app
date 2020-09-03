import 'package:domain/src/entity/request_result.dart';
import 'package:domain/src/repository/auth_repository.dart';
import 'package:domain/src/repository/user_repository.dart';
import 'package:domain/src/usecase/usecase.dart';
import 'package:get_it/get_it.dart';

class IsLoggedInUsecase extends Usecase {
  final _authRepository = GetIt.I<AuthRepository>();
  final _userRepository = GetIt.I<UserRepository>();

  @override
  Stream<RequestResult> invoke([dynamic params]) async* {
    yield RequestResult.loading();

    bool isLoggedIn = await _authRepository.isLoggedIn() &&
        await _userRepository.isLoggedIn();

    yield RequestResult.success(isLoggedIn);
  }

  @override
  String get key => "IS_LOGGED_IN";
}
