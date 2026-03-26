import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:story_roles_web/core/utils/result.dart';
import 'package:story_roles_web/domain/entities/chapter.dart';
import 'package:story_roles_web/domain/entities/track.dart';
import 'package:story_roles_web/domain/repositories/chapter_repository.dart';
import 'package:story_roles_web/domain/repositories/track_repository.dart';

part 'project_event.dart';
part 'project_state.dart';

class ProjectBloc extends Bloc<ProjectEvent, ProjectState> {
  final ChapterRepository _chapterRepository;
  final TrackRepository _trackRepository;

  ProjectBloc({
    required ChapterRepository chapterRepository,
    required TrackRepository trackRepository,
  })  : _chapterRepository = chapterRepository,
        _trackRepository = trackRepository,
        super(const ProjectState()) {
    on<LoadProjectEvent>(_onLoad);
    on<CreateChapterEvent>(_onCreateChapter);
    on<RenameChapterEvent>(_onRenameChapter);
    on<DeleteChapterEvent>(_onDeleteChapter);
    on<UpdateChapterContentEvent>(_onUpdateContent);
    on<DeleteTrackEvent>(_onDeleteTrack);
    on<GenerateTracksEvent>(_onGenerateTracks);
  }

  Future<void> _onLoad(LoadProjectEvent event, Emitter<ProjectState> emit) async {
    emit(state.copyWith(status: ProjectStatus.loading));
    try {
      final chapters = await _chapterRepository.getAll(event.projectId);

      // Load tracks for every chapter in parallel
      final tracksByChapter = <int, List<Track>>{};
      await Future.wait(chapters.map((c) async {
        final tracks = await _trackRepository.getByChapter(c.id);
        tracksByChapter[c.id] = tracks;
      }));

      emit(state.copyWith(
        status: ProjectStatus.success,
        chapters: chapters,
        tracksByChapter: tracksByChapter,
      ));
    } catch (e, st) {
      debugPrint('ProjectBloc error: $e\n$st');
      emit(state.copyWith(status: ProjectStatus.failure));
    }
  }

  Future<void> _onRenameChapter(
    RenameChapterEvent event,
    Emitter<ProjectState> emit,
  ) async {
    await _chapterRepository.rename(event.chapterId, event.newName);
    final updated = state.chapters
        .map((c) => c.id == event.chapterId
            ? Chapter(
                id: c.id,
                projectId: c.projectId,
                name: event.newName,
                content: c.content,
                createdAt: c.createdAt,
              )
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
    emit(state.copyWith(chapters: updatedChapters, tracksByChapter: updatedTracks));
  }

  Future<void> _onCreateChapter(
    CreateChapterEvent event,
    Emitter<ProjectState> emit,
  ) async {
    final result = await _chapterRepository.create(
      projectId: event.projectId,
      name: event.name,
      content: event.content,
    );
    if (result.isSuccess) {
      final chapter = result.dataOrNull!;
      emit(state.copyWith(
        chapters: [...state.chapters, chapter],
        tracksByChapter: {...state.tracksByChapter, chapter.id: []},
      ));
    }
  }

  Future<void> _onUpdateContent(
    UpdateChapterContentEvent event,
    Emitter<ProjectState> emit,
  ) async {
    await _chapterRepository.updateContent(event.chapterId, event.content);
    final updated = state.chapters
        .map((c) => c.id == event.chapterId
            ? Chapter(
                id: c.id,
                projectId: c.projectId,
                name: c.name,
                content: event.content,
                createdAt: c.createdAt,
              )
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
    updatedTracks[event.chapterId] =
        (updatedTracks[event.chapterId] ?? [])
            .where((t) => t.id != event.trackId)
            .toList();
    emit(state.copyWith(tracksByChapter: updatedTracks));
  }

  Future<void> _onGenerateTracks(
    GenerateTracksEvent event,
    Emitter<ProjectState> emit,
  ) async {
    // Mark as generating
    emit(state.copyWith(
      generatingChapterIds: {...state.generatingChapterIds, event.chapterId},
    ));

    await _chapterRepository.generateTracks(event.chapterId, event.narratorId);

    // Reload tracks for this chapter and unmark generating
    final tracks = await _trackRepository.getByChapter(event.chapterId);
    final updatedTracks = {...state.tracksByChapter, event.chapterId: tracks};
    final updatedGenerating = Set.of(state.generatingChapterIds)
      ..remove(event.chapterId);
    emit(state.copyWith(
      tracksByChapter: updatedTracks,
      generatingChapterIds: updatedGenerating,
    ));
  }
}
