import 'dart:developer';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../shared/components/components.dart';
import '../../shared/components/constants.dart';
import '../../shared/network/local/cache_helper.dart';
import '../../shared/styles/colors.dart';
import '../../translations/locale_keys.g.dart';
import 'cubit/cubit.dart';
import 'cubit/states.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key key}) : super(key: key);

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  var userFirstNameController = TextEditingController();
  var userSecondNameController = TextEditingController();
  var userAddressController = TextEditingController();
  var userStreetController = TextEditingController();
  var userAreaController = TextEditingController();
  var userEmailController = TextEditingController();
  var userPasswordController = TextEditingController();
  var userConfirmPasswordController = TextEditingController();
  bool userIsPassword = true;
  bool userConfirmPassword = true;

  var userFormKey = GlobalKey<FormState>();
  var sellerFirstNameController = TextEditingController();
  var sellerSecondNameController = TextEditingController();
  var sellerOrganizationNameController = TextEditingController();
  var sellerAddressController = TextEditingController();
  var sellerStreetController = TextEditingController();
  var sellerAreaController = TextEditingController();
  var sellerEmailController = TextEditingController();
  var sellerPasswordController = TextEditingController();
  var sellerConfirmPasswordController = TextEditingController();
  bool sellerIsPassword = true;
  bool sellerConfirmPassword = true;

  final sellerFormKey = GlobalKey<FormState>();
  bool isSeller;

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
              CacheHelper.saveData(
                  key: 'user',
                  value: isSeller
                      ? sellerEmailController.text
                      : userEmailController.text);
              CacheHelper.saveData(
                  key: 'pass',
                  value: isSeller
                      ? sellerPasswordController.text
                      : userPasswordController.text);
              CacheHelper.saveData(key: 'isSeller', value: isSeller);
              token = state.userModel.uId;
            });
          }
          if (state is ShopRegisterErrorState) {
            showToast(text: LocaleKeys.alerts_errorInRegistration.tr(), state: ToastStates.error);
          }
        },
        builder: (context, state) {
          return SafeArea(
            child: DefaultTabController(
              length: 2,
              initialIndex: 0,
              child: Scaffold(
                // resizeToAvoidBottomInset: false,
                body: Column(
                  children: [
                    TabBar(
                      labelColor: Colors.black,
                      indicatorColor: defaultColor,
                      tabs: [
                        Tab(
                          text: LocaleKeys.signUpScreen_user.tr(),
                        ),
                        Tab(
                          text: LocaleKeys.signUpScreen_seller.tr(),
                        ),
                      ],
                    ),
                    Expanded(
                      child: TabBarView(
                        children: [
                          buildUserRegister(
                            context: context,
                            userAreaController: userAreaController,
                            userEmailController: userEmailController,
                            userFirstNameController: userFirstNameController,
                            userFormKey: userFormKey,
                            userPasswordController: userPasswordController,
                            userConfirmPasswordController: userConfirmPasswordController,
                            userSecondNameController: userSecondNameController,
                            userStreetController: userStreetController,
                          ),
                          buildSellerRegister(
                            context: context,
                            sellerAreaController: sellerAreaController,
                            sellerEmailController: sellerEmailController,
                            sellerFirstNameController: sellerFirstNameController,
                            sellerOrganizationNameController: sellerOrganizationNameController,
                            sellerFormKey: sellerFormKey,
                            sellerPasswordController: sellerPasswordController,
                            sellerSecondNameController: sellerSecondNameController,
                            sellerStreetController: sellerStreetController,
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
