import 'package:domain/domain.dart';

extension UserExt on User {
  User copyWithDelta(User userDelta) {
    return copyWith(
      id: userDelta.id ?? this.id,
      name: userDelta.name ?? this.name,
      email: userDelta.email ?? this.email,
      avatarUrl: userDelta.avatarUrl ?? this.avatarUrl,
      authProvider: userDelta.authProvider ?? this.authProvider,
      location: userDelta.location ?? this.location,
    );
  }
}
