import 'dart:async';

/// A mixin that encapsulates periodic-timer management for BLoC classes.
///
/// Usage:
/// ```dart
/// class MyBloc extends Bloc<MyEvent, MyState> with PollingMixin {
///   @override
///   Future<void> close() {
///     stopPolling(); // required — must be called before super.close()
///     return super.close();
///   }
/// }
/// ```
///
/// The callback passed to [startPolling] is fully responsible for error
/// handling (e.g. emitting an error state). This mixin does NOT swallow
/// errors — any exception thrown by the callback will propagate normally.
mixin PollingMixin {
  Timer? _pollingTimer;

  /// Starts (or restarts) a periodic timer that calls [callback] every
  /// [interval]. Cancels any previously running timer first.
  ///
  /// [interval] defaults to 60 seconds.
  ///
  /// The [callback] must handle its own errors; exceptions are not caught here.
  void startPolling(
    Future<void> Function() callback, {
    Duration interval = const Duration(seconds: 60),
  }) {
    stopPolling();
    _pollingTimer = Timer.periodic(interval, (_) => callback());
  }

  /// Cancels the active polling timer, if any.
  ///
  /// NOTE: The BLoC's [close] override MUST call [stopPolling] to avoid
  /// timer callbacks firing after the BLoC has been closed.
  void stopPolling() {
    _pollingTimer?.cancel();
    _pollingTimer = null;
  }
}
