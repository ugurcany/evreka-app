import 'package:domain/domain.dart';
import 'package:get_it/get_it.dart';

class UpdateUserUsecase extends Usecase {
  final _userRepository = GetIt.I<UserRepository>();

  @override
  Stream<RequestResult> invoke([dynamic params]) async* {
    yield RequestResult.loading();

    User userDelta = params as User;
    User user = await _userRepository.updateUser(userDelta);

    yield RequestResult.success(user);
  }
}
