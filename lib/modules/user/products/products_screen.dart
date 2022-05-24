import 'dart:developer';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../layout/shop_app/cubit/cubit.dart';
import '../../../layout/shop_app/cubit/states.dart';
import '../../../shared/components/components.dart';
import '../home_selected_product/selected_prodct.dart';

class ProductsScreen extends StatelessWidget {
  const ProductsScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopCubit, ShopStates>(
      listener: (context, state) {
        // if (state is ShopSuccessChangeFavoritesState) {
        //   if (!state.model.status) {
        //     showToast(
        //       text: state.model.message,
        //       state: ToastStates.ERROR,
        //     );
        //   }
        // }
        if (state is ShopLoginSuccessState) {
          log(state.loginModel.firstName);
        }
      },
      builder: (context, state) {
        return ConditionalBuilder(
          condition: ShopCubit.get(context).products != null &&
              ShopCubit.get(context).menCategory != null &&
              ShopCubit.get(context).womenCategory != null &&
              ShopCubit.get(context).childrenCategory != null &&
              ShopCubit.get(context).sportCategory != null &&
              ShopCubit.get(context).shoeCategory != null &&
              ShopCubit.get(context).bagCategory != null &&
              ShopCubit.get(context).accessoriesCategory != null &&
              ShopCubit.get(context).offers != null,
          builder: (context) => builderWidget(context),
          fallback: (context) => const Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }

  Widget builderWidget(context) => RefreshIndicator(
        onRefresh: () {
          return Future.delayed(const Duration(seconds: 2), () {
            ShopCubit.get(context).getAllProducts();
            ShopCubit.get(context).getFavourite();
            ShopCubit.get(context).getCart();
            ShopCubit.get(context).getPromoCodes();
            ShopCubit.get(context).getProducts('Men');
            ShopCubit.get(context).getProducts('Women');
            ShopCubit.get(context).getProducts('Children');
            ShopCubit.get(context).getProducts('Bags');
            ShopCubit.get(context).getProducts('Accessories');
            ShopCubit.get(context).getProducts('Shoe');
            ShopCubit.get(context).getProducts('Sports');
          });
        },
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CarouselSlider(
                items: ShopCubit.get(context)
                    .offers
                    .map((e) => Image(
                          image: NetworkImage(e),
                        ))
                    .toList(),
                options: CarouselOptions(
                  height: 200,
                  viewportFraction: 1.0,
                  enlargeCenterPage: false,
                  initialPage: 0,
                  enableInfiniteScroll: true,
                  reverse: false,
                  autoPlay: true,
                  autoPlayInterval: const Duration(seconds: 3),
                  autoPlayAnimationDuration: const Duration(seconds: 1),
                  autoPlayCurve: Curves.fastOutSlowIn,
                  scrollDirection: Axis.horizontal,
                ),
              ),
              const SizedBox(
                height: 10.0,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10.0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 20.0,
                    ),
                    const SizedBox(
                      height: 15.0,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                flex: 21,
                                child: categoryButton(
                                  text: 'Men\'s',
                                  iconPath: 'assets/images/mens.png',
                                  color: Colors.deepOrangeAccent,
                                  context: context,
                                  mmodel: ShopCubit.get(context).menCategory,
                                  mmodelID: ShopCubit.get(context).menCategoryID,
                                  name: 'Men\'s',
                                  // width: 28.0,
                                ),
                              ),
                              const Spacer(),
                              Expanded(
                                flex: 21,
                                child: categoryButton(
                                  text: 'Women\'s',
                                  iconPath: 'assets/images/women.png',
                                  color: Colors.pink,
                                  context: context,
                                  mmodel: ShopCubit.get(context).womenCategory,
                                  mmodelID: ShopCubit.get(context).womenCategoryID,

                                  name: 'Women\'s',
                                  // width: 28.0,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Expanded(
                                flex: 21,
                                child: categoryButton(
                                  text: 'Shoes',
                                  iconPath: 'assets/images/shoes.png',
                                  color: Colors.deepPurple,
                                  context: context,
                                  mmodel: ShopCubit.get(context).shoeCategory,
                                  mmodelID: ShopCubit.get(context).shoeCategoryID,

                                  name: 'Shoes',
                                ),
                              ),
                              const Spacer(),
                              Expanded(
                                flex: 21,
                                child: categoryButton(
                                  text: 'Bags',
                                  iconPath: 'assets/images/bags.png',
                                  color: Colors.teal,
                                  context: context,
                                  mmodel: ShopCubit.get(context).bagCategory,
                                  mmodelID: ShopCubit.get(context).bagCategoryID,

                                  name: 'Bags',
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Expanded(
                                flex: 21,
                                child: categoryButton(
                                  color: Colors.green,
                                  text: 'Sports',
                                  iconPath: 'assets/images/sports.png',
                                  context: context,
                                  mmodel: ShopCubit.get(context).sportCategory,
                                  mmodelID: ShopCubit.get(context).sportCategoryID,

                                  name: 'Sports',
                                ),
                              ),
                              const Spacer(),
                              Expanded(
                                flex: 21,
                                child: categoryButton(
                                  text: 'Children',
                                  iconPath: 'assets/images/children.png',
                                  color: Colors.lightBlue,
                                  context: context,
                                  mmodel:
                                      ShopCubit.get(context).childrenCategory,
                                  mmodelID: ShopCubit.get(context).childrenCategoryID,

                                  name: 'Children',
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Expanded(
                                flex: 21,
                                child: categoryButton(
                                  text: 'Accessories',
                                  iconPath: 'assets/images/Accessories.png',
                                  color: Colors.red[900],
                                  context: context,
                                  mmodel: ShopCubit.get(context)
                                      .accessoriesCategory,
                                  mmodelID: ShopCubit.get(context).accessoriesCategoryID,

                                  name: 'Accessories',
                                ),
                              ),
                              const Spacer(),
                              const Expanded(
                                flex: 21,
                                child: SizedBox(),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 20.0,
                    ),
                    const Text(
                      'Recommended for you',
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  'Men\'s Fashion:',
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.w800,
                    color: Colors.grey,
                  ),
                ),
              ),
              const SizedBox(
                height: 10.0,
              ),
              SizedBox(
                height: 300.0,
                child: ListView.separated(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) => InkWell(
                    onTap: () {
                      navigateTo(
                          context,
                          HomeSelectedProductScreen(
                            productIndex: index,
                            mmodel: ShopCubit.get(context).menCategory[index],
                            mmodelID: ShopCubit.get(context).menCategoryID,
                            category: 'Men\'s',
                            color: Colors.deepOrangeAccent,
                          ),
                      );
                      // print(ShopCubit.get(context).menCategoryID);
                    },
                    child: buildRecommendedItem(
                      context: context,
                      index: index,
                      model: ShopCubit.get(context).menCategory,
                      idList: ShopCubit.get(context).menCategoryID,
                    ),
                  ),
                  separatorBuilder: (context, index) => const SizedBox(),
                  itemCount: ShopCubit.get(context).menCategory.length,
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  'Women\'s Fashion:',
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.w800,
                    color: Colors.grey,
                  ),
                ),
              ),
              const SizedBox(
                height: 20.0,
              ),
              SizedBox(
                height: 300.0,
                child: ListView.separated(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) => InkWell(
                    onTap: () {
                      navigateTo(
                          context,
                          HomeSelectedProductScreen(
                            productIndex: index,
                            mmodel: ShopCubit.get(context).womenCategory[index],
                            mmodelID: ShopCubit.get(context).womenCategoryID,
                            category: 'Women\'s',
                            color: Colors.pink,
                          ));
                    },
                    child: buildRecommendedItem(
                      context: context,
                      index: index,
                      model: ShopCubit.get(context).womenCategory,
                      idList: ShopCubit.get(context).womenCategoryID,
                    ),
                  ),
                  separatorBuilder: (context, index) => const SizedBox(),
                  itemCount: ShopCubit.get(context).womenCategory.length,
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  'Shoes Fashion:',
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.w800,
                    color: Colors.grey,
                  ),
                ),
              ),
              const SizedBox(
                height: 20.0,
              ),
              SizedBox(
                height: 300.0,
                child: ListView.separated(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) => InkWell(
                    onTap: () {
                      navigateTo(
                          context,
                          HomeSelectedProductScreen(
                            productIndex: index,
                            mmodel: ShopCubit.get(context).shoeCategory[index],
                            mmodelID: ShopCubit.get(context).shoeCategoryID,
                            category: 'Shoes',
                            color: Colors.deepPurple,
                          ));
                    },
                    child: buildRecommendedItem(
                      context: context,
                      index: index,
                      model: ShopCubit.get(context).shoeCategory,
                      idList: ShopCubit.get(context).shoeCategoryID,
                    ),
                  ),
                  separatorBuilder: (context, index) => const SizedBox(),
                  itemCount: ShopCubit.get(context).shoeCategory.length,
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  'Bags Fashion:',
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.w800,
                    color: Colors.grey,
                  ),
                ),
              ),
              const SizedBox(
                height: 20.0,
              ),
              SizedBox(
                height: 300.0,
                child: ListView.separated(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) => InkWell(
                    onTap: () {
                      navigateTo(
                          context,
                          HomeSelectedProductScreen(
                            productIndex: index,
                            mmodel: ShopCubit.get(context).bagCategory[index],
                            mmodelID: ShopCubit.get(context).bagCategoryID,
                            category: 'Bags',
                            color: Colors.teal,
                          ));
                    },
                    child: buildRecommendedItem(
                      context: context,
                      index: index,
                      model: ShopCubit.get(context).bagCategory,
                      idList: ShopCubit.get(context).bagCategoryID,
                    ),
                  ),
                  separatorBuilder: (context, index) => const SizedBox(),
                  itemCount: ShopCubit.get(context).bagCategory.length,
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  'Sporting Fashion:',
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.w800,
                    color: Colors.grey,
                  ),
                ),
              ),
              const SizedBox(
                height: 20.0,
              ),
              SizedBox(
                height: 300.0,
                child: ListView.separated(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) => InkWell(
                    onTap: () {
                      navigateTo(
                          context,
                          HomeSelectedProductScreen(
                            productIndex: index,
                            mmodel: ShopCubit.get(context).sportCategory[index],
                            mmodelID: ShopCubit.get(context).sportCategoryID,
                            category: 'Sporting',
                            color: Colors.green,
                          ));
                    },
                    child: buildRecommendedItem(
                      context: context,
                      index: index,
                      model: ShopCubit.get(context).sportCategory,
                      idList: ShopCubit.get(context).sportCategoryID,
                    ),
                  ),
                  separatorBuilder: (context, index) => const SizedBox(),
                  itemCount: ShopCubit.get(context).sportCategory.length,
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  'Children Fashion:',
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.w800,
                    color: Colors.grey,
                  ),
                ),
              ),
              const SizedBox(
                height: 20.0,
              ),
              SizedBox(
                height: 300.0,
                child: ListView.separated(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) => InkWell(
                    onTap: () {
                      navigateTo(
                          context,
                          HomeSelectedProductScreen(
                            productIndex: index,
                            mmodel:
                                ShopCubit.get(context).childrenCategory[index],
                            mmodelID: ShopCubit.get(context).childrenCategoryID,
                            category: 'Children',
                            color: Colors.lightBlue,
                          ));
                    },
                    child: buildRecommendedItem(
                      context: context,
                      index: index,
                      model: ShopCubit.get(context).childrenCategory,
                      idList: ShopCubit.get(context).childrenCategoryID,
                    ),
                  ),
                  separatorBuilder: (context, index) => const SizedBox(),
                  itemCount: ShopCubit.get(context).childrenCategory.length,
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  'Accessories Fashion:',
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.w800,
                    color: Colors.grey,
                  ),
                ),
              ),
              const SizedBox(
                height: 20.0,
              ),
              SizedBox(
                height: 300.0,
                child: ListView.separated(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) => InkWell(
                    onTap: () {
                      navigateTo(
                          context,
                          HomeSelectedProductScreen(
                            productIndex: index,
                            mmodel: ShopCubit.get(context)
                                .accessoriesCategory[index],
                            mmodelID: ShopCubit.get(context).accessoriesCategoryID,
                            category: 'Accessories',
                            color: Colors.red,
                          ));
                    },
                    child: buildRecommendedItem(
                      context: context,
                      index: index,
                      model: ShopCubit.get(context).accessoriesCategory,
                      idList: ShopCubit.get(context).accessoriesCategoryID,
                    ),
                  ),
                  separatorBuilder: (context, index) => const SizedBox(),
                  itemCount: ShopCubit.get(context).accessoriesCategory.length,
                ),
              ),
            ],
          ),
        ),
      );

//       text: model.name,
}
