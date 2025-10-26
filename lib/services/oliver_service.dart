import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kidney_admin/core/errors/exceptions.dart';
import 'package:kidney_admin/entities/oliver.dart';

const String _collectionOlivers = "olivers";

final oliverServiceProvider = AutoDisposeProvider((ref) => OliverService(ref));

class OliverService {
  final Ref ref;

  OliverService(this.ref);

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<Oliver> saveOliver(Oliver oliver) async {
    try {
      final randomPassword = _generateRandomPassword(length: 6);
      final credential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: oliver.email,
        password: randomPassword,
      );
      if (credential.user == null) {
        throw DataException("Could not create oliver, please try again later");
      }

      await _firebaseAuth.signOut();

      // send email to email address
      _firebaseAuth.sendPasswordResetEmail(email: oliver.email);

      // save oliver data in collection
      oliver = oliver.copyWith(id: credential.user?.uid);
      Map<String, dynamic> oliverJson = oliver.toJson();
      oliverJson['password'] = randomPassword;
      await _firestore
          .collection(_collectionOlivers)
          .doc(oliver.id)
          .set(oliverJson);
      return oliver;
    } catch (error) {
      throw DataException("Could not save oliver, please try again later");
    }
  }

  Future<List<Oliver>> fetchOlivers() async {
    try {
      final query = await _firestore
          .collection(_collectionOlivers)
          .where("role", isNotEqualTo: 'Admin')
          .get();
      List<Oliver> olivers = List<Oliver>.from(
        query.docs.map((doc) => Oliver.fromJson(doc.data())),
      );
      return olivers;
    } catch (error) {
      throw DataException("Could not fetch olivers");
    }
  }

  Future<void> deleteOliver(String oliverId) async {
    try {
      await _firestore.collection(_collectionOlivers).doc(oliverId).delete();
    } catch (error) {
      throw DataException(error.toString());
    }
  }

  Future<Oliver?> getOliverById(String id) async {
    try {
      final query = await _firestore
          .collection(_collectionOlivers)
          .doc(id)
          .get();
      Oliver oliver = Oliver.fromJson(query.data() ?? {});
      debugPrint("Oliver ${oliver.toJson()}");
      return oliver;
    } catch (error) {
      return null;
    }
  }

  String _generateRandomPassword({int length = 12}) {
    const String upperCase = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
    const String lowerCase = 'abcdefghijklmnopqrstuvwxyz';
    const String numbers = '0123456789';
    const String specialChars = '!@#\$%^&*';
    const String allChars = upperCase + lowerCase + numbers + specialChars;

    final Random random =
        Random.secure(); // Use secure random for cryptographic safety
    return List.generate(length, (index) {
      return allChars[random.nextInt(allChars.length)];
    }).join();
  }
}
