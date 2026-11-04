import 'package:equatable/equatable.dart';

class SyllabusAssessment extends Equatable {
  const SyllabusAssessment({
    required this.code,
    required this.name,
    required this.weight,
    required this.form,
  });

  final String code;
  final String name;
  final String weight;
  final String? form;

  @override
  List<Object?> get props => [code, name, weight, form];
}
