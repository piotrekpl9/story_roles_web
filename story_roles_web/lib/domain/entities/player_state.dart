import 'package:equatable/equatable.dart';

enum PlaybackStatus { playing, paused, stopped, loading, buffering, completed }

class PlayerState extends Equatable {
  final PlaybackStatus status;
  final Duration position;
  final Duration? duration;

  const PlayerState({
    required this.status,
    required this.position,
    this.duration,
  });

  const PlayerState.initial()
      : status = PlaybackStatus.stopped,
        position = Duration.zero,
        duration = null;

  @override
  List<Object?> get props => [status, position, duration];

  PlayerState copyWith({
    PlaybackStatus? status,
    Duration? position,
    Duration? duration,
  }) {
    return PlayerState(
      status: status ?? this.status,
      position: position ?? this.position,
      duration: duration ?? this.duration,
    );
  }
}
