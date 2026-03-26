part of 'home_bloc.dart';

enum HomeBlocStatus { initial, loading, success, failure }

class HomeState extends Equatable {
  final HomeBlocStatus status;
  final List<Project> projects;

  HomeState({
    required this.status,
    List<Project>? projects,
  }) : projects = projects ?? [];

  HomeState copyWith({
    HomeBlocStatus? status,
    List<Project>? projects,
  }) {
    return HomeState(
      status: status ?? this.status,
      projects: projects ?? this.projects,
    );
  }

  @override
  List<Object> get props => [status, projects];
}
