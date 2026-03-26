part of 'home_bloc.dart';

sealed class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object> get props => [];
}

class LoadHomeEvent extends HomeEvent {}

class SilentPoolTracksEvent extends HomeEvent {}

class RenameProjectEvent extends HomeEvent {
  final int projectId;
  final String newName;
  const RenameProjectEvent({required this.projectId, required this.newName});

  @override
  List<Object> get props => [projectId, newName];
}

class DeleteProjectEvent extends HomeEvent {
  final int projectId;
  const DeleteProjectEvent({required this.projectId});

  @override
  List<Object> get props => [projectId];
}

class CreateProjectEvent extends HomeEvent {
  final String name;
  const CreateProjectEvent({required this.name});

  @override
  List<Object> get props => [name];
}
