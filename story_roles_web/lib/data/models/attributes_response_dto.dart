import 'package:story_roles_web/domain/entities/attributes.dart';
import 'package:story_roles_web/domain/entities/track.dart';

class AttributesResponseDto {
  final String title;
  final String? imageUrl;
  final DateTime createdAt;
  final String status;

  AttributesResponseDto({
    required this.title,
    required this.createdAt,
    required this.status,
    this.imageUrl,
  });

  factory AttributesResponseDto.fromJson(Map<String, dynamic> json) {
    return AttributesResponseDto(
      title: json['title'] as String,
      imageUrl: json['image_url'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      status: json['status'] as String,
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
    );
  }

  Attributes toDomain() {
    return Attributes(
      title: title,
      status: _mapStatus(status),
      createdAt: createdAt,
      imageUrl: imageUrl,
    );
  }
}
