import 'package:easy_localization/easy_localization.dart';
import 'package:egyoutfit/layout/shop_app/cubit/cubit.dart';
import 'package:egyoutfit/layout/shop_app/cubit/states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../models/orders/orders_model.dart';
import '../../../translations/locale_keys.g.dart';

class UserOpenedOrderScreen extends StatelessWidget {
  const UserOpenedOrderScreen({
    Key key,
    this.orderModel,
    this.index,
  }) : super(key: key);
  final OrdersModel orderModel;
  final int index;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: BlocConsumer<ShopCubit, ShopStates>(
        listener: (context, state) {},
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              title: Text(LocaleKeys.userAccountScreen_order.tr()),
            ),
            body: SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15.0),
                                border: Border.all(
                                  width: 2.0,
                                  color: Colors.black,
                                ),
                              ),
                              child: Image(
                                image: NetworkImage(orderModel.orderImage),
                                // carouselController: caroController,
                                height: MediaQuery.of(context).size.height / 3,
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(LocaleKeys.userAccountScreen_orderName.tr()+':'),
                                  Text(orderModel.orderName),
                                  const Spacer(),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                      left: 8.0,
                                      right: 8.0,
                                    ),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: ShopCubit.get(
                                            context)
                                            .ordersModel[
                                        index]
                                            .pState ==
                                            'Pending'
                                            ? Colors.orange
                                            : ShopCubit.get(context)
                                            .ordersModel[
                                        index]
                                            .pState ==
                                            'Scheduled'
                                            ? Colors.blue
                                            : ShopCubit.get(context)
                                            .ordersModel[
                                        index]
                                            .pState ==
                                            'Cancelled'
                                            ? Colors.red
                                            : ShopCubit.get(context)
                                            .ordersModel[
                                        index]
                                            .pState ==
                                            'Completed'
                                            ? Colors
                                            .green
                                            : Colors
                                            .orange,
                                        borderRadius:
                                        BorderRadius.circular(
                                          14.0,
                                        ),
                                      ),
                                      child: Padding(
                                        padding:
                                        const EdgeInsets.only(
                                            left: 8.0,
                                            right: 8.0,
                                            top: 4.0,
                                            bottom: 4.0),
                                        child: Center(
                                          child: Text(
                                            ShopCubit.get(context)
                                                .ordersModel[index]
                                                .pState,
                                            style: const TextStyle(
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Text(
                                    LocaleKeys.userAccountScreen_orderCost.tr()+':  ',
                                  ),
                                  Text(
                                    orderModel.orderedProductsCount.toString(),
                                  ),
                                ],
                              ),
                              orderModel.orderPromoDiscount.isEmpty
                                  ? Row(
                                    children: [
                                      Text(LocaleKeys.userAccountScreen_orderDiscount.tr()+':  '),
                                      const Text('No Discount'),
                                    ],
                                  )
                                  : Row(
                                      children: [
                                        Text(LocaleKeys.userAccountScreen_orderDiscount.tr()+':  '),
                                        Row(
                                          children: orderModel.orderPromoDiscount
                                              .map((e) =>
                                                  Text(e.toString() + '% , '))
                                              .toList(),
                                        )
                                      ],
                                    ),
                              Row(
                                children: [
                                  Text(LocaleKeys.userAccountScreen_orderSize.tr()+':  '),
                                  Text(orderModel.orderSize.toString()),
                                ],
                              ),
                              Row(
                                children: [
                                  Text(LocaleKeys.userAccountScreen_orderCost.tr()+':  '),
                                  Text(orderModel.orderCost.toString() + ' LE'),
                                ],
                              ),
                              orderModel.orderPromoDiscount.isNotEmpty
                                  ? Row(
                                      children: [
                                        Text(
                                          LocaleKeys.userAccountScreen_orderPromoCode.tr()+':  ',
                                        ),
                                        Row(
                                          children: orderModel.orderPromo
                                              .map((e) =>
                                                  Text(e.toString() + ' , '))
                                              .toList(),
                                        ),
                                      ],
                                    )
                                  : Row(
                                      children: [
                                        Text(
                                          LocaleKeys.userAccountScreen_orderPromoCode.tr()+':  ',
                                        ),
                                        const Text('No promo'),
                                      ],
                                    ),
                              Row(
                                children: [
                                  Text(
                                    LocaleKeys.userAccountScreen_orderCustomer.tr()+':  ',
                                  ),
                                  Text(orderModel.firstName),
                                ],
                              ),
                              Row(
                                children: [
                                  Text(
                                    LocaleKeys.userAccountScreen_orderAddress.tr()+':  ',
                                  ),
                                  Text(
                                    orderModel.address,
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Text(
                                    LocaleKeys.userAccountScreen_orderPhone.tr()+':  ',
                                  ),
                                  Text(
                                    orderModel.phoneNumber,
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                   Text(
                                     LocaleKeys.userAccountScreen_orderOtherPhone.tr()+':  ',
                                  ),
                                  Text(
                                    orderModel.otherPhoneNumber,
                                  ),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Flex(
                                    direction: Axis.horizontal,
                                    children: [
                                      Expanded(
                                        child: Container(
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                                width: 2.0, color: Colors.black),
                                            borderRadius:
                                                BorderRadius.circular(20.0),
                                          ),
                                          height: 80.0,
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(
                                              orderModel.orderComment == ''
                                                  ? LocaleKeys.userAccountScreen_orderNoComment.tr()
                                                  : orderModel.orderComment,
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  buildDiscount(List list) {
    for (var element in list) {
      Text((element.toString()));
    }
  }
}
