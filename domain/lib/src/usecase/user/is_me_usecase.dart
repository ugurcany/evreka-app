import 'package:domain/domain.dart';
import 'package:get_it/get_it.dart';

class IsMeUsecase extends Usecase {
  final _userRepository = GetIt.I<UserRepository>();

  @override
  Stream<RequestResult> invoke([dynamic params]) async* {
    String userId = params as String;
    bool isMe = userId == null ? true : await _userRepository.isMe(userId);

    yield RequestResult.success(isMe);
  }
}
