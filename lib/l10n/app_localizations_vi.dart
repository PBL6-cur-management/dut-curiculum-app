// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Vietnamese (`vi`).
class AppLocalizationsVi extends AppLocalizations {
  AppLocalizationsVi([String locale = 'vi']) : super(locale);

  @override
  String get appTitle => 'dDUT CTĐT';

  @override
  String get wordmark => 'dDUT';

  @override
  String get wordmarkPrefix => 'dD';

  @override
  String get wordmarkU => 'U';

  @override
  String get wordmarkT => 'T';

  @override
  String get loginWelcome => 'Chào mừng đến với DUT số';

  @override
  String get loginButton => 'ĐĂNG NHẬP';

  @override
  String get loginSubtitle =>
      'Đăng nhập bằng tài khoản hệ thống Quản lý chương trình đào tạo';

  @override
  String get username => 'Tên đăng nhập';

  @override
  String get password => 'Mật khẩu';

  @override
  String get showPassword => 'Hiện mật khẩu';

  @override
  String get hidePassword => 'Ẩn mật khẩu';

  @override
  String get submitLogin => 'Đăng nhập tài khoản';

  @override
  String get requiredCredentials => 'Nhập tên đăng nhập và mật khẩu.';

  @override
  String get changePassword => 'Đổi mật khẩu';

  @override
  String get currentPassword => 'Mật khẩu hiện tại';

  @override
  String get newPassword => 'Mật khẩu mới';

  @override
  String get confirmPassword => 'Xác nhận mật khẩu mới';

  @override
  String get forcedPasswordChange => 'Bạn cần đổi mật khẩu trước khi tiếp tục.';

  @override
  String get passwordPolicy =>
      'Mật khẩu mới gồm 8–128 ký tự, có ít nhất một chữ cái và một chữ số.';

  @override
  String get passwordMismatch => 'Mật khẩu xác nhận không khớp.';

  @override
  String get currentPasswordRequired => 'Nhập mật khẩu hiện tại.';

  @override
  String get passwordChanged => 'Đã đổi mật khẩu.';

  @override
  String get home => 'Trang chủ';

  @override
  String get profile => 'Hồ sơ';

  @override
  String get fullName => 'Họ tên';

  @override
  String get userCode => 'Mã';

  @override
  String get email => 'Email';

  @override
  String get roles => 'Vai trò';

  @override
  String get notProvided => 'Chưa có thông tin';

  @override
  String get emptyValue => '_';

  @override
  String get scoreTenLabel => 'Điểm hệ 10';

  @override
  String get scoreFourLabel => 'Điểm hệ 4';

  @override
  String get letterGradeLabel => 'Điểm chữ';

  @override
  String get attemptCountLabel => 'Số lần học';

  @override
  String get logout => 'Đăng xuất';

  @override
  String get logoutConfirmation => 'Bạn muốn đăng xuất tài khoản này?';

  @override
  String get cancel => 'Hủy thao tác';

  @override
  String get notifications => 'Thông báo';

  @override
  String get curriculum => 'Chương trình đào tạo';

  @override
  String get timetable => 'Thời khóa biểu';

  @override
  String get academicResults => 'Kết quả học tập';

  @override
  String get academicAffairs => 'Học vụ';

  @override
  String get homeroomClass => 'Lớp sinh hoạt';

  @override
  String get tuition => 'Học phí';

  @override
  String get creditRegistration => 'Đăng ký tín chỉ';

  @override
  String get communityActivities => 'Hoạt động cộng đồng';

  @override
  String get assistant => 'Trợ lý dDUT';

  @override
  String get feedback => 'Góp ý';

  @override
  String get serviceQueue => 'Lấy số tổ 1 cửa';

  @override
  String get todayNoSchedule => 'Hôm nay không có lịch nào!';

  @override
  String monthLabel(int month) {
    return 'Tháng $month';
  }

  @override
  String get sunday => 'Chủ Nhật';

  @override
  String get monday => 'Thứ Hai';

  @override
  String get tuesday => 'Thứ Ba';

  @override
  String get wednesday => 'Thứ Tư';

  @override
  String get thursday => 'Thứ Năm';

  @override
  String get friday => 'Thứ Sáu';

  @override
  String get saturday => 'Thứ Bảy';

  @override
  String get placeholderBody =>
      'Đây là bản mô phỏng ứng dụng dDUT, dùng để trình diễn hệ thống Quản lý CTĐT.';

  @override
  String get placeholderOpenCurriculum => 'Mở Chương trình đào tạo';

  @override
  String get unknownTile => 'Không tìm thấy chức năng được yêu cầu.';

  @override
  String get retry => 'Thử lại yêu cầu';

  @override
  String get loading => 'Đang tải dữ liệu';

