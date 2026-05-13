part of 'projects_bloc.dart';

enum ProjectsBlocStatus { initial, loading, success, failure }

class ProjectsState extends Equatable {
  final ProjectsBlocStatus status;
  final List<Project> projects;

  ProjectsState({
    required this.status,
    List<Project>? projects,
  }) : projects = projects ?? [];

  ProjectsState copyWith({
    ProjectsBlocStatus? status,
    List<Project>? projects,
  }) {
    return ProjectsState(
      status: status ?? this.status,
      projects: projects ?? this.projects,
    );
  }

  @override
  List<Object> get props => [status, projects];
}
