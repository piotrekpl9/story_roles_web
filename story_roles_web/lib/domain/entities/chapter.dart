class Chapter {
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
}
