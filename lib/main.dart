import 'dart:developer';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:egyoutfit/shared/bloc_observer.dart';
import 'package:egyoutfit/shared/components/constants.dart';
import 'package:egyoutfit/shared/network/local/cache_helper.dart';
import 'package:egyoutfit/shared/network/remote/dio_helper.dart';
import 'package:egyoutfit/shared/styles/themes.dart';
import 'package:egyoutfit/translations/codegen_loader.g.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:showcaseview/showcaseview.dart';
import 'layout/dashboard_layout/cubit/cubit.dart';
import 'layout/dashboard_layout/dashboard_layout.dart';
import 'layout/shop_app/cubit/cubit.dart';
import 'layout/shop_app/shop_layout.dart';
import 'modules/login/login_screen.dart';
import 'modules/on_boarding/on_boarding_screen.dart';

///Receive message when app is in background solution for on message
Future<void> backgroundHandler(RemoteMessage message) async {
  log(message.data.toString());
  log(message.notification.title);
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  log("Handling a background message: ${message.messageId}");
}

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = MyBlocObserver();
  await EasyLocalization.ensureInitialized();
  Firebase.initializeApp(
    name: 'egyoutfit',
    options: const FirebaseOptions(
      apiKey: "AIzaSyAcSAZkDsjBYGXuN1545nN5hzT_LaHBQS4",
      appId: "1:817925315934:web:45ea71c445b14607d203cf",
      messagingSenderId: "817925315934",
      projectId: "egyoutfit-a9d89",
    ),
  ).whenComplete(() {
    // Firebase.apps.forEach((element) {log(element.toString());});
    log("completed");
  });
  // FirebaseWebService
  FirebaseMessaging.onBackgroundMessage(backgroundHandler);
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');
  final IOSInitializationSettings initializationSettingsIOS =
      IOSInitializationSettings(
          requestAlertPermission: false,
          requestBadgePermission: false,
          requestSoundPermission: false,
          onDidReceiveLocalNotification: (
            int id,
            String title,
            String body,
            String payload,
          ) async {});
  final InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
    iOS: initializationSettingsIOS,
  );
  await flutterLocalNotificationsPlugin.initialize(
    initializationSettings,
  );
  DioHelper.init();
  await CacheHelper.init();
  Widget widget;
  bool onBoarding = CacheHelper.getData(key: 'onBoarding');
  token = await CacheHelper.getData(key: 'token');
  bool isSeller = await CacheHelper.getData(key: 'isSeller');
  token != null ? log(token) : null;
  if (onBoarding != null) {
    if (token != null) {
      if (isSeller != null) {
        isSeller
            ? widget = const DashboardLayout()
            : widget = const ShopLayout();
      }
    } else {
      widget = const LoginScreen();
    }
  } else {
    widget = const OnBoardingScreen();
  }
  // widget = const OtpScreen();
  runApp(EasyLocalization(
    supportedLocales: const [Locale('en'), Locale('ar')],
    path: 'assets/lang',
    assetLoader: const CodegenLoader(),
    fallbackLocale: const Locale('en'),
    child: MyApp(
      startWidget: widget,
    ),
  ));
}

class MyApp extends StatefulWidget {
  final Widget startWidget;

  const MyApp({
    Key key,
    this.startWidget,
  }) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  FirebaseMessaging _messaging;
  PushNotification _notificationInfo;

  void registerNotification() async {
    await Firebase.initializeApp();
    _messaging = FirebaseMessaging.instance;

    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    NotificationSettings settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      log('User granted permission');

      FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
        log('Message title: ${message.notification?.title}, body: ${message.notification?.body}, data: ${message.data}');

        // Parse the message received
        PushNotification notification = PushNotification(
          title: message.notification.title,
          body: message.notification.body,
          dataTitle: message.data['title'],
          dataBody: message.data['body'],
        );

        setState(() {
          _notificationInfo = notification;
        });

        if (_notificationInfo != null) {
          // For displaying the notification as an overlay
          FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
              FlutterLocalNotificationsPlugin();

          await flutterLocalNotificationsPlugin.show(
            0,
            _notificationInfo.title,
            _notificationInfo.body,
            const NotificationDetails(
              android: AndroidNotificationDetails(
                'Egyoutfit notification channel id',
                'Egyoutfit notification channel name',
                channelDescription: 'Egyoutfit notification description',
                channelShowBadge: true,
                icon: '@mipmap/ic_launcher',
              ),
            ),
          );
        }
      });
    } else {
      log('User declined or has not accepted permission');
    }
  }

  checkForInitialMessage() async {
    await Firebase.initializeApp();
    RemoteMessage initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();

    if (initialMessage != null) {
      PushNotification notification = PushNotification(
        title: initialMessage.notification.title,
        body: initialMessage.notification.body,
        dataTitle: initialMessage.data['title'],
        dataBody: initialMessage.data['body'],
      );

      setState(() {
        _notificationInfo = notification;
      });
    }
  }

  @override
  void initState() {
    registerNotification();
    checkForInitialMessage();

    // For handling notification when the app is in background
    // but not terminated
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      PushNotification notification = PushNotification(
        title: message.notification.title,
        body: message.notification.body,
        dataTitle: message.data['title'],
        dataBody: message.data['body'],
      );

      setState(() {
        _notificationInfo = notification;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => ShopCubit()
            ..changeLanguageValue(
                CacheHelper.getData(key: 'lang') != null
                    ? CacheHelper.getData(key: 'lang') == 'en'
                        ? true
                        : false
                    : true,
                context),
        ),
        BlocProvider(
          create: (context) => DashboardCubit()
            ..changeLanguageValue(
                CacheHelper.getData(key: 'lang') != null
                    ? CacheHelper.getData(key: 'lang') == 'en'
                        ? true
                        : false
                    : true,
                context),
        )
      ],
      child: OverlaySupport(
        global: true,
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          localizationsDelegates: context.localizationDelegates,
          supportedLocales: context.supportedLocales,
          locale: context.locale,
          theme: lightTheme,
          // theme: lightTheme,
          // darkTheme: darkTheme,
          // themeMode: false ? ThemeMode.dark : ThemeMode.light,
          home: AnimatedSplashScreen(
            nextScreen: ShowCaseWidget(builder: Builder(builder:(context)=> widget.startWidget),),
            backgroundColor: Colors.white,
            duration: 1500,
            centered: true,
            splash: Image.asset('assets/images/logo black.png'),
            splashIconSize: 250,
          ),
        ),
      ),
    );
  }
}

class PushNotification {
  PushNotification({
    this.title,
    this.body,
    this.dataTitle,
    this.dataBody,
  });

  String title;
  String body;
  String dataTitle;
  String dataBody;
}
