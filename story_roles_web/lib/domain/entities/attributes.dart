import 'package:story_roles_web/domain/entities/track.dart';

class Attributes {
  final String title;
  final String? imageUrl;
  final DateTime createdAt;
  final TrackStatus status;

  Attributes({
    required this.title,
    this.imageUrl,
    required this.createdAt,
    required this.status,
  });
}
