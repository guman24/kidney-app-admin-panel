import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kidney_admin/core/enums/action_status.dart';
import 'package:kidney_admin/entities/inspiration.dart';
import 'package:kidney_admin/services/inspiration_service.dart';
import 'package:kidney_admin/view_models/inspiration/inspiration_state.dart';

final inspirationsViewModel =
    NotifierProvider<InspirationNotifier, InspirationState>(
      () => InspirationNotifier(),
    );

class InspirationNotifier extends Notifier<InspirationState> {
  @override
  InspirationState build() {
    Future.microtask(() {
      fetchInspirations();
    });
    return InspirationState();
  }

  Future<void> fetchInspirations() async {
    state = state.copyWith(fetchStatus: ActionStatus.loading);
    try {
      final inspirations = await ref
          .read(inspirationServiceProvider)
          .fetchInspirations();
      state = state.copyWith(
        fetchStatus: ActionStatus.success,
        inspirations: inspirations,
      );
    } catch (error) {
      state = state.copyWith(fetchStatus: ActionStatus.failed);
    }
  }

  Future<void> saveInspiration(Inspiration inspiration) async {
    state = state.copyWith(saveStatus: ActionStatus.loading);
    try {
      final savedInspiration = await ref
          .read(inspirationServiceProvider)
          .saveInspiration(inspiration);
      List<Inspiration> inspirations = List.from(state.inspirations);
      if (inspirations.contains(inspiration)) {
        /// just update current list with content
        final int index = inspirations.indexOf(inspiration);
        if (index >= 0) {
          inspirations[index] = inspiration;
        }
      } else {
        /// add new saved inspiration in the list
        inspirations.add(savedInspiration);
      }

      state = state.copyWith(
        inspirations: inspirations,
        saveStatus: ActionStatus.success,
      );
    } catch (error) {
      state = state.copyWith(saveStatus: ActionStatus.failed);
    }
  }

  Future<void> deleteInspiration(String id) async {
    try {
      await ref.read(inspirationServiceProvider).deleteInspiration(id);
      List<Inspiration> inspirations = List.from(state.inspirations);
      inspirations.removeWhere((e) => e.id == id);
      state = state.copyWith(inspirations: inspirations);
    } catch (error) {
      log("Exception [deleteInspiration] $error");
    }
  }

  void setEditInspiration(Inspiration? inspiration) =>
      state = state.copyWith(editInspiration: inspiration);
}
