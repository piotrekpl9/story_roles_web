import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:story_roles_web/core/utils/result.dart';
import 'package:story_roles_web/domain/entities/chapter.dart';
import 'package:story_roles_web/domain/entities/lector_voice.dart';
import 'package:story_roles_web/domain/entities/track.dart';
import 'package:story_roles_web/domain/entities/project.dart';
import 'package:story_roles_web/domain/repositories/chapter_repository.dart';
import 'package:story_roles_web/domain/repositories/lector_voice_repository.dart';
import 'package:story_roles_web/domain/repositories/project_repository.dart';
import 'package:story_roles_web/domain/repositories/track_repository.dart';
import 'package:story_roles_web/presentation/common/polling_mixin.dart';

part 'project_event.dart';
part 'project_state.dart';

class ProjectBloc extends Bloc<ProjectEvent, ProjectState> with PollingMixin {
  final ProjectRepository _projectRepository;
  final ChapterRepository _chapterRepository;
  final TrackRepository _trackRepository;
  final LectorVoiceRepository _lectorVoiceRepository;

  ProjectBloc({
    required ProjectRepository projectRepository,
    required ChapterRepository chapterRepository,
    required TrackRepository trackRepository,
    required LectorVoiceRepository lectorVoiceRepository,
  })  : _projectRepository = projectRepository,
        _chapterRepository = chapterRepository,
        _trackRepository = trackRepository,
        _lectorVoiceRepository = lectorVoiceRepository,
        super(const ProjectState()) {
    on<LoadProjectEvent>(_onLoad);
    on<SilentRefreshProjectEvent>(_onSilentRefresh);
    on<CreateChapterEvent>(_onCreateChapter);
    on<RenameChapterEvent>(_onRenameChapter);
    on<DeleteChapterEvent>(_onDeleteChapter);
    on<UpdateChapterContentEvent>(_onUpdateContent);
    on<DeleteTrackEvent>(_onDeleteTrack);
    on<GenerateTracksEvent>(_onGenerateTracks);
  }

  Future<void> _onLoad(
      LoadProjectEvent event, Emitter<ProjectState> emit) async {
    emit(state.copyWith(status: ProjectStatus.loading));

    final projectResult = await _projectRepository.getById(event.projectId);
    final chaptersResult = await _chapterRepository.getAll(event.projectId);
    final lectorVoices = await _lectorVoiceRepository.getAll();

    if (projectResult.isError || chaptersResult.isError) {
      debugPrint('ProjectBloc load error');
      emit(state.copyWith(status: ProjectStatus.failure));
      return;
    }

    final project = projectResult.dataOrNull!;
    final chapters = chaptersResult.dataOrNull!;

    final tracksByChapter = <int, List<Track>>{};
    await Future.wait(chapters.map((c) async {
      final tracksResult = await _trackRepository.getByChapter(c.id);
      tracksResult.fold(
        onSuccess: (tracks) => tracksByChapter[c.id] = tracks,
        onError: (_) => tracksByChapter[c.id] = [],
      );
    }));

    emit(state.copyWith(
      status: ProjectStatus.success,
      project: project,
      chapters: chapters,
      tracksByChapter: tracksByChapter,
      lectorVoices: lectorVoices,
    ));
    startPolling(() async => add(SilentRefreshProjectEvent(event.projectId)));
  }

  Future<void> _onSilentRefresh(
    SilentRefreshProjectEvent event,
    Emitter<ProjectState> emit,
  ) async {
    final projectResult = await _projectRepository.getById(event.projectId);
    final chaptersResult = await _chapterRepository.getAll(event.projectId);

    projectResult.fold(
      onSuccess: (_) {},
      onError: (failure) {
        debugPrint('ProjectBloc polling error (project): $failure');
        emit(state.copyWith(status: ProjectStatus.failure));
      },
    );
    if (projectResult.isError) return;

    chaptersResult.fold(
      onSuccess: (_) {},
      onError: (failure) {
        debugPrint('ProjectBloc polling error (chapters): $failure');
        emit(state.copyWith(status: ProjectStatus.failure));
      },
    );
    if (chaptersResult.isError) return;

    final updatedProject = projectResult.dataOrNull!;
    final updatedChapters = chaptersResult.dataOrNull!;

    final tracksByChapter = <int, List<Track>>{};
    await Future.wait(updatedChapters.map((c) async {
      final tracksResult = await _trackRepository.getByChapter(c.id);
      tracksResult.fold(
        onSuccess: (tracks) => tracksByChapter[c.id] = tracks,
        onError: (_) => tracksByChapter[c.id] = state.tracksByChapter[c.id] ?? [],
      );
    }));

    emit(state.copyWith(
      status: ProjectStatus.success,
      project: updatedProject,
      chapters: updatedChapters,
      tracksByChapter: tracksByChapter,
    ));
  }

