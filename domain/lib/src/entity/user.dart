import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@CopyWith()
@JsonSerializable(nullable: true, explicitToJson: true, includeIfNull: false)
class User extends Equatable {
  final String id;
  final String name;
  final String email;
  final String avatarUrl;
  final String authProvider;

  User({
    this.id,
    this.name,
    this.email,
    this.avatarUrl,
    this.authProvider,
  });

  @override
  List<Object> get props => [
        id,
        name,
        email,
        avatarUrl,
        authProvider,
      ];

  @override
  bool get stringify => true;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);
}
