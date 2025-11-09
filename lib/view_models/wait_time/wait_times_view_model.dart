import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kidney_admin/core/enums/action_status.dart';
import 'package:kidney_admin/entities/transplant_center.dart';
import 'package:kidney_admin/services/wait_times_service.dart';
import 'package:kidney_admin/view_models/wait_time/wait_time_state.dart';

final waitTimesViewModel = NotifierProvider<WaitTimesNotifier, WaitTimeState>(
  () => WaitTimesNotifier(),
);

class WaitTimesNotifier extends Notifier<WaitTimeState> {
  @override
  WaitTimeState build() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetchTransplantCenters();
    });
    return WaitTimeState();
  }

  Future<void> saveTransplantCenter(TransplantCenter center) async {
    state = state.copyWith(saveStatus: ActionStatus.loading);
    try {
      final savedTransplant = await ref
          .read(waitTimeServiceProvider)
          .saveTransplantCenter(center);
      List<TransplantCenter> allCenters = List.from(state.transplantCenters);

      List<TransplantCenter> updatedCenters = allCenters;
      if (allCenters.where((e) => e.id == center.id).isNotEmpty) {
        // update index
        final index = allCenters.indexWhere((e) => e.id == center.id);
        allCenters[index] = center;
        updatedCenters = allCenters;
      } else {
        updatedCenters = [savedTransplant, ...allCenters];
      }
      state = state.copyWith(
        saveStatus: ActionStatus.success,
        transplantCenters: updatedCenters,
      );
    } catch (error) {
      state = state.copyWith(
        saveStatus: ActionStatus.failed,
        saveError: error.toString(),
      );
    }
  }

  Future<void> fetchTransplantCenters() async {
    state = state.copyWith(fetchStatus: ActionStatus.loading);
    try {
      final transplantCenters = await ref
          .read(waitTimeServiceProvider)
          .fetchTransplantCenters();
      state = state.copyWith(
        fetchStatus: ActionStatus.success,
        transplantCenters: transplantCenters,
      );
    } catch (error) {
      state = state.copyWith(
        fetchStatus: ActionStatus.failed,
        fetchError: error.toString(),
      );
    }
  }

  Future<void> deleteTransplantCenter(String id) async {
    try {
      await ref.read(waitTimeServiceProvider).deleteTransplantCenter(id);
      List<TransplantCenter> allCenters = List.from(state.transplantCenters);
      allCenters.removeWhere((e) => e.id == id);
      state = state.copyWith(transplantCenters: allCenters);
    } catch (error) {
      debugPrint("Could not delete wait time -> $error");
    }
  }

  void setEditCenter(TransplantCenter? center) {
    state = state.copyWith(editCenter: center);
  }
}
