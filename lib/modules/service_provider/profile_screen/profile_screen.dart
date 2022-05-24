import 'package:flutter/material.dart';

import '../../../layout/dashboard_layout/cubit/cubit.dart';
import '../../../shared/components/components.dart';
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    var model = DashboardCubit
        .get(context)
        .loginModel;
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
                            style: Theme
                                .of(context)
                                .textTheme
                                .headline3
                                ?.copyWith(
                                color: Colors.white,
                                fontSize: 27,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                        Row(
                          children: [
                            const CircleAvatar(
                              radius: 20.0,
                              child:  Icon(Icons.person),
                            ),
                            const SizedBox(
                              width: 8,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Welcome ${model.firstName}!',
                                  style: Theme
                                      .of(context)
                                      .textTheme
                                      .headline5
                                      ?.copyWith(
                                      color: Colors.orange,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 17),
                                ),
                                Text(
                                  model.email,
                                  style: Theme
                                      .of(context)
                                      .textTheme
                                      .headline5
                                      ?.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w300,
                                      fontSize: 15),
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
                                  onTap: () {},
                                  child: Container(
                                    height: 30,
                                    alignment: AlignmentDirectional.centerStart,
                                    child: Row(
                                      children: [
                                        const Icon(Icons
                                            .production_quantity_limits_rounded),
                                        const SizedBox(
                                          width: 8,
                                        ),
                                        const Text(
                                          'Products',
                                          style: TextStyle(fontSize: 16),
                                        ),
                                        const Spacer(),
                                        IconButton(
                                          icon: const Icon(Icons.navigate_next),
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
                                        const Icon(Icons.local_offer_outlined),
                                        const SizedBox(
                                          width: 8,
                                        ),
                                        const Text(
                                          'Promo-codes',
                                          style: TextStyle(fontSize: 16),
                                        ),
                                        const Spacer(),
                                        IconButton(
                                          icon: const Icon(Icons.navigate_next),
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
                                        const Icon(Icons.settings),
                                        const SizedBox(
                                          width: 8,
                                        ),
                                        const Text(
                                          'Settings',
                                          style: TextStyle(fontSize: 16),
                                        ),
                                        const Spacer(),
                                        IconButton(
                                          icon: const Icon(Icons.navigate_next),
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
                                        const Icon(Icons
                                            .production_quantity_limits_rounded),
                                        const SizedBox(
                                          width: 8,
                                        ),
                                        const Text(
                                          'Language',
                                          style: TextStyle(fontSize: 16),
                                        ),
                                        const Spacer(),
                                        IconButton(
                                          icon: const Icon(Icons.navigate_next),
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
                                        const Icon(Icons.local_offer_outlined),
                                        const SizedBox(
                                          width: 8,
                                        ),
                                        const Text(
                                          'Contact-US',
                                          style: TextStyle(fontSize: 16),
                                        ),
                                        const Spacer(),
                                        IconButton(
                                          icon: const Icon(Icons.navigate_next),
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
                // defaultButton(function: () {
                //   log(DashboardCubit.get(context).loginModel.firstName.toString());
                // }, text: 'print', height: 50.0),
                defaultButton(
                    function: () {
                      DashboardCubit.get(context).currentIndex =0;
                      DashboardCubit.get(context).signOut(context);
                    },
                    text: 'LOGOUT',
                    height: 50.0),
              ],
            ),
          );
  }
}
