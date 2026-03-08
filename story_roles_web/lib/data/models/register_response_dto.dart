class RegisterResponseDto {
  final String email;
  final DateTime? createdAt;

  const RegisterResponseDto({required this.email, this.createdAt});

  factory RegisterResponseDto.fromJson(Map<String, dynamic> json) {
    return RegisterResponseDto(
      email: json['email'] as String,
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'] as String)
          : null,
    );
  }
}
