import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kidney_admin/core/errors/exceptions.dart';
import 'package:kidney_admin/entities/oliver.dart';
import 'package:kidney_admin/services/oliver_service.dart';
import 'package:kidney_admin/view_models/olivers/olivers_state.dart';

final oliversViewModel = NotifierProvider(() => OliversViewModel());

class OliversViewModel extends Notifier<OliversState> {
  @override
  OliversState build() {
    fetchOlivers();
    return OliversState();
  }

  void saveOliver(Oliver oliver) async {
    state = state.copyWith(isLoading: true);
    try {
      final savedOliver = await ref
          .read(oliverServiceProvider)
          .saveOliver(oliver);
      List<Oliver> allOlivers = List.from(state.olivers);
      allOlivers = [savedOliver, ...allOlivers];
      state = state.copyWith(olivers: allOlivers);
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  void fetchOlivers() async {
    final olivers = await ref.read(oliverServiceProvider).fetchOlivers();
    state = state.copyWith(olivers: olivers);
  }

  Future<void> deleteOliver(String oliverId) async {
    state = state.copyWith(isLoading: true);
    try {
      await ref.read(oliverServiceProvider).deleteOliver(oliverId);
      List<Oliver> olivers = List.from(state.olivers);
      olivers.removeWhere((e) => e.id == oliverId);
      state = state.copyWith(olivers: olivers);
    } catch (error) {
      throw DataException(error.toString());
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }
}
