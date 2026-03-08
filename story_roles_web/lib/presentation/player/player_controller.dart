import 'package:audioplayers/audioplayers.dart' as ap;
import 'package:flutter/foundation.dart';
import 'package:story_roles_web/domain/entities/player_state.dart';

class PlayerController {
  final ap.AudioPlayer _player = ap.AudioPlayer();
  final ValueNotifier<PlayerState> _stateNotifier = ValueNotifier(
    const PlayerState.initial(),
  );

  Duration _position = Duration.zero;
  Duration? _duration;

  PlayerController() {
    _player.onDurationChanged.listen((d) {
      _duration = d;
      _emitState();
    });
    _player.onPositionChanged.listen((p) {
      _position = p;
      _emitState();
    });
    _player.onPlayerStateChanged.listen((_) {
      _emitState();
    });
  }

  void _emitState() {
    PlaybackStatus status;
    switch (_player.state) {
      case ap.PlayerState.playing:
        status = PlaybackStatus.playing;
      case ap.PlayerState.paused:
        status = PlaybackStatus.paused;
      case ap.PlayerState.completed:
        status = PlaybackStatus.paused;
      case ap.PlayerState.stopped:
        status = PlaybackStatus.stopped;
      case ap.PlayerState.disposed:
        status = PlaybackStatus.stopped;
    }
    _stateNotifier.value = PlayerState(
      status: status,
      position: _position,
      duration: _duration,
    );
  }

  Future<void> loadFromBytes(Uint8List bytes) async {
    await _player.setSourceBytes(bytes);
  }

  Future<void> play() => _player.resume();

  Future<void> pause() => _player.pause();

  Future<void> seek(Duration position) => _player.seek(position);

  ValueNotifier<PlayerState> get stateNotifier => _stateNotifier;

  PlayerState get currentState => _stateNotifier.value;

  void dispose() {
    _player.dispose();
    _stateNotifier.dispose();
  }
}