  Future<void> _onRenameChapter(
    RenameChapterEvent event,
    Emitter<ProjectState> emit,
  ) async {
    await _chapterRepository.rename(event.chapterId, event.newName);
    final updated = state.chapters
        .map((c) => c.id == event.chapterId
            ? c.copyWith(name: event.newName)
            : c)
        .toList();
    emit(state.copyWith(chapters: updated));
  }

  Future<void> _onDeleteChapter(
    DeleteChapterEvent event,
    Emitter<ProjectState> emit,
  ) async {
    await _chapterRepository.delete(event.chapterId);
    final updatedChapters =
        state.chapters.where((c) => c.id != event.chapterId).toList();
    final updatedTracks = Map.of(state.tracksByChapter)
      ..remove(event.chapterId);
    emit(state.copyWith(
        chapters: updatedChapters, tracksByChapter: updatedTracks));
  }

  Future<void> _onCreateChapter(
    CreateChapterEvent event,
    Emitter<ProjectState> emit,
  ) async {
    emit(state.copyWith(chapterActionStatus: ChapterActionStatus.loading));
    final result = await _chapterRepository.create(
      projectId: event.projectId,
      name: event.name,
      content: event.content,
      bytes: event.bytes,
      fileName: event.fileName,
    );
    if (result.isSuccess) {
      final chapter = result.dataOrNull!;
      emit(state.copyWith(
        chapters: [...state.chapters, chapter],
        tracksByChapter: {...state.tracksByChapter, chapter.id: []},
        chapterActionStatus: ChapterActionStatus.success,
      ));
    } else {
      emit(state.copyWith(chapterActionStatus: ChapterActionStatus.failure));
    }
    emit(state.copyWith(chapterActionStatus: ChapterActionStatus.idle));
  }

  Future<void> _onUpdateContent(
    UpdateChapterContentEvent event,
    Emitter<ProjectState> emit,
  ) async {
    await _chapterRepository.updateContent(event.chapterId, event.content);
    final updated = state.chapters
        .map((c) => c.id == event.chapterId
            ? c.copyWith(content: event.content)
            : c)
        .toList();
    emit(state.copyWith(chapters: updated));
  }

  Future<void> _onDeleteTrack(
    DeleteTrackEvent event,
    Emitter<ProjectState> emit,
  ) async {
    await _trackRepository.deleteTrack(event.trackId);
    final updatedTracks = Map.of(state.tracksByChapter);
    updatedTracks[event.chapterId] = (updatedTracks[event.chapterId] ?? [])
        .where((t) => t.id != event.trackId)
        .toList();
    emit(state.copyWith(tracksByChapter: updatedTracks));
  }

  Future<void> _onGenerateTracks(
    GenerateTracksEvent event,
    Emitter<ProjectState> emit,
  ) async {
    emit(state.copyWith(
      generatingChapterIds: {...state.generatingChapterIds, event.chapterId},
    ));

    final result = await _chapterRepository.generateTracks(
      event.projectId,
      event.chapterId,
      event.lectorVoice,
      event.emotion,
    );

    final updatedGenerating = Set.of(state.generatingChapterIds)
      ..remove(event.chapterId);

    if (result.isSuccess) {
      final pendingTrack = result.dataOrNull!;
      final existing = state.tracksByChapter[event.chapterId] ?? [];
      final updatedTracks = {
        ...state.tracksByChapter,
        event.chapterId: [...existing, pendingTrack],
      };
      emit(state.copyWith(
        tracksByChapter: updatedTracks,
        generatingChapterIds: updatedGenerating,
      ));
    } else {
      emit(state.copyWith(generatingChapterIds: updatedGenerating));
    }
  }

  @override
  Future<void> close() {
    stopPolling();
    return super.close();
  }
}
