import 'package:hive/hive.dart';

part 'user.g.dart';

@HiveType(typeId: 1)
class User extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String email;

  @HiveField(3)
  final String password;

  @HiveField(4)
  final String? avatarIndex;

  @HiveField(5)
  final DateTime createdAt;

  @HiveField(6)
  final String? bio;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.password,
    this.avatarIndex,
    required this.createdAt,
    this.bio,
  });

  User copyWith({
    String? name,
    String? email,
    String? password,
    String? avatarIndex,
    String? bio,
  }) {
    return User(
      id: id,
      name: name ?? this.name,
      email: email ?? this.email,
      password: password ?? this.password,
      avatarIndex: avatarIndex ?? this.avatarIndex,
      createdAt: createdAt,
      bio: bio ?? this.bio,
    );
  }
}
