import 'package:story_roles_web/data/models/json_api_parser.dart';
import 'package:story_roles_web/domain/entities/attributes.dart';
import 'package:story_roles_web/domain/entities/track.dart';

class AttributesResponseDto {
  final String title;
  final String? imageUrl;
  final DateTime createdAt;
  final String status;
  final String? lectorVoice;

  AttributesResponseDto({
    required this.title,
    required this.createdAt,
    required this.status,
    this.imageUrl,
    this.lectorVoice,
  });

  factory AttributesResponseDto.fromJson(Map<String, dynamic> json) {
    final attrs = JsonApiParser.extractAttributes(json);
    return AttributesResponseDto(
      title: attrs['title'] as String,
      imageUrl: attrs['image_url'] as String?,
      createdAt: DateTime.parse(attrs['created_at'] as String),
      status: attrs['status'] as String,
      lectorVoice: attrs['lector_voice'] as String?,
    );
  }

  TrackStatus _mapStatus(String status) {
    switch (status) {
      case 'completed':
        return TrackStatus.completed;
      default:
        return TrackStatus.pending;
    }
  }

  AttributesResponseDto copyWith({String? title}) {
    return AttributesResponseDto(
      title: title ?? this.title,
      imageUrl: imageUrl,
      createdAt: createdAt,
      status: status,
      lectorVoice: lectorVoice,
    );
  }

  Attributes toDomain() {
    return Attributes(
      title: title,
      status: _mapStatus(status),
      createdAt: createdAt,
      imageUrl: imageUrl,
      lectorVoice: lectorVoice,
    );
  }
}
