import 'package:kidney_admin/core/enums/action_status.dart';
import 'package:kidney_admin/entities/playlist.dart';

class PlaylistState {
  final ActionStatus saveStatus;
  final ActionStatus fetchStatus;
  final String? saveError;
  final Playlist? playlist;

  PlaylistState({
    this.saveStatus = ActionStatus.initial,
    this.fetchStatus = ActionStatus.initial,
    this.saveError,
    this.playlist,
  });

  PlaylistState copyWith({
    ActionStatus? saveStatus,
    ActionStatus? fetchStatus,
    String? saveError,
    Playlist? playlist,
  }) {
    return PlaylistState(
      saveStatus: saveStatus ?? this.saveStatus,
      fetchStatus: fetchStatus ?? this.fetchStatus,
      saveError: saveError ?? this.saveError,
      playlist: playlist ?? this.playlist,
    );
  }
}
