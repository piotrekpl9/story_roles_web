import 'package:equatable/equatable.dart';

class UserSummary extends Equatable {
  final int id;
  final String email;

  const UserSummary({
    required this.id,
    required this.email,
  });

  UserSummary copyWith({
    int? id,
    String? email,
  }) {
    return UserSummary(
      id: id ?? this.id,
      email: email ?? this.email,
    );
  }

  @override
  List<Object?> get props => [id, email];
}
