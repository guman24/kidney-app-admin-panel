import 'package:desktop_drop/desktop_drop.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

// For web-specific functionality
import 'dart:html' as html;
import 'dart:ui_web' as ui_web;

import 'package:web/web.dart' as web;

/// Media data model ready for Firebase upload
class MediaUploadData {
  final String fileName;
  final String mimeType;
  final Uint8List bytes;
  final bool isImage;
  final bool isVideo;

  MediaUploadData({
    required this.fileName,
    required this.mimeType,
    required this.bytes,
    required this.isImage,
    required this.isVideo,
  });

  String get fileExtension {
    final parts = fileName.split('.');
    return parts.isNotEmpty ? parts.last : '';
  }

  int get sizeInBytes => bytes.length;

  double get sizeInMB => sizeInBytes / (1024 * 1024);
}

class MediaUploadCard extends StatefulWidget {
  const MediaUploadCard({
    super.key,
    this.onMediaPicked,
    this.maxSizeMB = 15,
    this.height = 200,
    this.acceptedFormats = const ['image/*', 'video/*'],
    this.initialNetworkUrl,
  });

  final Function(MediaUploadData?)? onMediaPicked;
  final double maxSizeMB;
  final double height;
  final List<String> acceptedFormats;
  final String? initialNetworkUrl;

  @override
  State<MediaUploadCard> createState() => _MediaUploadCardState();
}

class _MediaUploadCardState extends State<MediaUploadCard> {
  MediaUploadData? _mediaData;
  String? _previewUrl;
  String? _videoViewId;
  String? _networkVideoViewId;
  bool _isDragging = false;
  bool _isLoading = false;
  bool _isFromNetwork = false;

  @override
  void initState() {
    super.initState();
    if (widget.initialNetworkUrl != null) {
      _loadNetworkFile(widget.initialNetworkUrl!);
    }
  }

  @override
  void dispose() {
    _revokeObjectUrl();
    super.dispose();
  }

  void _loadNetworkFile(String url) {
    setState(() {
      _isFromNetwork = true;
      _previewUrl = url;

      // Determine if it's a video based on URL
      final isVideo =
          url.contains('.mp4') ||
          url.contains('.mov') ||
          url.contains('.webm') ||
          url.contains('.mkv') ||
          url.contains('video');

      if (isVideo && kIsWeb) {
        _createNetworkVideoView(url);
      }
    });
  }

  void _createNetworkVideoView(String url) {
    final viewId = 'network-video-${DateTime.now().microsecondsSinceEpoch}';
    _networkVideoViewId = viewId;

    ui_web.platformViewRegistry.registerViewFactory(viewId, (int viewId) {
      final video = web.document.createElement('video') as web.HTMLVideoElement;
      video.src = url;
      video.controls = true;
      video.autoplay = false;
      video.style.width = '100%';
      video.style.height = '100%';
      video.style.objectFit = 'contain';
      video.style.backgroundColor = 'black';
      return video;
    });
  }

  void _revokeObjectUrl() {
    if (_previewUrl != null && kIsWeb) {
      try {
        html.Url.revokeObjectUrl(_previewUrl!);
      } catch (_) {}
      _previewUrl = null;
    }
  }

  Future<void> _pickFile() async {
    if (!kIsWeb) {
      // Fallback to image_picker for mobile
      await _pickFileNative();
      return;
    }

    setState(() => _isLoading = true);

    final input = html.FileUploadInputElement();
    input.accept = widget.acceptedFormats.join(',');
    input.multiple = false;
    input.click();

    input.onChange.listen((_) async {
      final files = input.files;
      if (files == null || files.isEmpty) {
        setState(() => _isLoading = false);
        return;
      }

      await _processWebFile(files.first);
      setState(() => _isLoading = false);
    });
  }

