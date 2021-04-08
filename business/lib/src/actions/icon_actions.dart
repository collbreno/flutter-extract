import 'package:infrastructure/infrastructure.dart';

class FetchIconAction {
  final int iconId;

  FetchIconAction(this.iconId);
}

class FetchIconSucceededAction {
  final IconEntity icon;

  FetchIconSucceededAction(this.icon);
}

class FetchIconFailedAction {
  final Exception exception;

  FetchIconFailedAction(this.exception);
}
