part of 'project_bloc.dart';

sealed class ProjectEvent extends Equatable {
  const ProjectEvent();

  @override
  List<Object> get props => [];
}

class LoadProjectEvent extends ProjectEvent {
  final int projectId;
  const LoadProjectEvent(this.projectId);

  @override
  List<Object> get props => [projectId];
}

class RenameChapterEvent extends ProjectEvent {
  final int chapterId;
  final String newName;
  const RenameChapterEvent({required this.chapterId, required this.newName});

  @override
  List<Object> get props => [chapterId, newName];
}

class DeleteChapterEvent extends ProjectEvent {
  final int chapterId;
  const DeleteChapterEvent(this.chapterId);

  @override
  List<Object> get props => [chapterId];
}

class CreateChapterEvent extends ProjectEvent {
  final int projectId;
  final String name;
  final Uint8List bytes;
  final String fileName;
  final String content;
  const CreateChapterEvent({
    required this.projectId,
    required this.name,
    required this.content,
    required this.bytes,
    required this.fileName,
  });

  @override
  List<Object> get props => [projectId, name, content, bytes, fileName];
}

class UpdateChapterContentEvent extends ProjectEvent {
  final int chapterId;
  final String content;
  const UpdateChapterContentEvent(
      {required this.chapterId, required this.content});

  @override
  List<Object> get props => [chapterId, content];
}

class DeleteTrackEvent extends ProjectEvent {
  final int trackId;
  final int chapterId;
  const DeleteTrackEvent({required this.trackId, required this.chapterId});

  @override
  List<Object> get props => [trackId, chapterId];
}

class GenerateTracksEvent extends ProjectEvent {
  final int projectId;
  final int chapterId;
  final String lectorVoice;
  const GenerateTracksEvent(this.projectId, this.chapterId, this.lectorVoice);

  @override
  List<Object> get props => [projectId, chapterId, lectorVoice];
}
