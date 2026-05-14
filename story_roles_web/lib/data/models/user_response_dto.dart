import 'package:story_roles_web/data/models/json_api_parser.dart';
import 'package:story_roles_web/domain/entities/user.dart';

class UserResponseDto {
  final int id;
  final String email;
  final bool isAdmin;
  final int? companyId;
  final DateTime? createdAt;

  const UserResponseDto({
    required this.id,
    required this.email,
    this.isAdmin = false,
    this.companyId,
    this.createdAt,
  });

  factory UserResponseDto.fromJson(Map<String, dynamic> json) {
    final attrs = JsonApiParser.extractAttributes(json, entityKey: 'user');
    return UserResponseDto(
      id: int.parse(attrs['id'].toString()),
      email: attrs['email'] as String,
      isAdmin: attrs['admin'] as bool? ?? attrs['is_admin'] as bool? ?? false,
      companyId: attrs['company_id'] != null
          ? int.tryParse(attrs['company_id'].toString())
          : null,
      createdAt: attrs['created_at'] != null
          ? DateTime.tryParse(attrs['created_at'] as String)
          : null,
    );
  }

  User toDomain() => User(
        id: id,
        email: email,
        isAdmin: isAdmin,
        companyId: companyId,
        createdAt: createdAt,
      );
}
