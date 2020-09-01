import 'package:domain/domain.dart';
import 'package:get_it/get_it.dart';

class GetUserUsecase extends Usecase {
  final _userRepository = GetIt.I<UserRepository>();

  @override
  Stream<RequestResult> invoke([dynamic params]) async* {
    User userFromLocal = await _userRepository.getUserFromLocal();
    if (userFromLocal != null) yield RequestResult.success(userFromLocal);

    User userFromRemote = await _userRepository.getUserFromRemote();

    yield RequestResult.success(userFromRemote);
  }

  @override
  String get key => "GET_USER";
}
