part of 'track_upload_bloc.dart';

enum UploadStatus { initial, fileSelected, uploading, success, error }

class TrackUploadState extends Equatable {
  final UploadStatus status;
  final Uint8List? selectedBytes;
  final String? fileName;
  final int? fileSize;
  final String? errorMessage;

  const TrackUploadState({
    this.status = UploadStatus.initial,
    this.selectedBytes,
    this.fileName,
    this.fileSize,
    this.errorMessage,
  });

  TrackUploadState copyWith({
    UploadStatus? status,
    Uint8List? selectedBytes,
    String? fileName,
    int? fileSize,
    String? errorMessage,
  }) {
    return TrackUploadState(
      status: status ?? this.status,
      selectedBytes: selectedBytes ?? this.selectedBytes,
      fileName: fileName ?? this.fileName,
      fileSize: fileSize ?? this.fileSize,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, fileName, fileSize, errorMessage];
}
