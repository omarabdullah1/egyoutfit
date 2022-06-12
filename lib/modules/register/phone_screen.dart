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
import 'cubit/cubit.dart';
import 'cubit/states.dart';

class PhoneScreen extends StatefulWidget {
  final String firstName;
  final String secondName;
  final String organization;
  final String area;
  final String email;
  final String password;
  final String address;
  final String city;
  final bool isSeller;

  const PhoneScreen({
    Key key,
    this.firstName,
    this.secondName,
    this.organization,
    this.area,
    this.email,
    this.password,
    this.address,
    this.city,
    this.isSeller,
  }) : super(key: key);

  @override
  State<PhoneScreen> createState() => _PhoneScreenState();
}

class _PhoneScreenState extends State<PhoneScreen> {
  var phoneController = TextEditingController();
  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ShopRegisterCubit(),
      child: BlocConsumer<ShopRegisterCubit, ShopRegisterStates>(
        listener: (context, state) {
          if (state is ShopCreateUserSuccessState) {
            log(state.userModel.firstName);
            log(state.userModel.uId);
            CacheHelper.saveData(
              key: 'token',
              value: state.userModel.uId,
            ).then((value) {
              CacheHelper.saveData(key: 'user', value: widget.email);
              CacheHelper.saveData(key: 'pass', value: widget.password);
              CacheHelper.saveData(
                  key: 'isSeller', value: state.userModel.isSeller);
              token = state.userModel.uId;
              if (state.userModel.isSeller) {
                navigateAndFinish(context, const DashboardLayout());
              } else {
                navigateAndFinish(context, const ShopLayout());
              }
            });
          }
          if (state is ShopRegisterErrorState) {
            showToast(
                text: LocaleKeys.alerts_errorInRegistration.tr(),
                state: ToastStates.error);
          }
        },
        builder: (context, state) {
          return Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: AppBar(
              elevation: 0,
              backgroundColor: Colors.white,
              leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(
                  Icons.arrow_back_ios_outlined,
                  color: Colors.black,
                ),
              ),
            ),
            body: SingleChildScrollView(
              child: Container(
                color: Colors.white,
                child: Column(
                  children: [
                    const Image(
                      image: AssetImage(
                        'assets/images/logo black.png',
                      ),
                      width: 125,
                      height: 125,
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                    Text(
                      LocaleKeys.signUpScreen_enterYourPhoneNumber.tr(),
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      LocaleKeys.signUpScreen_wellSendYouAVerificationCode.tr(),
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.black38,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                    Form(
                      key: formKey,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 60, vertical: 28.0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          children: [
                            defaultFormField(
                              controller: phoneController,
                              type: TextInputType.phone,
                              label: LocaleKeys.signUpScreen_phoneNumber.tr(),
                              isPrefixText: true,
                              prefix: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 8.0),
                                    child: Text(
                                      '(+02)',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              isValidate: true,
                              validate: (String value) {
                                if (value.isEmpty) {
                                  return LocaleKeys
                                      .signUpScreen_enterYourPhoneNumber
                                      .tr();
                                }
                                return null;
                              },
                              onChange: (v) {
                                if (v.length > 11) {
                                  log('true');
                                  phoneController.text = phoneController.text
                                      .substring(
                                          0, phoneController.text.length - 1);
                                }
                              },
                            ),
                            const SizedBox(
                              height: 50,
                            ),
                            SizedBox(
                              child: ConditionalBuilder(
                                condition: state is! ShopRegisterLoadingState,
                                fallback: (context) =>
                                    const CircularProgressIndicator(),
                                builder: (context) => MaterialButton(
                                  height: 55,
                                  minWidth: 240,
                                  elevation: 5.0,
                                  onPressed: () {
                                    if (formKey.currentState.validate()) {
                                      log(phoneController.text);
                                      ShopRegisterCubit.get(context)
                                          .userRegister(
                                        firstName: widget.firstName,
                                        secondName: widget.secondName,
                                        email: widget.email,
                                        password: widget.password,
                                        address: widget.address,
                                        phone: phoneController.text,
                                        isSeller: widget.isSeller,
                                        area: widget.area,
                                        city: widget.city,
                                        organization: widget.organization,
                                        context: context,
                                      );
                                    }
                                  },
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    LocaleKeys.signUpScreen_next.tr(),
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
                          ],
                        ),
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
