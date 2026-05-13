part of 'projects_bloc.dart';

sealed class ProjectsEvent extends Equatable {
  const ProjectsEvent();

  @override
  List<Object> get props => [];
}

class LoadProjectsEvent extends ProjectsEvent {}

class SilentPoolTracksEvent extends ProjectsEvent {}

class RenameProjectEvent extends ProjectsEvent {
  final int projectId;
  final String newName;
  const RenameProjectEvent({required this.projectId, required this.newName});

  @override
  List<Object> get props => [projectId, newName];
}

class DeleteProjectEvent extends ProjectsEvent {
  final int projectId;
  const DeleteProjectEvent({required this.projectId});

  @override
  List<Object> get props => [projectId];
}

class CreateProjectEvent extends ProjectsEvent {
  final String name;
  const CreateProjectEvent({required this.name});

  @override
  List<Object> get props => [name];
}
