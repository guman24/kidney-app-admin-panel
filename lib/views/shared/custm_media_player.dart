import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:video_player/video_player.dart';
import 'package:kidney_admin/core/constants/app_colors.dart';
import 'package:kidney_admin/entities/media.dart';

class CustomMediaPlayer extends StatefulWidget {
  const CustomMediaPlayer({super.key, this.media});

  final Media? media;

  @override
  State<CustomMediaPlayer> createState() => _CustomMediaPlayerState();
}

class _CustomMediaPlayerState extends State<CustomMediaPlayer> {
  VideoPlayerController? _videoController;
  AudioPlayer? _audioPlayer;
  bool _isAudioPlaying = false;

  Media? get media => widget.media;

  @override
  void initState() {
    super.initState();
    if (media == null || media?.value.isEmpty == true) return;

    switch (media!.type) {
      case MediaType.video:
        _videoController =
            VideoPlayerController.networkUrl(Uri.parse(media!.value))
              ..initialize().then((_) {
                setState(() {});
              });
        break;

      case MediaType.audio:
        _audioPlayer = AudioPlayer();
        _audioPlayer!.setUrl(media!.value);
        break;
      default:
        break;
    }
  }

  @override
  void dispose() {
    _videoController?.dispose();
    _audioPlayer?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final type = media?.type;

    return Container(
      height: type == MediaType.audio ? 80 : 180,
      width: double.infinity,
      decoration: BoxDecoration(color: AppColors.green.withValues(alpha: 0.1)),
      child: switch (type) {
        MediaType.image => _buildImage(),
        MediaType.video => _buildVideo(),
        MediaType.audio => _buildAudio(),
        _ => _buildPlaceholder(),
      },
    );
  }

  Widget _buildImage() {
    return CachedNetworkImage(
      imageUrl: media?.value ?? "",
      fit: BoxFit.cover,
      progressIndicatorBuilder: (context, _, __) =>
          const Center(child: CircularProgressIndicator.adaptive()),
      errorWidget: (context, _, __) =>
          const Icon(CupertinoIcons.photo, size: 100),
    );
  }

  Widget _buildVideo() {
    if (_videoController == null) return const SizedBox.shrink();

    if (!_videoController!.value.isInitialized) {
      return const Center(child: CircularProgressIndicator());
    }

    return AspectRatio(
      aspectRatio: _videoController!.value.aspectRatio,
      child: Stack(
        alignment: Alignment.center,
        children: [
          VideoPlayer(_videoController!),
          Positioned.fill(
            child: InkWell(
              onTap: () async {
                if (_videoController!.value.isPlaying) {
                  await _videoController!.pause();
                } else {
                  await _videoController!.play();
                }
                setState(() {});
              },
              child: Visibility(
                visible: !_videoController!.value.isPlaying,
                child: Align(
                  child: SizedBox.square(
                    dimension: 50,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.play_arrow,
                        color: AppColors.green,
                        size: 36,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAudio() {
    if (_audioPlayer == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            iconSize: 40,
            icon: Icon(
              _isAudioPlaying
                  ? Icons.pause_circle_filled
                  : Icons.play_circle_fill,
              color: AppColors.green,
            ),
            onPressed: () async {
              if (_audioPlayer == null) return;
              if (_isAudioPlaying) {
                await _audioPlayer!.pause();
              } else {
                await _audioPlayer!.play();
              }
              setState(() => _isAudioPlaying = !_isAudioPlaying);
            },
          ),
          const SizedBox(width: 8),
          const Text(
            "Audio",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  Widget _buildPlaceholder() {
    return const Icon(CupertinoIcons.photo, size: 100);
  }
}
