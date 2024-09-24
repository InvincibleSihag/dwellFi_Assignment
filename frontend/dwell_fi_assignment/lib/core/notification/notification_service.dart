
import 'package:dwell_fi_assignment/core/notification/custom_notification_provider.dart';
import 'package:dwell_fi_assignment/init_dependencies.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class LocalNotificationService {

  static final LocalNotificationService _nfService = LocalNotificationService();

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  final NotificationManager _notificationManager = serviceLocator<NotificationManager>();

  static LocalNotificationService get nfService  {
    return _nfService;
  }

  Future<void> init() async {
    // Initialize native android notification
    const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('@drawable/ic_notification');

    // Initialize native Ios Notifications
    const DarwinInitializationSettings initializationSettingsIOS = DarwinInitializationSettings();

    const InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>()?.requestNotificationsPermission();

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
    );
  }

  void showNotification(String title, String value) async {
    const AndroidNotificationDetails androidNotificationDetails = AndroidNotificationDetails('generals', 'GeneralNotifications',
        channelDescription: 'Notifications related to attendance, marks, data fetching',
        importance: Importance.max,
        priority: Priority.high,
        ticker: 'ticker');

    DarwinNotificationDetails iOSPlatformChannelSpecifics = const DarwinNotificationDetails(
      presentAlert: true,  // Present an alert when the notification is displayed and the application is in the foreground (only from iOS 10 onwards)
      presentBadge: true,  // Present the badge number when the notification is displayed and the application is in the foreground (only from iOS 10 onwards)
      presentSound: true,  // Play a sound when the notification is displayed and the application is in the foreground (only from iOS 10 onwards)
      // sound: String?,  // Specifics the file path to play (only from iOS 10 onwards)
      // badgeNumber: int?, // The application's icon badge number
      // attachments: List<IOSNotificationAttachment>?, (only from iOS 10 onwards)
      // subtitle: value, //Secondary description  (only from iOS 10 onwards)
      // threadIdentifier: String? (only from iOS 10 onwards)
    );

    NotificationDetails platformChannelSpecifics = NotificationDetails(android: androidNotificationDetails, iOS: iOSPlatformChannelSpecifics);

    int notificationId = UniqueKey().hashCode;
    await flutterLocalNotificationsPlugin
        .show(notificationId, title, value, platformChannelSpecifics, payload: 'Not present');
  }

  void showNotificationAndroid(String title, String value) async {
    const AndroidNotificationDetails androidNotificationDetails = AndroidNotificationDetails('generals', 'GeneralNotifications',
        channelDescription: 'Notifications related to attendance, marks, data fetching',
        importance: Importance.max,
        priority: Priority.high,
        ticker: 'ticker');

    int notificationId = 1;
    const NotificationDetails notificationDetails = NotificationDetails(android: androidNotificationDetails);

    await flutterLocalNotificationsPlugin
        .show(notificationId, title, value, notificationDetails, payload: 'Not present');
  }


  void showNotificationIos(String title, String value) async {
    DarwinNotificationDetails iOSPlatformChannelSpecifics = const DarwinNotificationDetails(
        presentAlert: true,  // Present an alert when the notification is displayed and the application is in the foreground (only from iOS 10 onwards)
        presentBadge: true,  // Present the badge number when the notification is displayed and the application is in the foreground (only from iOS 10 onwards)
        presentSound: true,  // Play a sound when the notification is displayed and the application is in the foreground (only from iOS 10 onwards)
        // sound: String?,  // Specifics the file path to play (only from iOS 10 onwards)
        // badgeNumber: int?, // The application's icon badge number
        // attachments: List<IOSNotificationAttachment>?, (only from iOS 10 onwards)
        // subtitle: value, //Secondary description  (only from iOS 10 onwards)
        // threadIdentifier: String? (only from iOS 10 onwards)
    );

    int notificationId = 1;

    NotificationDetails platformChannelSpecifics = NotificationDetails(iOS: iOSPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin
        .show(notificationId, title, value, platformChannelSpecifics, payload: 'Not present');
  }

  void showCustomNotification(BuildContext context, String title, String message) {
    _notificationManager.showNotification(context, title, message);
  }
}
