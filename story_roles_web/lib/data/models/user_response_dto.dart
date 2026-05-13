import 'package:story_roles_web/domain/entities/user.dart';

class UserResponseDto {
  final int id;
  final String email;
  final bool isAdmin;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const UserResponseDto({
    required this.id,
    required this.email,
    this.isAdmin = false,
    this.createdAt,
    this.updatedAt,
  });

  factory UserResponseDto.fromJson(Map<String, dynamic> json) {
    final unwrapped = (json['data']?['user'] as Map<String, dynamic>?) ?? json;
    final attrs = (unwrapped['attributes'] as Map<String, dynamic>?) ?? unwrapped;
    return UserResponseDto(
      id: int.parse(attrs['id'].toString()),
      email: attrs['email'] as String,
      isAdmin: attrs['admin'] as bool? ?? attrs['is_admin'] as bool? ?? false,
      createdAt: attrs['created_at'] != null
          ? DateTime.tryParse(attrs['created_at'] as String)
          : null,
      updatedAt: attrs['updated_at'] != null
          ? DateTime.tryParse(attrs['updated_at'] as String)
          : null,
    );
  }

  User toDomain() => User(
        id: id,
        email: email,
        isAdmin: isAdmin,
        createdAt: createdAt,
        updatedAt: updatedAt,
      );
}
