import 'dart:developer';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:egyoutfit/shared/bloc_observer.dart';
import 'package:egyoutfit/shared/components/constants.dart';
import 'package:egyoutfit/shared/network/local/cache_helper.dart';
import 'package:egyoutfit/shared/network/remote/dio_helper.dart';
import 'package:egyoutfit/shared/styles/themes.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'layout/dashboard_layout/cubit/cubit.dart';
import 'layout/dashboard_layout/dashboard_layout.dart';
import 'layout/shop_app/cubit/cubit.dart';
import 'layout/shop_app/shop_layout.dart';
import 'modules/login/login_screen.dart';
import 'modules/on_boarding/on_boarding_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = MyBlocObserver();
  Firebase.initializeApp(
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
  runApp(MyApp(
    startWidget: widget,
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
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => ShopCubit(),),
        BlocProvider(create: (context) => DashboardCubit(),)
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: lightTheme,
        // theme: lightTheme,
        // darkTheme: darkTheme,
        // themeMode: false ? ThemeMode.dark : ThemeMode.light,
        home: AnimatedSplashScreen(
          nextScreen: widget.startWidget,
          backgroundColor: Colors.white,
          duration: 3000,
          centered: true,
          splash: Image.asset('assets/images/logo black.png'),
          splashIconSize: 250,
        ),
      ),
    );
  }
}
