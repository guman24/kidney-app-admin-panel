import 'package:desktop_drop/desktop_drop.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:just_audio/just_audio.dart';
import 'dart:typed_data';

// Web-specific imports
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
  final bool isAudio;

  MediaUploadData({
    required this.fileName,
    required this.mimeType,
    required this.bytes,
    this.isImage = false,
    this.isVideo = false,
    this.isAudio = false,
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
    this.acceptedFormats = const ['image/*', 'video/*', 'audio/*'],
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
  String? _audioViewId;
  bool _isDragging = false;
  bool _isLoading = false;
  bool _isFromNetwork = false;

  AudioPlayer? _audioPlayer;
  bool _isAudioPlaying = false;

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
    _audioPlayer?.dispose();
    super.dispose();
  }

  void _loadNetworkFile(String url) {
    setState(() {
      _isFromNetwork = true;
      _previewUrl = url;

      final isVideo =
          url.contains('.mp4') ||
          url.contains('.mov') ||
          url.contains('.webm') ||
          url.contains('video');
      final isAudio =
          url.contains('.mp3') ||
          url.contains('.wav') ||
          url.contains('.ogg') ||
          url.contains('audio');

      if (isVideo && kIsWeb) _createNetworkVideoView(url);
      if (isAudio && kIsWeb) _createNetworkAudioView(url);
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

  void _createNetworkAudioView(String url) {
    final viewId = 'network-audio-${DateTime.now().microsecondsSinceEpoch}';
    _audioViewId = viewId;

    ui_web.platformViewRegistry.registerViewFactory(viewId, (int viewId) {
      final audio = web.document.createElement('audio') as web.AudioElement;
      audio.src = url;
      audio.controls = true;
      audio.autoplay = false;
      audio.style.width = '100%';
      return audio;
    });
  }

  void _revokeObjectUrl() {
    if (_previewUrl != null && kIsWeb) {
      try {
        html.Url.revokeObjectUrl(_previewUrl!);
      } catch (_) {}
      _previewUrl = null;
    }
    _videoViewId = null;
    _networkVideoViewId = null;
    _audioViewId = null;
  }

  Future<void> _pickFile() async {
    if (!kIsWeb) {
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
    final sizeMB = bytes.length / (1024 * 1024);
    if (sizeMB > widget.maxSizeMB) {
      _showError(
        'File size (${sizeMB.toStringAsFixed(1)}MB) exceeds maximum allowed size (${widget.maxSizeMB}MB)',
      );
      return;
    }

    _revokeObjectUrl();

    final isImage = mimeType.startsWith('image/');
    final isVideo = mimeType.startsWith('video/');
    final isAudio = mimeType.startsWith('audio/');

    if (!isImage && !isVideo && !isAudio) {
      _showError(
        'Unsupported file type. Please select image, video, or audio.',
      );
      return;
    }

    final mediaData = MediaUploadData(
      fileName: fileName,
      mimeType: mimeType,
      bytes: bytes,
      isImage: isImage,
      isVideo: isVideo,
      isAudio: isAudio,
    );

    if (kIsWeb) {
      final blob = html.Blob([bytes], mimeType);
      _previewUrl = html.Url.createObjectUrlFromBlob(blob);

      if (isVideo) _createVideoView(_previewUrl!);
      if (isAudio) _createAudioView(_previewUrl!);
    } else if (isAudio) {
      _audioPlayer = AudioPlayer();
      await _audioPlayer!.setAudioSource(
        AudioSource.uri(Uri.dataFromBytes(bytes)),
      );
    }

    setState(() {
      _mediaData = mediaData;
    });

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

  void _createAudioView(String url) {
    final viewId = 'audio-${DateTime.now().microsecondsSinceEpoch}';
    _audioViewId = viewId;

    ui_web.platformViewRegistry.registerViewFactory(viewId, (int viewId) {
      final audio = html.AudioElement()
        ..src = url
        ..controls = true
        ..autoplay = false
        ..style.width = '100%';
      return audio;
    });
  }

  void _removeMedia() {
    _revokeObjectUrl();
    _audioPlayer?.stop();
    setState(() {
      _mediaData = null;
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

    final videoTypes = {
      'mp4': 'video/mp4',
      'mov': 'video/quicktime',
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

    final audioTypes = {
      'mp3': 'audio/mpeg',
      'wav': 'audio/wav',
      'ogg': 'audio/ogg',
      'm4a': 'audio/mp4',
      'aac': 'audio/aac',
    };

    if (imageTypes.containsKey(ext)) return imageTypes[ext]!;
    if (videoTypes.containsKey(ext)) return videoTypes[ext]!;
    if (audioTypes.containsKey(ext)) return audioTypes[ext]!;

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
            final bytes = await file.readAsBytes();
            final mimeType = _getMimeTypeFromPath(file.name);
            await _processFileData(
              fileName: file.name,
              mimeType: mimeType,
              bytes: bytes,
            );
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
              ? const Center(child: CircularProgressIndicator())
              : (_mediaData != null || _isFromNetwork)
              ? _buildPreview()
              : _buildPlaceholder(),
        ),
      ),
    );
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
      ],
    );
  }

  Widget _buildPreview() {
    if (_mediaData == null && !_isFromNetwork) return const SizedBox.shrink();

    final url = _previewUrl ?? '';
    String decodedUrl = Uri.decodeFull(url).toLowerCase();
    final objectPath = decodedUrl.contains('/o/')
        ? decodedUrl.split('/o/').last.split('?').first
        : decodedUrl;
    final isImage =
        _mediaData?.isImage ??
        (objectPath.endsWith('.jpg') ||
            objectPath.endsWith('.jpeg') ||
            objectPath.endsWith('.png') ||
            objectPath.endsWith('.webp') ||
            objectPath.endsWith('.gif'));
    final isVideo =
        _mediaData?.isVideo ??
        (objectPath.endsWith('.mp4') ||
            objectPath.endsWith('.mov') ||
            objectPath.endsWith('.webm') ||
            objectPath.contains('video'));
    final isAudio =
        _mediaData?.isAudio ??
        (url.endsWith('.mp3') ||
            objectPath.endsWith('.m4a') ||
            objectPath.endsWith('.aac') ||
            objectPath.endsWith('.wav') ||
            objectPath.endsWith('.ogg') ||
            objectPath.contains('audio') ||
            objectPath.contains(".mp3"));

    Widget mediaWidget;
    if (isImage) {
      mediaWidget = Image.network(
        url,
        fit: BoxFit.contain,
        errorBuilder: (_, __, ___) => const Icon(Icons.broken_image, size: 48),
      );
    } else if (isVideo) {
      mediaWidget = HtmlElementView(
        viewType: _videoViewId ?? _networkVideoViewId ?? '',
      );
    } else if (isAudio) {
      mediaWidget = HtmlElementView(viewType: _audioViewId ?? '');
    } else {
      mediaWidget = const Center(
        child: Text(
          'Unsupported file type',
          style: TextStyle(color: Colors.red),
        ),
      );
    }

    // ✅ Wrap media preview in Stack to show a delete button overlay
    return Stack(
      fit: StackFit.expand,
      children: [
        mediaWidget,
        Positioned(
          top: 8,
          right: 8,
          child: InkWell(
            onTap: _removeMedia,
            borderRadius: BorderRadius.circular(20),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black54,
                shape: BoxShape.circle,
              ),
              padding: const EdgeInsets.all(6),
              child: const Icon(Icons.close, color: Colors.white, size: 18),
            ),
          ),
        ),
      ],
    );
  }
}
