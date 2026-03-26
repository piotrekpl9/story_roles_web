class Company {
  final int id;
  final String name;
  final int allowedUsers;
  final bool active;
  final DateTime createdAt;

  const Company({
    required this.id,
    required this.name,
    required this.allowedUsers,
    required this.active,
    required this.createdAt,
  });
}
