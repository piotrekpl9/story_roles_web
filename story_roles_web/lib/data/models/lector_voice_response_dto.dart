import 'package:story_roles_web/domain/entities/lector_voice.dart';

class LectorVoiceResponseDto {
  final String id;
  final String name;
  final String description;

  const LectorVoiceResponseDto({
    required this.id,
    required this.name,
    required this.description,
  });

  factory LectorVoiceResponseDto.fromJson(Map<String, dynamic> json) {
    final attrs = json['attributes'] as Map<String, dynamic>;
    return LectorVoiceResponseDto(
      id: json['id'] as String,
      name: attrs['name'] as String,
      description: attrs['description'] as String,
    );
  }

  LectorVoice toDomain() => LectorVoice(id: id, name: name, description: description);
}
