import 'package:injectable/injectable.dart';
import 'package:open_filex/open_filex.dart';

import '../network/contract_exception.dart';

@singleton
class AttachmentViewer {
  Future<void> open(String path) async {
    final result = await OpenFilex.open(path);
    if (result.type != ResultType.done) {
      throw ContractException(result.message);
    }
  }
}
