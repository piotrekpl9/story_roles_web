import 'package:story_roles_web/data/models/json_api_parser.dart';
import 'package:story_roles_web/domain/entities/project.dart';

class ProjectResponseDto {
  final int id;
  final String name;
  final DateTime createdAt;

  const ProjectResponseDto({
    required this.id,
    required this.name,
    required this.createdAt,
  });

  factory ProjectResponseDto.fromJson(Map<String, dynamic> json) {
    final src = JsonApiParser.extractAttributes(json);
    return ProjectResponseDto(
      id: int.parse(src['id'].toString()),
      name: src['name'] as String,
      createdAt: DateTime.parse(src['created_at'] as String),
    );
  }

  Project toDomain() => Project(
        id: id,
        name: name,
        createdAt: createdAt,
      );
}
