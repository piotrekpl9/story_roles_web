class ProfileResponseDto {
  final String email;
  final DateTime? createdAt;

  const ProfileResponseDto({
    required this.email,
    this.createdAt,
  });

  factory ProfileResponseDto.fromJson(Map<String, dynamic> json) {
    return ProfileResponseDto(
      email: json['email'] as String,
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'] as String)
          : null,
    );
  }
}
