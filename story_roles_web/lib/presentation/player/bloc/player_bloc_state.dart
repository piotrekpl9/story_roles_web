import 'package:equatable/equatable.dart';
import 'package:story_roles_web/domain/entities/player_state.dart';
import 'package:story_roles_web/domain/entities/track.dart';

class PlayerBlocState extends Equatable {
  final Track? currentTrack;
  final PlayerState playerState;
  final bool isLoading;
  final String? error;

  const PlayerBlocState({
    this.currentTrack,
    this.playerState = const PlayerState.initial(),
    this.isLoading = false,
    this.error,
  });

  bool get hasTrack => currentTrack != null;

  PlayerBlocState copyWith({
    Track? currentTrack,
    PlayerState? playerState,
    bool? isLoading,
    String? error,
    bool clearError = false,
    bool clearTrack = false,
  }) {
    return PlayerBlocState(
      currentTrack: clearTrack ? null : (currentTrack ?? this.currentTrack),
      playerState: playerState ?? this.playerState,
      isLoading: isLoading ?? this.isLoading,
      error: clearError ? null : (error ?? this.error),
    );
  }

  @override
  List<Object?> get props => [currentTrack, playerState, isLoading, error];
}
