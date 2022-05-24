import 'package:flutter/material.dart';

class ShopLoginModel
{
  String firstName;
  String secondName;
  String email;
  String address;
  String phone;
  String uId;
  bool isEmailVerfied;
  bool isSeller;
  List cart;
  List favorites;
  ShopLoginModel({
    @required this.firstName,
    @required this.secondName,
    @required this.email,
    @required this.address,
    @required this.phone,
    @required this.uId,
    @required this.isEmailVerfied,
    @required this.isSeller,
    @required this.cart,
    @required this.favorites,
  });
  ShopLoginModel.fromJson(Map<String, dynamic> json) {
    email = json['email'];
    phone = json['phone'];
    address = json['address'];
    firstName = json['firstName'];
    secondName = json['secondName'];
    uId = json['uId'];
    isEmailVerfied = json['isEmailVerfied'];
    isSeller = json['isSeller'];
    cart = json['cart'];
    favorites = json['favorites'];
  }
  Map<String, dynamic> toMap() {
    return {
      'firstName': firstName,
      'secondName': secondName,
      'phone': phone,
      'address': address,
      'email': email,
      'uId': uId,
      'isEmailVerfied': isEmailVerfied,
      'isSeller': isSeller,
      'cart': cart,
      'favorites': favorites,
    };
  }
}
