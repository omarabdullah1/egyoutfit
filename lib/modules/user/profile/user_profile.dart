import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';

import '../../../layout/shop_app/cubit/cubit.dart';
import '../../../shared/components/components.dart';
import '../settings/settings_screen.dart';

class UserProfile extends StatelessWidget {
   const UserProfile({Key key}) : super(key: key);



  @override
  Widget build(BuildContext context) {
    var model = ShopCubit.get(context).loginModel;

    return ConditionalBuilder(
      condition: model.firstName!=null,
      builder: (context)=>SafeArea(
        child:  Container(
          color: Colors.white,
          child: Column(
            children: [
              Padding(
                padding:
                const EdgeInsets.symmetric(horizontal: 10.0, vertical: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: const [
                        Text(
                          'Account',
                          style: TextStyle(color: Colors.black, fontSize: 30),
                        ),
                        Spacer(),
                        Icon(
                          Icons.search,
                          color: Colors.black,
                        ),
                        SizedBox(
                          width: 15.0,
                        ),
                        Icon(
                          Icons.shopping_cart,
                          color: Colors.black,
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    Text(
                      'Welcome ${model.firstName??''} !',
                      style: const TextStyle(color: Colors.orange, fontSize: 20),
                    ),
                    Text(
                      model.email??'',
                      style: const TextStyle(color: Colors.black, fontSize: 16),
                    ),
                  ],
                ),
              ),
              Container(
                color: Colors.grey[400],
                // height: 30,
                child: Padding(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 10.0, vertical: 8),
                  child: Row(
                    children: const [
                      Text(
                        'My EgyOutFit Store Account',
                        style: TextStyle(color: Colors.black54),
                      )
                    ],
                  ),
                ),
              ),
              Padding(
                padding:
                const EdgeInsets.symmetric(horizontal: 10.0, vertical: 8),
                child: Column(
                  children: [
                    Row(
                      children: const [
                        Icon(
                          Icons.shop,
                          color: Colors.black,
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        Text(
                          'Orders',
                          style: TextStyle(color: Colors.black),
                        ),
                        Spacer(),
                        Icon(
                          Icons.navigate_next,
                          color: Colors.black,
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: myDivider(),
                    ),
                    Row(
                      children: const [
                        Icon(
                          Icons.saved_search,
                          color: Colors.black,
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        Text(
                          'Recently Searched',
                          style: TextStyle(color: Colors.black),
                        ),
                        Spacer(),
                        Icon(
                          Icons.navigate_next,
                          color: Colors.black,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                color: Colors.grey[400],
                // height: 30,
                child: Padding(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 10.0, vertical: 8),
                  child: Row(
                    children: const [
                      Text(
                        'My Settings',
                        style: TextStyle(color: Colors.black54),
                      )
                    ],
                  ),
                ),
              ),
              Padding(
                padding:
                const EdgeInsets.symmetric(horizontal: 10.0, vertical: 8),
                child: Column(
                  children: [
                    GestureDetector
                      (onTap: (){
                      navigateTo(context, const SettingsScreen());
                    },
                      child: Row(
                        children: const [
                          Text(
                            'Details',
                            style: TextStyle(color: Colors.black),
                          ),
                          Spacer(),
                          Icon(
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
                      children: const [
                        Text(
                          'Address book',
                          style: TextStyle(color: Colors.black),
                        ),
                        Spacer(),
                        Icon(
                          Icons.navigate_next,
                          color: Colors.black,
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: myDivider(),
                    ),
                    Row(
                      children: const [
                        Text(
                          'Change Password',
                          style: TextStyle(color: Colors.black),
                        ),
                        Spacer(),
                        Icon(
                          Icons.navigate_next,
                          color: Colors.black,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const Expanded(child: SizedBox(height: 1,)),
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: defaultButton(
                  height: 60.0,
                  width: MediaQuery.of(context).size.width-30.0,
                  radius: 14.0,
                  function: () {
                    ShopCubit.get(context).signOut(context);
                  },
                  text: 'Logout',
                ),
              ),
            ],
          ),
        ),
      ),
      fallback: (context)=>const Center(child: CircularProgressIndicator(),),
    );
  }
}
