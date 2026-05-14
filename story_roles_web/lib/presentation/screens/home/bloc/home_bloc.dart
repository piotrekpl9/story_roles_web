import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:story_roles_web/core/utils/result.dart';
import 'package:story_roles_web/domain/entities/project.dart';
import 'package:story_roles_web/domain/repositories/project_repository.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final ProjectRepository _projectRepository;
  Timer? _pollingTimer;

  HomeBloc({required ProjectRepository projectRepository})
      : _projectRepository = projectRepository,
        super(HomeState(status: HomeBlocStatus.initial)) {
    on<LoadHomeEvent>(_onLoadHome);
    on<SilentPoolTracksEvent>(_onSilentPool);
    on<RenameProjectEvent>(_onRenameProject);
    on<DeleteProjectEvent>(_onDeleteProject);
    on<CreateProjectEvent>(_onCreateProject);
  }

  Future<void> _onLoadHome(LoadHomeEvent event, Emitter<HomeState> emit) async {
    emit(state.copyWith(status: HomeBlocStatus.loading));
    final result = await _projectRepository.getAll();
    result.fold(
      onSuccess: (projects) {
        emit(state.copyWith(status: HomeBlocStatus.success, projects: projects));
        _pollingTimer?.cancel();
        _pollingTimer = Timer.periodic(
          const Duration(seconds: 60),
          (_) => add(SilentPoolTracksEvent()),
        );
      },
      onError: (failure) {
        debugPrint('HomeBloc error: $failure');
        emit(state.copyWith(status: HomeBlocStatus.failure));
      },
    );
  }

  Future<void> _onSilentPool(
    SilentPoolTracksEvent event,
    Emitter<HomeState> emit,
  ) async {
    final result = await _projectRepository.getAll();
    result.fold(
      onSuccess: (projects) =>
          emit(state.copyWith(status: HomeBlocStatus.success, projects: projects)),
      onError: (_) {},
    );
  }

  Future<void> _onRenameProject(
    RenameProjectEvent event,
    Emitter<HomeState> emit,
  ) async {
    await _projectRepository.rename(event.projectId, event.newName);
    final result = await _projectRepository.getAll();
    result.fold(
      onSuccess: (projects) => emit(state.copyWith(projects: projects)),
      onError: (_) {},
    );
  }

  Future<void> _onDeleteProject(
    DeleteProjectEvent event,
    Emitter<HomeState> emit,
  ) async {
    await _projectRepository.delete(event.projectId);
    final updated = state.projects.where((p) => p.id != event.projectId).toList();
    emit(state.copyWith(projects: updated));
  }

  Future<void> _onCreateProject(
    CreateProjectEvent event,
    Emitter<HomeState> emit,
  ) async {
    final result = await _projectRepository.create(name: event.name);
    result.fold(
      onSuccess: (project) =>
          emit(state.copyWith(projects: [...state.projects, project])),
      onError: (_) {},
    );
  }

  @override
  Future<void> close() {
    _pollingTimer?.cancel();
    return super.close();
  }
}
