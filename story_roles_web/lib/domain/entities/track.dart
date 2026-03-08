import 'package:story_roles_web/domain/entities/attributes.dart';

enum TrackStatus { completed, pending }

class Track {
  final int id;
  final Attributes attributes;

  Track({required this.id, required this.attributes});
}
