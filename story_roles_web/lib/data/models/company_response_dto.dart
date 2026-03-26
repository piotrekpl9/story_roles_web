import 'package:story_roles_web/domain/entities/company.dart';

class CompanyResponseDto {
  final int id;
  final String name;
  final int allowedUsers;
  final bool active;
  final DateTime createdAt;

  const CompanyResponseDto({
    required this.id,
    required this.name,
    required this.allowedUsers,
    required this.active,
    required this.createdAt,
  });

  factory CompanyResponseDto.fromJson(Map<String, dynamic> json) {
    return CompanyResponseDto(
      id: json['id'] as int,
      name: json['name'] as String,
      allowedUsers: json['allowed_users'] as int,
      active: json['active'] as bool,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Company toDomain() => Company(
        id: id,
        name: name,
        allowedUsers: allowedUsers,
        active: active,
        createdAt: createdAt,
      );
}
