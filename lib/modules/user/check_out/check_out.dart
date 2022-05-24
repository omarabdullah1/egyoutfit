import 'dart:developer';
import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../layout/shop_app/cubit/cubit.dart';
import '../../../layout/shop_app/cubit/states.dart';
import '../../../models/shop_app/products_model.dart';
import '../../../shared/components/components.dart';

class CheckoutScreen extends StatefulWidget {
  final String id;
  final String size;
  final int index;
  final int count;
  final int price;
  final String image;
  final ShopProductsModel model;

  const CheckoutScreen({
    Key key,
    this.size,
    this.index,
    this.id,
    this.count,
    this.price,
    this.image,
    this.model,
  }) : super(key: key);

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  var addressController = TextEditingController();
  var phoneController = TextEditingController();
  var otherPhoneController = TextEditingController();
  var commentController = TextEditingController();
  var promoCodeController = TextEditingController();
  var mcvController = TextEditingController();
  var formKey = GlobalKey<FormState>();
  double screenPrice = 0.0;
  double screenPriceCPY = 0.0;
  List<String> promo = [];
  List promoDiscount = [];

  @override
  void initState() {
    phoneController.text = ShopCubit.get(context).loginModel.phone;
    addressController.text = ShopCubit.get(context).loginModel.address;
    screenPrice = widget.price.toDouble();
    screenPriceCPY = widget.price.toDouble();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // Size size = MediaQuery.of(context).size;
    // var model = ShopCubit.get(context).loginModel;
    return BlocConsumer<ShopCubit, ShopStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return SafeArea(
          child: Scaffold(
            appBar: AppBar(),
            body: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SingleChildScrollView(
                child: Form(
                  key: formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // SizedBox(
                      //   width: double.infinity,
                      //   height: size.height / 8,
                      //   child: Image.asset('assets/images/cart.gif'),
                      // ),

                      Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: defaultFormField(
                                prefix: Icons.location_on,
                                label: 'Address',
                                controller: addressController,
                                type: TextInputType.text,
                                validate: (value) {
                                  if (value.isEmpty) {
                                    return "Address  must not be empty";
                                  }
                                }),
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: defaultFormField(
                                prefix: Icons.phone,
                                label: 'Phone',
                                controller: phoneController,
                                type: TextInputType.text,
                                validate: (value) {
                                  if (value.isEmpty) {
                                    return "Phone  must not be empty";
                                  } else if (value.toString().length > 11 ||
                                      value.toString().length < 11) {
                                    return 'Wrong phone number';
                                  }
                                }),
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: defaultFormField(
                                prefix: Icons.phone,
                                label: 'Other Phone',
                                controller: otherPhoneController,
                                type: TextInputType.text,
                                validate: (value) {}),
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: defaultFormField(
                              prefix: Icons.mode_comment,
                              label: 'Comment',
                              controller: commentController,
                              type: TextInputType.text,
                              validate: (v) {},
                            ),
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          Row(
                            children: [
                              SizedBox(
                                width: MediaQuery.of(context).size.width / 2,
                                height: 50.0,
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: defaultFormField(
                                    prefix: Icons.local_offer,
                                    label: 'Promo Code',
                                    controller: promoCodeController,
                                    type: TextInputType.text,
                                    validate: (v) {},
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width / 9,
                              ),
                              defaultButton(
                                  function: () {
                                    if (!promo
                                        .contains(promoCodeController.text)) {
                                      log(ShopCubit.get(context)
                                          .promoCodesList
                                          .contains(promoCodeController.text)
                                          .toString());
                                      bool flag = false;
                                      log(promoCodeController.text);
                                      if (ShopCubit.get(context)
                                          .promoCodesList
                                          .contains(promoCodeController.text)) {
                                        log(ShopCubit.get(context)
                                            .promoCodesIDList
                                            .toString());
                                        if(ShopCubit.get(context)
                                            .promoCodesIDList[ShopCubit.get(context)
                                            .promoCodesList.indexOf(promoCodeController.text)]==widget.model.uid) {
                                          if(ShopCubit.get(context)
                                              .promoCodesStateList[ShopCubit.get(context)
                                              .promoCodesList.indexOf(promoCodeController.text)]=='Active') {
                                            flag = true;
                                          }
                                          else{
                                            showToast(
                                                text: 'Not Active promo code',
                                                state: ToastStates.error);
                                          }
                                        }
                                        else{
                                          showToast(
                                              text: 'The Promo Code Not Activated with this product',
                                              state: ToastStates.error);
                                        }
                                      } else {
                                        flag = false;
                                      }

                                      if (flag) {
                                        log('message');
                                        showToast(
                                            text: 'Activated promo code',
                                            state: ToastStates.success);
                                        int x = ShopCubit.get(context)
                                            .discountList[ShopCubit.get(
                                                context)
                                            .promoCodesList
                                            .indexOf(promoCodeController.text)];
                                        screenPrice = screenPrice -
                                            ((screenPriceCPY / 100.0) *
                                                x.toDouble());

                                        ShopCubit.get(context)
                                            .changeCartPrice();
                                        log(screenPrice.toString());
                                        promo.add(promoCodeController.text);
                                        promoDiscount.add(x.toDouble());
                                      }
                                    } else {
                                      if (!promo
                                          .contains(promoCodeController.text)) {
                                        showToast(
                                            text: 'Wrong promo code',
                                            state: ToastStates.error);
                                      } else {
                                        showToast(
                                            text: 'Repeated promo code',
                                            state: ToastStates.error);
                                      }
                                    }
                                    log(ShopCubit.get(context)
                                        .promoCodesIDList
                                        .toString());
                                    log(ShopCubit.get(context)
                                        .promoCodesList.indexOf(promoCodeController.text).toString());
                                    log(widget.model.uid.toString());
                                  },
                                  text: 'Apply',
                                  width: MediaQuery.of(context).size.width / 3,
                                  height: 40.0,
                                  radius: 12)
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text('Price: ${screenPrice}LE'),
                          ),
                        ],
                      ),
                      // const SizedBox(
                      //   height: 10,
                      // ),
                      Text('Payment',
                          style: Theme.of(context)
                              .textTheme
                              .headline3
                              .copyWith(fontSize: 23)),
                      Text('All transaction are secure and encrypted',
                          style: Theme.of(context)
                              .textTheme
                              .headline3
                              .copyWith(fontSize: 16)),
                      Row(
                        children: [
                          Radio(
                              value: 1,
                              groupValue: ShopCubit.get(context).group,
                              onChanged: (T) {
                                ShopCubit.get(context).changePaymentMethod(1);
                              }),
                          const Text(
                            'Cash (On Delivery)',
                            style: TextStyle(fontSize: 20),
                          )
                        ],
                      ),
                      Row(
                        children: [
                          Radio(
                              value: 2,
                              groupValue: ShopCubit.get(context).group,
                              onChanged: (T) {
                                ShopCubit.get(context).changePaymentMethod(2);
                              }),
                          const Text(
                            'Cards, Net Banking, Wallets',
                            style: TextStyle(fontSize: 20),
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      ConditionalBuilder(
                          condition: ShopCubit.get(context).group == 2,
                          builder: (context) => Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  color: Colors.black,
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 20.0, horizontal: 14),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: const [
                                          Text(
                                            'Credit Card',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 20),
                                          ),
                                          Spacer(),
                                          Text(
                                            'Bank',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 20),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      SizedBox(
                                        width: 35,
                                        height: 25,
                                        child: Image.asset(
                                          'assets/images/chip.png',
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      Row(
                                        children: [
                                          textFieldCardNumber(
                                            context: context,
                                            first: true,
                                            last: false,
                                          ),
                                          const Spacer(),
                                          textFieldCardNumber(
                                            context: context,
                                            first: false,
                                            last: false,
                                          ),
                                          const Spacer(),
                                          textFieldCardNumber(
                                            context: context,
                                            first: false,
                                            last: false,
                                          ),
                                          const Spacer(),
                                          textFieldCardNumber(
                                            context: context,
                                            first: false,
                                            last: true,
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          const Text(
                                            'MCV:  ',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 18),
                                          ),
                                          SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                5,
                                            height: 50,
                                            child: TextField(
                                              autofocus: true,
                                              showCursor: false,
                                              readOnly: false,
                                              textAlignVertical:
                                                  TextAlignVertical.top,
                                              textAlign: TextAlign.center,
                                              style: const TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white),
                                              keyboardType:
                                                  TextInputType.number,
                                              maxLength: 3,
                                              decoration: InputDecoration(
                                                counter: const Offstage(),
                                                enabledBorder:
                                                    OutlineInputBorder(
                                                        borderSide:
                                                            const BorderSide(
                                                                width: 2,
                                                                color: Colors
                                                                    .white),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(13)),
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                        borderSide:
                                                            const BorderSide(
                                                                width: 2,
                                                                color: Colors
                                                                    .deepOrange),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(12)),
                                              ),
                                            ),
                                          ),
                                          const Spacer(),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          const Text(
                                            'valid  ',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 15),
                                          ),
                                          const Text(
                                            'thru   ',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 15),
                                          ),
                                          textFieldDateValidation(
                                            context: context,
                                            first: true,
                                            last: false,
                                          ),
                                          const Text(
                                            '  /  ',
                                            style: TextStyle(
                                                fontSize: 30,
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          textFieldDateValidation(
                                            context: context,
                                            first: false,
                                            last: true,
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              )),
                      const SizedBox(
                        height: 8,
                      ),
                      defaultButton(
                        height: 60.0,
                        radius: 14.0,
                        function: () {
                          if (formKey.currentState.validate() &&
                              addressController.text.isNotEmpty &&
                              phoneController.text.isNotEmpty &&
                              phoneController.text.length == 11) {
                            ShopCubit.get(context).createOrder(
                                orderCount: widget.count,
                                orderId: widget.id,
                                orderSize: widget.size,
                                orderIndex: widget.index,
                                orderAddress: addressController.text,
                                orderComment: commentController.text,
                                orderCost: screenPrice,
                                orderPhone: phoneController.text,
                                orderOtherPhone: otherPhoneController.text,
                                orderPromoCode: promo,
                                orderPromoDiscount: promoDiscount,
                                orderImage: widget.image);
                            // ShopCubit
                            //     .get(context)
                            //     .currentIndex = 0;
                            Navigator.pop(context);
                          } else {
                            if (addressController.text.isEmpty) {
                              showToast(
                                  text: 'Please enter address',
                                  state: ToastStates.error);
                            } else if (phoneController.text.isEmpty) {
                              showToast(
                                  text: 'Please enter phone',
                                  state: ToastStates.error);
                            } else if (phoneController.text.length != 11) {
                              showToast(
                                  text: 'Wrong phone number',
                                  state: ToastStates.error);
                            }
                          }
                        },
                        text: 'Complete Order',
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
