import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_vi.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[Locale('vi')];

  /// No description provided for @appTitle.
  ///
  /// In vi, this message translates to:
  /// **'dDUT CTĐT'**
  String get appTitle;

  /// No description provided for @wordmark.
  ///
  /// In vi, this message translates to:
  /// **'dDUT'**
  String get wordmark;

  /// No description provided for @wordmarkPrefix.
  ///
  /// In vi, this message translates to:
  /// **'dD'**
  String get wordmarkPrefix;

  /// No description provided for @wordmarkU.
  ///
  /// In vi, this message translates to:
  /// **'U'**
  String get wordmarkU;

  /// No description provided for @wordmarkT.
  ///
  /// In vi, this message translates to:
  /// **'T'**
  String get wordmarkT;

  /// No description provided for @loginWelcome.
  ///
  /// In vi, this message translates to:
  /// **'Chào mừng đến với DUT số'**
  String get loginWelcome;

  /// No description provided for @loginButton.
  ///
  /// In vi, this message translates to:
  /// **'ĐĂNG NHẬP'**
  String get loginButton;

  /// No description provided for @loginSubtitle.
  ///
  /// In vi, this message translates to:
  /// **'Đăng nhập bằng tài khoản hệ thống Quản lý chương trình đào tạo'**
  String get loginSubtitle;

  /// No description provided for @username.
  ///
  /// In vi, this message translates to:
  /// **'Tên đăng nhập'**
  String get username;

  /// No description provided for @password.
  ///
  /// In vi, this message translates to:
  /// **'Mật khẩu'**
  String get password;

  /// No description provided for @showPassword.
  ///
  /// In vi, this message translates to:
  /// **'Hiện mật khẩu'**
  String get showPassword;

  /// No description provided for @hidePassword.
  ///
  /// In vi, this message translates to:
  /// **'Ẩn mật khẩu'**
  String get hidePassword;

  /// No description provided for @submitLogin.
  ///
  /// In vi, this message translates to:
  /// **'Đăng nhập tài khoản'**
  String get submitLogin;

  /// No description provided for @requiredCredentials.
  ///
  /// In vi, this message translates to:
  /// **'Nhập tên đăng nhập và mật khẩu.'**
  String get requiredCredentials;

  /// No description provided for @changePassword.
  ///
  /// In vi, this message translates to:
  /// **'Đổi mật khẩu'**
  String get changePassword;

  /// No description provided for @currentPassword.
  ///
  /// In vi, this message translates to:
  /// **'Mật khẩu hiện tại'**
  String get currentPassword;

  /// No description provided for @newPassword.
  ///
  /// In vi, this message translates to:
  /// **'Mật khẩu mới'**
  String get newPassword;

  /// No description provided for @confirmPassword.
  ///
  /// In vi, this message translates to:
  /// **'Xác nhận mật khẩu mới'**
  String get confirmPassword;

  /// No description provided for @forcedPasswordChange.
  ///
  /// In vi, this message translates to:
  /// **'Bạn cần đổi mật khẩu trước khi tiếp tục.'**
  String get forcedPasswordChange;

  /// No description provided for @passwordPolicy.
  ///
  /// In vi, this message translates to:
  /// **'Mật khẩu mới gồm 8–128 ký tự, có ít nhất một chữ cái và một chữ số.'**
  String get passwordPolicy;

  /// No description provided for @passwordMismatch.
  ///
  /// In vi, this message translates to:
  /// **'Mật khẩu xác nhận không khớp.'**
  String get passwordMismatch;

  /// No description provided for @currentPasswordRequired.
  ///
  /// In vi, this message translates to:
  /// **'Nhập mật khẩu hiện tại.'**
  String get currentPasswordRequired;

  /// No description provided for @passwordChanged.
  ///
  /// In vi, this message translates to:
  /// **'Đã đổi mật khẩu.'**
  String get passwordChanged;

  /// No description provided for @home.
  ///
  /// In vi, this message translates to:
  /// **'Trang chủ'**
  String get home;

  /// No description provided for @profile.
  ///
  /// In vi, this message translates to:
  /// **'Hồ sơ'**
  String get profile;

  /// No description provided for @fullName.
  ///
  /// In vi, this message translates to:
  /// **'Họ tên'**
  String get fullName;

  /// No description provided for @userCode.
  ///
  /// In vi, this message translates to:
  /// **'Mã'**
  String get userCode;

  /// No description provided for @email.
  ///
  /// In vi, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @roles.
  ///
  /// In vi, this message translates to:
  /// **'Vai trò'**
  String get roles;

  /// No description provided for @notProvided.
  ///
  /// In vi, this message translates to:
  /// **'Chưa có thông tin'**
  String get notProvided;

  /// No description provided for @emptyValue.
  ///
  /// In vi, this message translates to:
  /// **'_'**
  String get emptyValue;

  /// No description provided for @scoreTenLabel.
  ///
  /// In vi, this message translates to:
  /// **'Điểm hệ 10'**
  String get scoreTenLabel;

  /// No description provided for @scoreFourLabel.
  ///
  /// In vi, this message translates to:
  /// **'Điểm hệ 4'**
  String get scoreFourLabel;

  /// No description provided for @letterGradeLabel.
  ///
  /// In vi, this message translates to:
  /// **'Điểm chữ'**
  String get letterGradeLabel;

  /// No description provided for @attemptCountLabel.
  ///
  /// In vi, this message translates to:
  /// **'Số lần học'**
  String get attemptCountLabel;

  /// No description provided for @logout.
  ///
  /// In vi, this message translates to:
  /// **'Đăng xuất'**
  String get logout;

  /// No description provided for @logoutConfirmation.
  ///
  /// In vi, this message translates to:
  /// **'Bạn muốn đăng xuất tài khoản này?'**
  String get logoutConfirmation;

  /// No description provided for @cancel.
  ///
  /// In vi, this message translates to:
  /// **'Hủy thao tác'**
  String get cancel;

  /// No description provided for @notifications.
  ///
  /// In vi, this message translates to:
  /// **'Thông báo'**
  String get notifications;

  /// No description provided for @curriculum.
  ///
  /// In vi, this message translates to:
  /// **'Chương trình đào tạo'**
  String get curriculum;

  /// No description provided for @timetable.
  ///
  /// In vi, this message translates to:
  /// **'Thời khóa biểu'**
  String get timetable;

  /// No description provided for @academicResults.
  ///
  /// In vi, this message translates to:
  /// **'Kết quả học tập'**
  String get academicResults;

  /// No description provided for @academicAffairs.
  ///
  /// In vi, this message translates to:
  /// **'Học vụ'**
  String get academicAffairs;

  /// No description provided for @homeroomClass.
  ///
  /// In vi, this message translates to:
  /// **'Lớp sinh hoạt'**
  String get homeroomClass;

  /// No description provided for @tuition.
  ///
  /// In vi, this message translates to:
  /// **'Học phí'**
  String get tuition;

  /// No description provided for @creditRegistration.
  ///
  /// In vi, this message translates to:
  /// **'Đăng ký tín chỉ'**
  String get creditRegistration;

  /// No description provided for @communityActivities.
  ///
  /// In vi, this message translates to:
  /// **'Hoạt động cộng đồng'**
  String get communityActivities;

  /// No description provided for @assistant.
  ///
  /// In vi, this message translates to:
  /// **'Trợ lý dDUT'**
  String get assistant;

  /// No description provided for @feedback.
  ///
  /// In vi, this message translates to:
  /// **'Góp ý'**
  String get feedback;

  /// No description provided for @serviceQueue.
  ///
  /// In vi, this message translates to:
  /// **'Lấy số tổ 1 cửa'**
  String get serviceQueue;

  /// No description provided for @todayNoSchedule.
  ///
  /// In vi, this message translates to:
  /// **'Hôm nay không có lịch nào!'**
  String get todayNoSchedule;

  /// No description provided for @monthLabel.
  ///
  /// In vi, this message translates to:
  /// **'Tháng {month}'**
  String monthLabel(int month);

  /// No description provided for @sunday.
  ///
  /// In vi, this message translates to:
  /// **'Chủ Nhật'**
  String get sunday;

  /// No description provided for @monday.
  ///
  /// In vi, this message translates to:
  /// **'Thứ Hai'**
  String get monday;

  /// No description provided for @tuesday.
  ///
  /// In vi, this message translates to:
  /// **'Thứ Ba'**
  String get tuesday;

  /// No description provided for @wednesday.
  ///
  /// In vi, this message translates to:
  /// **'Thứ Tư'**
  String get wednesday;

  /// No description provided for @thursday.
  ///
  /// In vi, this message translates to:
  /// **'Thứ Năm'**
  String get thursday;

  /// No description provided for @friday.
  ///
  /// In vi, this message translates to:
  /// **'Thứ Sáu'**
  String get friday;

  /// No description provided for @saturday.
  ///
  /// In vi, this message translates to:
  /// **'Thứ Bảy'**
  String get saturday;

  /// No description provided for @placeholderBody.
  ///
  /// In vi, this message translates to:
  /// **'Đây là bản mô phỏng ứng dụng dDUT, dùng để trình diễn hệ thống Quản lý CTĐT.'**
  String get placeholderBody;

  /// No description provided for @placeholderOpenCurriculum.
  ///
  /// In vi, this message translates to:
  /// **'Mở Chương trình đào tạo'**
  String get placeholderOpenCurriculum;

  /// No description provided for @unknownTile.
  ///
  /// In vi, this message translates to:
  /// **'Không tìm thấy chức năng được yêu cầu.'**
  String get unknownTile;

  /// No description provided for @retry.
  ///
  /// In vi, this message translates to:
  /// **'Thử lại yêu cầu'**
  String get retry;

  /// No description provided for @loading.
  ///
  /// In vi, this message translates to:
  /// **'Đang tải dữ liệu'**
  String get loading;

  /// No description provided for @checkingSession.
  ///
  /// In vi, this message translates to:
  /// **'Đang kiểm tra phiên đăng nhập'**
  String get checkingSession;

  /// No description provided for @sessionExpired.
  ///
  /// In vi, this message translates to:
  /// **'Phiên đăng nhập đã hết hạn. Vui lòng đăng nhập lại.'**
  String get sessionExpired;

  /// No description provided for @networkError.
  ///
  /// In vi, this message translates to:
  /// **'Không kết nối được máy chủ. Kiểm tra mạng rồi thử lại.'**
  String get networkError;

  /// No description provided for @invalidResponse.
  ///
  /// In vi, this message translates to:
  /// **'Phản hồi máy chủ không đúng định dạng: {detail}'**
  String invalidResponse(String detail);

  /// No description provided for @missingApiBaseUrl.
  ///
  /// In vi, this message translates to:
  /// **'Thiếu API_BASE_URL: chạy với --dart-define-from-file=.env'**
  String get missingApiBaseUrl;

  /// No description provided for @noStudentLinked.
  ///
  /// In vi, this message translates to:
  /// **'Tài khoản chưa được liên kết với hồ sơ sinh viên. Liên hệ Phòng Đào tạo.'**
  String get noStudentLinked;

  /// No description provided for @noProgram.
  ///
  /// In vi, this message translates to:
  /// **'Chưa xác định được chương trình, liên hệ Phòng Đào tạo.'**
  String get noProgram;

  /// No description provided for @graduationInfo.
  ///
  /// In vi, this message translates to:
  /// **'Kết quả tính tại thời điểm xem, chưa phải quyết định công nhận tốt nghiệp.'**
  String get graduationInfo;

  /// No description provided for @unsupportedResultVersion.
  ///
  /// In vi, this message translates to:
  /// **'Chưa hỗ trợ phiên bản kết quả này'**
  String get unsupportedResultVersion;

  /// No description provided for @statePassed.
  ///
  /// In vi, this message translates to:
  /// **'Đã đạt'**
  String get statePassed;

  /// No description provided for @statePassedEquivalent.
  ///
  /// In vi, this message translates to:
  /// **'Đạt bằng HP tương đương'**
  String get statePassedEquivalent;

  /// No description provided for @stateInProgress.
  ///
  /// In vi, this message translates to:
  /// **'Đang học'**
  String get stateInProgress;

  /// No description provided for @stateFailed.
  ///
  /// In vi, this message translates to:
  /// **'Chưa đạt'**
  String get stateFailed;

  /// No description provided for @stateNotTaken.
  ///
  /// In vi, this message translates to:
  /// **'Chưa học'**
  String get stateNotTaken;

  /// No description provided for @eligible.
  ///
  /// In vi, this message translates to:
  /// **'Đủ điều kiện'**
  String get eligible;

  /// No description provided for @conditional.
  ///
  /// In vi, this message translates to:
  /// **'Phải học cùng'**
  String get conditional;

  /// No description provided for @registrationEligible.
  ///
  /// In vi, this message translates to:
  /// **'Đăng ký được'**
  String get registrationEligible;

  /// No description provided for @registrationIneligible.
  ///
  /// In vi, this message translates to:
  /// **'Chưa đăng ký được'**
  String get registrationIneligible;

  /// No description provided for @primaryMajor.
  ///
  /// In vi, this message translates to:
  /// **'Ngành chính'**
  String get primaryMajor;

  /// No description provided for @secondMajor.
  ///
  /// In vi, this message translates to:
  /// **'Ngành thứ hai'**
  String get secondMajor;

  /// No description provided for @studentStudying.
  ///
  /// In vi, this message translates to:
  /// **'Đang học'**
  String get studentStudying;

  /// No description provided for @studentOnLeave.
  ///
  /// In vi, this message translates to:
  /// **'Bảo lưu'**
  String get studentOnLeave;

  /// No description provided for @studentWithdrawn.
  ///
  /// In vi, this message translates to:
  /// **'Thôi học'**
  String get studentWithdrawn;

  /// No description provided for @studentGraduated.
  ///
  /// In vi, this message translates to:
  /// **'Đã tốt nghiệp'**
  String get studentGraduated;

  /// No description provided for @ineligible.
  ///
  /// In vi, this message translates to:
  /// **'Chưa đủ điều kiện'**
  String get ineligible;

  /// No description provided for @signedSyllabus.
  ///
  /// In vi, this message translates to:
  /// **'Đề cương có chữ ký'**
  String get signedSyllabus;

  /// No description provided for @textbook.
  ///
  /// In vi, this message translates to:
  /// **'Giáo trình'**
  String get textbook;

  /// No description provided for @lectureSlides.
  ///
  /// In vi, this message translates to:
  /// **'Bài giảng'**
  String get lectureSlides;

  /// No description provided for @other.
  ///
  /// In vi, this message translates to:
  /// **'Khác'**
  String get other;

  /// No description provided for @otherMaterial.
  ///
  /// In vi, this message translates to:
  /// **'Tài liệu khác'**
  String get otherMaterial;

  /// No description provided for @mandatoryCourseMissing.
  ///
  /// In vi, this message translates to:
  /// **'Thiếu học phần bắt buộc'**
  String get mandatoryCourseMissing;

  /// No description provided for @conditionalCourseMissing.
  ///
  /// In vi, this message translates to:
  /// **'Chưa hoàn thành học phần điều kiện'**
  String get conditionalCourseMissing;

  /// No description provided for @electiveCreditsMissing.
  ///
  /// In vi, this message translates to:
  /// **'Thiếu tín chỉ nhóm tự chọn'**
  String get electiveCreditsMissing;

  /// No description provided for @electiveCoursesMissing.
  ///
  /// In vi, this message translates to:
  /// **'Thiếu số học phần nhóm tự chọn'**
  String get electiveCoursesMissing;

  /// No description provided for @totalCreditsMissing.
  ///
  /// In vi, this message translates to:
  /// **'Thiếu tổng tín chỉ'**
  String get totalCreditsMissing;

  /// No description provided for @bytes.
  ///
  /// In vi, this message translates to:
  /// **'{value} B'**
  String bytes(String value);

  /// No description provided for @kilobytes.
  ///
  /// In vi, this message translates to:
  /// **'{value} KB'**
  String kilobytes(String value);

  /// No description provided for @myCurriculum.
  ///
  /// In vi, this message translates to:
  /// **'Chương trình của tôi'**
  String get myCurriculum;

  /// No description provided for @plos.
  ///
  /// In vi, this message translates to:
  /// **'Chuẩn đầu ra (PLO)'**
  String get plos;

  /// No description provided for @progressResults.
  ///
  /// In vi, this message translates to:
  /// **'Tiến độ và kết quả'**
  String get progressResults;

  /// No description provided for @registration.
  ///
  /// In vi, this message translates to:
  /// **'Đăng ký học phần'**
  String get registration;

  /// No description provided for @graduation.
  ///
  /// In vi, this message translates to:
  /// **'Xét tốt nghiệp'**
  String get graduation;

  /// No description provided for @semesterView.
  ///
  /// In vi, this message translates to:
  /// **'Học kỳ xem'**
  String get semesterView;

  /// No description provided for @studentCode.
  ///
  /// In vi, this message translates to:
  /// **'Mã sinh viên'**
  String get studentCode;

  /// No description provided for @cohort.
  ///
  /// In vi, this message translates to:
  /// **'Khóa'**
  String get cohort;

  /// No description provided for @major.
  ///
  /// In vi, this message translates to:
  /// **'Ngành'**
  String get major;

  /// No description provided for @version.
  ///
  /// In vi, this message translates to:
  /// **'Phiên bản'**
  String get version;

  /// No description provided for @decision.
  ///
  /// In vi, this message translates to:
  /// **'Quyết định'**
  String get decision;

  /// No description provided for @noVersion.
  ///
  /// In vi, this message translates to:
  /// **'Chưa có'**
  String get noVersion;

  /// No description provided for @noDecision.
  ///
  /// In vi, this message translates to:
  /// **'Chưa có số quyết định'**
  String get noDecision;

  /// No description provided for @noData.
  ///
  /// In vi, this message translates to:
  /// **'Chưa có dữ liệu.'**
  String get noData;

  /// No description provided for @noPlos.
  ///
  /// In vi, this message translates to:
  /// **'Phiên bản chương trình này chưa có chuẩn đầu ra. Khoa sẽ cập nhật khi ban hành.'**
  String get noPlos;

  /// No description provided for @ploSummary.
  ///
  /// In vi, this message translates to:
  /// **'{count} chuẩn đầu ra · {groups} nhóm năng lực'**
  String ploSummary(int count, int groups);

  /// No description provided for @allCourses.
  ///
  /// In vi, this message translates to:
  /// **'Tất cả'**
  String get allCourses;

  /// No description provided for @elective.
  ///
  /// In vi, this message translates to:
  /// **'Tự chọn'**
  String get elective;

  /// No description provided for @noSyllabus.
  ///
  /// In vi, this message translates to:
  /// **'Chưa có đề cương'**
  String get noSyllabus;

  /// No description provided for @syllabus.
  ///
  /// In vi, this message translates to:
  /// **'Đề cương học phần'**
  String get syllabus;

  /// No description provided for @courseDescription.
  ///
  /// In vi, this message translates to:
  /// **'Mô tả học phần'**
  String get courseDescription;

  /// No description provided for @objectives.
  ///
  /// In vi, this message translates to:
  /// **'Mục tiêu'**
  String get objectives;

  /// No description provided for @clos.
  ///
  /// In vi, this message translates to:
  /// **'Chuẩn đầu ra học phần (CLO)'**
  String get clos;

  /// No description provided for @teachingMethods.
  ///
  /// In vi, this message translates to:
  /// **'Phương pháp giảng dạy'**
  String get teachingMethods;

  /// No description provided for @weeklyPlan.
  ///
  /// In vi, this message translates to:
  /// **'Kế hoạch theo tuần'**
  String get weeklyPlan;

  /// No description provided for @assessment.
  ///
  /// In vi, this message translates to:
  /// **'Đánh giá'**
  String get assessment;

  /// No description provided for @assessmentMethods.
  ///
  /// In vi, this message translates to:
  /// **'Phương pháp đánh giá'**
  String get assessmentMethods;

  /// No description provided for @references.
  ///
  /// In vi, this message translates to:
  /// **'Tài liệu tham khảo'**
  String get references;

  /// No description provided for @attachments.
  ///
  /// In vi, this message translates to:
  /// **'Tài liệu đính kèm'**
  String get attachments;

  /// No description provided for @assessmentComponent.
  ///
  /// In vi, this message translates to:
  /// **'Thành phần'**
  String get assessmentComponent;

  /// No description provided for @assessmentForm.
  ///
  /// In vi, this message translates to:
  /// **'Hình thức'**
  String get assessmentForm;

  /// No description provided for @assessmentWeight.
  ///
  /// In vi, this message translates to:
  /// **'Trọng số'**
  String get assessmentWeight;

  /// No description provided for @downloadAttachment.
  ///
  /// In vi, this message translates to:
  /// **'Mở tài liệu'**
  String get downloadAttachment;

  /// No description provided for @stateExempt.
  ///
  /// In vi, this message translates to:
  /// **'Miễn học'**
  String get stateExempt;

  /// No description provided for @recognizedCredits.
  ///
  /// In vi, this message translates to:
  /// **'Tín chỉ được công nhận'**
  String get recognizedCredits;

  /// No description provided for @requiredCredits.
  ///
  /// In vi, this message translates to:
  /// **'Tổng tín chỉ yêu cầu'**
  String get requiredCredits;

  /// No description provided for @missingCredits.
  ///
  /// In vi, this message translates to:
  /// **'Tín chỉ còn thiếu'**
  String get missingCredits;

  /// No description provided for @compulsoryCredits.
  ///
  /// In vi, this message translates to:
  /// **'Tín chỉ bắt buộc'**
  String get compulsoryCredits;

  /// No description provided for @electiveCredits.
  ///
  /// In vi, this message translates to:
  /// **'Tín chỉ tự chọn'**
  String get electiveCredits;

  /// No description provided for @freeCredits.
  ///
  /// In vi, this message translates to:
  /// **'Tín chỉ tự do'**
  String get freeCredits;

  /// No description provided for @results.
  ///
  /// In vi, this message translates to:
  /// **'Kết quả học tập'**
  String get results;

  /// No description provided for @loadMore.
  ///
  /// In vi, this message translates to:
  /// **'Tải thêm kết quả'**
  String get loadMore;

  /// No description provided for @registrationAllowed.
  ///
  /// In vi, this message translates to:
  /// **'Có thể đăng ký'**
  String get registrationAllowed;

  /// No description provided for @registrationBlocked.
  ///
  /// In vi, this message translates to:
  /// **'Chưa đăng ký được'**
  String get registrationBlocked;

  /// No description provided for @catalogDiscontinued.
  ///
  /// In vi, this message translates to:
  /// **'Ngừng đào tạo'**
  String get catalogDiscontinued;

  /// No description provided for @catalogCancelled.
  ///
  /// In vi, this message translates to:
  /// **'Đã hủy'**
  String get catalogCancelled;

  /// No description provided for @warnings.
  ///
  /// In vi, this message translates to:
  /// **'Lưu ý'**
  String get warnings;

  /// No description provided for @warningCount.
  ///
  /// In vi, this message translates to:
  /// **'Lưu ý ({count})'**
  String warningCount(int count);

  /// No description provided for @creditsOutOf.
  ///
  /// In vi, this message translates to:
  /// **'/ {total} tín chỉ'**
  String creditsOutOf(String total);

  /// No description provided for @compulsoryShort.
  ///
  /// In vi, this message translates to:
  /// **'Bắt buộc'**
  String get compulsoryShort;

  /// No description provided for @freeShort.
  ///
  /// In vi, this message translates to:
  /// **'Tự do'**
  String get freeShort;

  /// No description provided for @missingShort.
  ///
  /// In vi, this message translates to:
  /// **'Còn thiếu'**
  String get missingShort;

  /// No description provided for @shortfalls.
  ///
  /// In vi, this message translates to:
  /// **'Điều kiện còn thiếu'**
  String get shortfalls;

  /// No description provided for @mandatoryCourses.
  ///
  /// In vi, this message translates to:
  /// **'Học phần bắt buộc'**
  String get mandatoryCourses;

  /// No description provided for @conditionalCourses.
  ///
  /// In vi, this message translates to:
  /// **'Học phần điều kiện'**
  String get conditionalCourses;

  /// No description provided for @electiveGroups.
  ///
  /// In vi, this message translates to:
  /// **'Nhóm tự chọn'**
  String get electiveGroups;

  /// No description provided for @totalCredits.
  ///
  /// In vi, this message translates to:
  /// **'Tổng tín chỉ'**
  String get totalCredits;

  /// No description provided for @notSpecified.
  ///
  /// In vi, this message translates to:
  /// **'Không quy định'**
  String get notSpecified;

  /// No description provided for @knowledgeBlocks.
  ///
  /// In vi, this message translates to:
  /// **'Tham khảo, không phải điều kiện xét riêng'**
  String get knowledgeBlocks;

  /// No description provided for @creditsValue.
  ///
  /// In vi, this message translates to:
  /// **'{value} TC'**
  String creditsValue(String value);

  /// No description provided for @semesterNumber.
  ///
  /// In vi, this message translates to:
  /// **'Học kỳ {number}'**
  String semesterNumber(int number);

  /// No description provided for @semesterCodeLabel.
  ///
  /// In vi, this message translates to:
  /// **'Học kỳ {code}'**
  String semesterCodeLabel(String code);

  /// No description provided for @attempts.
  ///
  /// In vi, this message translates to:
  /// **'Học {count} lần'**
  String attempts(int count);

  /// No description provided for @scores.
  ///
  /// In vi, this message translates to:
  /// **'Điểm 10: {score10} · Điểm 4: {score4} · Điểm chữ: {letter}'**
  String scores(String score10, String score4, String letter);

  /// No description provided for @revision.
  ///
  /// In vi, this message translates to:
  /// **'Lần sửa {number}'**
  String revision(int number);

  /// No description provided for @publishedAt.
  ///
  /// In vi, this message translates to:
  /// **'Ngày công bố: {date}'**
  String publishedAt(String date);

  /// No description provided for @evaluatedAt.
  ///
  /// In vi, this message translates to:
  /// **'Thời điểm tính: {date}'**
  String evaluatedAt(String date);

  /// No description provided for @mustStudyTogether.
  ///
  /// In vi, this message translates to:
  /// **'Phải học cùng: {courses}'**
  String mustStudyTogether(String courses);

  /// No description provided for @creditProgress.
  ///
  /// In vi, this message translates to:
  /// **'{recognized}/{required} tín chỉ'**
  String creditProgress(String recognized, String required);

  /// No description provided for @requiredEarnedMissing.
  ///
  /// In vi, this message translates to:
  /// **'Yêu cầu: {required} · Đạt: {earned} · Thiếu: {missing}'**
  String requiredEarnedMissing(String required, String earned, String missing);

  /// No description provided for @courseCount.
  ///
  /// In vi, this message translates to:
  /// **'Số học phần: {required} · Đạt: {earned} · Thiếu: {missing}'**
  String courseCount(String required, String earned, String missing);

  /// No description provided for @percentValue.
  ///
  /// In vi, this message translates to:
  /// **'{value}%'**
  String percentValue(String value);

  /// No description provided for @advisoryGap.
  ///
  /// In vi, this message translates to:
  /// **'Chênh lệch tham khảo: {value}'**
  String advisoryGap(String value);

  /// No description provided for @fieldValue.
  ///
  /// In vi, this message translates to:
  /// **'{label}: {value}'**
  String fieldValue(String label, String value);

  /// No description provided for @bulletItem.
  ///
  /// In vi, this message translates to:
  /// **'• {value}'**
  String bulletItem(String value);

  /// No description provided for @megabytes.
  ///
  /// In vi, this message translates to:
  /// **'{value} MB'**
  String megabytes(String value);

  /// No description provided for @portalContext.
  ///
  /// In vi, this message translates to:
  /// **'Ngữ cảnh học tập'**
  String get portalContext;

  /// No description provided for @portalChangeContext.
  ///
  /// In vi, this message translates to:
  /// **'Đổi chương trình hoặc học kỳ'**
  String get portalChangeContext;

  /// No description provided for @portalAppliedCurriculum.
  ///
  /// In vi, this message translates to:
  /// **'Chương trình áp dụng'**
  String get portalAppliedCurriculum;

  /// No description provided for @portalMissingSemester.
  ///
  /// In vi, this message translates to:
  /// **'Chưa có học kỳ có ngày bắt đầu để xem. Vui lòng thử lại hoặc liên hệ đơn vị đào tạo.'**
  String get portalMissingSemester;

  /// No description provided for @portalNoApplicableProgram.
  ///
  /// In vi, this message translates to:
  /// **'Chưa xác định được chương trình áp dụng trong học kỳ này. Hãy đổi học kỳ, thử lại hoặc liên hệ đơn vị đào tạo.'**
  String get portalNoApplicableProgram;

  /// No description provided for @portalCompulsoryCredits.
  ///
  /// In vi, this message translates to:
  /// **'{value} TC bắt buộc'**
  String portalCompulsoryCredits(String value);

  /// No description provided for @portalNoTerms.
  ///
  /// In vi, this message translates to:
  /// **'Chưa có học phần trong phiên bản chương trình này.'**
  String get portalNoTerms;

  /// No description provided for @portalNoFilterMatches.
  ///
  /// In vi, this message translates to:
  /// **'Không có học phần phù hợp với bộ lọc.'**
  String get portalNoFilterMatches;

  /// No description provided for @portalClearFilter.
  ///
  /// In vi, this message translates to:
  /// **'Xóa bộ lọc'**
  String get portalClearFilter;

  /// No description provided for @portalChooseWithinGroup.
  ///
  /// In vi, this message translates to:
  /// **'Chọn học phần trong nhóm này'**
  String get portalChooseWithinGroup;

  /// No description provided for @portalCourseDetails.
  ///
  /// In vi, this message translates to:
  /// **'Chi tiết kết quả học phần'**
  String get portalCourseDetails;

  /// No description provided for @portalEquivalentFrom.
  ///
  /// In vi, this message translates to:
  /// **'Được công nhận qua học phần {course}'**
  String portalEquivalentFrom(String course);

  /// No description provided for @portalEquivalentUnavailable.
  ///
  /// In vi, this message translates to:
  /// **'Chưa tải được học phần tương đương. Kết quả công nhận vẫn được giữ nguyên.'**
  String get portalEquivalentUnavailable;

  /// No description provided for @portalEquivalentNotSupplied.
  ///
  /// In vi, this message translates to:
  /// **'Chưa có thông tin học phần nguồn trong dữ liệu trả về.'**
  String get portalEquivalentNotSupplied;

  /// No description provided for @portalNoIssuedSyllabus.
  ///
  /// In vi, this message translates to:
  /// **'Chưa liên kết đề cương đã ban hành'**
  String get portalNoIssuedSyllabus;

  /// No description provided for @portalAssessmentNotice.
  ///
  /// In vi, this message translates to:
  /// **'Chỉ hiển thị thành phần và mô tả đánh giá được cung cấp. Xem tài liệu ban hành để biết điều kiện đánh giá đầy đủ.'**
  String get portalAssessmentNotice;

  /// No description provided for @portalCreditBreakdown.
  ///
  /// In vi, this message translates to:
  /// **'Chi tiết tín chỉ'**
  String get portalCreditBreakdown;

  /// No description provided for @portalScore10.
  ///
  /// In vi, this message translates to:
  /// **'{value}/10'**
  String portalScore10(String value);

  /// No description provided for @portalScore4.
  ///
  /// In vi, this message translates to:
  /// **'{value}/4'**
  String portalScore4(String value);

  /// No description provided for @portalHistoryScope.
  ///
  /// In vi, this message translates to:
  /// **'Lịch sử có thể gồm học phần không được tính tín chỉ cho chương trình đang xem.'**
  String get portalHistoryScope;

  /// No description provided for @portalProgressTab.
  ///
  /// In vi, this message translates to:
  /// **'Tiến độ'**
  String get portalProgressTab;

  /// No description provided for @portalResultsTab.
  ///
  /// In vi, this message translates to:
  /// **'Kết quả'**
  String get portalResultsTab;

  /// No description provided for @portalEligibilityTitle.
  ///
  /// In vi, this message translates to:
  /// **'Điều kiện đăng ký'**
  String get portalEligibilityTitle;

  /// No description provided for @portalEligibilityAdvice.
  ///
  /// In vi, this message translates to:
  /// **'Thông tin tham khảo về điều kiện học phần, không phải đăng ký lớp hay xác nhận lớp được mở.'**
  String get portalEligibilityAdvice;

  /// No description provided for @portalUnknownEligibility.
  ///
  /// In vi, this message translates to:
  /// **'Chưa đủ thông tin kết luận điều kiện đăng ký'**
  String get portalUnknownEligibility;

  /// No description provided for @portalNoCandidates.
  ///
  /// In vi, this message translates to:
  /// **'Không có học phần chưa hoàn thành trong nhóm này.'**
  String get portalNoCandidates;

  /// No description provided for @portalAllCompleted.
  ///
  /// In vi, this message translates to:
  /// **'Tất cả học phần trong dữ liệu trả về đã hoàn thành.'**
  String get portalAllCompleted;

  /// No description provided for @portalConditions.
  ///
  /// In vi, this message translates to:
  /// **'Điều kiện cần lưu ý'**
  String get portalConditions;

  /// No description provided for @portalEvaluationBasis.
  ///
  /// In vi, this message translates to:
  /// **'Cơ sở và thời điểm đánh giá'**
  String get portalEvaluationBasis;

  /// No description provided for @portalNoShortfalls.
  ///
  /// In vi, this message translates to:
  /// **'Không có điều kiện còn thiếu trong kết quả đánh giá trả về.'**
  String get portalNoShortfalls;

  /// No description provided for @portalNotApplicable.
  ///
  /// In vi, this message translates to:
  /// **'Không áp dụng'**
  String get portalNotApplicable;

  /// No description provided for @portalCurriculumHint.
  ///
  /// In vi, this message translates to:
  /// **'Xem học phần cần hoàn thành'**
  String get portalCurriculumHint;

  /// No description provided for @portalPlosHint.
  ///
  /// In vi, this message translates to:
  /// **'Xem năng lực chương trình hướng tới'**
  String get portalPlosHint;

  /// No description provided for @portalProgressHint.
  ///
  /// In vi, this message translates to:
  /// **'Kiểm tra tín chỉ và kết quả đã ghi nhận'**
  String get portalProgressHint;

  /// No description provided for @portalEligibilityHint.
  ///
  /// In vi, this message translates to:
  /// **'Kiểm tra điều kiện trước khi đăng ký'**
  String get portalEligibilityHint;

  /// No description provided for @portalGraduationHint.
  ///
  /// In vi, this message translates to:
  /// **'Xem điều kiện tốt nghiệp còn thiếu'**
  String get portalGraduationHint;

  /// No description provided for @basicInfo.
  ///
  /// In vi, this message translates to:
  /// **'Thông tin cơ bản'**
  String get basicInfo;

  /// No description provided for @academicInfo.
  ///
  /// In vi, this message translates to:
  /// **'Thông tin học vấn'**
  String get academicInfo;

  /// No description provided for @birthDate.
  ///
  /// In vi, this message translates to:
  /// **'Ngày sinh'**
  String get birthDate;

  /// No description provided for @gender.
  ///
  /// In vi, this message translates to:
  /// **'Giới tính'**
  String get gender;

  /// No description provided for @phoneNumber.
  ///
  /// In vi, this message translates to:
  /// **'Số điện thoại'**
  String get phoneNumber;

  /// No description provided for @personalEmail.
  ///
  /// In vi, this message translates to:
  /// **'Email cá nhân'**
  String get personalEmail;

  /// No description provided for @programShort.
  ///
  /// In vi, this message translates to:
  /// **'CTĐT'**
  String get programShort;

  /// No description provided for @office365Account.
  ///
  /// In vi, this message translates to:
  /// **'TK Office365'**
  String get office365Account;

  /// No description provided for @noValue.
  ///
  /// In vi, this message translates to:
  /// **'Không có'**
  String get noValue;

  /// No description provided for @labelWithColon.
  ///
  /// In vi, this message translates to:
  /// **'{label}:'**
  String labelWithColon(String label);

  /// No description provided for @shortcutPlo.
  ///
  /// In vi, this message translates to:
  /// **'Chuẩn đầu ra'**
  String get shortcutPlo;

  /// No description provided for @shortcutProgress.
  ///
  /// In vi, this message translates to:
  /// **'Tiến độ'**
  String get shortcutProgress;

  /// No description provided for @shortcutEligibility.
  ///
  /// In vi, this message translates to:
  /// **'Điều kiện ĐK'**
  String get shortcutEligibility;

  /// No description provided for @shortcutGraduation.
  ///
  /// In vi, this message translates to:
  /// **'Tốt nghiệp'**
  String get shortcutGraduation;

  /// No description provided for @earnedCreditsOf.
  ///
  /// In vi, this message translates to:
  /// **'Đã tích lũy {earned}/{total} tín chỉ'**
  String earnedCreditsOf(String earned, String total);

  /// No description provided for @labelWithCount.
  ///
  /// In vi, this message translates to:
  /// **'{label} ({count})'**
  String labelWithCount(String label, int count);

  /// No description provided for @scoreWithLetter.
  ///
  /// In vi, this message translates to:
  /// **'Điểm: {score} ({letter})'**
  String scoreWithLetter(String score, String letter);

  /// No description provided for @creditsLong.
  ///
  /// In vi, this message translates to:
  /// **'{value} tín chỉ'**
  String creditsLong(String value);

  /// No description provided for @syllabusShort.
  ///
  /// In vi, this message translates to:
  /// **'Đề cương'**
  String get syllabusShort;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['vi'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'vi':
      return AppLocalizationsVi();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