  Future<void> _pickFileNative() async {
    try {
      setState(() => _isLoading = true);

      final ImagePicker picker = ImagePicker();
      final XFile? file = await picker.pickMedia();

      if (file != null) {
        final bytes = await file.readAsBytes();
        final mimeType = file.mimeType ?? _getMimeTypeFromPath(file.path);

        await _processFileData(
          fileName: file.name,
          mimeType: mimeType,
          bytes: bytes,
        );
      }
    } catch (e) {
      _showError('Failed to pick file: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _processWebFile(html.File file) async {
    try {
      final mime = file.type;
      final reader = html.FileReader();

      reader.readAsArrayBuffer(file);
      await reader.onLoad.first;

      final bytes = reader.result as Uint8List;

      await _processFileData(fileName: file.name, mimeType: mime, bytes: bytes);
    } catch (e) {
      _showError('Failed to process file: $e');
    }
  }

  Future<void> _processFileData({
    required String fileName,
    required String mimeType,
    required Uint8List bytes,
  }) async {
    // Validate file size
    final sizeMB = bytes.length / (1024 * 1024);
    if (sizeMB > widget.maxSizeMB) {
      _showError(
        'File size (${sizeMB.toStringAsFixed(1)}MB) exceeds maximum allowed size (${widget.maxSizeMB}MB)',
      );
      return;
    }

    // Clean up old preview
    _revokeObjectUrl();

    final isImage = mimeType.startsWith('image/');
    final isVideo = mimeType.startsWith('video/');

    if (!isImage && !isVideo) {
      _showError('Unsupported file type. Please select an image or video.');
      return;
    }

    // Create media data
    final mediaData = MediaUploadData(
      fileName: fileName,
      mimeType: mimeType,
      bytes: bytes,
      isImage: isImage,
      isVideo: isVideo,
    );

    // Create preview URL for web
    if (kIsWeb) {
      final blob = html.Blob([bytes], mimeType);
      _previewUrl = html.Url.createObjectUrlFromBlob(blob);

      if (isVideo) {
        _createVideoView(_previewUrl!);
      }
    }

    setState(() {
      _mediaData = mediaData;
    });

    // Callback
    widget.onMediaPicked?.call(mediaData);
  }

  void _createVideoView(String url) {
    final viewId = 'video-${DateTime.now().microsecondsSinceEpoch}';
    _videoViewId = viewId;

    ui_web.platformViewRegistry.registerViewFactory(viewId, (int viewId) {
      final video = html.VideoElement()
        ..src = url
        ..controls = true
        ..autoplay = false
        ..style.width = '100%'
        ..style.height = '100%'
        ..style.objectFit = 'contain'
        ..style.backgroundColor = 'black';
      return video;
    });
  }

  void _removeMedia() {
    _revokeObjectUrl();
    setState(() {
      _mediaData = null;
      _videoViewId = null;
      _networkVideoViewId = null;
      _isFromNetwork = false;
    });
    widget.onMediaPicked?.call(null);
  }

  void _showError(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  String _getMimeTypeFromPath(String path) {
    final ext = path.split('.').last.toLowerCase();

    // Image formats
    final imageTypes = {
      'jpg': 'image/jpeg',
      'jpeg': 'image/jpeg',
      'png': 'image/png',
      'gif': 'image/gif',
      'webp': 'image/webp',
      'bmp': 'image/bmp',
      'svg': 'image/svg+xml',
      'ico': 'image/x-icon',
      'heic': 'image/heic',
      'heif': 'image/heif',
    };

    // Video formats
    final videoTypes = {
      'mp4': 'video/mp4',
      'mov': 'video/quicktime', // ✅ Fixed: .mov = video/quicktime
      'avi': 'video/x-msvideo',
      'mkv': 'video/x-matroska',
      'webm': 'video/webm',
      'flv': 'video/x-flv',
      'wmv': 'video/x-ms-wmv',
      'm4v': 'video/x-m4v',
      'mpeg': 'video/mpeg',
      'mpg': 'video/mpeg',
      '3gp': 'video/3gpp',
      'ogv': 'video/ogg',
    };

    if (imageTypes.containsKey(ext)) {
      return imageTypes[ext]!;
    }

    if (videoTypes.containsKey(ext)) {
      return videoTypes[ext]!;
    }

    return 'application/octet-stream';
  }

  @override
  Widget build(BuildContext context) {
    return DropTarget(
      onDragEntered: (_) => setState(() => _isDragging = true),
      onDragExited: (_) => setState(() => _isDragging = false),
      onDragDone: (details) async {
        setState(() {
          _isDragging = false;
          _isLoading = true;
        });

        try {
          if (details.files.isNotEmpty) {
            final file = details.files.first;

            if (kIsWeb) {
              // For web, we need to handle XFile differently
              final bytes = await file.readAsBytes();
              final fileName = file.name;
              final mimeType = file.mimeType ?? _getMimeTypeFromPath(file.name);
              print(mimeType);
              await _processFileData(
                fileName: fileName,
                mimeType: mimeType,
                bytes: bytes,
              );
            } else {
              // For desktop/mobile
              final bytes = await file.readAsBytes();
              final mimeType = _getMimeTypeFromPath(file.path);

              await _processFileData(
                fileName: file.name,
                mimeType: mimeType,
                bytes: bytes,
              );
            }
          }
        } catch (e) {
          _showError('Failed to process dropped file: $e');
        } finally {
          setState(() => _isLoading = false);
        }
      },
      child: InkWell(
        onTap: _isLoading ? null : _pickFile,
        borderRadius: BorderRadius.circular(8),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          height: widget.height,
          width: double.infinity,
          decoration: BoxDecoration(
            color: _isDragging ? Colors.blue.withOpacity(0.1) : Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: _isDragging ? Colors.blue : Colors.black.withOpacity(0.1),
              width: _isDragging ? 2 : 1,
            ),
          ),
          child: _isLoading
              ? _buildLoading()
              : (_mediaData != null || _isFromNetwork)
              ? _buildPreview()
              : _buildPlaceholder(),
        ),
      ),
    );
  }

  Widget _buildLoading() {
    return const Center(child: CircularProgressIndicator());
  }

  Widget _buildPlaceholder() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.grey.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          padding: const EdgeInsets.all(16),
          child: Icon(
            Icons.file_upload_outlined,
            size: 40,
            color: Colors.grey.shade600,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          _isDragging ? 'Drop file here' : 'Drop media file here',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            decoration: TextDecoration.underline,
            color: _isDragging ? Colors.blue : null,
          ),
        ),
        const SizedBox(height: 4),
        Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: 'Maximum file size ',
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: Colors.grey.shade600),
              ),
              TextSpan(
                text: '${widget.maxSizeMB.toInt()}MB',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.grey.shade800,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Click to browse or drag & drop',
          style: Theme.of(
            context,
          ).textTheme.bodySmall?.copyWith(color: Colors.grey.shade500),
        ),
      ],
    );
  }

  Widget _buildPreview() {
    if (_mediaData == null && !_isFromNetwork) return const SizedBox.shrink();

    // Check if it's a network file
    final isNetworkVideo =
        _isFromNetwork &&
        (_previewUrl?.contains('.mp4') == true ||
            _previewUrl?.contains('.mov') == true ||
            _previewUrl?.contains('.webm') == true ||
            _previewUrl?.contains('video') == true);
    final isNetworkImage = _isFromNetwork && !isNetworkVideo;

    return Stack(
      fit: StackFit.expand,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: _isFromNetwork
              ? (isNetworkVideo
                    ? _buildNetworkVideoPreview()
                    : _buildNetworkImagePreview())
              : (_mediaData!.isImage
                    ? _buildImagePreview()
                    : _buildVideoPreview()),
        ),

        // Remove button
        Positioned(
          top: 8,
          right: 8,
          child: Material(
            color: Colors.white,
            shape: const CircleBorder(),
            elevation: 2,
            child: InkWell(
              onTap: _removeMedia,
              customBorder: const CircleBorder(),
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Icon(Icons.close, size: 20, color: Colors.red.shade700),
              ),
            ),
          ),
        ),

        // File info overlay
        if (_mediaData != null)
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [Colors.black.withOpacity(0.7), Colors.transparent],
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    _mediaData!.isImage ? Icons.image : Icons.video_library,
                    color: Colors.white,
                    size: 16,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      _mediaData!.fileName,
                      style: const TextStyle(color: Colors.white, fontSize: 12),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '${_mediaData!.sizeInMB.toStringAsFixed(1)}MB',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildImagePreview() {
    if (kIsWeb && _previewUrl != null) {
      return Image.network(
        _previewUrl!,
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) {
          return _buildErrorPreview();
        },
      );
    }

    // For non-web or if preview URL failed
    return Image.memory(
      _mediaData!.bytes,
      fit: BoxFit.contain,
      errorBuilder: (context, error, stackTrace) {
        return _buildErrorPreview();
      },
    );
  }

  Widget _buildVideoPreview() {
    if (kIsWeb && _videoViewId != null) {
      return HtmlElementView(viewType: _videoViewId!);
    }

    // Fallback for video preview
    return Container(
      color: Colors.black87,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.play_circle_outline,
              size: 64,
              color: Colors.white.withOpacity(0.8),
            ),
            const SizedBox(height: 8),
            Text(
              _mediaData!.fileName,
              style: const TextStyle(color: Colors.white, fontSize: 14),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNetworkImagePreview() {
    return Image.network(
      _previewUrl!,
      fit: BoxFit.contain,
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return Center(
          child: CircularProgressIndicator(
            value: loadingProgress.expectedTotalBytes != null
                ? loadingProgress.cumulativeBytesLoaded /
                      loadingProgress.expectedTotalBytes!
                : null,
          ),
        );
      },
      errorBuilder: (context, error, stackTrace) {
        return _buildErrorPreview();
      },
    );
  }

  Widget _buildNetworkVideoPreview() {
    if (kIsWeb && _networkVideoViewId != null) {
      return HtmlElementView(viewType: _networkVideoViewId!);
    }

    // Fallback
    return Container(
      color: Colors.black87,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.play_circle_outline,
              size: 64,
              color: Colors.white.withOpacity(0.8),
            ),
            const SizedBox(height: 8),
            Text(
              'Network Video',
              style: const TextStyle(color: Colors.white, fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorPreview() {
    return Container(
      color: Colors.grey.shade200,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.broken_image_outlined,
              size: 48,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 8),
            Text(
              'Preview not available',
              style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}

// Example usage with Firebase Storage
/*
Future<String?> uploadToFirebaseStorage(
  MediaUploadData mediaData,
  String path,
) async {
  try {
    final storageRef = FirebaseStorage.instance.ref();
    final fileRef = storageRef.child('$path/${mediaData.fileName}');

    final metadata = SettableMetadata(
      contentType: mediaData.mimeType,
    );

    final uploadTask = fileRef.putData(mediaData.bytes, metadata);
    final snapshot = await uploadTask;
    final downloadUrl = await snapshot.ref.getDownloadURL();

    return downloadUrl;
  } catch (e) {
    print('Upload failed: $e');
    return null;
  }
}

// Usage example:
MediaUploadCard(
  maxSizeMB: 15,
  onMediaPicked: (mediaData) async {
    if (mediaData != null) {
      final url = await uploadToFirebaseStorage(
        mediaData,
        'uploads/${DateTime.now().millisecondsSinceEpoch}',
      );

      if (url != null) {
        print('Uploaded to: $url');
      }
    }
  },
)
*/

// import 'dart:io';
// import 'package:desktop_drop/desktop_drop.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:kidney_admin/core/constants/app_colors.dart';
// import 'package:kidney_admin/entities/media.dart';
// import 'dart:html' as html;
// import 'dart:ui' as ui; // only for web
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
//
// class MediaUploadCard extends StatefulWidget {
//   const MediaUploadCard({super.key, this.onMediaPicked});
//
//   final Function(Media?)? onMediaPicked;
//
//   @override
//   State<MediaUploadCard> createState() => _MediaUploadCardState();
// }
//
// class _MediaUploadCardState extends State<MediaUploadCard> {
//   File? image;
//   Media? media;
//
//   Future? videoThumbnailFuture;
//
//   String? _objectUrl; // the blob/object URL for preview
//   String? _mimeType; // mime type of selected file
//   String? _videoViewId; // id for HtmlElementView when showing video
//
//   final double previewHeight = 200;
//   final double previewWidth = double.infinity;
//
//   void _revokeObjectUrl() {
//     if (_objectUrl != null) {
//       try {
//         html.Url.revokeObjectUrl(_objectUrl!);
//       } catch (_) {}
//       _objectUrl = null;
//     }
//     if (_videoViewId != null) {
//       // Optionally unregister? platformViewRegistry does not provide unregister.
//       _videoViewId = null;
//     }
//   }
//
//   Future<void> _pickFile() async {
//     if (!kIsWeb) {
//       // This widget is built for web. If accidentally used on other platforms, do nothing.
//       return;
//     }
//
//     final input = html.FileUploadInputElement();
//     input.accept = 'image/*,video/*';
//     input.multiple = false;
//
//     // Trigger file browser
//     input.click();
//
//     input.onChange.listen((_) {
//       final files = input.files;
//       if (files == null || files.isEmpty) return;
//
//       final file = files.first;
//       final mime = file.type; // e.g. "image/png" or "video/mp4"
//       final url = html.Url.createObjectUrlFromBlob(file);
//
//       // Clean up old object URL
//       _revokeObjectUrl();
//
//       setState(() {
//         _objectUrl = url;
//         _mimeType = mime;
//       });
//
//       if (mime.startsWith('video/')) {
//         _createVideoView(url);
//       } else {
//         // For images we don't need to register a platform view
//         _videoViewId = null;
//       }
//     });
//   }
//
//   void _createVideoView(String url) {
//     // create a unique id for this view
//     final viewId = 'video-element-${DateTime.now().microsecondsSinceEpoch}';
//     _videoViewId = viewId;
//
//     // register the video element factory
//     // The callback should return an HtmlElement; we create a VideoElement configured with controls.
//
//     // ignore: undefined_prefixed_name
//     ui.platformViewRegistry.registerViewFactory(viewId, (int id) {
//       final video = html.VideoElement()
//         ..src = url
//         ..controls = true
//         ..autoplay = false
//         ..style.width = '${previewWidth}px'
//         ..style.height = '${previewHeight}px'
//         ..style.objectFit = 'contain';
//       return video;
//     });
//
//     // rebuild to show HtmlElementView
//     setState(() {});
//   }
//
//   Widget _buildPreview() {
//     if (_objectUrl == null || _mimeType == null) {
//       return Container(
//         width: previewWidth,
//         height: previewHeight,
//         alignment: Alignment.center,
//         decoration: BoxDecoration(
//           border: Border.all(color: Colors.grey.shade300),
//           borderRadius: BorderRadius.circular(8),
//           color: Colors.grey.shade50,
//         ),
//         child: const Text('No media selected'),
//       );
//     }
//
//     if (_mimeType!.startsWith('image/')) {
//       // Use normal Flutter Image.network to preview the blob URL
//       return ClipRRect(
//         borderRadius: BorderRadius.circular(8),
//         child: Image.network(
//           _objectUrl!,
//           width: previewWidth,
//           height: previewHeight,
//           fit: BoxFit.contain,
//           // If you want to show loading progress, wrap with Stack and use ImageStream.
//         ),
//       );
//     }
//
//     if (_mimeType!.startsWith('video/')) {
//       // Use HtmlElementView for the video element
//       if (_videoViewId == null) {
//         // fallback message while view is being prepared
//         return SizedBox(
//           width: previewWidth,
//           height: previewHeight,
//           child: const Center(child: Text('Preparing video...')),
//         );
//       }
//
//       return SizedBox(
//         width: previewWidth,
//         height: previewHeight,
//         child: HtmlElementView(viewType: _videoViewId!),
//       );
//     }
//
//     // unknown type fallback
//     return Container(
//       width: previewWidth,
//       height: previewHeight,
//       alignment: Alignment.center,
//       child: const Text('Selected file not supported'),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: BoxDecoration(),
//       child: DropTarget(
//         onDragDone: (details) {
//           print("drop file done: ${details.files.first.path}");
//         },
//         child: InkWell(
//           onTap: () async {
//             // final pickedFile = await ImagePicker().pickMedia();
//             // print(pickedFile);
//             _pickFile();
//             // showModalBottomSheet(
//             //   context: context,
//             //   backgroundColor: Colors.transparent,
//             //   builder: (context) {
//             //     return SafeArea(
//             //       child: Container(
//             //         margin: const EdgeInsets.symmetric(horizontal: 12.0),
//             //         decoration: BoxDecoration(
//             //           color: AppColors.white,
//             //           borderRadius: BorderRadius.circular(24.0),
//             //         ),
//             //         padding: const EdgeInsets.symmetric(
//             //           horizontal: 24.0,
//             //           vertical: 18.0,
//             //         ),
//             //         child: Row(
//             //           spacing: 16.0,
//             //           children: [
//             //             Expanded(
//             //               child: GestureDetector(
//             //                 onTap: () async {
//             //                   try {
//             //                     XFile? file = await ImagePicker().pickImage(
//             //                       source: ImageSource.gallery,
//             //                     );
//             //                     if (file != null) {
//             //                       setState(() {
//             //                         media = Media(
//             //                           type: MediaType.image,
//             //                           networkType: NetworkType.file,
//             //                           value: file.path,
//             //                         );
//             //                       });
//             //                     }
//             //                   } finally {
//             //                     widget.onMediaPicked?.call(media);
//             //                     if (!context.mounted) return;
//             //                     Navigator.pop(context);
//             //                   }
//             //                 },
//             //                 child: Container(
//             //                   decoration: BoxDecoration(
//             //                     color: AppColors.green,
//             //                     borderRadius: BorderRadius.circular(8.0),
//             //                   ),
//             //                   padding: const EdgeInsets.symmetric(vertical: 24.0),
//             //                   child: Row(
//             //                     spacing: 12.0,
//             //                     mainAxisAlignment: MainAxisAlignment.center,
//             //                     children: [
//             //                       Icon(
//             //                         Icons.photo_outlined,
//             //                         color: AppColors.white,
//             //                       ),
//             //                       Text(
//             //                         "Photo",
//             //                         // style: AppTheme.button16.copyWith(
//             //                         //   color: AppColors.white,
//             //                         // ),
//             //                       ),
//             //                     ],
//             //                   ),
//             //                 ),
//             //               ),
//             //             ),
//             //             Expanded(
//             //               child: GestureDetector(
//             //                 onTap: () async {
//             //                   try {
//             //                     const int maxSizeBytes =
//             //                         15 * 1024 * 1024; // 15MB in bytes
//             //                     XFile? file = await ImagePicker().pickVideo(
//             //                       source: ImageSource.gallery,
//             //                     );
//             //                     if (file != null) {
//             //                       final int fileSize = await File(
//             //                         file.path,
//             //                       ).length();
//             //                       if (fileSize > maxSizeBytes) {
//             //                         if (!context.mounted) return;
//             //                         context.showErrorSnackBar(
//             //                           "Please select a video under 5MB. Try compressing the video using a video editor.",
//             //                         );
//             //                         return;
//             //                       }
//             //                       setState(() {
//             //                         media = Media(
//             //                           type: MediaType.video,
//             //                           networkType: NetworkType.file,
//             //                           value: file.path,
//             //                         );
//             //                         // videoThumbnailFuture = media!
//             //                         //     .getVideoThumbnail();
//             //                       });
//             //                     }
//             //                   } finally {
//             //                     widget.onMediaPicked?.call(media);
//             //                     if (!context.mounted) return;
//             //                     Navigator.pop(context);
//             //                   }
//             //                 },
//             //                 child: Container(
//             //                   decoration: BoxDecoration(
//             //                     color: AppColors.green,
//             //                     borderRadius: BorderRadius.circular(8.0),
//             //                   ),
//             //                   padding: const EdgeInsets.symmetric(vertical: 24.0),
//             //                   child: Row(
//             //                     spacing: 12.0,
//             //                     mainAxisAlignment: MainAxisAlignment.center,
//             //                     children: [
//             //                       Icon(
//             //                         Icons.video_library_outlined,
//             //                         color: AppColors.white,
//             //                       ),
//             //                       Text(
//             //                         "Video",
//             //                         // style: AppTheme.button16.copyWith(
//             //                         //   color: AppColors.white,
//             //                         // ),
//             //                       ),
//             //                     ],
//             //                   ),
//             //                 ),
//             //               ),
//             //             ),
//             //           ],
//             //         ),
//             //       ),
//             //     );
//             //   },
//             // );
//           },
//           child: DecoratedBox(
//             decoration: BoxDecoration(
//               color: AppColors.white,
//               borderRadius: BorderRadius.circular(8.0),
//               border: Border.all(color: AppColors.black.withValues(alpha: 0.1)),
//             ),
//             child: SizedBox(
//               height: 200,
//               width: double.infinity,
//               child: _objectUrl == null ? _buildPlaceholder() : _buildPreview(),
//               // child: media != null
//               //     ? ClipRRect(
//               //         borderRadius: BorderRadius.circular(8.0),
//               //         child: Builder(
//               //           builder: (context) {
//               //             if (media!.type == MediaType.image) {
//               //               return Stack(
//               //                 fit: StackFit.expand,
//               //                 children: [
//               //                   Image.file(
//               //                     File(media!.value),
//               //                     fit: BoxFit.cover,
//               //                   ),
//               //                   Positioned(
//               //                     top: 6,
//               //                     right: 12.0,
//               //                     child: GestureDetector(
//               //                       onTap: () {
//               //                         setState(() {
//               //                           media = null;
//               //                         });
//               //                       },
//               //                       child: Icon(
//               //                         Icons.cancel,
//               //                         color: AppColors.red,
//               //                       ),
//               //                     ),
//               //                   ),
//               //                 ],
//               //               );
//               //             } else if (media!.type == MediaType.video) {
//               //               return FutureBuilder(
//               //                 future: videoThumbnailFuture,
//               //                 builder: (context, snapshot) {
//               //                   if (snapshot.data == null) {
//               //                     return const SizedBox.shrink();
//               //                   }
//               //                   return Stack(
//               //                     fit: StackFit.expand,
//               //                     children: [
//               //                       Image.memory(
//               //                         snapshot.data as Uint8List,
//               //                         fit: BoxFit.cover,
//               //                       ),
//               //                       Icon(
//               //                         Icons.play_circle_outline_sharp,
//               //                         color: AppColors.green,
//               //                         size: 40.0,
//               //                       ),
//               //                       Positioned(
//               //                         top: 6,
//               //                         right: 12.0,
//               //                         child: GestureDetector(
//               //                           onTap: () {
//               //                             setState(() {
//               //                               media = null;
//               //                             });
//               //                           },
//               //                           child: Icon(
//               //                             Icons.cancel,
//               //                             color: AppColors.red,
//               //                           ),
//               //                         ),
//               //                       ),
//               //                     ],
//               //                   );
//               //                 },
//               //               );
//               //             } else {
//               //               return const SizedBox.shrink();
//               //             }
//               //           },
//               //         ),
//               //       )
//               //     : Column(
//               //         mainAxisAlignment: MainAxisAlignment.center,
//               //         spacing: 4.0,
//               //         children: [
//               //           DecoratedBox(
//               //             decoration: BoxDecoration(
//               //               color: AppColors.white.withValues(alpha: 0.4),
//               //               shape: BoxShape.circle,
//               //             ),
//               //             child: Padding(
//               //               padding: const EdgeInsets.all(8.0),
//               //               child: Icon(Icons.file_upload_outlined),
//               //             ),
//               //           ),
//               //           Text(
//               //             "Drop media file here",
//               //             style: Theme.of(context).textTheme.titleMedium
//               //                 ?.copyWith(decoration: TextDecoration.underline),
//               //           ),
//               //           Text.rich(
//               //             TextSpan(
//               //               children: [
//               //                 TextSpan(
//               //                   text: "Maximum file size ",
//               //                   style: Theme.of(context).textTheme.bodyMedium,
//               //                 ),
//               //                 TextSpan(
//               //                   text: "15MB",
//               //                   style: Theme.of(context).textTheme.bodyMedium
//               //                       ?.copyWith(fontWeight: FontWeight.w700),
//               //                 ),
//               //               ],
//               //             ),
//               //           ),
//               //         ],
//               //       ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildPlaceholder() {
//     return Column(
//       mainAxisAlignment: MainAxisAlignment.center,
//       spacing: 4.0,
//       children: [
//         DecoratedBox(
//           decoration: BoxDecoration(
//             color: AppColors.white.withValues(alpha: 0.4),
//             shape: BoxShape.circle,
//           ),
//           child: Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Icon(Icons.file_upload_outlined),
//           ),
//         ),
//         Text(
//           "Drop media file here",
//           style: Theme.of(context).textTheme.titleMedium?.copyWith(
//             decoration: TextDecoration.underline,
//           ),
//         ),
//         Text.rich(
//           TextSpan(
//             children: [
//               TextSpan(
//                 text: "Maximum file size ",
//                 style: Theme.of(context).textTheme.bodyMedium,
//               ),
//               TextSpan(
//                 text: "15MB",
//                 style: Theme.of(
//                   context,
//                 ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w700),
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }
// }
