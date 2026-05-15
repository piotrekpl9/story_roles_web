import 'package:equatable/equatable.dart';

class Chapter extends Equatable {
  final int id;
  final int projectId;
  final String name;
  final String? content;
  final String? emotion;
  final DateTime createdAt;

  const Chapter({
    required this.id,
    required this.projectId,
    required this.name,
    this.content,
    this.emotion,
    required this.createdAt,
  });

  Chapter copyWith({
    int? id,
    int? projectId,
    String? name,
    String? content,
    String? emotion,
    DateTime? createdAt,
  }) {
    return Chapter(
      id: id ?? this.id,
      projectId: projectId ?? this.projectId,
      name: name ?? this.name,
      content: content ?? this.content,
      emotion: emotion ?? this.emotion,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  List<Object?> get props => [id, projectId, name, content, emotion, createdAt];
}
