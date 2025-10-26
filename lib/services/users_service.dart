import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kidney_admin/core/constants/firebase_collections.dart';
import 'package:kidney_admin/core/errors/exceptions.dart';
import 'package:kidney_admin/entities/user.dart';

final userServiceProvider = AutoDisposeProvider((ref) => UsersService(ref));

class UsersService {
  final Ref ref;

  UsersService(this.ref);

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<User>> fetchUsers() async {
    try {
      final query = await _firestore
          .collection(FirebaseCollections.users)
          .get();
      final List<User> users = List<User>.from(
        query.docs.map((e) => User.fromJson(e.data())),
      );
      return users;
    } catch (error) {
      throw DataException(error.toString());
    }
  }
}
