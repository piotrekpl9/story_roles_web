part of 'project_bloc.dart';

enum ProjectStatus { initial, loading, success, failure }

class ProjectState extends Equatable {
  final ProjectStatus status;
  final List<Chapter> chapters;
  final Map<int, List<Track>> tracksByChapter;
  final Set<int> generatingChapterIds;
  final List<LectorVoice> lectorVoices;

  const ProjectState({
    this.status = ProjectStatus.initial,
    this.chapters = const [],
    this.tracksByChapter = const {},
    this.generatingChapterIds = const {},
    this.lectorVoices = const [],
  });

  ProjectState copyWith({
    ProjectStatus? status,
    List<Chapter>? chapters,
    Map<int, List<Track>>? tracksByChapter,
    Set<int>? generatingChapterIds,
    List<LectorVoice>? lectorVoices,
  }) {
    return ProjectState(
      status: status ?? this.status,
      chapters: chapters ?? this.chapters,
      tracksByChapter: tracksByChapter ?? this.tracksByChapter,
      generatingChapterIds: generatingChapterIds ?? this.generatingChapterIds,
      lectorVoices: lectorVoices ?? this.lectorVoices,
    );
  }

  @override
  List<Object> get props => [status, chapters, tracksByChapter, generatingChapterIds, lectorVoices];
}
