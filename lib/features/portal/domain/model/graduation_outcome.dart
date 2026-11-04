import 'package:equatable/equatable.dart';

import 'graduation_result.dart';

sealed class GraduationOutcome extends Equatable {
  const GraduationOutcome();
}

class GraduationReviewed extends GraduationOutcome {
  const GraduationReviewed(this.result);

  final GraduationResult result;

  @override
  List<Object?> get props => [result];
}

class GraduationCannotAudit extends GraduationOutcome {
  const GraduationCannotAudit(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}

class GraduationUnsupported extends GraduationOutcome {
  const GraduationUnsupported(this.schemaVersion);

  final int schemaVersion;

  @override
  List<Object?> get props => [schemaVersion];
}
