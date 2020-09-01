import 'package:domain/src/entity/request_result.dart';
import 'package:domain/src/repository/auth_repository.dart';
import 'package:domain/src/repository/user_repository.dart';
import 'package:domain/src/usecase/usecase.dart';
import 'package:get_it/get_it.dart';

class LogoutUsecase extends Usecase {
  final _authRepository = GetIt.I<AuthRepository>();
  final _userRepository = GetIt.I<UserRepository>();

  @override
  Stream<RequestResult> invoke([dynamic params]) async* {
    yield RequestResult.loading();

    await _authRepository.logOut();
    await _userRepository.deleteUserFromLocal();

    yield RequestResult.success(false);
  }

  @override
  String get key => "LOGOUT";
}
