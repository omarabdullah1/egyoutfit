import 'package:conditional_builder/conditional_builder.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:egyoutfit/layout/shop_app/cubit/states.dart';
import 'package:egyoutfit/modules/user/profile/user_orders_screen.dart';
import 'package:egyoutfit/shared/network/local/cache_helper.dart';
import 'package:egyoutfit/translations/locale_keys.g.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:showcaseview/showcaseview.dart';

import '../../../layout/shop_app/cubit/cubit.dart';
import '../../../shared/components/components.dart';
import 'change_password_screen.dart';
import 'user_settings_screen.dart';

var one = GlobalKey();

class UserProfile extends StatelessWidget {
  const UserProfile({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var model = ShopCubit.get(context).loginModel;
    return BlocConsumer<ShopCubit, ShopStates>(
      listener: (context, state) async {
        if (ShopCubit.get(context).isEnglish) {
          await context.setLocale(const Locale('en'));
        } else {
          await context.setLocale(const Locale('ar'));
        }
      },
      builder: (context, state) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (CacheHelper.getData(key: 'showCase') == null ||
              CacheHelper.getData(key: 'showCase') == false) {
            ShowCaseWidget.of(context).startShowCase([one]);
          }
        });

        return ConditionalBuilder(
          condition: model.firstName != null,
          builder: (context) => SafeArea(
            child: Container(
              color: Colors.white,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10.0, vertical: 8),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                LocaleKeys.userAccountScreen_account.tr(),
                                // 'Account',
                                style: const TextStyle(
                                    color: Colors.black, fontSize: 30),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 10.0,
                          ),
                          Text(
                            LocaleKeys.userAccountScreen_welcome.tr() +
                                ' ' +
                                (model.firstName ?? '') +
                                '!',
                            style: const TextStyle(
                                color: Colors.orange, fontSize: 20),
                          ),
                          Text(
                            model.email ?? '',
                            style: const TextStyle(
                                color: Colors.black, fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    color: Colors.grey[400],
                    // height: 30,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10.0, vertical: 8),
                      child: Row(
                        children: [
                          Text(
                            LocaleKeys.userAccountScreen_myEgyOutFitStoreAccount
                                .tr(),
                            style: const TextStyle(color: Colors.black54),
                          )
                        ],
                      ),
                    ),
                  ),
                  (CacheHelper.getData(key: 'showCase') == null ||
                          CacheHelper.getData(key: 'showCase') == false)
                      ? Showcase(
                          key: one,
                          description: LocaleKeys.alerts_openOrdersToSee.tr(),
                          disposeOnTap: true,
                          onTargetClick: () {
                            CacheHelper.putBoolean(
                                key: 'showCase', value: true);
                          },
                          onToolTipClick: () {
                            CacheHelper.putBoolean(
                                key: 'showCase', value: true);
                          },
                          animationDuration: const Duration(milliseconds: 500),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10.0, vertical: 8),
                            child: Column(
                              children: [
                                InkWell(
                                  onTap: () {
                                    navigateTo(context, const OrdersScreen());
                                  },
                                  child: Row(
                                    children: [
                                      const Icon(
                                        Icons.shop,
                                        color: Colors.black,
                                      ),
                                      const SizedBox(
                                        width: 15,
                                      ),
                                      Text(
                                        LocaleKeys.userAccountScreen_orders
                                            .tr(),
                                        style: const TextStyle(
                                            color: Colors.black),
                                      ),
                                      const Spacer(),
                                      const Icon(
                                        Icons.navigate_next,
                                        color: Colors.black,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      : Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10.0, vertical: 8),
                          child: Column(
                            children: [
                              InkWell(
                                onTap: () {
                                  navigateTo(context, const OrdersScreen());
                                },
                                child: Row(
                                  children: [
                                    const Icon(
                                      Icons.shop,
                                      color: Colors.black,
                                    ),
                                    const SizedBox(
                                      width: 15,
                                    ),
                                    Text(
                                      LocaleKeys.userAccountScreen_orders.tr(),
                                      style:
                                          const TextStyle(color: Colors.black),
                                    ),
                                    const Spacer(),
                                    const Icon(
                                      Icons.navigate_next,
                                      color: Colors.black,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                  Container(
                    color: Colors.grey[400],
                    // height: 30,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10.0, vertical: 8),
                      child: Row(
                        children: [
                          Text(
                            LocaleKeys.userAccountScreen_mySettings.tr(),
                            style: const TextStyle(color: Colors.black54),
                          )
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10.0, vertical: 8),
                    child: Column(
                      children: [
                        InkWell(
                          onTap: () {
                            navigateTo(context, const SettingsScreen());
                          },
                          child: Row(
                            children: [
                              Text(
                                LocaleKeys.userAccountScreen_details.tr(),
                                style: const TextStyle(color: Colors.black),
                              ),
                              const Spacer(),
                              const Icon(
                                Icons.navigate_next,
                                color: Colors.black,
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: myDivider(),
                        ),
                        InkWell(
                          onTap: () {
                            navigateTo(context, const ChangePasswordScreen());
                          },
                          child: Row(
                            children: [
                              Text(
                                LocaleKeys.userAccountScreen_changePassword
                                    .tr(),
                                style: const TextStyle(color: Colors.black),
                              ),
                              const Spacer(),
                              const Icon(
                                Icons.navigate_next,
                                color: Colors.black,
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: myDivider(),
                        ),
                        Row(
                          children: [
                            Text(
                              LocaleKeys.userAccountScreen_changeLanguage.tr(),
                              style: const TextStyle(color: Colors.black),
                            ),
                            const Spacer(),
                            Switch(
                              value: ShopCubit.get(context).isEnglish,
                              onChanged: (v) {
                                ShopCubit.get(context)
                                    .changeLanguageValue(v, context);
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const Expanded(
                      child: SizedBox(
                    height: 1,
                  )),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: defaultButton(
                      height: 60.0,
                      width: MediaQuery.of(context).size.width - 30.0,
                      radius: 14.0,
                      function: () {
                        ShopCubit.get(context).signOut(context);
                      },
                      text: LocaleKeys.userAccountScreen_logout.tr(),
                    ),
                  ),
                ],
              ),
            ),
          ),
          fallback: (context) => const Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }
}
