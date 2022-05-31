import 'dart:developer';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:conditional_builder/conditional_builder.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../layout/shop_app/cubit/cubit.dart';
import '../../../layout/shop_app/cubit/states.dart';
import '../../../models/shop_app/products_model.dart';
import '../../../shared/components/components.dart';
import '../../../shared/styles/colors.dart';
import '../../../shared/styles/icons.dart';
import '../../../translations/locale_keys.g.dart';

class HomeSelectedProductScreen extends StatefulWidget {
  const HomeSelectedProductScreen(
      {Key key, this.productIndex, this.mmodel, this.mmodelID,this.category,this.color})
      : super(key: key);
  final ShopProductsModel mmodel;
  final List mmodelID;
  final int productIndex;
  final String category;
  final Color color;

  @override
  State<HomeSelectedProductScreen> createState() =>
      _HomeSelectedProductScreenState();
}

class _HomeSelectedProductScreenState extends State<HomeSelectedProductScreen> {
  @override
  void initState() {
    ShopCubit.get(context).isS = false;
    ShopCubit.get(context).isM = false;
    ShopCubit.get(context).isL = false;
    ShopCubit.get(context).isXL = false;
    ShopCubit.get(context).is2XL = false;
    ShopCubit.get(context).is3XL = false;
    ShopCubit.get(context).is4XL = false;
    ShopCubit.get(context).is5XL = false;
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopCubit, ShopStates>(
      listener: (context, state) {
        if (state is AddCartSuccessState) {
          showToast(
              text: LocaleKeys.alerts_productAddedToYourCart.tr(), state: ToastStates.success);
        } else if (state is UpdateCartSuccessState) {
          showToast(
              text:LocaleKeys.alerts_productAddedToYourCart.tr(), state: ToastStates.success);
        } else if (state is RemoveCartSuccessState) {
          showToast(
              text: 'Product removed from your cart', state: ToastStates.error);
        } else if (state is AddFavouritesSuccessState) {
          showToast(
              text: LocaleKeys.alerts_productAddedToYourFavourites.tr(),
              state: ToastStates.success);
        } else if (state is RemoveFavouritesSuccessState) {
          showToast(
              text: LocaleKeys.alerts_productRemovedFromYourFavourites.tr(),
              state: ToastStates.error);
        }
      },
      builder: (context, state) {
        return ConditionalBuilder(
          condition: ShopCubit.get(context).products != null,
          fallback: (context) => const Center(
            child: CircularProgressIndicator(),
          ),
          builder: (context) => Scaffold(
            backgroundColor: const Color(0xffF7F7F7),
            appBar: AppBar(
              leading: IconButton(
                onPressed: () {
                  ShopCubit.get(context).productCaroIndex = 0;
                  Navigator.pop(context);
                },
                icon: const Icon(
                  Icons.arrow_back_ios,
                  // size: 14.0,
                  color: Colors.black,
                ),
              ),
            ),
            body: builderWidget(context),
          ),
        );
      },
    );
  }

