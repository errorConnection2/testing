import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:reminder/models/task.dart';
import 'package:reminder/ui/notify_page.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotifiHelper {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin(); //

  initializeNotification() async {
    _configureLocalTimeZone();
    final IOSInitializationSettings initializationSettingsIOS =
        IOSInitializationSettings(
            requestSoundPermission: false,
            requestBadgePermission: false,
            requestAlertPermission: false,
            onDidReceiveLocalNotification: onDidReceiveLocalNotification);
    final AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('appicon');
    final InitializationSettings initializationSettings =
        InitializationSettings(
            iOS: initializationSettingsIOS,
            android: initializationSettingsAndroid);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: selectNotification);
  }

  Future<void> displayNotification(
      {required String title, required String body}) async {
    print("doing test");
    for (var i = displayNotification(title: title, body: body);;) {
      const androidPlatformChannelSpecifics = const AndroidNotificationDetails(
        'your channel id',
        'your channel name',
        importance: Importance.max,
        priority: Priority.high,
      );
      var platformChannelSpecifics =
          new NotificationDetails(android: androidPlatformChannelSpecifics);
      await flutterLocalNotificationsPlugin.periodicallyShow(
        0,
        title,
        body,
        RepeatInterval.everyMinute,
        platformChannelSpecifics,
        payload: title,
      );
    }
  }

  scheduledNotification(int hour, int minutes, Task task) async {
    await flutterLocalNotificationsPlugin.zonedSchedule(
        task.id!.toInt(),
        task.title,
        task.note,
        _convertTime(hour, minutes),
        const NotificationDetails(
            android: AndroidNotificationDetails(
                'your channel id', 'your channel name')),
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.time,
        payload: "${task.title}|" "${task.note}|" "${task.startTime}|");
  }

  tz.TZDateTime _convertTime(int hour, int minutes) {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduleDate =
        tz.TZDateTime(tz.local, now.year, now.month, now.day, hour, minutes);

    if (scheduleDate.isBefore(now)) {
      scheduleDate = scheduleDate.add(const Duration(days: 1));
    }
    return scheduleDate;
  }

  Future<void> _configureLocalTimeZone() async {
    tz.initializeTimeZones();
    final String timeZone = await FlutterNativeTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(timeZone));
  }

  void requestIOSPermissions() {
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
  }

  Future selectNotification(String? payload) async {
    if (payload != null) {
      print('notification payload: $payload');
    } else {
      print("Notification Done");
    }
    if (payload == "Theme Change") {
      print("Nothing to Navigate");
    } else {
      Get.to(() => NotifyPage(label: payload));
    }
  }

  Future onDidReceiveLocalNotification(
      int id, String? title, String? body, String? payload) async {
    Get.dialog(Text("Welcome to Super Reminder"));
  }
}

// Future<void> sReminderNotifikasi(Task task) async {
//   String localTimeZone =
//       await AwesomeNotifications().getLocalTimeZoneIdentifier();
//   await AwesomeNotifications().createNotification(
//       content: NotificationContent(
//         id: task.id!.toInt(),
//         channelKey: 'basic_channel',
//         title: "${task.title}|",
//         body: "${task.note}|",
//         wakeUpScreen: true,
//       ),
//       actionButtons: [
//         NotificationActionButton(key: 'MarkDone', label: 'Mark Done')
//       ],
//       schedule: NotificationCalendar(
//         weekday: ,
//         hour: ????,
//         day: ????,
//         year: ?????,
//         month: ????????,
//           second: 0, millisecond: 0, timeZone: ??????, repeats: ?????));
// }

Future<void> sReminderNotifikasi() async {
  String localTimeZone =
      await AwesomeNotifications().getLocalTimeZoneIdentifier();
  await AwesomeNotifications().createNotification(
    content: NotificationContent(
      id: createdUniqueId(),
      channelKey: 'basic_channel',
      title: "Judul",
      body: "notes",
      wakeUpScreen: true,
    ),
    actionButtons: [
      NotificationActionButton(key: 'MarkDone', label: 'Mark Done')
    ],//schedule: NotificationCalendar.fromDate()
  );
}
int createdUniqueId() {
  return DateTime.now().millisecondsSinceEpoch.remainder(100000);
}

