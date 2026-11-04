import 'package:mocktail/mocktail.dart';
import 'package:dut_curriculum_app/core/files/attachment_viewer.dart';
import 'package:dut_curriculum_app/features/auth/domain/use_case/auth_use_cases.dart';
import 'package:dut_curriculum_app/features/portal/domain/model/portal_context.dart';
import 'package:dut_curriculum_app/features/portal/domain/use_case/portal_use_cases.dart';

class MockAuthUseCases extends Mock implements AuthUseCases {}

class MockPortalUseCases extends Mock implements PortalUseCases {}

class MockAttachmentViewer extends Mock implements AttachmentViewer {}

const portalContext = PortalContext(
  studentId: 'student-1',
  programId: 'program-1',
  semesterId: 'semester-1',
);
