import 'package:dwell_fi_assignment/core/notification/custom_notification_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class NotificationManager extends ChangeNotifier {
  OverlayEntry? _overlayEntry;
  bool _isShowing = false;

  void showNotification(BuildContext context, String title, String message) {
    if (_isShowing) return;

    _overlayEntry = _createOverlayEntry(context, title, message);
    Overlay.of(context).insert(_overlayEntry!);
    _isShowing = true;

    SchedulerBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(seconds: 2), () {
        _overlayEntry?.remove();
        _isShowing = false;
      });
    });
  }

  OverlayEntry _createOverlayEntry(BuildContext context, String title, String message) {
    return OverlayEntry(
      builder: (context) => Positioned(
        top: 50.0,
        right: 10.0,
        child: Material(
          color: Colors.transparent,
          child: CustomNotification(
            title: title,
            message: message,
          ),
        ),
      ),
    );
  }
}
