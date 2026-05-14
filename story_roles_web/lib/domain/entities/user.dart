import 'package:equatable/equatable.dart';

class User extends Equatable {
  final int? id;
  final String email;
  final bool isAdmin;
  final int? companyId;
  final DateTime? createdAt;

  const User({
    this.id,
    required this.email,
    this.isAdmin = false,
    this.companyId,
    this.createdAt,
  });

  User copyWith({
    int? id,
    String? email,
    bool? isAdmin,
    int? companyId,
    DateTime? createdAt,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      isAdmin: isAdmin ?? this.isAdmin,
      companyId: companyId ?? this.companyId,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  List<Object?> get props => [id, email, isAdmin, companyId, createdAt];
}
