import 'package:story_roles_web/data/models/json_api_parser.dart';
import 'package:story_roles_web/domain/entities/chapter.dart';

class ChapterResponseDto {
  final int id;
  final int projectId;
  final String name;
  final String? content;
  final String? emotion;
  final DateTime createdAt;

  const ChapterResponseDto({
    required this.id,
    required this.projectId,
    required this.name,
    this.content,
    this.emotion,
    required this.createdAt,
  });

  factory ChapterResponseDto.fromJson(Map<String, dynamic> json) {
    final src = JsonApiParser.extractAttributes(json);
    return ChapterResponseDto(
      id: int.parse(src['id'].toString()),
      projectId: int.parse(src['project_id'].toString()),
      name: src['name'] as String,
      content: src['content'] as String?,
      emotion: src['emotion'] as String?,
      createdAt: DateTime.parse(src['created_at'] as String),
    );
  }

  Chapter toDomain() => Chapter(
        id: id,
        projectId: projectId,
        name: name,
        content: content,
        emotion: emotion,
        createdAt: createdAt,
      );
}