  @override
  String get checkingSession => 'Đang kiểm tra phiên đăng nhập';

  @override
  String get sessionExpired =>
      'Phiên đăng nhập đã hết hạn. Vui lòng đăng nhập lại.';

  @override
  String get networkError =>
      'Không kết nối được máy chủ. Kiểm tra mạng rồi thử lại.';

  @override
  String invalidResponse(String detail) {
    return 'Phản hồi máy chủ không đúng định dạng: $detail';
  }

  @override
  String get missingApiBaseUrl =>
      'Thiếu API_BASE_URL: chạy với --dart-define-from-file=.env';

  @override
  String get noStudentLinked =>
      'Tài khoản chưa được liên kết với hồ sơ sinh viên. Liên hệ Phòng Đào tạo.';

  @override
  String get noProgram =>
      'Chưa xác định được chương trình, liên hệ Phòng Đào tạo.';

  @override
  String get graduationInfo =>
      'Kết quả tính tại thời điểm xem, chưa phải quyết định công nhận tốt nghiệp.';

  @override
  String get unsupportedResultVersion => 'Chưa hỗ trợ phiên bản kết quả này';

  @override
  String get statePassed => 'Đã đạt';

  @override
  String get statePassedEquivalent => 'Đạt bằng HP tương đương';

  @override
  String get stateInProgress => 'Đang học';

  @override
  String get stateFailed => 'Chưa đạt';

  @override
  String get stateNotTaken => 'Chưa học';

  @override
  String get eligible => 'Đủ điều kiện';

  @override
  String get conditional => 'Phải học cùng';

  @override
  String get registrationEligible => 'Đăng ký được';

  @override
  String get registrationIneligible => 'Chưa đăng ký được';

  @override
  String get primaryMajor => 'Ngành chính';

  @override
  String get secondMajor => 'Ngành thứ hai';

  @override
  String get studentStudying => 'Đang học';

  @override
  String get studentOnLeave => 'Bảo lưu';

  @override
  String get studentWithdrawn => 'Thôi học';

  @override
  String get studentGraduated => 'Đã tốt nghiệp';

  @override
  String get ineligible => 'Chưa đủ điều kiện';

  @override
  String get signedSyllabus => 'Đề cương có chữ ký';

  @override
  String get textbook => 'Giáo trình';

  @override
  String get lectureSlides => 'Bài giảng';

  @override
  String get other => 'Khác';

  @override
  String get otherMaterial => 'Tài liệu khác';

  @override
  String get mandatoryCourseMissing => 'Thiếu học phần bắt buộc';

  @override
  String get conditionalCourseMissing => 'Chưa hoàn thành học phần điều kiện';

  @override
  String get electiveCreditsMissing => 'Thiếu tín chỉ nhóm tự chọn';

  @override
  String get electiveCoursesMissing => 'Thiếu số học phần nhóm tự chọn';

  @override
  String get totalCreditsMissing => 'Thiếu tổng tín chỉ';

  @override
  String bytes(String value) {
    return '$value B';
  }

  @override
  String kilobytes(String value) {
    return '$value KB';
  }

  @override
  String get myCurriculum => 'Chương trình của tôi';

  @override
  String get plos => 'Chuẩn đầu ra (PLO)';

  @override
  String get progressResults => 'Tiến độ và kết quả';

  @override
  String get registration => 'Đăng ký học phần';

  @override
  String get graduation => 'Xét tốt nghiệp';

  @override
  String get semesterView => 'Học kỳ xem';

  @override
  String get studentCode => 'Mã sinh viên';

  @override
  String get cohort => 'Khóa';

  @override
  String get major => 'Ngành';

  @override
  String get version => 'Phiên bản';

  @override
  String get decision => 'Quyết định';

  @override
  String get noVersion => 'Chưa có';

  @override
  String get noDecision => 'Chưa có số quyết định';

  @override
  String get noData => 'Chưa có dữ liệu.';

  @override
  String get noPlos =>
      'Phiên bản chương trình này chưa có chuẩn đầu ra. Khoa sẽ cập nhật khi ban hành.';

  @override
  String ploSummary(int count, int groups) {
    return '$count chuẩn đầu ra · $groups nhóm năng lực';
  }

  @override
  String get allCourses => 'Tất cả';

  @override
  String get elective => 'Tự chọn';

  @override
  String get noSyllabus => 'Chưa có đề cương';

  @override
  String get syllabus => 'Đề cương học phần';

  @override
  String get courseDescription => 'Mô tả học phần';

  @override
  String get objectives => 'Mục tiêu';

  @override
  String get clos => 'Chuẩn đầu ra học phần (CLO)';

  @override
  String get teachingMethods => 'Phương pháp giảng dạy';

