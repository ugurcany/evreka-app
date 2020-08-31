import 'package:domain/src/entity/request_result.dart';
import 'package:domain/src/repository/auth_repository.dart';
import 'package:domain/src/repository/user_repository.dart';
import 'package:domain/src/usecase/usecase.dart';
import 'package:get_it/get_it.dart';
import 'package:uni_links/uni_links.dart';

class LoginWithGithubUsecase extends Usecase {
  final _authRepository = GetIt.I<AuthRepository>();
  final _userRepository = GetIt.I<UserRepository>();

  @override
  Stream<RequestResult> invoke([dynamic params]) async* {
    yield RequestResult.loading();
    await _authRepository.authenticateWithGitHubPart1();
    yield RequestResult.success(false);

    Uri link = await getUriLinksStream().first;

    yield RequestResult.loading();

    await _authRepository.authenticateWithGitHubPart2(link);
    await _userRepository.getUserFromRemote();

    yield RequestResult.success(true);
  }
}
