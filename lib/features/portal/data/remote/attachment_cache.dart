import 'package:injectable/injectable.dart';
import 'package:path_provider/path_provider.dart';

import 'portal_contract.dart';

@singleton
class AttachmentCache {
  Future<String> pathFor(String id, String fileName) async {
    final directory = await getTemporaryDirectory();
    final basename = fileName.replaceAll('\\', '/').split('/').last;
    final safe = basename.replaceAll(RegExp(r'[<>:"/\\|?*\x00-\x1F]'), '_');
    final name = safe.isEmpty || safe == '.' || safe == '..'
        ? PortalContract.defaultAttachmentName
        : safe;
    return '${directory.path}/${Uri.encodeComponent(id)}-$name';
  }
}
