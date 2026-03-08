import 'dart:typed_data';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:story_roles_web/core/utils/result.dart';
import 'package:story_roles_web/data/usecases/track/upload_track.dart';

part 'track_upload_event.dart';
part 'track_upload_state.dart';

class TrackUploadBloc extends Bloc<TrackUploadEvent, TrackUploadState> {
  final UploadTrack uploadTrack;

  TrackUploadBloc({required this.uploadTrack})
    : super(const TrackUploadState()) {
    on<FileSelected>(_onFileSelected);
    on<UploadSubmitted>(_onUploadSubmitted);
    on<UploadReset>(_onUploadReset);
  }

  void _onFileSelected(FileSelected event, Emitter<TrackUploadState> emit) {
    emit(
      state.copyWith(
        status: UploadStatus.fileSelected,
        selectedBytes: event.bytes,
        fileName: event.fileName,
        fileSize: event.fileSize,
      ),
    );
  }

  Future<void> _onUploadSubmitted(
    UploadSubmitted event,
    Emitter<TrackUploadState> emit,
  ) async {
    emit(state.copyWith(status: UploadStatus.uploading));

    final result = await uploadTrack(
      title: event.title,
      bytes: event.bytes,
      fileName: event.fileName,
    );

    if (result.isSuccess) {
      emit(state.copyWith(status: UploadStatus.success));
    } else {
      emit(
        state.copyWith(
          status: UploadStatus.error,
          errorMessage: result.failureOrNull?.message ?? 'Upload failed',
        ),
      );
    }
  }

  void _onUploadReset(UploadReset event, Emitter<TrackUploadState> emit) {
    emit(const TrackUploadState());
  }
}
