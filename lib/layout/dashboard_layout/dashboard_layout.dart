import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../shared/network/local/cache_helper.dart';
import 'cubit/cubit.dart';
import 'cubit/states.dart';

class DashboardLayout extends StatefulWidget {
  const DashboardLayout({Key key}) : super(key: key);

  @override
  State<DashboardLayout> createState() => _DashboardLayoutState();
}

class _DashboardLayoutState extends State<DashboardLayout> {
  @override
  void initState() {
    DashboardCubit.get(context).userLogin(
        context: context,
        email: CacheHelper.getData(key: 'user'),
        password: CacheHelper.getData(key: 'pass'));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<DashboardCubit, DashboardStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = DashboardCubit.get(context);

        return FutureBuilder(builder: (context, snapshot) {
          return Scaffold(
            // appBar: AppBar(),
            resizeToAvoidBottomInset: false,
            // floatingActionButton: Column(
            //   mainAxisAlignment: MainAxisAlignment.end,
            //     children: [
            //   FloatingActionButton(
            //     onPressed: () {
            //       DashboardCubit.get(context).getAllProducts();
            //       DashboardCubit.get(context).getAllOrdered();
            //     },
            //     backgroundColor: defaultColor,
            //     child: const Icon(Icons.mic),
            //   ),
            //   FloatingActionButton(
            //     onPressed: () {
            //       navigateTo(context, CreateProductScreen());
            //     },
            //     backgroundColor: defaultColor,
            //     child: const Icon(Icons.add),
            //   ),
            // ]),
            body: cubit.bottomScreens[cubit.currentIndex],
            bottomNavigationBar: BottomNavigationBar(
              backgroundColor: Colors.black,
              showSelectedLabels: false,
              showUnselectedLabels: false,
              selectedItemColor: Colors.white,
              onTap: (index) {
                cubit.changeBottom(index);
              },
              currentIndex: cubit.currentIndex,
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.dashboard,
                  ),
                  label: 'dashboard',
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.local_offer,
                  ),
                  label: 'sale',
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.person,
                  ),
                  label: 'profile',
                ),
              ],
            ),
          );
        });
      },
    );
  }
}
