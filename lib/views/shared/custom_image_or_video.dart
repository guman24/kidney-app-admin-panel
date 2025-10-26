import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
  Widget build(BuildContext context) {
    return SizedBox(
      height: 180,
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
                child: VideoPlayer(_controller!),
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
