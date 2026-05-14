import 'package:equatable/equatable.dart';
import 'package:story_roles_web/domain/entities/attributes.dart';

enum TrackStatus { completed, pending }

class Track extends Equatable {
  final int id;
  final int? chapterId;
  final Attributes attributes;

  const Track({required this.id, this.chapterId, required this.attributes});

  Track copyWith({
    int? id,
    int? chapterId,
    Attributes? attributes,
  }) {
    return Track(
      id: id ?? this.id,
      chapterId: chapterId ?? this.chapterId,
      attributes: attributes ?? this.attributes,
    );
  }

  @override
  List<Object?> get props => [id, chapterId, attributes];
}
