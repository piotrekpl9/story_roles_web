import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:story_roles_web/domain/entities/track.dart';
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
  }

  Future<void> _onLoadHome(
    LoadHomeEvent event,
    Emitter<HomeState> emit,
  ) async {
    emit(state.copyWith(status: HomeBlocStatus.loading));
    try {
      final tracks = await _trackRepository.getAll();
      emit(state.copyWith(status: HomeBlocStatus.success, tracks: tracks));
      _pollingTimer?.cancel();
      _pollingTimer = Timer.periodic(
        const Duration(seconds: 60),
        (_) => add(SilentPoolTracksEvent()),
      );
    } catch (e, st) {
      print('HomeBloc error: $e\n$st');
      emit(state.copyWith(status: HomeBlocStatus.failure));
    }
  }

  Future<void> _onSilentPool(
    SilentPoolTracksEvent event,
    Emitter<HomeState> emit,
  ) async {
    try {
      final tracks = await _trackRepository.getAll();
      emit(state.copyWith(status: HomeBlocStatus.success, tracks: tracks));
    } catch (_) {
      // silent poll — nie zmieniamy stanu przy błędzie
    }
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

  @override
  Future<void> close() {
    _pollingTimer?.cancel();
    return super.close();
  }
}
