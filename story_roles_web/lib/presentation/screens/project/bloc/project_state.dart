part of 'project_bloc.dart';

enum ProjectStatus { initial, loading, success, failure }

enum ChapterActionStatus { idle, loading, success, failure }

class ProjectState extends Equatable {
  final ProjectStatus status;
  final Project? project;
  final List<Chapter> chapters;
  final Map<int, List<Track>> tracksByChapter;
  final Set<int> generatingChapterIds;
  final List<LectorVoice> lectorVoices;
  final ChapterActionStatus chapterActionStatus;
  // Negative IDs used for optimistic (in-flight) chapters
  final Set<int> pendingChapterIds;

  const ProjectState({
    this.status = ProjectStatus.initial,
    this.project,
    this.chapters = const [],
    this.tracksByChapter = const {},
    this.generatingChapterIds = const {},
    this.lectorVoices = const [],
    this.chapterActionStatus = ChapterActionStatus.idle,
    this.pendingChapterIds = const {},
  });

  ProjectState copyWith({
    ProjectStatus? status,
    Project? project,
    List<Chapter>? chapters,
    Map<int, List<Track>>? tracksByChapter,
    Set<int>? generatingChapterIds,
    List<LectorVoice>? lectorVoices,
    ChapterActionStatus? chapterActionStatus,
    Set<int>? pendingChapterIds,
  }) {
    return ProjectState(
      status: status ?? this.status,
      project: project ?? this.project,
      chapters: chapters ?? this.chapters,
      tracksByChapter: tracksByChapter ?? this.tracksByChapter,
      generatingChapterIds: generatingChapterIds ?? this.generatingChapterIds,
      lectorVoices: lectorVoices ?? this.lectorVoices,
      chapterActionStatus: chapterActionStatus ?? this.chapterActionStatus,
      pendingChapterIds: pendingChapterIds ?? this.pendingChapterIds,
    );
  }

  @override
  List<Object?> get props => [status, project, chapters, tracksByChapter, generatingChapterIds, lectorVoices, chapterActionStatus, pendingChapterIds];
}
