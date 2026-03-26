class Project {
  final int id;
  final int companyId;
  final int userId;
  final String name;
  final DateTime createdAt;

  const Project({
    required this.id,
    required this.companyId,
    required this.userId,
    required this.name,
    required this.createdAt,
  });
}
