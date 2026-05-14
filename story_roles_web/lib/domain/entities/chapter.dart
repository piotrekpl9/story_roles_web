import 'package:equatable/equatable.dart';

class Chapter extends Equatable {
  final int id;
  final int projectId;
  final String name;
  final String? content;
  final DateTime createdAt;

  const Chapter({
    required this.id,
    required this.projectId,
    required this.name,
    this.content,
    required this.createdAt,
  });

  Chapter copyWith({
    int? id,
    int? projectId,
    String? name,
    String? content,
    DateTime? createdAt,
  }) {
    return Chapter(
      id: id ?? this.id,
      projectId: projectId ?? this.projectId,
      name: name ?? this.name,
      content: content ?? this.content,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  List<Object?> get props => [id, projectId, name, content, createdAt];
}
