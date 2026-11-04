import 'package:equatable/equatable.dart';

import '../../domain/model/plo.dart';

class PlosState extends Equatable {
  const PlosState({
    this.isLoading = true,
    this.items = const [],
    this.errorMessage,
  });

  final bool isLoading;
  final List<Plo> items;
  final String? errorMessage;

  @override
  List<Object?> get props => [isLoading, items, errorMessage];
}
