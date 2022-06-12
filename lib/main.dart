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
import 'package:showcaseview/showcaseview.dart';
import 'layout/dashboard_layout/cubit/cubit.dart';
import 'layout/dashboard_layout/dashboard_layout.dart';
import 'layout/shop_app/cubit/cubit.dart';
import 'layout/shop_app/shop_layout.dart';
import 'modules/login/login_screen.dart';

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
  // const firebaseConfig = {
  //   apiKey: "AIzaSyAcSAZkDsjBYGXuN1545nN5hzT_LaHBQS4",
  //   authDomain: "egyoutfit-a9d89.firebaseapp.com",
  //   projectId: "egyoutfit-a9d89",
  //   storageBucket: "egyoutfit-a9d89.appspot.com",
  //   messagingSenderId: "817925315934",
  //   appId: "1:817925315934:web:45ea71c445b14607d203cf",
  //   measurementId: "G-Q44TRPSJQM"
  // };
  Firebase.initializeApp(
    // name: 'EgyOutfit',
    options: const FirebaseOptions(
      apiKey: "AIzaSyAcSAZkDsjBYGXuN1545nN5hzT_LaHBQS4",
      authDomain: "egyoutfit-a9d89.firebaseapp.com",
      projectId: "egyoutfit-a9d89",
      storageBucket: "egyoutfit-a9d89.appspot.com",
      messagingSenderId: "817925315934",
      appId: "1:817925315934:web:45ea71c445b14607d203cf",
      measurementId: "G-Q44TRPSJQM"
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
  // bool onBoarding = CacheHelper.getData(key: 'onBoarding');
  token = await CacheHelper.getData(key: 'token');
  bool isSeller = await CacheHelper.getData(key: 'isSeller');
  token != null ? log(token) : null;
    if (token != null) {
      if (isSeller != null) {
        isSeller
            ? widget = const DashboardLayout()
            : widget = const ShopLayout();
      }
    } else {
      widget = const LoginScreen();
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


  @override
  void initState() {
    // For handling notification when the app is in background
    // but not terminated
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      PushNotification notification = PushNotification(
        title: message.notification.title,
        body: message.notification.body,
        dataTitle: message.data['title'],
        dataBody: message.data['body'],
      );
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => ShopCubit(),
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
