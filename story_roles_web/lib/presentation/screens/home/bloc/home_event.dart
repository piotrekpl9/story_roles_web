part of 'home_bloc.dart';

sealed class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object> get props => [];
}

class LoadHomeEvent extends HomeEvent {}

class SilentPoolTracksEvent extends HomeEvent {}

class RefreshTracksAfterUpload extends HomeEvent {}

class RefreshProgressesEvent extends HomeEvent {}

class RenameTrackEvent extends HomeEvent {
  final int trackId;
  final String newTitle;
  const RenameTrackEvent({required this.trackId, required this.newTitle});

  @override
  List<Object> get props => [trackId, newTitle];
}

class DeleteTrackEvent extends HomeEvent {
  final int trackId;
  const DeleteTrackEvent({required this.trackId});

  @override
  List<Object> get props => [trackId];
}
