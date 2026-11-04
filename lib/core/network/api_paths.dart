abstract final class ApiPaths {
  static const login = '/auth/login';
  static const logout = '/auth/logout';
  static const me = '/auth/me';
  static const changePassword = '/auth/change-password';
  static const semesters = '/semesters';
  static const portalMe = '/portal/me';
  static const portalCurriculum = '/portal/curriculum';
  static const portalPlos = '/portal/plos';

  static String portalSyllabus(String itemId) =>
      '/portal/curriculum-items/${Uri.encodeComponent(itemId)}/syllabus';

  static String portalAttachment(String itemId, String attachmentId) =>
      '${portalSyllabus(itemId)}/attachments/'
      '${Uri.encodeComponent(attachmentId)}/file';

  static String studentResults(String id) =>
      '/students/${Uri.encodeComponent(id)}/results';

  static String studentEligibility(String id) =>
      '/students/${Uri.encodeComponent(id)}/registration-eligibility';

  static String studentGraduation(String id) =>
      '/students/${Uri.encodeComponent(id)}/graduation';
}
