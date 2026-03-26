import 'package:story_roles_web/domain/entities/user.dart';

class UserResponseDto {
  final int id;
  final int role;
  final int? companyId;
  final String username;
  final String email;
  final bool active;
  final DateTime? createdAt;

  const UserResponseDto({
    required this.id,
    required this.role,
    this.companyId,
    required this.username,
    required this.email,
    required this.active,
    this.createdAt,
  });

  factory UserResponseDto.fromJson(Map<String, dynamic> json) {
    return UserResponseDto(
      id: json['id'] as int,
      role: json['role'] as int,
      companyId: json['company_id'] as int?,
      username: json['username'] as String,
      email: json['email'] as String,
      active: json['active'] as bool? ?? true,
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'] as String)
          : null,
    );
  }

  User toDomain() => User(
        id: id,
        role: _mapRole(role),
        companyId: companyId,
        username: username,
        email: email,
        active: active,
        createdAt: createdAt,
      );

  UserRole _mapRole(int role) {
    return switch (role) {
      0 => UserRole.admin,
      1 => UserRole.owner,
      _ => UserRole.member,
    };
  }
}
