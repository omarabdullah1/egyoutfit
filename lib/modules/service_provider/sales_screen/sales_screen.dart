import 'package:egyoutfit/modules/service_provider/create_offer/create_offer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../layout/dashboard_layout/cubit/cubit.dart';
import '../../../layout/dashboard_layout/cubit/states.dart';
import '../../../shared/components/components.dart';
import '../create_offer/edit_offer.dart';

class SalesScreen extends StatefulWidget {
  const SalesScreen({Key key}) : super(key: key);

  @override
  State<SalesScreen> createState() => _SalesScreenState();
}

class _SalesScreenState extends State<SalesScreen> {
  @override
  void initState() {
    DashboardCubit.get(context).getAllOrdered();
    DashboardCubit.get(context).getOffers();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return BlocConsumer<DashboardCubit, DashboardStates>(
      listener: (context, state) {},
      builder: (context, state) {
        // return const Center(child: Text('offers'),);
        return Scaffold(
          // appBar: AppBar(
          //
          // ),
          floatingActionButton: FloatingActionButton(
              backgroundColor: Colors.black,
              onPressed: () {
                navigateTo(context, const CreateOfferScreen());
              },
              child: const Icon(Icons.local_offer_outlined)),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Expanded(
                    child: Text(
                      'My Promo Codes: ',
                      style: TextStyle(fontSize: 18.0),
                    ),
                  ),
                  Expanded(
                    flex: 9,
                    child: ListView.separated(
                      itemBuilder: (context, index) => Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: GestureDetector(
                            onTap: () {
                              navigateTo(
                                  context,
                                  EditOfferScreen(
                                    promo: DashboardCubit.get(context)
                                        .myPromoCodesList[index],
                                    discount: DashboardCubit.get(context)
                                        .myDiscountList[index],
                                    state: DashboardCubit.get(context)
                                        .myPromoCodesStateList[index],
                                    id: DashboardCubit.get(context)
                                        .allPromoCodesIDList[index],
                                  ));
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  width: width - 50.0,
                                  height: height / 8,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(14.0),
                                    border: Border.all(
                                        color: Colors.black54, width: 2.0),
                                  ),
                                  child: Center(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            const Text('Promo Code: '),
                                            Text(DashboardCubit.get(context)
                                                .myPromoCodesList[index]),
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            const Text('Discount: '),
                                            Text(DashboardCubit.get(context)
                                                    .myDiscountList[index]
                                                    .toString() +
                                                '%'),
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            const Text('State: '),
                                            Text(DashboardCubit.get(context)
                                                .myPromoCodesStateList[index]),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )),
                      separatorBuilder: (context, index) => myDivider(),
                      itemCount:
                          DashboardCubit.get(context).myPromoCodesList.length,
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
