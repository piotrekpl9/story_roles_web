part of 'home_bloc.dart';

enum HomeBlocStatus { initial, loading, success, failure }

class HomeState extends Equatable {
  final HomeBlocStatus status;
  final List<Track> tracks;
  final Map<int, TrackProgress> audioProgresses;

  HomeState({
    required this.status,
    List<Track>? tracks,
    Map<int, TrackProgress>? audioProgresses,
  })  : tracks = tracks ?? [],
        audioProgresses = audioProgresses ?? {};

  HomeState copyWith({
    HomeBlocStatus? status,
    List<Track>? tracks,
    Map<int, TrackProgress>? audioProgresses,
  }) {
    return HomeState(
      status: status ?? this.status,
      tracks: tracks ?? this.tracks,
      audioProgresses: audioProgresses ?? this.audioProgresses,
    );
  }

  @override
  List<Object> get props => [status, tracks, audioProgresses];
}
