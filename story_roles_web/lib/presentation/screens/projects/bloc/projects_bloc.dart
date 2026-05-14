import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:story_roles_web/core/utils/result.dart';
import 'package:story_roles_web/domain/entities/project.dart';
import 'package:story_roles_web/domain/repositories/project_repository.dart';
import 'package:story_roles_web/presentation/common/polling_mixin.dart';

part 'projects_event.dart';
part 'projects_state.dart';

class ProjectsBloc extends Bloc<ProjectsEvent, ProjectsState> with PollingMixin {
  final ProjectRepository _projectRepository;

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
    final result = await _projectRepository.getAll();
    result.fold(
      onSuccess: (projects) {
        emit(
          state.copyWith(status: ProjectsBlocStatus.success, projects: projects),
        );
        startPolling(() async => add(SilentPoolTracksEvent()));
      },
      onError: (failure) {
        debugPrint('ProjectsBloc error: $failure');
        emit(state.copyWith(status: ProjectsBlocStatus.failure));
      },
    );
  }

  Future<void> _onSilentPool(
    SilentPoolTracksEvent event,
    Emitter<ProjectsState> emit,
  ) async {
    final result = await _projectRepository.getAll();
    result.fold(
      onSuccess: (projects) {
        emit(
          state.copyWith(status: ProjectsBlocStatus.success, projects: projects),
        );
      },
      onError: (failure) {
        debugPrint('ProjectsBloc polling error: $failure');
        emit(state.copyWith(status: ProjectsBlocStatus.failure));
      },
    );
  }

  Future<void> _onRenameProject(
    RenameProjectEvent event,
    Emitter<ProjectsState> emit,
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
    final result = await _projectRepository.create(name: event.name);
    result.fold(
      onSuccess: (project) =>
          emit(state.copyWith(projects: [...state.projects, project])),
      onError: (_) {},
    );
  }

  @override
  Future<void> close() {
    stopPolling();
    return super.close();
  }
}
