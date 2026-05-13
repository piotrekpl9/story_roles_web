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
    final attrs = (json['attributes'] as Map<String, dynamic>?) ?? json;
    return CompanyResponseDto(
      id: int.parse(attrs['id'].toString()),
      name: attrs['name'] as String,
      allowedUsers: attrs['allowed_users'] as int,
      active: attrs['active'] as bool,
      createdAt: DateTime.parse(attrs['created_at'] as String),
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
