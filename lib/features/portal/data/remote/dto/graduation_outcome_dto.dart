import 'package:json_annotation/json_annotation.dart';
import 'package:dut_curriculum_app/l10n/app_localizations.dart';

import '../../../../../core/network/contract_exception.dart';
import '../../../domain/model/graduation_outcome.dart';
import '../portal_contract.dart';
import 'graduation_diagnostic_dto.dart';
import 'graduation_result_dto.dart';

part 'graduation_outcome_dto.g.dart';

@JsonSerializable()
class GraduationOutcomeDto {
  const GraduationOutcomeDto({
    required this.status,
    required this.result,
    required this.error,
  });

  factory GraduationOutcomeDto.fromJson(Map<String, dynamic> json) =>
      _$GraduationOutcomeDtoFromJson(json);

  final String status;
  final Map<String, dynamic>? result;
  final GraduationDiagnosticDto? error;

  Map<String, dynamic> toJson() => _$GraduationOutcomeDtoToJson(this);

  GraduationOutcome toDomain(AppLocalizations strings) {
    switch (status) {
      case 'CANNOT_AUDIT':
        if (error == null || result != null) {
          throw ContractException(status);
        }
        return GraduationCannotAudit(error!.message);
      case 'REVIEWED':
        final payload = result;
        if (payload == null || error != null) {
          throw ContractException(status);
        }
        final version = payload['schemaVersion'];
        if (version is! int) {
          throw ContractException(version.toString());
        }
        if (version != PortalContract.schemaVersion) {
          return GraduationUnsupported(version);
        }
        return GraduationReviewed(
          GraduationResultDto.fromJson(payload).toDomain(strings),
        );
      default:
        throw ContractException(status);
    }
  }
}
