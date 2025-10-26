import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kidney_admin/core/constants/app_colors.dart';
import 'package:kidney_admin/entities/media.dart';
import 'package:video_player/video_player.dart';

class CustomImageOrVideo extends StatefulWidget {
  const CustomImageOrVideo({super.key, this.media});

  final Media? media;

  @override
  State<CustomImageOrVideo> createState() => _CustomImageOrVideoState();
}

class _CustomImageOrVideoState extends State<CustomImageOrVideo> {
  Media? get media => widget.media;

  VideoPlayerController? _controller;

  @override
  void initState() {
    super.initState();
    if (media?.networkType == NetworkType.network &&
        (media?.value.isNotEmpty ?? false)) {
      _controller = VideoPlayerController.networkUrl(Uri.parse(media!.value))
        ..initialize().then((_) {
          setState(() {});
        });
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 180,
      decoration: BoxDecoration(color: AppColors.green.withValues(alpha: 0.1)),
      width: double.infinity,
      child: Builder(
        builder: (context) {
          if (widget.media?.type == MediaType.image) {
            return CachedNetworkImage(
              imageUrl: widget.media?.value ?? "",
              fit: BoxFit.cover,
              progressIndicatorBuilder: (context, _, __) {
                return Align(
                  child: SizedBox.square(
                    dimension: 30.0,
                    child: const CircularProgressIndicator.adaptive(),
                  ),
                );
              },
              errorWidget: (context, _, __) {
                return Icon(CupertinoIcons.photo, size: 100);
              },
            );
          } else if (widget.media?.type == MediaType.video) {
            if (_controller != null && _controller!.value.isInitialized) {
              return AspectRatio(
                aspectRatio: _controller!.value.aspectRatio,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    VideoPlayer(_controller!),
                    Positioned.fill(
                      child: Container(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () {
                            if (_controller!.value.isPlaying) {
                              _controller!.pause();
                            } else {
                              _controller!.play();
                            }
                            setState(() {});
                          },
                          child: Visibility(
                            visible: !_controller!.value.isPlaying,
                            child: Align(
                              child: SizedBox.square(
                                dimension: 50,
                                child: DecoratedBox(
                                  decoration: BoxDecoration(
                                    color: AppColors.white,
                                  ),
                                  child: Icon(
                                    Icons.play_arrow,
                                    color: AppColors.green,
                                  ),
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
            } else if (_controller?.value.isBuffering ?? false) {
              return Center(child: CircularProgressIndicator());
            }
            return const SizedBox.shrink();
          }
          return Icon(CupertinoIcons.photo, size: 100);
        },
      ),
    );
  }
}
