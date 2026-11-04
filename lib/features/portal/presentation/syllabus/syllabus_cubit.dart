import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/files/attachment_viewer.dart';
import '../../domain/model/portal_context.dart';
import '../../domain/model/syllabus_attachment.dart';
import '../../domain/use_case/portal_use_cases.dart';
import 'syllabus_state.dart';

@injectable
class SyllabusCubit extends Cubit<SyllabusState> {
  SyllabusCubit(
    this._portal,
    this._viewer,
    @factoryParam this.context,
    @factoryParam this.itemId,
  ) : super(const SyllabusState());

  final PortalUseCases _portal;
  final AttachmentViewer _viewer;
  final PortalContext context;
  final String itemId;
  int _revision = 0;

  Future<void> load() async {
    if (state.openingAttachmentId != null) {
      return;
    }
    final revision = ++_revision;
    emit(const SyllabusState());
    try {
      final data = await _portal.syllabus(context, itemId);
      if (!isClosed && revision == _revision) {
        emit(SyllabusState(isLoading: false, data: data));
      }
    } catch (error) {
      if (!isClosed && revision == _revision) {
        emit(SyllabusState(isLoading: false, errorMessage: error.toString()));
      }
    }
  }

  Future<void> openAttachment(SyllabusAttachment attachment) async {
    final data = state.data;
    if (data == null || state.openingAttachmentId != null) {
      return;
    }
    emit(
      SyllabusState(
        isLoading: false,
        data: data,
        openingAttachmentId: attachment.id,
      ),
    );
    try {
      final path = await _portal.downloadAttachment(
        context,
        itemId,
        attachment,
        onProgress: (received, total) {
          if (!isClosed) {
            emit(
              SyllabusState(
                isLoading: false,
                data: data,
                openingAttachmentId: attachment.id,
                downloadProgress: total <= 0
                    ? null
                    : (received / total).clamp(0.0, 1.0).toDouble(),
              ),
            );
          }
        },
      );
      if (isClosed) {
        return;
      }
      await _viewer.open(path);
      if (!isClosed) {
        emit(SyllabusState(isLoading: false, data: data));
      }
    } catch (error) {
      if (!isClosed) {
        emit(
          SyllabusState(
            isLoading: false,
            data: data,
            errorMessage: error.toString(),
          ),
        );
      }
    }
  }
}
