import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:story_roles_web/domain/entities/project.dart';
import 'package:story_roles_web/domain/repositories/project_repository.dart';

part 'projects_event.dart';
part 'projects_state.dart';

class ProjectsBloc extends Bloc<ProjectsEvent, ProjectsState> {
  final ProjectRepository _projectRepository;
  Timer? _pollingTimer;

  ProjectsBloc({required ProjectRepository projectRepository})
      : _projectRepository = projectRepository,
        super(ProjectsState(status: ProjectsBlocStatus.initial)) {
    on<LoadProjectsEvent>(_onLoadProjects);
    on<SilentPoolTracksEvent>(_onSilentPool);
    on<RenameProjectEvent>(_onRenameProject);
    on<DeleteProjectEvent>(_onDeleteProject);
    on<CreateProjectEvent>(_onCreateProject);
  }

  Future<void> _onLoadProjects(
    LoadProjectsEvent event,
    Emitter<ProjectsState> emit,
  ) async {
    emit(state.copyWith(status: ProjectsBlocStatus.loading));
    try {
      final projects = await _projectRepository.getAll();
      emit(
        state.copyWith(status: ProjectsBlocStatus.success, projects: projects),
      );
      _pollingTimer?.cancel();
      _pollingTimer = Timer.periodic(
        const Duration(seconds: 60),
        (_) => add(SilentPoolTracksEvent()),
      );
    } catch (e, st) {
      debugPrint('ProjectsBloc error: $e\n$st');
      emit(state.copyWith(status: ProjectsBlocStatus.failure));
    }
  }

  Future<void> _onSilentPool(
    SilentPoolTracksEvent event,
    Emitter<ProjectsState> emit,
  ) async {
    try {
      final projects = await _projectRepository.getAll();
      emit(
        state.copyWith(status: ProjectsBlocStatus.success, projects: projects),
      );
    } catch (_) {}
  }

  Future<void> _onRenameProject(
    RenameProjectEvent event,
    Emitter<ProjectsState> emit,
  ) async {
    await _projectRepository.rename(event.projectId, event.newName);
    try {
      final projects = await _projectRepository.getAll();
      emit(state.copyWith(projects: projects));
    } catch (_) {}
  }

  Future<void> _onDeleteProject(
    DeleteProjectEvent event,
    Emitter<ProjectsState> emit,
  ) async {
    await _projectRepository.delete(event.projectId);
    final updated =
        state.projects.where((p) => p.id != event.projectId).toList();
    emit(state.copyWith(projects: updated));
  }

  Future<void> _onCreateProject(
    CreateProjectEvent event,
    Emitter<ProjectsState> emit,
  ) async {
    final project = await _projectRepository.create(name: event.name);
    emit(state.copyWith(projects: [...state.projects, project]));
  }

  @override
  Future<void> close() {
    _pollingTimer?.cancel();
    return super.close();
  }
}
