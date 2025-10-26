import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kidney_admin/views/shared/media_upload_card.dart';

final mediaServiceProvider = AutoDisposeProvider((ref) => MediaService());

class MediaService {
  MediaService();

  Future<String?> uploadToFirebaseStorage(
    MediaUploadData mediaData,
    String path,
  ) async {
    try {
      final storageRef = FirebaseStorage.instance.ref();
      final fileRef = storageRef.child('$path/${mediaData.fileName}');

      final metadata = SettableMetadata(contentType: mediaData.mimeType);

      final uploadTask = fileRef.putData(mediaData.bytes, metadata);

      // Optional: Track upload progress
      uploadTask.snapshotEvents.listen((snapshot) {
        double progress = snapshot.bytesTransferred / snapshot.totalBytes;
        print('Upload progress: ${(progress * 100).toStringAsFixed(2)}%');
      });

      final snapshot = await uploadTask;
      final downloadUrl = await snapshot.ref.getDownloadURL();

      return downloadUrl;
    } catch (e) {
      print('Upload failed: $e');
      return null;
    }
  }
}
