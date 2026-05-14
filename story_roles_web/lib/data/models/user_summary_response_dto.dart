import 'package:story_roles_web/data/models/json_api_parser.dart';
import 'package:story_roles_web/domain/entities/user_summary.dart';

class UserSummaryResponseDto {
  final int id;
  final String email;

  const UserSummaryResponseDto({
    required this.id,
    required this.email,
  });

  factory UserSummaryResponseDto.fromJson(Map<String, dynamic> json) {
    final attrs = JsonApiParser.extractAttributes(json);
    return UserSummaryResponseDto(
      id: int.parse(attrs['id'].toString()),
      email: attrs['email'] as String,
    );
  }

  UserSummary toDomain() => UserSummary(
        id: id,
        email: email,
      );
}
