import '../../../../core/network/contract_exception.dart';

enum MaterialKind {
  signedSyllabus,
  textbook,
  lectureSlides,
  other;

  static MaterialKind parse(String wire) => switch (wire) {
    'SIGNED_SYLLABUS' => signedSyllabus,
    'TEXTBOOK' => textbook,
    'LECTURE_SLIDES' => lectureSlides,
    'OTHER' => other,
    _ => throw ContractException(wire),
  };
}
