import 'package:story_roles_web/data/models/json_api_parser.dart';

class LoginResponseDto {
  final String token;
  final String email;
  final DateTime? createdAt;

  const LoginResponseDto({
    required this.token,
    required this.email,
    this.createdAt,
  });

  factory LoginResponseDto.fromJson(Map<String, dynamic> json) {
    final attrs = JsonApiParser.extractAttributes(json);
    return LoginResponseDto(
      token: attrs['token'] as String? ?? '',
      email: attrs['email'] as String,
      createdAt: attrs['created_at'] != null
          ? DateTime.tryParse(attrs['created_at'] as String)
          : null,
    );
  }
}
