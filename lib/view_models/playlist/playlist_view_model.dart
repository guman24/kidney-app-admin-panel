import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kidney_admin/core/enums/action_status.dart';
import 'package:kidney_admin/entities/media.dart';
import 'package:kidney_admin/entities/playlist.dart';
import 'package:kidney_admin/services/media_service.dart';
import 'package:kidney_admin/services/playlist_service.dart';
import 'package:kidney_admin/view_models/playlist/playlist_state.dart';
import 'package:kidney_admin/views/shared/media_upload_card.dart';

final playlistViewModel = NotifierProvider<PlaylistViewNotifier, PlaylistState>(
  () => PlaylistViewNotifier(),
);

class PlaylistViewNotifier extends Notifier<PlaylistState> {
  @override
  PlaylistState build() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetchPlaylist();
    });
    return PlaylistState();
  }

  Future<void> fetchPlaylist() async {
    state = state.copyWith(fetchStatus: ActionStatus.loading);
    try {
      final playlist = await ref.read(playlistServiceProvider).fetchPlaylist();
      state = state.copyWith(
        fetchStatus: ActionStatus.success,
        playlist: playlist,
      );
    } catch (error) {
      state = state.copyWith(fetchStatus: ActionStatus.failed);
    }
  }

  Future<void> savePlaylist(
    Playlist playlist, {
    MediaUploadData? mediaData,
  }) async {
    state = state.copyWith(saveStatus: ActionStatus.loading);
    try {
      if (mediaData != null) {
        final mediaUrl = await ref
            .read(mediaServiceProvider)
            .uploadToFirebaseStorage(mediaData, "/playlist");
        if (mediaUrl == null) return;
        Media media = Media(
          type: mediaData.isVideo
              ? MediaType.video
              : (mediaData.isAudio ? MediaType.audio : MediaType.image),
          networkType: NetworkType.network,
          value: mediaUrl,
        );
        playlist = playlist.copyWith(media: media);
      }

      final savedPlaylist = await ref
          .read(playlistServiceProvider)
          .savePlaylist(playlist);
      state = state.copyWith(
        saveStatus: ActionStatus.success,
        playlist: savedPlaylist,
      );
    } catch (error) {
      state = state.copyWith(
        saveStatus: ActionStatus.failed,
        saveError: error.toString(),
      );
    }
  }
}