  Widget builderWidget(context) => Column(
        children: [
          Expanded(
            child: Container(
              alignment: AlignmentDirectional.topStart,
              child: Stack(
                alignment: AlignmentDirectional.center,
                children: [
                  GestureDetector(
                    child: CarouselSlider(
                      items: widget.mmodel.image.isEmpty
                          ? const [Icon(Icons.image)]
                          : widget.mmodel.image
                              .map((e) => Image.network(e))
                              .toList(),
                      options: CarouselOptions(
                        onPageChanged: (index, reason) {
                          ShopCubit.get(context).changeProductCarousel(index);
                        },
                        aspectRatio: 1.0,
                        height: 240,
                        viewportFraction: 1.0,
                        enlargeCenterPage: false,
                        initialPage: 0,
                        enableInfiniteScroll: true,
                        reverse: false,
                        autoPlay: false,
                        autoPlayInterval: const Duration(seconds: 3),
                        autoPlayAnimationDuration: const Duration(seconds: 1),
                        autoPlayCurve: Curves.fastOutSlowIn,
                        scrollDirection: Axis.horizontal,
                      ),
                      // carouselController: caroController,
                    ),
                    // Image(
                    //   image: NetworkImage(
                    //     widget.mmodel.image.first,
                    //   ),
                    //   // width: 500,
                    //   width: double.infinity,
                    // ),
                    onTap: () {
                      navigateTo(
                        context,
                        OpenImage(
                          mImage: widget.mmodel
                              .image[ShopCubit.get(context).productCaroIndex],
                        ),
                      );
                    },
                  ),
                  Positioned(
                    bottom: 0.0,
                    child: Row(
                      children: [
                        Row(
                          children: [
                            const SizedBox(
                              width: 15.0,
                            ),
                            if (widget.mmodel.discount != 0)
                              Container(
                                color: Colors.red,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 5.0,
                                ),
                                child: Text(
                                  LocaleKeys.usersHomeScreen_productDiscount.tr(),
                                  style: const TextStyle(
                                    fontSize: 14.0,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            SizedBox(
                              width: widget.mmodel.discount != 0
                                  ? MediaQuery.of(context).size.width - 180
                                  : MediaQuery.of(context).size.width - 150,
                            ),
                            IconButton(
                              onPressed: () {
                                // ShopCubit.get(context).changeFavorites(
                                // widget.mmodel.data.data[widget.productIndex].id);
                                // print(widget.mmodel.data.data[widget.productIndex].id);
                                ShopCubit.get(context).inFavorites(
                                    pid: widget.mmodelID[widget.productIndex]);
                                ShopCubit.get(context).getFavourite();
                                // ShopCubit.get(context).updateData();
                              },
                              icon: CircleAvatar(
                                radius: 15.0,
                                backgroundColor: ShopCubit.get(context)
                                        .favorites
                                        .contains(widget
                                            .mmodelID[widget.productIndex])
                                    ? Colors.black
                                    : Colors.grey,
                                child: const Icon(
                                  Icons.favorite_border,
                                  size: 14.0,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    bottom: 0.0,
                    child: DotsIndicator(
                      dotsCount: widget.mmodel.image.length,
                      position:
                          ShopCubit.get(context).productCaroIndex.toDouble(),
                      decorator: DotsDecorator(
                        size: const Size.square(9.0),
                        activeSize: const Size(18.0, 9.0),
                        activeShape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          flex: 3,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.mmodel.name,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 14.0,
                                  height: 1.3,
                                ),
                              ),
                              Row(
                                children: [
                                  Text(LocaleKeys.usersHomeScreen_productDelivery.tr()+':  '),
                                  Text(widget.mmodel.isShipping?widget.mmodel.shippingPrice.toString()+' LE':'Not Available'),
                                ],
                              ),
                              widget.mmodel.discount!=0?Text(
                                LocaleKeys.usersHomeScreen_productDiscount.tr()+':  '+widget.mmodel.discount.toString()+' %',
                                style: const TextStyle(
                                  fontSize: 16.0,
                                  color: defaultColor,
                                ),
                              ):const SizedBox(),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  color: widget.color,
                                  borderRadius:
                                  BorderRadius.circular(14.0),
                                ),
                                width: 100.0,
                                height: 30.0,
                                child: Center(
                                    child: Text(widget.category,
                                        style: const TextStyle(
                                          color: Colors.white,
                                        ))),
                              ),
                              Text(
                                '\$${widget.mmodel.price-((widget.mmodel.price/100)*widget.mmodel.discount)}',
                                style: const TextStyle(
                                  fontSize: 16.0,
                                  color: defaultColor,
                                ),
                              ),
                              widget.mmodel.discount != 0?
                              Text(
                                '\$${widget.mmodel.price}',
                                style: const TextStyle(
                                  fontSize: 16.0,
                                  color: Colors.grey,
                                  decoration: TextDecoration.lineThrough,
                                ),
                              ): const SizedBox(),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Text(
                      widget.mmodel.description,
                      style: const TextStyle(
                        fontSize: 16.0,
                        color: defaultColor,
                      ),
                    ),
                    const SizedBox(
                      height: 15.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        widget.mmodel.isS
                            ? GestureDetector(
                            child: buildSizeCircle(
                                size: 'S',
                                state: ShopCubit.get(context).isS),
                            onTap: () {
                              ShopCubit.get(context).changeSize('isS');
                            })
                            : buildSizeCircle(
                          size: 'S',
                          state: true,
                          color: Colors.grey[300],
                        ),
                        const SizedBox(
                          width: 10.0,
                        ),
                        widget.mmodel.isM
                            ? GestureDetector(
                            child: buildSizeCircle(
                                size: 'M',
                                state: ShopCubit.get(context).isM),
                            onTap: () {
                              ShopCubit.get(context).changeSize('isM');
                            })
                            : buildSizeCircle(
                          size: 'M',
                          state: true,
                          color: Colors.grey[300],
                        ),
                        const SizedBox(
                          width: 10.0,
                        ),
                        widget.mmodel.isL
                            ? GestureDetector(
                          child: buildSizeCircle(
                              size: 'L',
                              state: ShopCubit.get(context).isL),
                          onTap: () {
                            ShopCubit.get(context).changeSize('isL');
                          },
                        )
                            : buildSizeCircle(
                          size: 'L',
                          state: true,
                          color: Colors.grey[300],
                        ),
                        const SizedBox(
                          width: 10.0,
                        ),
                        widget.mmodel.isXL
                            ? GestureDetector(
                          child: buildSizeCircle(
                              size: 'XL',
                              state: ShopCubit.get(context).isXL),
                          onTap: () {
                            ShopCubit.get(context).changeSize('isXL');
                          },
                        )
                            : buildSizeCircle(
                          size: 'XL',
                          state: true,
                          color: Colors.grey[300],
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 15.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        widget.mmodel.is2XL
                            ? GestureDetector(
                          child: buildSizeCircle(
                              size: '2XL',
                              state: ShopCubit.get(context).is2XL),
                          onTap: () {
                            ShopCubit.get(context)
                                .changeSize('is2XL');
                          },
                        )
                            : buildSizeCircle(
                          size: '2XL',
                          state: true,
                          color: Colors.grey[300],
                        ),
                        const SizedBox(
                          width: 10.0,
                        ),
                        widget.mmodel.is3XL
                            ? GestureDetector(
                          child: buildSizeCircle(
                              size: '3XL',
                              state: ShopCubit.get(context).is3XL),
                          onTap: () {
                            ShopCubit.get(context)
                                .changeSize('is3XL');
                          },
                        )
                            : buildSizeCircle(
                          size: '3XL',
                          state: true,
                          color: Colors.grey[300],
                        ),
                        const SizedBox(
                          width: 10.0,
                        ),
                        widget.mmodel.is4XL
                            ? GestureDetector(
                          child: buildSizeCircle(
                              size: '4XL',
                              state: ShopCubit.get(context).is4XL),
                          onTap: () {
                            ShopCubit.get(context)
                                .changeSize('is4XL');
                          },
                        )
                            : buildSizeCircle(
                          size: '4XL',
                          state: true,
                          color: Colors.grey[300],
                        ),
                        const SizedBox(
                          width: 10.0,
                        ),
                        widget.mmodel.is5XL
                            ? GestureDetector(
                          child: buildSizeCircle(
                              size: '5XL',
                              state: ShopCubit.get(context).is5XL),
                          onTap: () {
                            ShopCubit.get(context)
                                .changeSize('is5XL');
                          },
                        )
                            : buildSizeCircle(
                          size: '5XL',
                          state: true,
                          color: Colors.grey[300],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0,left: 12.0,right: 12.0,),
            child: defaultButton2(
                function: () {
                  String s = '';
                  if (ShopCubit.get(context).isS==true) {
                    s = 'S';
                    log(s);
                  } else if (ShopCubit.get(context).isM==true) {
                    s = 'M';
                    log(s);
                  } else if (ShopCubit.get(context).isL==true) {
                    s = 'L';
                    log(s);
                  } else if (ShopCubit.get(context).isXL==true) {
                    s = 'XL';
                    log(s);
                  } else if (ShopCubit.get(context).is2XL==true) {
                    s = '2XL';
                    log(s);
                  } else if (ShopCubit.get(context).is3XL==true) {
                    s = '3XL';
                    log(s);
                  } else if (ShopCubit.get(context).is4XL==true) {
                    s = '4XL';
                    log(s);
                  } else if (ShopCubit.get(context).is5XL==true) {
                    s = '5XL';
                    log(s);
                  }
                  ShopCubit.get(context).isS=false;
                  ShopCubit.get(context).isM=false;
                  ShopCubit.get(context).isL=false;
                  ShopCubit.get(context).isXL=false;
                  ShopCubit.get(context).is2XL=false;
                  ShopCubit.get(context).is3XL=false;
                  ShopCubit.get(context).is4XL=false;
                  ShopCubit.get(context).is5XL=false;
                  ShopCubit.get(context).inCart(
                    pid: widget.mmodelID[widget.productIndex],
                    s: s,
                  );
                  log(s);
                  ShopCubit.get(context).getCart();
                  // Navigator.pop(context);
                },
                text: LocaleKeys.usersHomeScreen_productAddToCart.tr(),
                width: double.infinity,
                radius: 14,
                height: 60.0,
                ico: MySecondCartIcon.myCart,
                background: Colors.black),
          )
        ],
      );
}

class OpenImage extends StatelessWidget {
  final String mImage;

  const OpenImage({Key key, this.mImage}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back_ios,
            // size: 14.0,
            color: Colors.black,
          ),
        ),
      ),
      body: Center(
        child: Image(
          image: NetworkImage(
            mImage,
          ),
          // width: 500,
          width: double.infinity,
        ),
      ),
    );
  }
}
