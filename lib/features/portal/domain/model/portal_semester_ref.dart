import 'package:equatable/equatable.dart';

class PortalSemesterRef extends Equatable {
  const PortalSemesterRef({required this.id, required this.code});

  final String id;
  final String code;

  @override
  List<Object?> get props => [id, code];
}
