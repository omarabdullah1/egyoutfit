
import 'package:egyoutfit/layout/shop_app/cubit/cubit.dart';
import 'package:egyoutfit/layout/shop_app/cubit/states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../models/orders/orders_model.dart';
import '../../../shared/components/components.dart';

class UserOpenedOrderScreen extends StatelessWidget {
  const UserOpenedOrderScreen(
      {Key key,
        this.orderModel,
        this.index,
        })
      : super(key: key);
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
              title: const Text('Order'),
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
                                      width: 2.0, color: Colors.black)),
                              child: Image(
                                image: NetworkImage(orderModel.orderImage),
                                // carouselController: caroController,
                              ),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Text('Product Name: '),
                                Text(orderModel.orderName),
                              ],
                            ),
                            Row(
                              children: [
                                const Text(
                                  'Pieces: ',
                                ),
                                Text(
                                  orderModel.orderedProductsCount
                                      .toString(),
                                ),
                              ],
                            ),
                            orderModel.orderPromoDiscount.isEmpty
                                ? const Text('Discount: No Discount')
                                : Row(
                              children: [
                                const Text('Discount: '),
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
                                const Text('Size: '),
                                Text(orderModel.orderSize.toString()),
                              ],
                            ),
                            Row(
                              children: [
                                const Text('Price: '),
                                Text(orderModel.orderCost.toString() +
                                    ' LE'),
                              ],
                            ),
                            orderModel.orderPromoDiscount.isNotEmpty
                                ? Row(
                              children: [
                                const Text(
                                  'Promo Code: ',
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
                              children: const [
                                Text(
                                  'Promo Code: ',
                                ),
                                Text('No promo'),
                              ],
                            ),
                            Row(
                              children: [
                                const Text(
                                  'Customer: ',
                                ),
                                Text(orderModel.firstName),
                              ],
                            ),
                            Row(
                              children: [
                                const Text(
                                  'Address: ',
                                ),
                                Text(
                                  orderModel.address,
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                const Text(
                                  'Phone: ',
                                ),
                                Text(
                                  orderModel.phoneNumber,
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                const Text(
                                  'Other Phone: ',
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
                                                ? 'No Comment'
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

  Widget buildDiscount(List list) {
    for (var element in list) {
      Text((element.toString()));
    }
  }
}
