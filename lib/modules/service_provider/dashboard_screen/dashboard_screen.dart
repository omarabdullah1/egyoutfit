import 'dart:async';
import 'package:easy_localization/easy_localization.dart';
import 'package:egyoutfit/modules/service_provider/create_product/create_product1.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../layout/dashboard_layout/cubit/cubit.dart';
import '../../../layout/dashboard_layout/cubit/states.dart';
import '../../../shared/components/components.dart';
import '../../../shared/styles/colors.dart';
import '../../../translations/locale_keys.g.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  void initState() {
    DashboardCubit.get(context).getAllProducts();
    Timer(const Duration(milliseconds: 500), () {
      DashboardCubit.get(context).getAllOrdered(context);
      DashboardCubit.get(context).getPromoCodes();
      DashboardCubit.get(context).changeDropButtonValue(
        EasyLocalization.of(context).locale.languageCode == 'en'
            ? DashboardCubit.get(context).lastDropDownValueEn
            : DashboardCubit.get(context).lastDropDownValueAr,
        context,
      );
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    // var height = MediaQuery.of(context).size.height;
    return BlocConsumer<DashboardCubit, DashboardStates>(
        listener: (context, states) {},
        builder: (context, state) {
          return DefaultTabController(
            initialIndex: 0,
            length: 2,
            child: Scaffold(
              appBar: AppBar(
                actions: [
                  IconButton(
                    onPressed: () async {
                      await DashboardCubit.get(context).getAllProducts();
                      await DashboardCubit.get(context).getAllOrdered(context);
                    },
                    icon: const Icon(Icons.refresh),
                  )
                ],
              ),
              floatingActionButton: FloatingActionButton(
                heroTag: 'uniqueTag',
                onPressed: () {
                  navigateTo(context, const CreateProductScreen());
                },
                child: const Icon(Icons.add),
                backgroundColor: Colors.black,
              ),
              body: RefreshIndicator(
                onRefresh: () {
                  DashboardCubit.get(context).getAllProducts();
                  DashboardCubit.get(context).getAllOrdered(context);
                  DashboardCubit.get(context).getPromoCodes();
                  return;
                },
                child: Column(
                  children: [
                    TabBar(
                      labelColor: Colors.black,
                      indicatorColor: defaultColor,
                      tabs: [
                        Tab(
                          text: LocaleKeys.dashboardScreen_allProducts.tr(),
                        ),
                        Tab(
                          text: LocaleKeys.dashboardScreen_requests.tr(),
                        ),
                      ],
                    ),
                    Expanded(
                      child: TabBarView(
                        children: [
                          BuildAllProducts(
                            screenWidth: width,
                            model: DashboardCubit.get(context).products,
                            modelIDList: DashboardCubit.get(context).productsID,
                          ),
                          buildRequests(
                              context: context,
                              width: width,
                              ordersModel:
                                  DashboardCubit.get(context).requestOrderModel,
                              model: DashboardCubit.get(context).requestModel,
                              countList: DashboardCubit.get(context)
                                  .requestModelCountList,
                              id: DashboardCubit.get(context)
                                  .requestedOrderedProductsID),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }
}