  @override
  String get weeklyPlan => 'Kế hoạch theo tuần';

  @override
  String get assessment => 'Đánh giá';

  @override
  String get assessmentMethods => 'Phương pháp đánh giá';

  @override
  String get references => 'Tài liệu tham khảo';

  @override
  String get attachments => 'Tài liệu đính kèm';

  @override
  String get assessmentComponent => 'Thành phần';

  @override
  String get assessmentForm => 'Hình thức';

  @override
  String get assessmentWeight => 'Trọng số';

  @override
  String get downloadAttachment => 'Mở tài liệu';

  @override
  String get stateExempt => 'Miễn học';

  @override
  String get recognizedCredits => 'Tín chỉ được công nhận';

  @override
  String get requiredCredits => 'Tổng tín chỉ yêu cầu';

  @override
  String get missingCredits => 'Tín chỉ còn thiếu';

  @override
  String get compulsoryCredits => 'Tín chỉ bắt buộc';

  @override
  String get electiveCredits => 'Tín chỉ tự chọn';

  @override
  String get freeCredits => 'Tín chỉ tự do';

  @override
  String get results => 'Kết quả học tập';

  @override
  String get loadMore => 'Tải thêm kết quả';

  @override
  String get registrationAllowed => 'Có thể đăng ký';

  @override
  String get registrationBlocked => 'Chưa đăng ký được';

  @override
  String get catalogDiscontinued => 'Ngừng đào tạo';

  @override
  String get catalogCancelled => 'Đã hủy';

  @override
  String get warnings => 'Lưu ý';

  @override
  String warningCount(int count) {
    return 'Lưu ý ($count)';
  }

  @override
  String creditsOutOf(String total) {
    return '/ $total tín chỉ';
  }

  @override
  String get compulsoryShort => 'Bắt buộc';

  @override
  String get freeShort => 'Tự do';

  @override
  String get missingShort => 'Còn thiếu';

  @override
  String get shortfalls => 'Điều kiện còn thiếu';

  @override
  String get mandatoryCourses => 'Học phần bắt buộc';

  @override
  String get conditionalCourses => 'Học phần điều kiện';

  @override
  String get electiveGroups => 'Nhóm tự chọn';

  @override
  String get totalCredits => 'Tổng tín chỉ';

  @override
  String get notSpecified => 'Không quy định';

  @override
  String get knowledgeBlocks => 'Tham khảo, không phải điều kiện xét riêng';

  @override
  String creditsValue(String value) {
    return '$value TC';
  }

  @override
  String semesterNumber(int number) {
    return 'Học kỳ $number';
  }

  @override
  String semesterCodeLabel(String code) {
    return 'Học kỳ $code';
  }

  @override
  String attempts(int count) {
    return 'Học $count lần';
  }

  @override
  String scores(String score10, String score4, String letter) {
    return 'Điểm 10: $score10 · Điểm 4: $score4 · Điểm chữ: $letter';
  }

  @override
  String revision(int number) {
    return 'Lần sửa $number';
  }

  @override
  String publishedAt(String date) {
    return 'Ngày công bố: $date';
  }

  @override
  String evaluatedAt(String date) {
    return 'Thời điểm tính: $date';
  }

  @override
  String mustStudyTogether(String courses) {
    return 'Phải học cùng: $courses';
  }

  @override
  String creditProgress(String recognized, String required) {
    return '$recognized/$required tín chỉ';
  }

  @override
  String requiredEarnedMissing(String required, String earned, String missing) {
    return 'Yêu cầu: $required · Đạt: $earned · Thiếu: $missing';
  }

  @override
  String courseCount(String required, String earned, String missing) {
    return 'Số học phần: $required · Đạt: $earned · Thiếu: $missing';
  }

  @override
  String percentValue(String value) {
    return '$value%';
  }

  @override
  String advisoryGap(String value) {
    return 'Chênh lệch tham khảo: $value';
  }

  @override
  String fieldValue(String label, String value) {
    return '$label: $value';
  }

  @override
  String bulletItem(String value) {
    return '• $value';
  }

  @override
  String megabytes(String value) {
    return '$value MB';
  }

  @override
  String get portalContext => 'Ngữ cảnh học tập';

  @override
  String get portalChangeContext => 'Đổi chương trình hoặc học kỳ';

  @override
  String get portalAppliedCurriculum => 'Chương trình áp dụng';

  @override
  String get portalMissingSemester =>
      'Chưa có học kỳ có ngày bắt đầu để xem. Vui lòng thử lại hoặc liên hệ đơn vị đào tạo.';

  @override
  String get portalNoApplicableProgram =>
      'Chưa xác định được chương trình áp dụng trong học kỳ này. Hãy đổi học kỳ, thử lại hoặc liên hệ đơn vị đào tạo.';

