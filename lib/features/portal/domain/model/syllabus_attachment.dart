import 'package:equatable/equatable.dart';
import 'material_kind.dart';

class SyllabusAttachment extends Equatable {
  const SyllabusAttachment({
    required this.id,
    required this.fileName,
    required this.kind,
    required this.sizeBytes,
  });

  final String id;
  final String fileName;
  final MaterialKind kind;
  final int sizeBytes;

  @override
  List<Object?> get props => [id, fileName, kind, sizeBytes];
}
