import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:get_storage/get_storage.dart';
import 'package:reminder/db/db_Helper.dart';
import 'package:reminder/ui/home_page.dart';
import 'package:reminder/ui/notify_page.dart';
import 'package:reminder/ui/theme.dart';
import 'package:reminder/ui/theme_services.dart';
import 'package:get/get.dart';
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
 AwesomeNotifications().initialize('resource://drawable/appicon', [
    NotificationChannel(
        channelKey: 'basic_channel',
        channelName: 'Basic Notifications',
        defaultColor: Colors.teal,
        locked: true,
        importance: NotificationImportance.Max,
        channelShowBadge: true,
        channelDescription: '',
        playSound: true,
        enableLights: true,
        enableVibration: true)
  ]);
  await DBHelper.initDB();
  await GetStorage.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'SReminder',
      debugShowCheckedModeBanner: false,
      theme: Themes.light,
      darkTheme: Themes.dark,
      themeMode: ThemeService().theme,
      
      home:  HomePage(),
    );
  }
}
