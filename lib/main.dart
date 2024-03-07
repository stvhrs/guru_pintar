import 'dart:developer';

import 'package:Bupin/Home.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(statusBarColor: Colors.transparent));

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  return runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    if (!mounted) return;

    OneSignal.Debug.setLogLevel(OSLogLevel.verbose);

    OneSignal.Debug.setAlertLevel(OSLogLevel.none);

    OneSignal.initialize("fdfd9caf-329f-4c83-973c-726d73fb6169");
    OneSignal.Notifications.requestPermission(true);
    // OneSignal.Notifications.clearAll();

    OneSignal.User.pushSubscription.addObserver((state) {
      log(OneSignal.User.pushSubscription.optedIn.toString());
      log(OneSignal.User.pushSubscription.id.toString());
      log(OneSignal.User.pushSubscription.token.toString());
      log(state.current.jsonRepresentation());
    });

    OneSignal.Notifications.addPermissionObserver((state) {
      log("Has permission $state");
    });

    OneSignal.Notifications.addClickListener((event) {
      log("nitifikasi opende");
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        themeMode: ThemeMode.dark,
        theme: ThemeData(
            appBarTheme: const AppBarTheme(
                actionsIconTheme: IconThemeData(color: Colors.white)),
            fontFamily: 'Nunito',
            textTheme:
                const TextTheme(titleMedium: TextStyle(fontFamily: "Nunito")),
            scaffoldBackgroundColor: const Color.fromRGBO(70, 89, 166, 1),
            colorScheme: ColorScheme.fromSwatch().copyWith(
                secondary: const Color.fromRGBO(236, 180, 84, 1),
                primary: const Color.fromRGBO(70, 89, 166, 1))),
        home: const Home());
  }
}
