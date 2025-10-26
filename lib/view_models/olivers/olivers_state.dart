import 'package:kidney_admin/entities/oliver.dart';

class OliversState {
  final List<Oliver> olivers;
  final bool isLoading;

  OliversState({this.olivers = const [], this.isLoading = false});

  OliversState copyWith({List<Oliver>? olivers, bool? isLoading}) {
    return OliversState(
      olivers: olivers ?? this.olivers,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
