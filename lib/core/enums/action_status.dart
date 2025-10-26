enum ActionStatus { initial, loading, success, failed }

extension ActionStatusX on ActionStatus {
  bool get isLoading => this == ActionStatus.loading;

  bool get isSuccess => this == ActionStatus.success;

  bool get isFailed => this == ActionStatus.failed;
}
