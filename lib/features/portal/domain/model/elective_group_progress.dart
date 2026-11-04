import 'package:equatable/equatable.dart';

class ElectiveGroupProgress extends Equatable {
  const ElectiveGroupProgress({
    required this.groupCode,
    required this.groupName,
    required this.requiredCredits,
    required this.earnedCredits,
    required this.missingCredits,
    required this.requiredCourses,
    required this.earnedCourses,
    required this.missingCourses,
  });

  final String groupCode;
  final String groupName;
  final String? requiredCredits;
  final String earnedCredits;
  final String? missingCredits;
  final int? requiredCourses;
  final int earnedCourses;
  final int? missingCourses;

  @override
  List<Object?> get props => [
    groupCode,
    groupName,
    requiredCredits,
    earnedCredits,
    missingCredits,
    requiredCourses,
    earnedCourses,
    missingCourses,
  ];
}
