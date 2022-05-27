import 'package:egyoutfit/modules/user/profile/user_order_screen_opened.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../layout/shop_app/cubit/cubit.dart';
import '../../../layout/shop_app/cubit/states.dart';
import '../../../shared/components/components.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({Key key}) : super(key: key);

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  @override
  void initState() {
    ShopCubit.get(context).getOrders();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var formKey = GlobalKey<FormState>();
    var searchController = TextEditingController();

    return BlocConsumer<ShopCubit, ShopStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.arrow_back_ios)),
          ),
          body: Form(
            key: formKey,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  // if (state is SearchLoadingState)
                  //   const LinearProgressIndicator(),
                  // const SizedBox(
                  //   height: 10.0,
                  // ),
                  // if (state is SearchSuccessState)
                  Expanded(
                    child: ListView.separated(
                      itemBuilder: (context, index) => InkWell(
                        onTap: () {
                          navigateTo(
                              context,
                              UserOpenedOrderScreen(
                                index: index,
                                orderModel:
                                    ShopCubit.get(context).ordersModel[index],
                              ));
                        },
                        child: SizedBox(
                            height: 180.0,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      color: Colors.black, width: 2.0),
                                  borderRadius: BorderRadius.circular(14.0),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    children: [
                                      Image(
                                        image: NetworkImage(
                                          ShopCubit.get(context)
                                              .ordersModel[index]
                                              .orderImage,
                                        ),
                                        width: 120.0,
                                        height: 120.0,
                                      ),
                                      const SizedBox(
                                        width: 15.0,
                                      ),
                                      Container(
                                        width: 1.5,
                                        height: 100.0,
                                        color: Colors.black,
                                      ),
                                      const SizedBox(
                                        width: 15.0,
                                      ),
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const SizedBox(
                                            height: 5.0,
                                          ),
                                          Text(
                                            'Name: ' +
                                                ShopCubit.get(context)
                                                    .ordersModel[index]
                                                    .orderName,
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 1,
                                          ),
                                          const SizedBox(
                                            height: 5.0,
                                          ),
                                          Text(
                                            'Cost: ' +
                                                ShopCubit.get(context)
                                                    .ordersModel[index]
                                                    .orderCost
                                                    .toString(),
                                          ),
                                          const SizedBox(
                                            height: 5.0,
                                          ),
                                          Text(
                                            'Count: ' +
                                                ShopCubit.get(context)
                                                    .ordersModel[index]
                                                    .orderedProductsCount
                                                    .toString(),
                                          ),
                                          const SizedBox(
                                            height: 5.0,
                                          ),
                                          Text(
                                            'Size: ' +
                                                ShopCubit.get(context)
                                                    .ordersModel[index]
                                                    .orderSize,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            )),
                      ),
                      separatorBuilder: (context, index) => myDivider(),
                      itemCount: ShopCubit.get(context).ordersModel.length,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
