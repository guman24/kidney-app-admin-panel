import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kidney_admin/core/constants/firebase_collections.dart';
import 'package:kidney_admin/core/errors/exceptions.dart';
import 'package:kidney_admin/entities/playlist.dart';

final playlistServiceProvider = AutoDisposeProvider((_) => PlaylistService());

class PlaylistService {
  PlaylistService();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<Playlist> fetchPlaylist() async {
    try {
      final query = await _firestore
          .collection(FirebaseCollections.playlist)
          .doc('healing-playlist')
          .get();
      if (query.exists) {
        final playlist = Playlist.fromMap(query.data()!);
        return playlist;
      }
      throw DataException("No healing playlist added");
    } on FirebaseException catch (error) {
      throw DataException(error.message ?? error.code);
    } catch (error) {
      throw DataException(error.toString());
    }
  }

  Future<Playlist> savePlaylist(Playlist playlist) async {
    try {
      await _firestore
          .collection(FirebaseCollections.playlist)
          .doc('healing-playlist')
          .set(playlist.toMap(), SetOptions(merge: true));
      return playlist;
    } on FirebaseException catch (error) {
      throw DataException(error.message ?? error.code);
    } catch (error) {
      throw DataException(error.toString());
    }
  }
}
