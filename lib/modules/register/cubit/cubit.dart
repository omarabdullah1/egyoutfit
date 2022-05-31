import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:egyoutfit/modules/register/cubit/states.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../models/shop_app/login_model.dart';
import '../../../models/user/user_model.dart';

class ShopRegisterCubit extends Cubit<ShopRegisterStates> {
  ShopRegisterCubit() : super(ShopRegisterInitialState());

  static ShopRegisterCubit get(context) => BlocProvider.of(context);

  ShopLoginModel loginModel;
  String userRegisterDropdownValueEn;
  String userRegisterDropdownValueAr;
  String sellerRegisterDropdownValueEn;
  String sellerRegisterDropdownValueAr;
  UserModel model;
  List itemsEn = <String>[
    'Cairo',
    'Alexandria',
    'Giza',
    'Matrouh',
    'Port Said',
    'Helwan',
    'Port Said',
    'Al-Mahallah Al-Kubra',
    'Tanta',
    'Suez',
    'Asyut',
    'Al-Fayoum',
    'Ismailia',
    'Damietta',
    'Al-Minya',
    'Luxor',
    'Qema',
    'Sohag',
    'Bani Sewief',
    'Al-Sharkya',
    'Al-Gharbya',
    'Sinai',
    'Al-Wady El-Geded',
    'Al-Monofya',
    'Qalubia',
    'Dakahlya',
    'Red Sea',
    'Beheira',
  ];
  List itemsAr = <String>[
    "القاهرة",
    'الإسكندرية',
    'الجيزة',
    'مطروح',
    'بورسعيد',
    'حلوان',
    'بورسعيد'
        'المحلة الكبرى',
    "طنطا",
    "السويس",
    "أسيوط",
    "الفيوم",
    'الإسماعيلية',
    'دمياط',
    'المنيا',
    "الأقصر",
    'قمة',
    'سوهاج',
    "بني سويف",
    'الشرقية',
    'الغربية',
    'سيناء',
    'الوادي الجديد',
    'المنوفية',
    'القليوبية',
    'الدقهلية',
    'البحر الاحمر',
    "البحيرة",
  ];

  void userRegister({
    @required String email,
    @required String password,
    @required String firstName,
    @required String secondName,
    @required String address,
    @required String phone,
    @required String area,
    @required String city,
    String organization,
    @required bool isSeller,
  }) {
    emit(ShopRegisterLoadingState());
    FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password)
        .then((value) {
      emit(ShopRegisterSuccessState());
      log(value.user.email);
      log(value.user.uid);
      createUser(
        email: value.user.email,
        firstName: firstName,
        secondName: secondName,
        uId: value.user.uid,
        isEmailVerified: false,
        address: address,
        phone: phone,
        isSeller: isSeller,
        area: area,
        city: city,
        organization: organization,
      );
    }).catchError((error) {
      emit(ShopRegisterErrorState(error.toString()));
      log(error.toString());
    });
  }

  Future<void> createUser({
    @required String email,
    @required String firstName,
    @required String secondName,
    @required String uId,
    @required bool isEmailVerified,
    @required bool isSeller,
    @required String address,
    @required String phone,
    @required String area,
    @required String city,
    @required String organization,
  }) async {
    model = UserModel(
      firstName: firstName,
      secondName: secondName,
      address: address,
      email: email,
      uId: uId,
      isEmailVerfied: isEmailVerified,
      isSeller: isSeller,
      cart: [],
      size: [],
      favorites: [],
      phone: phone,
      area: area,
      city: city,
      organization: organization,
      image:
          'https://play-lh.googleusercontent.com/pkDx7qzmaH0F8LF6Q8W2JX0OCYxrIkoNyGI3QQ7ozwJ19ncR6HuZuBP5MuYcuWL_cQ',
    );
    FirebaseFirestore.instance
        .collection('users')
        .doc(uId)
        .set(model.toMap())
        .then((value) async {
      emit(ShopCreateUserSuccessState(model));
    }).catchError((error) {
      emit(ShopCreateUserErrorState(error.toString()));
    });
  }

  IconData userSuffix = Icons.visibility_outlined;
  IconData userSuffix2 = Icons.visibility_outlined;
  bool userRegisterIsPassword = true;
  bool userRegisterIsPassword2 = true;

  IconData sellerSuffix = Icons.visibility_outlined;
  IconData sellerSuffix2 = Icons.visibility_outlined;
  bool sellerRegisterIsPassword = true;
  bool sellerRegisterIsPassword2 = true;

  void userChangePasswordVisibility() {
    userRegisterIsPassword = !userRegisterIsPassword;
    userSuffix = userRegisterIsPassword
        ? Icons.visibility_outlined
        : Icons.visibility_off_outlined;

    emit(ShopRegisterChangePasswordVisibilityState());
  }

  void userChangeConfirmPasswordVisibility() {
    userRegisterIsPassword2 = !userRegisterIsPassword2;
    userSuffix2 = userRegisterIsPassword2
        ? Icons.visibility_outlined
        : Icons.visibility_off_outlined;

    emit(ShopRegisterChangePasswordVisibilityState());
  }

  void sellerChangePasswordVisibility() {
    sellerRegisterIsPassword = !sellerRegisterIsPassword;
    sellerSuffix = sellerRegisterIsPassword
        ? Icons.visibility_outlined
        : Icons.visibility_off_outlined;

    emit(ShopRegisterChangePasswordVisibilityState());
  }

  void sellerChangeConfirmPasswordVisibility() {
    sellerRegisterIsPassword2 = !sellerRegisterIsPassword2;
    sellerSuffix2 = sellerRegisterIsPassword2
        ? Icons.visibility_outlined
        : Icons.visibility_off_outlined;

    emit(ShopRegisterChangePasswordVisibilityState());
  }

  userChangeDropValue(value, context) {
    EasyLocalization.of(context).locale.languageCode == 'en'
        ? userRegisterDropdownValueEn = value
        : userRegisterDropdownValueAr = value;
    emit(ShopRegisterChangeDropValueState());
  }

  sellerChangeDropValue(value, context) {
    EasyLocalization.of(context).locale.languageCode == 'en'
        ? sellerRegisterDropdownValueEn = value
        : sellerRegisterDropdownValueAr = value;
    emit(ShopRegisterChangeDropValueState());
  }
//Determin wheather the sentiment of text is positive use web service

}
