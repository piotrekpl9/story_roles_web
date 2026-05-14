class User {
  final int? id;
  final String email;
  final bool isAdmin;
  final DateTime? createdAt;

  const User({
    this.id,
    required this.email,
    this.isAdmin = false,
    this.createdAt,
  });
}
