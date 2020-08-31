// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

extension UserCopyWithExtension on User {
  User copyWith({
    String authProvider,
    String avatarUrl,
    String email,
    String id,
    String location,
    String name,
  }) {
    return User(
      authProvider: authProvider ?? this.authProvider,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      email: email ?? this.email,
      id: id ?? this.id,
      location: location ?? this.location,
      name: name ?? this.name,
    );
  }
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) {
  return User(
    id: json['id'] as String,
    name: json['name'] as String,
    email: json['email'] as String,
    avatarUrl: json['avatarUrl'] as String,
    authProvider: json['authProvider'] as String,
    location: json['location'] as String,
  );
}

Map<String, dynamic> _$UserToJson(User instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('id', instance.id);
  writeNotNull('name', instance.name);
  writeNotNull('email', instance.email);
  writeNotNull('avatarUrl', instance.avatarUrl);
  writeNotNull('authProvider', instance.authProvider);
  writeNotNull('location', instance.location);
  return val;
}
