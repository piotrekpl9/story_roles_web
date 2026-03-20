import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:story_roles_web/domain/entities/track.dart';
import 'package:story_roles_web/domain/entities/track_progress.dart';
import 'package:story_roles_web/domain/repositories/track_repository.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final TrackRepository _trackRepository;
  Timer? _pollingTimer;

  HomeBloc({required TrackRepository trackRepository})
    : _trackRepository = trackRepository,
      super(HomeState(status: HomeBlocStatus.initial)) {
    on<LoadHomeEvent>(_onLoadHome);
    on<SilentPoolTracksEvent>(_onSilentPool);
    on<RefreshTracksAfterUpload>(_onRefreshAfterUpload);
    on<RefreshProgressesEvent>(_onRefreshProgresses);
    on<RenameTrackEvent>(_onRenameTrack);
    on<DeleteTrackEvent>(_onDeleteTrack);
  }

  Future<void> _onLoadHome(
    LoadHomeEvent event,
    Emitter<HomeState> emit,
  ) async {
    emit(state.copyWith(status: HomeBlocStatus.loading));
    try {
      final results = await Future.wait([
        _trackRepository.getAll(),
        _trackRepository.getAudioProgresses(),
      ]);
      emit(state.copyWith(
        status: HomeBlocStatus.success,
        tracks: results[0] as List<Track>,
        audioProgresses: results[1] as Map<int, TrackProgress>,
      ));
      _pollingTimer?.cancel();
      _pollingTimer = Timer.periodic(
        const Duration(seconds: 60),
        (_) => add(SilentPoolTracksEvent()),
      );
    } catch (e, st) {
      debugPrint('HomeBloc error: $e\n$st');
      emit(state.copyWith(status: HomeBlocStatus.failure));
    }
  }

  Future<void> _onSilentPool(
    SilentPoolTracksEvent event,
    Emitter<HomeState> emit,
  ) async {
    try {
      final results = await Future.wait([
        _trackRepository.getAll(),
        _trackRepository.getAudioProgresses(),
      ]);
      emit(state.copyWith(
        status: HomeBlocStatus.success,
        tracks: results[0] as List<Track>,
        audioProgresses: results[1] as Map<int, TrackProgress>,
      ));
    } catch (_) {}
  }

  Future<void> _onRefreshAfterUpload(
    RefreshTracksAfterUpload event,
    Emitter<HomeState> emit,
  ) async {
    try {
      final tracks = await _trackRepository.getAll();
      emit(state.copyWith(status: HomeBlocStatus.success, tracks: tracks));
    } catch (_) {}
  }

  Future<void> _onRefreshProgresses(
    RefreshProgressesEvent event,
    Emitter<HomeState> emit,
  ) async {
    try {
      final progresses = await _trackRepository.getAudioProgresses();
      debugPrint('[HomeBloc] refreshProgresses: ${progresses.keys.toList()}');
      emit(state.copyWith(audioProgresses: progresses));
    } catch (e) {
      debugPrint('[HomeBloc] refreshProgresses error: $e');
    }
  }

  Future<void> _onRenameTrack(
    RenameTrackEvent event,
    Emitter<HomeState> emit,
  ) async {
    await _trackRepository.renameTrack(event.trackId, event.newTitle);
    try {
      final tracks = await _trackRepository.getAll();
      emit(state.copyWith(tracks: tracks));
    } catch (_) {}
  }

  Future<void> _onDeleteTrack(
    DeleteTrackEvent event,
    Emitter<HomeState> emit,
  ) async {
    await _trackRepository.deleteTrack(event.trackId);
    final updated =
        state.tracks.where((t) => t.id != event.trackId).toList();
    emit(state.copyWith(tracks: updated));
  }

  @override
  Future<void> close() {
    _pollingTimer?.cancel();
    return super.close();
  }
}
