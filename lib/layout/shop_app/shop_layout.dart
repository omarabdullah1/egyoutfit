import 'dart:developer';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:map_launcher/map_launcher.dart';
import '../../modules/user/search/search_screen.dart';
import '../../shared/components/components.dart';
import '../../shared/styles/icons.dart';
import '../../translations/locale_keys.g.dart';
import 'cubit/cubit.dart';
import 'cubit/states.dart';

class ShopLayout extends StatefulWidget {
  const ShopLayout({Key key}) : super(key: key);

  @override
  State<ShopLayout> createState() => _ShopLayoutState();
}

class _ShopLayoutState extends State<ShopLayout> {
  @override
  void initState() {
    ShopCubit.get(context).getData(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var widthQuarter = MediaQuery.of(context).size.width / 4;
    var width = MediaQuery.of(context).size.width;

    return BlocConsumer<ShopCubit, ShopStates>(
        listener: (context, state) {},
        builder: (context, state) {
          var cubit = ShopCubit.get(context);
          return Scaffold(
            appBar: AppBar(
              title: Image.asset(
                'assets/images/Egy-Outfit-Black.png',
              ),
              actions: [
                SizedBox(
                  child: GestureDetector(
                    onTap: () {
                      navigateTo(context, const SearchScreen());
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(
                          top: 10.0, bottom: 10.0, right: 10.0),
                      child: Container(
                        width: width - widthQuarter,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.search,
                              color: Colors.grey,
                            ),
                            Text(
                              LocaleKeys.usersHomeScreen_searchInEgyOutfit.tr(),
                              style: const TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
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
                  icon: Icon(Icons.home_filled),
                  label: 'Home',
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    MyCartIcon.myCart,
                  ),
                  label: 'cart',
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    MyOffersIcon.myOffers,
                  ),
                  label: 'cart',
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    MyHeartIcon.myHeart,
                  ),
                  label: 'Favorites',
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    MyPersonIcon.myPerson,
                  ),
                  label: 'Settings',
                ),
              ],
            ),
          );
        });
  }
}
