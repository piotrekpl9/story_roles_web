import 'package:equatable/equatable.dart';
import 'package:story_roles_web/domain/entities/player_state.dart';
import 'package:story_roles_web/domain/entities/script_word.dart';
import 'package:story_roles_web/domain/entities/track.dart';

class PlayerBlocState extends Equatable {
  final Track? currentTrack;
  final PlayerState playerState;
  final bool isLoading;
  final String? error;
  final List<ScriptWord> script;

  const PlayerBlocState({
    this.currentTrack,
    this.playerState = const PlayerState.initial(),
    this.isLoading = false,
    this.error,
    this.script = const [],
  });

  bool get hasTrack => currentTrack != null;

  PlayerBlocState copyWith({
    Track? currentTrack,
    PlayerState? playerState,
    bool? isLoading,
    String? error,
    bool clearError = false,
    bool clearTrack = false,
    List<ScriptWord>? script,
  }) {
    return PlayerBlocState(
      currentTrack: clearTrack ? null : (currentTrack ?? this.currentTrack),
      playerState: playerState ?? this.playerState,
      isLoading: isLoading ?? this.isLoading,
      error: clearError ? null : (error ?? this.error),
      script: clearTrack ? const [] : (script ?? this.script),
    );
  }

  @override
  List<Object?> get props => [currentTrack, playerState, isLoading, error, script];
}
