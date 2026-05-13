class UserSummary {
  final int id;
  final String email;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const UserSummary({
    required this.id,
    required this.email,
    this.createdAt,
    this.updatedAt,
  });
}