  @override
  String portalCompulsoryCredits(String value) {
    return '$value TC bắt buộc';
  }

  @override
  String get portalNoTerms =>
      'Chưa có học phần trong phiên bản chương trình này.';

  @override
  String get portalNoFilterMatches => 'Không có học phần phù hợp với bộ lọc.';

  @override
  String get portalClearFilter => 'Xóa bộ lọc';

  @override
  String get portalChooseWithinGroup => 'Chọn học phần trong nhóm này';

  @override
  String get portalCourseDetails => 'Chi tiết kết quả học phần';

  @override
  String portalEquivalentFrom(String course) {
    return 'Được công nhận qua học phần $course';
  }

  @override
  String get portalEquivalentUnavailable =>
      'Chưa tải được học phần tương đương. Kết quả công nhận vẫn được giữ nguyên.';

  @override
  String get portalEquivalentNotSupplied =>
      'Chưa có thông tin học phần nguồn trong dữ liệu trả về.';

  @override
  String get portalNoIssuedSyllabus => 'Chưa liên kết đề cương đã ban hành';

  @override
  String get portalAssessmentNotice =>
      'Chỉ hiển thị thành phần và mô tả đánh giá được cung cấp. Xem tài liệu ban hành để biết điều kiện đánh giá đầy đủ.';

  @override
  String get portalCreditBreakdown => 'Chi tiết tín chỉ';

  @override
  String portalScore10(String value) {
    return '$value/10';
  }

  @override
  String portalScore4(String value) {
    return '$value/4';
  }

  @override
  String get portalHistoryScope =>
      'Lịch sử có thể gồm học phần không được tính tín chỉ cho chương trình đang xem.';

  @override
  String get portalProgressTab => 'Tiến độ';

  @override
  String get portalResultsTab => 'Kết quả';

  @override
  String get portalEligibilityTitle => 'Điều kiện đăng ký';

  @override
  String get portalEligibilityAdvice =>
      'Thông tin tham khảo về điều kiện học phần, không phải đăng ký lớp hay xác nhận lớp được mở.';

  @override
  String get portalUnknownEligibility =>
      'Chưa đủ thông tin kết luận điều kiện đăng ký';

  @override
  String get portalNoCandidates =>
      'Không có học phần chưa hoàn thành trong nhóm này.';

  @override
  String get portalAllCompleted =>
      'Tất cả học phần trong dữ liệu trả về đã hoàn thành.';

  @override
  String get portalConditions => 'Điều kiện cần lưu ý';

  @override
  String get portalEvaluationBasis => 'Cơ sở và thời điểm đánh giá';

  @override
  String get portalNoShortfalls =>
      'Không có điều kiện còn thiếu trong kết quả đánh giá trả về.';

  @override
  String get portalNotApplicable => 'Không áp dụng';

  @override
  String get portalCurriculumHint => 'Xem học phần cần hoàn thành';

  @override
  String get portalPlosHint => 'Xem năng lực chương trình hướng tới';

  @override
  String get portalProgressHint => 'Kiểm tra tín chỉ và kết quả đã ghi nhận';

  @override
  String get portalEligibilityHint => 'Kiểm tra điều kiện trước khi đăng ký';

  @override
  String get portalGraduationHint => 'Xem điều kiện tốt nghiệp còn thiếu';

  @override
  String get basicInfo => 'Thông tin cơ bản';

  @override
  String get academicInfo => 'Thông tin học vấn';

  @override
  String get birthDate => 'Ngày sinh';

  @override
  String get gender => 'Giới tính';

  @override
  String get phoneNumber => 'Số điện thoại';

  @override
  String get personalEmail => 'Email cá nhân';

  @override
  String get programShort => 'CTĐT';

  @override
  String get office365Account => 'TK Office365';

  @override
  String get noValue => 'Không có';

  @override
  String labelWithColon(String label) {
    return '$label:';
  }

  @override
  String get shortcutPlo => 'Chuẩn đầu ra';

  @override
  String get shortcutProgress => 'Tiến độ';

  @override
  String get shortcutEligibility => 'Điều kiện ĐK';

  @override
  String get shortcutGraduation => 'Tốt nghiệp';

  @override
  String earnedCreditsOf(String earned, String total) {
    return 'Đã tích lũy $earned/$total tín chỉ';
  }

  @override
  String labelWithCount(String label, int count) {
    return '$label ($count)';
  }

  @override
  String scoreWithLetter(String score, String letter) {
    return 'Điểm: $score ($letter)';
  }

  @override
  String creditsLong(String value) {
    return '$value tín chỉ';
  }

  @override
  String get syllabusShort => 'Đề cương';
}
