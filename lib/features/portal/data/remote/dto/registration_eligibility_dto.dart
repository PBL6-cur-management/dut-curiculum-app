import '../../../../../common/extensions/date_parsing.dart';
import '../../../../../core/network/contract_exception.dart';
import '../../../domain/model/student_warning_codes.dart';
import '../../../domain/model/eligibility_report.dart';
import '../portal_contract.dart';
import 'eligibility_item_dto.dart';
import 'eligibility_warning_dto.dart';
import 'package:dut_curriculum_app/l10n/app_localizations.dart';
import 'package:json_annotation/json_annotation.dart';

part 'registration_eligibility_dto.g.dart';

@JsonSerializable()
class RegistrationEligibilityDto {
  const RegistrationEligibilityDto({
    required this.contractVersion,
    required this.evaluatedAt,
    required this.items,
    required this.warnings,
  });

  factory RegistrationEligibilityDto.fromJson(Map<String, dynamic> json) =>
      _$RegistrationEligibilityDtoFromJson(json);

  final int contractVersion;
  final String evaluatedAt;
  final List<EligibilityItemDto> items;
  final List<EligibilityWarningDto> warnings;

  Map<String, dynamic> toJson() => _$RegistrationEligibilityDtoToJson(this);

  EligibilityReport toDomain(AppLocalizations strings) {
    if (contractVersion != PortalContract.eligibilityVersion) {
      throw ContractException(strings.unsupportedResultVersion);
    }
    return EligibilityReport(
      evaluatedAtMs: parseTimestamp(evaluatedAt),
      items: List.unmodifiable(items.map((item) => item.toDomain())),
      warnings: List.unmodifiable(
        warnings
            .where((item) => studentEligibilityWarningCodes.contains(item.code))
            .map((item) => item.toDomain()),
      ),
    );
  }
}
