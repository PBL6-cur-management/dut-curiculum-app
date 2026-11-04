import 'package:equatable/equatable.dart';

class SyllabusWeek extends Equatable {
  const SyllabusWeek({required this.label, required this.content});

  final String label;
  final String content;

  @override
  List<Object?> get props => [label, content];
}
