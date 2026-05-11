import 'package:story_roles_web/data/models/attributes_response_dto.dart';
import 'package:story_roles_web/domain/entities/track.dart';

class TrackResponseDto {
  final int id;
  final int? chapterId;
  final AttributesResponseDto attributesResponseDto;

  TrackResponseDto({required this.id, this.chapterId, required this.attributesResponseDto});

  factory TrackResponseDto.fromJson(Map<String, dynamic> json) {
    final attrs = json['attributes'] as Map<String, dynamic>;
    return TrackResponseDto(
      id: int.parse(json['id'].toString()),
      chapterId: (attrs['chapter_id'] as num?)?.toInt(),
      attributesResponseDto: AttributesResponseDto.fromJson(attrs),
    );
  }

  Track toDomain() {
    return Track(id: id, chapterId: chapterId, attributes: attributesResponseDto.toDomain());
  }
}
