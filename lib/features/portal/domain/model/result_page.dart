import 'package:equatable/equatable.dart';
import 'academic_result.dart';

class ResultPage extends Equatable {
  const ResultPage({
    required this.items,
    required this.total,
    required this.page,
    required this.pageSize,
  });

  final List<AcademicResult> items;
  final int total;
  final int page;
  final int pageSize;

  @override
  List<Object?> get props => [items, total, page, pageSize];
}
