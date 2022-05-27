import 'package:egyoutfit/modules/service_provider/profile_screen/seller_profile_screen.dart';
import 'package:flutter/material.dart';
import '../../../layout/dashboard_layout/cubit/cubit.dart';
import '../../../shared/components/components.dart';
import 'seller_promo_codes_screen.dart';

class SellerSettingScreen extends StatelessWidget {
  const SellerSettingScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var model = DashboardCubit.get(context).loginModel;
    DashboardCubit.get(context).image=null;
    return SafeArea(
      child: Column(
        children: [
          Container(
            height: 150,
            color: Colors.black,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.only(left: 10.0),
                    child: Text(
                      'Account',
                      style: Theme.of(context).textTheme.headline3?.copyWith(
                            color: Colors.white,
                            fontSize: 27,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                  ),
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 20.0,
                        backgroundImage: NetworkImage(model.image),
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Welcome ${model.firstName}!',
                            style: Theme.of(context)
                                .textTheme
                                .headline5
                                ?.copyWith(
                                    color: Colors.orange,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 17),
                          ),
                          Text(
                            model.email,
                            style:
                                Theme.of(context).textTheme.headline5?.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w300,
                                      fontSize: 15,
                                    ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  )
                ],
              ),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 50.0,
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Text(
                        'MY ACCOUNT',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[800],
                        ),
                      ),
                    ),
                  ),
                  Container(
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          InkWell(
                            onTap: () {
                              navigateTo(
                                context,
                                const PromoCodesScreen(),
                              );
                            },
                            child: Container(
                              height: 30,
                              alignment: AlignmentDirectional.centerStart,
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.local_offer_outlined,
                                  ),
                                  const SizedBox(
                                    width: 8,
                                  ),
                                  const Text(
                                    'Promo-codes',
                                    style: TextStyle(fontSize: 16),
                                  ),
                                  const Spacer(),
                                  IconButton(
                                    icon: const Icon(
                                      Icons.navigate_next,
                                    ),
                                    onPressed: () {},
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          InkWell(
                            onTap: () {
                              navigateTo(context, SellerProfileScreen(logModel: DashboardCubit.get(context).loginModel,));
                            },
                            child: Container(
                              height: 30,
                              alignment: AlignmentDirectional.centerStart,
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.settings,
                                  ),
                                  const SizedBox(
                                    width: 8,
                                  ),
                                  const Text(
                                    'Settings',
                                    style: TextStyle(fontSize: 16),
                                  ),
                                  const Spacer(),
                                  IconButton(
                                    icon: const Icon(
                                      Icons.navigate_next,
                                    ),
                                    onPressed: () {},
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          InkWell(
                            onTap: () {},
                            child: Container(
                              height: 30,
                              alignment: AlignmentDirectional.centerStart,
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.production_quantity_limits_rounded,
                                  ),
                                  const SizedBox(
                                    width: 8,
                                  ),
                                  const Text(
                                    'Language',
                                    style: TextStyle(fontSize: 16),
                                  ),
                                  const Spacer(),
                                  IconButton(
                                    icon: const Icon(
                                      Icons.navigate_next,
                                    ),
                                    onPressed: () {},
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          InkWell(
                            onTap: () {},
                            child: Container(
                              height: 30,
                              alignment: AlignmentDirectional.centerStart,
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.contact_support_outlined,
                                  ),
                                  const SizedBox(
                                    width: 8,
                                  ),
                                  const Text(
                                    'Contact-US',
                                    style: TextStyle(fontSize: 16),
                                  ),
                                  const Spacer(),
                                  IconButton(
                                    icon: const Icon(
                                      Icons.navigate_next,
                                    ),
                                    onPressed: () {},
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: defaultButton(
              height: 60.0,
              width: MediaQuery.of(context).size.width - 30.0,
              radius: 14.0,
              function: () {
                DashboardCubit.get(context).currentIndex = 0;
                DashboardCubit.get(context).signOut(context);
              },
              text: 'Logout',
            ),
          ),
        ],
      ),
    );
  }
}
