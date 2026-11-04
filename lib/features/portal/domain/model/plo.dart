import 'package:equatable/equatable.dart';

class Plo extends Equatable {
  const Plo({
    required this.code,
    required this.description,
    required this.competencyGroup,
  });

  final String code;
  final String description;
  final String? competencyGroup;

  @override
  List<Object?> get props => [code, description, competencyGroup];
}
