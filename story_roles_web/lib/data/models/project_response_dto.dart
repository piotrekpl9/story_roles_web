import 'package:story_roles_web/domain/entities/project.dart';

class ProjectResponseDto {
  final int id;
  final int companyId;
  final int userId;
  final String name;
  final DateTime createdAt;

  const ProjectResponseDto({
    required this.id,
    required this.companyId,
    required this.userId,
    required this.name,
    required this.createdAt,
  });

  factory ProjectResponseDto.fromJson(Map<String, dynamic> json) {
    return ProjectResponseDto(
      id: json['id'] as int,
      companyId: json['company_id'] as int,
      userId: json['user_id'] as int,
      name: json['name'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Project toDomain() => Project(
        id: id,
        companyId: companyId,
        userId: userId,
        name: name,
        createdAt: createdAt,
      );
}
