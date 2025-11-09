import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kidney_admin/core/constants/app_colors.dart';
import 'package:kidney_admin/core/enums/action_status.dart';
import 'package:kidney_admin/entities/media.dart';
import 'package:kidney_admin/routes/routes.dart';
import 'package:kidney_admin/view_models/playlist/playlist_view_model.dart';
import 'package:kidney_admin/views/shared/custm_media_player.dart';
import 'package:kidney_admin/views/shared/dashboard_app_bar.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class PlaylistScreen extends ConsumerStatefulWidget {
  const PlaylistScreen({super.key});

  @override
  ConsumerState<PlaylistScreen> createState() => _PlaylistScreenState();
}

class _PlaylistScreenState extends ConsumerState<PlaylistScreen> {
  @override
  Widget build(BuildContext context) {
    final playlistState = ref.watch(playlistViewModel);
    return Scaffold(
      appBar: DashboardAppBar(
        titleWidget: Row(
          children: [
            Text(
              "Playlist for the soul",
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.w600,
                color: AppColors.textColor,
              ),
            ),
            InkWell(
              onTap: () {
                context.goNamed(Routes.savePlaylist.name);
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18.0),
                child: Icon(Icons.edit),
              ),
            ),
          ],
        ),
      ),
      body: LayoutBuilder(
        builder: (context, constraint) {
          if (playlistState.fetchStatus.isLoading) {
            return Center(child: CircularProgressIndicator());
          }
          if (playlistState.playlist == null) {
            return Center(
              child: Text("Your playlist content is empty, please add first"),
            );
          }
          final playlist = playlistState.playlist!;

          Widget _child1 = Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 18.0,
              vertical: 12.0,
            ),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 18.0,
                children: [
                  _buildInfoBox(
                    "The Healing Power of Music",
                    Text(playlist.overview),
                  ),
                  _buildInfoBox(
                    "Benefits for Mind and Body",
                    Text(
                      playlist.benefits,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                  _buildInfoBox(
                    "Creating Your Healing Playlist",
                    Text(playlist.healingDesc),
                  ),
                ],
              ),
            ),
          );
          Widget _child2 = Container(
            margin: const EdgeInsets.symmetric(
              horizontal: 12.0,
              vertical: 18.0,
            ),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 12.0,
                children: [
                  Text(
                    "Begin Your Healing Journey",
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  AspectRatio(
                    aspectRatio: 1,
                    child: CustomMediaPlayer(media: playlist.media),
                  ),
                ],
              ),
            ),
          );

          if (constraint.maxWidth <= 640) {
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [_child1, _child2],
              ),
            );
          } else {
            return Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(flex: 3, child: _child1),
                Expanded(flex: 2, child: _child2),
              ],
            );
          }
          // return GridView(
          //   padding: const EdgeInsets.symmetric(
          //     horizontal: 12.0,
          //     vertical: 8.0,
          //   ),
          //   gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
          //     maxCrossAxisExtent: 640,
          //     crossAxisSpacing: 24.0,
          //     mainAxisSpacing: 18.0,
          //   ),
          //   children: [
          //
          //   ],
          // );
        },
      ),
    );
  }

  Widget _buildInfoBox(String title, Widget child) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Column(
              spacing: 12.0,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: Theme.of(context).textTheme.titleLarge),
                child,
              ],
            ),
          ],
        ),
      ),
    );
  }
}
