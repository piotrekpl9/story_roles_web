import 'package:story_roles_web/domain/entities/chapter.dart';

class ChapterResponseDto {
  final int id;
  final int projectId;
  final String name;
  final String? content;
  final DateTime createdAt;

  const ChapterResponseDto({
    required this.id,
    required this.projectId,
    required this.name,
    this.content,
    required this.createdAt,
  });

  factory ChapterResponseDto.fromJson(Map<String, dynamic> json) {
    return ChapterResponseDto(
      id: json['id'] as int,
      projectId: json['project_id'] as int,
      name: json['name'] as String,
      content: json['content'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Chapter toDomain() => Chapter(
        id: id,
        projectId: projectId,
        name: name,
        content: content,
        createdAt: createdAt,
      );
}
