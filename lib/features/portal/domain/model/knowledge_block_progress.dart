import 'package:equatable/equatable.dart';

class KnowledgeBlockProgress extends Equatable {
  const KnowledgeBlockProgress({
    required this.blockSymbol,
    required this.blockName,
    required this.earnedCredits,
    required this.compulsoryCredits,
    required this.electiveCredits,
    required this.catalogRequiredCredits,
    required this.advisoryGap,
  });

  final String? blockSymbol;
  final String? blockName;
  final String earnedCredits;
  final String compulsoryCredits;
  final String electiveCredits;
  final String? catalogRequiredCredits;
  final String? advisoryGap;

  @override
  List<Object?> get props => [
    blockSymbol,
    blockName,
    earnedCredits,
    compulsoryCredits,
    electiveCredits,
    catalogRequiredCredits,
    advisoryGap,
  ];
}
