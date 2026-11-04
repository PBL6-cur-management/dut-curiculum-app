import '../../../../core/network/contract_exception.dart';
import '../../domain/model/portal_context.dart';

void validateGraduationContext(Object? returned, PortalContext expected) {
  if (returned is! Map<String, dynamic> ||
      returned['studentId'] != expected.studentId ||
      returned['programId'] != expected.programId ||
      returned['semesterId'] != expected.semesterId) {
    throw const ContractException('graduation-context-mismatch');
  }
}
