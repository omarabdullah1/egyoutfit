import 'package:flutter/material.dart';

class UserModel {
  String firstName;
  String secondName;
  String area;
  String city;
  String organization;
  String email;
  String address;
  String phone;
  String uId;
  bool isEmailVerfied;
  bool isSeller;
  List cart;
  List size;
  List favorites;
  UserModel({
    @required this.firstName,
    @required this.secondName,
    @required this.email,
    @required this.address,
    @required this.phone,
    @required this.uId,
    @required this.isEmailVerfied,
    @required this.isSeller,
    @required this.cart,
    @required this.size,
    @required this.favorites,
    @required this.area,
    @required this.city,
    @required this.organization,
  });
  UserModel.fromJson(Map<String, dynamic> json) {
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
    area = json['area'];
    city = json['city'];
    organization = json['organization'];
    size = json['size'];
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
      'area': area,
      'city': city,
      'organization': organization,
      'size': size,
    };
  }
}