import 'package:equatable/equatable.dart';

import '../../domain/model/syllabus.dart';

class SyllabusState extends Equatable {
  const SyllabusState({
    this.isLoading = true,
    this.data,
    this.openingAttachmentId,
    this.downloadProgress,
    this.errorMessage,
  });

  final bool isLoading;
  final Syllabus? data;
  final String? openingAttachmentId;
  final double? downloadProgress;
  final String? errorMessage;

  @override
  List<Object?> get props => [
    isLoading,
    data,
    openingAttachmentId,
    downloadProgress,
    errorMessage,
  ];
}
