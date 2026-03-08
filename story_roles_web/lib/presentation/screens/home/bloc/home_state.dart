part of 'home_bloc.dart';

enum HomeBlocStatus { initial, loading, success, failure }

class HomeState extends Equatable {
  final HomeBlocStatus status;
  final List<Track> tracks;

  HomeState({required this.status, List<Track>? tracks})
    : tracks = tracks ?? [];

  HomeState copyWith({HomeBlocStatus? status, List<Track>? tracks}) {
    return HomeState(
      status: status ?? this.status,
      tracks: tracks ?? this.tracks,
    );
  }

  @override
  List<Object> get props => [status, tracks];
}
