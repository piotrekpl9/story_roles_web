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
    final attrs = json['attributes'] as Map<String, dynamic>?;
    final src = attrs ?? json;
    return ProjectResponseDto(
      id: int.parse(src['id'].toString()),
      companyId: int.parse(src['company_id'].toString()),
      userId: src['user_id'] != null ? int.parse(src['user_id'].toString()) : 0,
      name: src['name'] as String,
      createdAt: DateTime.parse(src['created_at'] as String),
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
