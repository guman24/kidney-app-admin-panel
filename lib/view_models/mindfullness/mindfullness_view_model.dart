import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kidney_admin/core/enums/action_status.dart';
import 'package:kidney_admin/core/enums/post_status.dart';
import 'package:kidney_admin/entities/media.dart';
import 'package:kidney_admin/entities/mindfullness.dart';
import 'package:kidney_admin/services/media_service.dart';
import 'package:kidney_admin/services/mindfullness_service.dart';
import 'package:kidney_admin/view_models/mindfullness/mindfullness_state.dart';
import 'package:kidney_admin/views/shared/media_upload_card.dart';

final mindfullnessViewModel =
    NotifierProvider<MindfullnessNotifier, MindfullnessState>(
      () => MindfullnessNotifier(),
    );

class MindfullnessNotifier extends Notifier<MindfullnessState> {
  @override
  MindfullnessState build() {
    Future.microtask(() {
      fetchAllMindfullness();
    });
    return MindfullnessState();
  }

  void saveMindfullness(
    Mindfullness mindfullness, {
    MediaUploadData? uploadedMedia,
  }) async {
    state = state.copyWith(saveStatus: ActionStatus.loading);
    try {
      if (uploadedMedia != null) {
        final mediaUrl = await ref
            .read(mediaServiceProvider)
            .uploadToFirebaseStorage(uploadedMedia, "/mindfullness_images");
        if (mediaUrl == null) return;
        Media media = Media(
          type: uploadedMedia.isVideo ? MediaType.video : MediaType.image,
          networkType: NetworkType.network,
          value: mediaUrl,
        );

        mindfullness = mindfullness.copyWith(
          meditationMedia: mindfullness.mindfullnessMedia.copyWith(
            media: media,
          ),
        );
      }

      final savedMindfullness = await ref
          .read(mindfullnessServiceProvider)
          .saveMindfullness(mindfullness);
      final List<Mindfullness> allMindfullness = List.from(
        state.mindfullnessList,
      );
      List<Mindfullness> updatedList = [];
      final index = allMindfullness.indexWhere((e) => e.id == mindfullness.id);
      if (index >= 0) {
        allMindfullness[index] = savedMindfullness;
        updatedList = allMindfullness;
      } else {
        updatedList = [savedMindfullness, ...allMindfullness];
      }
      state = state.copyWith(
        saveStatus: ActionStatus.success,
        mindfullnessList: updatedList,
      );
    } catch (error) {
      state = state.copyWith(saveStatus: ActionStatus.failed);
    }
  }

  Future<void> fetchAllMindfullness() async {
    try {
      final meditations = await ref
          .read(mindfullnessServiceProvider)
          .fetchMindfullnessList();
      state = state.copyWith(
        fetchStatus: ActionStatus.success,
        mindfullnessList: meditations,
      );
    } catch (error) {
      state = state.copyWith(fetchStatus: ActionStatus.failed);
    }
  }

  Future<void> updatePostStatus(
    String mindfullnessId,
    PostStatus status,
  ) async {
    try {
      await ref
          .read(mindfullnessServiceProvider)
          .updatePostStatus(mindfullnessId, status);
      List<Mindfullness> allMindfullness = List.from(state.mindfullnessList);
      int index = allMindfullness.indexWhere((e) => e.id == mindfullnessId);
      Mindfullness updatedMindfullness = allMindfullness[index];
      updatedMindfullness = updatedMindfullness.copyWith(status: status);
      allMindfullness[index] = updatedMindfullness;
      state = state.copyWith(mindfullnessList: allMindfullness);
    } catch (error) {
      debugPrint("Could not update status of this exercise");
    }
  }

  void deleteMindfullness(String mindfullnessId) async {
    state = state.copyWith(deleteStatus: ActionStatus.loading);
    try {
      await ref
          .read(mindfullnessServiceProvider)
          .deleteMindfullness(mindfullnessId);
      List<Mindfullness> allMindfullness = List.from(state.mindfullnessList);
      allMindfullness.removeWhere((e) => e.id == mindfullnessId);
      state = state.copyWith(
        deleteStatus: ActionStatus.success,
        mindfullnessList: allMindfullness,
      );
    } catch (error) {
      state = state.copyWith(deleteStatus: ActionStatus.failed);
    }
  }
}
