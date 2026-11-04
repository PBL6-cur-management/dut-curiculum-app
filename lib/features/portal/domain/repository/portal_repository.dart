import '../model/curriculum.dart';
import '../model/eligibility_report.dart';
import '../model/graduation_outcome.dart';
import '../model/plo.dart';
import '../model/portal_context.dart';
import '../model/portal_overview.dart';
import '../model/result_page.dart';
import '../model/semester.dart';
import '../model/syllabus.dart';
import '../model/syllabus_attachment.dart';

abstract class PortalRepository {
  Future<List<Semester>> startedSemesters();
  Future<PortalOverview> overview({String? semesterId});
  Future<Curriculum> curriculum(PortalContext context);
  Future<List<Plo>> plos(PortalContext context);
  Future<Syllabus> syllabus(PortalContext context, String itemId);
  Future<String> downloadAttachment(
    PortalContext context,
    String itemId,
    SyllabusAttachment attachment, {
    void Function(int received, int total)? onProgress,
  });
  Future<ResultPage> results(PortalContext context, {required int page});
  Future<EligibilityReport> eligibility(PortalContext context);
  Future<GraduationOutcome> graduation(PortalContext context);
}
