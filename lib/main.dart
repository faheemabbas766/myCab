import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:my_cab/providers/homepro.dart';
import 'package:my_cab/providers/mappro.dart';
import 'package:provider/provider.dart';
import 'Api & Routes/api.dart';
import 'Language/appLocalizations.dart';
import 'constance/constance.dart' as constance;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:my_cab/constance/themes.dart';
import 'package:my_cab/constance/global.dart' as globals;
import 'package:my_cab/constance/routes.dart';
import 'firebase_options.dart';
import 'genericnotifications.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  GenericNotifications.showNotification(
    id: 1,
    title: "Shift Ended",
    body: "Your Shift has been Ended by the Admin",
    payload: "0",
  );
}
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await  Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown,]);
  GenericNotifications.initNotifications();
  await FlutterLocalNotificationsPlugin().getNotificationAppLaunchDetails();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: [SystemUiOverlay.bottom]);
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
  API.devid = await firebaseMessaging.getToken();
  runApp(
    MultiProvider(
    providers: [
      ChangeNotifierProvider<HomePro>(
          create: (_) => HomePro()),
      ChangeNotifierProvider<MapPro>(
          create: (_) => MapPro()),
    ],
    child: const MyApp(),
  ),);
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  static changeTheme(BuildContext context) {
    _MyAppState? state = context.findAncestorStateOfType<_MyAppState>();
    state!.changeTheme();
  }

  static setCustomeLanguage(BuildContext context, String languageCode) {
    final _MyAppState? state = context.findAncestorStateOfType<_MyAppState>();
    state!.setLanguage(languageCode);
  }

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Key key = UniqueKey();

  void changeTheme() {
    setState(() {
      globals.isLight = !globals.isLight;
    });
  }

  String locale = "en";
  setLanguage(String languageCode) {
    setState(() {
      locale = languageCode;
      constance.locale = languageCode;
    });
  }

  @override
  Widget build(BuildContext context) {
    Routes.context=context;
    Routes.width = MediaQuery.of(context).size.width;
    Routes.height = MediaQuery.of(context).size.height;
    constance.locale = locale;
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: globals.isLight ? Brightness.dark : Brightness.light,
      statusBarBrightness: Platform.isAndroid ? Brightness.dark : Brightness.light,
      systemNavigationBarColor: CoustomTheme.getThemeData().cardColor,
      systemNavigationBarDividerColor: CoustomTheme.getThemeData().disabledColor,
      systemNavigationBarIconBrightness: globals.isLight ? Brightness.dark : Brightness.light,
    ));
    return Container(
      key: key,
      color: CoustomTheme.getThemeData().colorScheme.background,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              CoustomTheme.getThemeData().colorScheme.background,
              CoustomTheme.getThemeData().colorScheme.background,
              CoustomTheme.getThemeData().colorScheme.background.withOpacity(0.8),
              CoustomTheme.getThemeData().colorScheme.background.withOpacity(0.7)
            ],
          ),
        ),
        child: MaterialApp(
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('en'), // English
            Locale('fr'), // French
            Locale('ar'), // Arabic
          ],
          debugShowCheckedModeBanner: false,
          title: AppLocalizations.of('My Cab'),
          // home: PhoneVerification(),
          routes: routes,
          theme: CoustomTheme.getThemeData(),
          builder: (BuildContext context, Widget? child) {
            return Directionality(
              textDirection: TextDirection.ltr,
              child: Builder(
                builder: (BuildContext context) {
                  return MediaQuery(
                    data: MediaQuery.of(context).copyWith(
                      textScaler: const TextScaler.linear(1.0),
                    ),
                    child: child ?? const Text(""),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
