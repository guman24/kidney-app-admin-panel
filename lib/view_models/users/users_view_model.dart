import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kidney_admin/entities/user.dart';
import 'package:kidney_admin/services/users_service.dart';

final usersViewModel = AsyncNotifierProvider<UsersViewModel, List<User>>(
  () => UsersViewModel(),
);

class UsersViewModel extends AsyncNotifier<List<User>> {
  @override
  FutureOr<List<User>> build() async {
    return await fetchUsers();
  }

  Future<List<User>> fetchUsers() async {
    return ref.read(userServiceProvider).fetchUsers();
  }
}
