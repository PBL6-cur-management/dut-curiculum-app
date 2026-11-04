import 'package:equatable/equatable.dart';

class CourseRef extends Equatable {
  const CourseRef({required this.id, required this.code, required this.name});

  final String id;
  final String code;
  final String name;

  @override
  List<Object?> get props => [id, code, name];
}
