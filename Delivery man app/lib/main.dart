import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:resturant_delivery_boy/common/providers/permission_handler_provider.dart';
import 'package:resturant_delivery_boy/common/providers/tracker_provider.dart';
import 'package:resturant_delivery_boy/features/auth/providers/auth_provider.dart';
import 'package:resturant_delivery_boy/features/chat/providers/chat_provider.dart';
import 'package:resturant_delivery_boy/features/language/providers/language_provider.dart';
import 'package:resturant_delivery_boy/features/language/providers/localization_provider.dart';
import 'package:resturant_delivery_boy/features/order/providers/order_provider.dart';
import 'package:resturant_delivery_boy/features/profile/providers/profile_provider.dart';
import 'package:resturant_delivery_boy/features/profile/providers/theme_provider.dart';
import 'package:resturant_delivery_boy/features/splash/providers/splash_provider.dart';
import 'package:resturant_delivery_boy/features/splash/screens/splash_screen.dart';
import 'package:resturant_delivery_boy/helper/notification_helper.dart';
import 'package:resturant_delivery_boy/localization/app_localization.dart';
import 'package:resturant_delivery_boy/theme/dark_theme.dart';
import 'package:resturant_delivery_boy/theme/light_theme.dart';
import 'package:resturant_delivery_boy/utill/app_constants.dart';

import 'di_container.dart' as di;
import 'features/order/providers/time_provider.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
AndroidNotificationChannel? channel;
final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();



Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  stopService();

  if(Platform.isIOS) {
    await Firebase.initializeApp();
  }else {
    await Firebase.initializeApp(options: const FirebaseOptions(
      apiKey: 'AIzaSyA40XT2LSjEI_V9LCfp8YDE2qN_P9Fcduw', ///current_key
      appId: '1:384321080318:android:eb44f7600efcf9452c0eaf', /// mobilesdk_app_id
      messagingSenderId: '384321080318', /// project_number
      projectId: 'gem-b5006', /// project_id
    ));

  }

  ///firebase crashlytics
  // FlutterError.onError = (errorDetails) {
  //   FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
  // };
  //
  // PlatformDispatcher.instance.onError = (error, stack) {
  //   FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
  //   return true;
  // };

  await di.init();

  if(defaultTargetPlatform == TargetPlatform.android){
    channel = const AndroidNotificationChannel(
      'high_importance_channel',
      'High Importance Notifications',
      importance: Importance.high,
    );
  }
  await NotificationHelper.initialize(flutterLocalNotificationsPlugin);
  FirebaseMessaging.onBackgroundMessage(myBackgroundMessageHandler);

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context) => di.sl<ThemeProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<SplashProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<LanguageProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<LocalizationProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<AuthProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<LocalizationProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<ProfileProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<OrderProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<TrackerProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<ChatProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<PermissionHandlerProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<TimerProvider>()),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {

    final Size size = MediaQuery.of(context).size;

    List<Locale> locals = [];
    for (var language in AppConstants.languages) {
      locals.add(Locale(language.languageCode!, language.countryCode));
    }

    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaler: TextScaler.linear(size.width < 380 ?  0.7 : 1)),
      child: SafeArea(top: false, child: MaterialApp(
        title: AppConstants.appName,
        navigatorKey: _navigatorKey,
        debugShowCheckedModeBanner: false,
        theme: Provider.of<ThemeProvider>(context).darkTheme ? dark : light,
        locale: Provider.of<LocalizationProvider>(context).locale,
        localizationsDelegates: const [
          AppLocalization.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: locals,
        home: const SplashScreen(),
      )),
    );
  }
}



class Get {
  static BuildContext? get context => _navigatorKey.currentContext;
  static NavigatorState? get navigator => _navigatorKey.currentState;
}


