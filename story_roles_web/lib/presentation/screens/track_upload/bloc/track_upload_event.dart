part of 'track_upload_bloc.dart';

sealed class TrackUploadEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class FileSelected extends TrackUploadEvent {
  final Uint8List bytes;
  final String fileName;
  final int fileSize;

  FileSelected({
    required this.bytes,
    required this.fileName,
    required this.fileSize,
  });

  @override
  List<Object?> get props => [fileName, fileSize];
}

class UploadSubmitted extends TrackUploadEvent {
  final String title;
  final Uint8List bytes;
  final String fileName;

  UploadSubmitted({
    required this.title,
    required this.bytes,
    required this.fileName,
  });

  @override
  List<Object?> get props => [title, fileName];
}

class UploadReset extends TrackUploadEvent {}
