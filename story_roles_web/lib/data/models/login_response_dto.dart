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
    return LoginResponseDto(
      token: json['token'] as String? ?? '',
      email: json['email'] as String,
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'] as String)
          : null,
    );
  }
}
