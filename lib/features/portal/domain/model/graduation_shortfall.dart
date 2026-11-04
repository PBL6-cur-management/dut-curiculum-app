import 'package:equatable/equatable.dart';
import 'shortfall_category.dart';

class GraduationShortfall extends Equatable {
  const GraduationShortfall({
    required this.category,
    required this.code,
    required this.title,
    required this.message,
  });

  final ShortfallCategory category;
  final String code;
  final String title;
  final String message;

  @override
  List<Object?> get props => [category, code, title, message];
}
