import 'dart:developer';
import 'package:conditional_builder/conditional_builder.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../layout/dashboard_layout/dashboard_layout.dart';
import '../../layout/shop_app/shop_layout.dart';
import '../../shared/components/components.dart';
import '../../shared/components/constants.dart';
import '../../shared/network/local/cache_helper.dart';
import '../../translations/locale_keys.g.dart';
import '../register/register_screen.dart';
import 'cubit/cubit.dart';
import 'cubit/states.dart';
import 'forget_password_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  var emailController = TextEditingController();

  var passwordController = TextEditingController();

  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ShopLoginCubit()
        ..changeLanguageValue(
          CacheHelper.getData(key: 'lang') != null
              ? CacheHelper.getData(key: 'lang') == 'en'
                  ? true
                  : false
              : true,
          context,
        ),
      child: BlocConsumer<ShopLoginCubit, ShopLoginStates>(
        listener: (context, state) async {
          if (ShopLoginCubit.get(context).isEnglish) {
            await context.setLocale(const Locale('en'));
            await CacheHelper.saveData(
              key: 'lang',
              value: 'en',
            );
          } else {
            await context.setLocale(const Locale('ar'));
            await CacheHelper.saveData(
              key: 'lang',
              value: 'ar',
            );
          }
          if (state is ShopLoginSuccessState) {
            log(state.loginModel.firstName);
            log(state.loginModel.uId);

            CacheHelper.saveData(
              key: 'token',
              value: state.loginModel.uId,
            ).then((value) {
              CacheHelper.saveData(key: 'user', value: emailController.text);
              CacheHelper.saveData(key: 'pass', value: passwordController.text);
              CacheHelper.saveData(
                  key: 'isSeller', value: state.loginModel.isSeller);
              token = state.loginModel.uId;
              showToast(
                  text: LocaleKeys.alerts_loginSuccessfully.tr(),
                  state: ToastStates.success);
              state.loginModel.isSeller
                  ? navigateAndFinish(
                      context,
                      const DashboardLayout(),
                    )
                  : navigateAndFinish(
                      context,
                      const ShopLayout(),
                    );
            });
          }
        },
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(leading: Container(), actions: [
              Row(
                children: [
                  const Icon(Icons.language),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                    child: SizedBox(
                      child: Text(
                        'Ar',
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  ),
                  Switch(
                    value: ShopLoginCubit.get(context).isEnglish,
                    onChanged: (v) {
                      ShopLoginCubit.get(context)
                          .changeLanguageValue(v, context);
                    },
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                    child: SizedBox(
                      child: Text(
                        'En',
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  ),
                ],
              ),
            ]),
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(
                    left: 20.0, right: 20.0, bottom: 10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Center(
                      child: Image(
                        image: AssetImage(
                          'assets/images/logo black.png',
                        ),
                        width: 125,
                        height: 125,
                      ),
                    ),
                    // const SizedBox(
                    //   height: 20.0,
                    // ),
                    Form(
                      key: formKey,
                      child: Column(
                        children: [
                          Text(
                            LocaleKeys.loginScreen_loginToYourAccount.tr(),
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 32.0,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          const SizedBox(
                            height: 30.0,
                          ),
                          defaultFormField(
                            controller: emailController,
                            type: TextInputType.emailAddress,
                            isValidate: true,
                            validate: (String value) {
                              if (value.isEmpty) {
                                return LocaleKeys
                                    .loginScreen_pleaseEnterYourEmailAddress
                                    .tr();
                              }
                            },
                            label: LocaleKeys.loginScreen_emailAddress.tr(),
                            prefix: Icons.email_outlined,
                          ),
                          const SizedBox(
                            height: 20.0,
                          ),
                          defaultFormField(
                            controller: passwordController,
                            type: TextInputType.visiblePassword,
                            suffix: ShopLoginCubit.get(context).suffix,
                            isValidate: true,
                            onSubmit: (value) {
                              if (formKey.currentState.validate()) {
                                ShopLoginCubit.get(context).userLogin(
                                  email: emailController.text,
                                  password: passwordController.text,
                                  context: context,
                                );
                              }
                            },
                            isPassword: ShopLoginCubit.get(context).isPassword,
                            suffixPressed: () {
                              ShopLoginCubit.get(context)
                                  .changePasswordVisibility();
                            },
                            validate: (String value) {
                              if (value.isEmpty) {
                                return LocaleKeys
                                    .loginScreen_pleaseEnterYourPassword
                                    .tr();
                              }
                            },
                            label: LocaleKeys.loginScreen_password.tr(),
                            prefix: Icons.lock_outline,
                          ),
                          Container(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              style: TextButton.styleFrom(
                                textStyle: const TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                ),
                              ),
                              onPressed: () {
                                navigateTo(
                                    context, const ForgetPasswordScreen());
                              },
                              child: Text(
                                LocaleKeys.loginScreen_forgetPassword.tr(),
                                style:
                                    const TextStyle(color: Colors.deepOrange),
                              ),
                            ),
                          ),
                          state is ShopLoginErrorState
                              ? Text(
                                  LocaleKeys
                                      .loginScreen_invalidUsernameOrPassword
                                      .tr(),
                                  style: const TextStyle(
                                      fontSize: 16.0, color: Colors.red),
                                )
                              : const SizedBox(
                                  height: 1.0,
                                ),
                          const SizedBox(
                            height: 10.0,
                          ),
                          ConditionalBuilder(
                            condition: state is! ShopLoginLoadingState,
                            fallback: (context) => const Center(
                                child: CircularProgressIndicator()),
                            builder: (context) => Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 70),
                              child: MaterialButton(
                                height: 55,
                                minWidth: 340,
                                elevation: 5.0,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20)),
                                onPressed: () {
                                  if (formKey.currentState.validate()) {
                                    ShopLoginCubit.get(context).userLogin(
                                      email: emailController.text,
                                      password: passwordController.text,
                                      context: context,
                                    );
                                  }
                                  // Navigator.push(context,MaterialPageRoute(builder: (context)=> RegisterScreen()));
                                },
                                child: Text(
                                  LocaleKeys.loginScreen_login.tr(),
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                color: Colors.black,
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 10.0,
                          ),
                          Center(
                            child: Text(
                              LocaleKeys.loginScreen_orSignInWith.tr(),
                              style: const TextStyle(
                                color: Colors.grey,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 20.0,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              MaterialButton(
                                shape: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  borderSide: const BorderSide(
                                    color: Colors.black26,
                                  ),
                                ),
                                minWidth: 150.0,
                                height: 40,
                                onPressed: () {},
                                child: Row(
                                  children: [
                                    const Image(
                                      image: AssetImage(
                                          'assets/images/google.png'),
                                      width: 25,
                                      height: 23,
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      LocaleKeys.loginScreen_google.tr(),
                                      style: const TextStyle(
                                          color: Colors.black45),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(
                                width: 10.0,
                              ),
                              MaterialButton(
                                shape: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  borderSide: const BorderSide(
                                    color: Colors.black26,
                                  ),
                                ),
                                minWidth: 150.0,
                                height: 40,
                                onPressed: () {},
                                child: Row(
                                  children: [
                                    const Image(
                                      image: AssetImage(
                                          'assets/images/facebook.png'),
                                      width: 25,
                                      height: 25,
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      LocaleKeys.loginScreen_facebook.tr(),
                                      style: const TextStyle(
                                          color: Colors.black45),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 10.0,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                LocaleKeys.loginScreen_dontHaveAccount.tr(),
                                style: const TextStyle(
                                  color: Colors.black,
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  navigateTo(context, const RegisterScreen());
                                },
                                child: Text(
                                  LocaleKeys.loginScreen_signUp.tr(),
                                  style: const TextStyle(
                                      color: Colors.deepOrange,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
