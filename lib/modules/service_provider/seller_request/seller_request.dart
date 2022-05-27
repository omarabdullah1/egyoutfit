import 'dart:developer';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../layout/dashboard_layout/cubit/cubit.dart';
import '../../../layout/dashboard_layout/cubit/states.dart';
import '../../../models/orders/orders_model.dart';
import '../../../models/shop_app/products_model.dart';
import '../../../shared/components/components.dart';

class SellerRequest extends StatelessWidget {
  const SellerRequest(
      {Key key,
      this.models,
      this.orderModel,
      this.state,
      this.index,
      this.id,
      this.dropValue})
      : super(key: key);
  final ShopProductsModel models;
  final OrdersModel orderModel;
  final String state;
  final int index;
  final String id;
  final String dropValue;

  @override
  Widget build(BuildContext context) {
    var descriptionController = TextEditingController();
    var priceController = TextEditingController();
    var oldPriceController = TextEditingController();
    var discountController = TextEditingController();
    var nameController = TextEditingController();
    descriptionController.text = models.description;
    nameController.text = models.name;
    priceController.text = models.price.toString();
    oldPriceController.text = models.oldPrice.toString();
    discountController.text = models.discount.toString();
    DashboardCubit.get(context).requestDropDownValue = state;
    DashboardCubit.get(context)
        .changeRequestDropButtonValue(state, id);
    log(id);
    log(dropValue);

    return SafeArea(
      child: BlocConsumer<DashboardCubit, DashboardStates>(
        listener: (context, state) {},
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Request'),
              leading: !DashboardCubit.get(context).stateChanged
                  ? IconButton(
                      onPressed: () {
                        DashboardCubit.get(context)
                            .changeDropButtonValue(dropValue);
                        DashboardCubit.get(context).lastDropDownValue =
                            dropValue;
                        Navigator.of(context).pop();
                      },
                      icon: const Icon(Icons.arrow_back_ios_outlined))
                  : IconButton(
                      onPressed: () {
                        DashboardCubit.get(context).changeState(
                          false,
                          state: state,
                        );
                      },
                      icon: const Icon(
                        Icons.close,
                        color: Colors.red,
                      ),
                    ),
              actions: [
                DashboardCubit.get(context).stateChanged
                    ? IconButton(
                        onPressed: () async {
                          await DashboardCubit.get(context).changeOrderState(
                            DashboardCubit.get(context).requestDropDownValue,
                            id,
                            dropValue,
                          );
                        },
                        icon: const Icon(
                          Icons.check,
                          color: Colors.green,
                        ))
                    : const SizedBox(),
              ],
            ),
            body: Column(
              children: [
                SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Row(
                                  children: [
                                    CircleAvatar(
                                      backgroundColor:
                                          DashboardCubit.get(context)
                                              .requesdtDropDownValueColor,
                                      radius: 5.0,
                                    ),
                                    const SizedBox(
                                      width: 5.0,
                                    ),
                                    Container(
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(15.0),
                                        shape: BoxShape.rectangle,
                                      ),
                                      child: DropdownButton(
                                        value: DashboardCubit.get(context)
                                            .requestDropDownValue,
                                        icon: const Icon(
                                            Icons.keyboard_arrow_down),
                                        items: [
                                          'Pending',
                                          'Scheduled',
                                          'Completed',
                                          'Cancelled',
                                        ].map((String items) {
                                          return DropdownMenuItem(
                                            value: items,
                                            child: Text(items),
                                          );
                                        }).toList(),
                                        onChanged: (newValue) {
                                          DashboardCubit.get(context)
                                              .changeRequestDropButtonValue(
                                            newValue,
                                            id,
                                          );
                                          DashboardCubit.get(context)
                                              .changeState(true);
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15.0),
                                  border: Border.all(
                                      width: 2.0, color: Colors.black)),
                              child: CarouselSlider(
                                items: models.image.isEmpty
                                    ? const [Icon(Icons.image)]
                                    : models.image
                                        .map((e) => Image.network(e))
                                        .toList(),
                                options: CarouselOptions(
                                  onPageChanged: (index, reason) {
                                    DashboardCubit.get(context)
                                        .changeProductCarousel(index);
                                  },
                                  aspectRatio: 1.0,
                                  height: 200,
                                  viewportFraction: 1.0,
                                  enlargeCenterPage: false,
                                  initialPage: 0,
                                  enableInfiniteScroll: true,
                                  reverse: false,
                                  autoPlay: false,
                                  autoPlayInterval: const Duration(seconds: 3),
                                  autoPlayAnimationDuration:
                                      const Duration(seconds: 1),
                                  autoPlayCurve: Curves.fastOutSlowIn,
                                  scrollDirection: Axis.horizontal,
                                ),
                                // carouselController: caroController,
                              ),
                            ),
                            DotsIndicator(
                              dotsCount: models.image.length,
                              position: DashboardCubit.get(context)
                                  .productCaroIndex
                                  .toDouble(),
                              decorator: DotsDecorator(
                                size: const Size.square(9.0),
                                activeSize: const Size(18.0, 9.0),
                                activeShape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5.0)),
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
                                Text(models.name),
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
                ),
                const Expanded(child: SizedBox()),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: defaultButton(
                    function: () {},
                    text: 'Send Message',
                    icon: Icons.email_outlined,
                    isIcon: true,
                    height: 50.0,
                    width: 300.0,
                    radius: 14.0,
                  ),
                ),
              ],
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