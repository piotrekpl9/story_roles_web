enum UserRole { admin, owner, member }

class User {
  final int? id;
  final UserRole role;
  final int? companyId;
  final String username;
  final String email;
  final bool active;
  final DateTime? createdAt;

  // Kept for backwards compatibility with existing code
  String? get displayName => username;

  const User({
    this.id,
    required this.role,
    this.companyId,
    required this.username,
    required this.email,
    this.active = true,
    this.createdAt,
  });
}
