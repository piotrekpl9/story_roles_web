import 'package:story_roles_web/domain/entities/track.dart';

abstract class PlayerEvent {}

class PlayTrackEvent extends PlayerEvent {
  final Track track;
  PlayTrackEvent(this.track);
}

class TogglePlayEvent extends PlayerEvent {}

class SeekEvent extends PlayerEvent {
  final Duration position;
  SeekEvent(this.position);
}

class PlayerStateUpdated extends PlayerEvent {}

class ClosePlayerEvent extends PlayerEvent {}
