abstract final class RoutePaths {
  static const splash = '/';
  static const login = '/login';
  static const changePassword = '/change-password';
  static const home = '/home';
  static const profile = '/profile';
  static const placeholder = '/placeholder/:tile';
  static const placeholderTileParameter = 'tile';
  static const notificationsTile = 'notifications';
  static const notifications = '/placeholder/notifications';
  static const curriculum = '/curriculum';
  static const curriculumProgram = '/curriculum/program';
  static const syllabus = '/curriculum/program/syllabus/:itemId';
  static const syllabusItemParameter = 'itemId';
  static const plos = '/curriculum/plos';
  static const progress = '/curriculum/progress';
  static const registration = '/curriculum/registration';
  static const graduation = '/curriculum/graduation';

  static String placeholderFor(String tile) =>
      '/placeholder/${Uri.encodeComponent(tile)}';

  static String syllabusFor(String itemId) =>
      '/curriculum/program/syllabus/${Uri.encodeComponent(itemId)}';
}
