import 'package:equatable/equatable.dart';
import 'course_ref.dart';

class EligibilityWarning extends Equatable {
  const EligibilityWarning({required this.message, required this.course});

  final String message;
  final CourseRef course;

  @override
  List<Object?> get props => [message, course];
}
