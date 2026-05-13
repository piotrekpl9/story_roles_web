import 'package:story_roles_web/domain/entities/user_summary.dart';

class UserSummaryResponseDto {
  final int id;
  final String email;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const UserSummaryResponseDto({
    required this.id,
    required this.email,
    this.createdAt,
    this.updatedAt,
  });

  factory UserSummaryResponseDto.fromJson(Map<String, dynamic> json) {
    final attrs = (json['attributes'] as Map<String, dynamic>?) ?? json;
    return UserSummaryResponseDto(
      id: int.parse(attrs['id'].toString()),
      email: attrs['email'] as String,
      createdAt: attrs['created_at'] != null
          ? DateTime.tryParse(attrs['created_at'] as String)
          : null,
      updatedAt: attrs['updated_at'] != null
          ? DateTime.tryParse(attrs['updated_at'] as String)
          : null,
    );
  }

  UserSummary toDomain() => UserSummary(
        id: id,
        email: email,
        createdAt: createdAt,
        updatedAt: updatedAt,
      );
}
