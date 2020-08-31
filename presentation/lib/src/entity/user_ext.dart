import 'package:domain/domain.dart';

extension UserExt on User {
  bool get hasAvatar => avatarUrl?.isNotEmpty ?? false;
}
