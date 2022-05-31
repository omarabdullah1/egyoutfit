import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:egyoutfit/layout/shop_app/cubit/states.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../models/orders/orders_model.dart';
import '../../../models/promo/promo_model.dart';
import '../../../models/shop_app/login_model.dart';
import '../../../models/shop_app/products_model.dart';
import '../../../modules/login/login_screen.dart';
import '../../../modules/user/cart/cart_screen.dart';
import '../../../modules/user/favorites/favorites_screen.dart';
import '../../../modules/user/offers/offers_screen.dart';
import '../../../modules/user/products/products_screen.dart';
import '../../../modules/user/profile/user_profile.dart';
import '../../../shared/components/components.dart';
import '../../../shared/network/local/cache_helper.dart';
import '../../../translations/locale_keys.g.dart';

class ShopCubit extends Cubit<ShopStates> {
  ShopCubit() : super(ShopInitialState());

  static ShopCubit get(context) => BlocProvider.of(context);
  bool cartScreenFlag = false;
  List offers;
  List<ShopProductsModel> offersProducts = [];
  List offersProductsID = [];

  List<ShopProductsModel> products = [];
  List productsID = [];
  List productsSearched = [];
  List productsSearchedID = [];

  List<ShopProductsModel> menCategory = [];
  List menCategoryID = [];
  List<ShopProductsModel> womenCategory = [];
  List womenCategoryID = [];
  List<ShopProductsModel> childrenCategory = [];
  List childrenCategoryID = [];
  List<ShopProductsModel> shoeCategory = [];
  List shoeCategoryID = [];
  List<ShopProductsModel> sportCategory = [];
  List sportCategoryID = [];
  List<ShopProductsModel> bagCategory = [];
  List bagCategoryID = [];
  List<ShopProductsModel> accessoriesCategory = [];
  List accessoriesCategoryID = [];

  List cart = [];
  List size = [];
  List promoCode = [];
  List<ShopProductsModel> cartModel = [];
  int cartPrice = 0;
  List<int> cartPriceList = [];
  List favorites = [];
  List<ShopProductsModel> favoritesModel = [];

  List<OrdersModel> ordersModel = [];
  List<PromoModel> promoModel = [];

  List promoCodesList = [];

  List promoCodesStateList = [];

  List promoCodesIDList = [];

  List discountList = [];

  List orders = [];

  List counters = [];

  int currentIndex = 0;

  bool isS = false;
  bool isM = false;
  bool isL = false;
  bool isXL = false;
  bool is2XL = false;
  bool is3XL = false;
  bool is4XL = false;
  bool is5XL = false;

  bool isEnglish = false;

  List<Widget> bottomScreens = [
    const ProductsScreen(),
    const CartScreen(),
    const OffersScreen(),
    const FavoritesScreen(),
    const UserProfile(),
  ];

  changeSize(size) {
    if (size == 'isS') {
      isS = true;
      isM = false;
      isL = false;
      isXL = false;
      is2XL = false;
      is3XL = false;
      is4XL = false;
      is5XL = false;

      emit(ChangeSizedState());
    } else if (size == 'isM') {
      isM = true;
      isS = false;
      isL = false;
      isXL = false;
      is2XL = false;
      is3XL = false;
      is4XL = false;
      is5XL = false;
      emit(ChangeSizedState());
    } else if (size == 'isL') {
      isL = true;
      isM = false;
      isS = false;
      isXL = false;
      is2XL = false;
      is3XL = false;
      is4XL = false;
      is5XL = false;
      emit(ChangeSizedState());
    } else if (size == 'isXL') {
      isXL = true;
      isM = false;
      isL = false;
      isS = false;
      is2XL = false;
      is3XL = false;
      is4XL = false;
      is5XL = false;
      emit(ChangeSizedState());
    } else if (size == 'is2XL') {
      is2XL = true;
      isM = false;
      isL = false;
      isXL = false;
      isS = false;
      is3XL = false;
      is4XL = false;
      is5XL = false;
      emit(ChangeSizedState());
    } else if (size == 'is3XL') {
      is3XL = true;
      isM = false;
      isL = false;
      isXL = false;
      is2XL = false;
      isS = false;
      is4XL = false;
      is5XL = false;
      emit(ChangeSizedState());
    } else if (size == 'is4XL') {
      is4XL = true;
      isM = false;
      isL = false;
      isXL = false;
      is2XL = false;
      is3XL = false;
      isS = false;
      is5XL = false;
      emit(ChangeSizedState());
    } else if (size == 'is5XL') {
      is5XL = true;
      isM = false;
      isL = false;
      isXL = false;
      is2XL = false;
      is3XL = false;
      is4XL = false;
      isS = false;
      emit(ChangeSizedState());
    }
  }

  void changeBottom(int index) {
    currentIndex = index;
    emit(ShopChangeBottomNavState());
  }

  var dropdownvalueEn = 'Shoes Fashion';
  var dropdownvalueAr = 'أحذية';

  changeDropValue(value,context) {
    EasyLocalization.of(context).locale.languageCode=='en'?dropdownvalueEn=value:dropdownvalueAr=value;
  }

  changeDropButtonValue(String newValue,context) {
    EasyLocalization.of(context).locale.languageCode=='en'?dropdownvalueEn=newValue:dropdownvalueAr=newValue;
    emit(ChangeDropState());
  }

  getOffers() {
    FirebaseFirestore.instance.collection('banners').get().then((value) {
      for (var element in value.docs) {
        offers = element
            .data()
            .values
            .first;
        for (var ele in offers) {
          log(ele);
        }
        emit(GetOffersSuccessState());
      }
    }).catchError((error) {
      emit(GetOffersErrorState());
    });
  }

  getProducts(categoryName) {
    menCategory.clear();
    menCategoryID.clear();
    womenCategory.clear();
    womenCategoryID.clear();
    childrenCategory.clear();
    childrenCategoryID.clear();
    shoeCategory.clear();
    shoeCategoryID.clear();
    sportCategory.clear();
    sportCategoryID.clear();
    bagCategory.clear();
    bagCategoryID.clear();
    accessoriesCategory.clear();
    accessoriesCategoryID.clear();
    FirebaseFirestore.instance
        .collection('products')
        .where('category', isEqualTo: categoryName)
        .get()
        .then((value) {
      // log(value.docs.first.id);
      for (var element in value.docs) {
        if (element.data()['state'] == 'Approved') {
          if (categoryName == 'Men') {
            menCategory.add(ShopProductsModel.fromJson(element.data()));
            menCategoryID.add(element.id);
          } else if (categoryName == 'Women') {
            womenCategory.add(ShopProductsModel.fromJson(element.data()));
            womenCategoryID.add(element.id);
          } else if (categoryName == 'Children') {
            childrenCategory.add(ShopProductsModel.fromJson(element.data()));
            childrenCategoryID.add(element.id);
          } else if (categoryName == 'Bags') {
            bagCategory.add(ShopProductsModel.fromJson(element.data()));
            bagCategoryID.add(element.id);
          } else if (categoryName == 'Accessories') {
            accessoriesCategory.add(ShopProductsModel.fromJson(element.data()));
            accessoriesCategoryID.add(element.id);
          } else if (categoryName == 'Shoe') {
            shoeCategory.add(ShopProductsModel.fromJson(element.data()));
            shoeCategoryID.add(element.id);
          } else if (categoryName == 'Sports') {
            sportCategory.add(ShopProductsModel.fromJson(element.data()));
            sportCategoryID.add(element.id);
          }
        }
      }
      // log('$menCategory menCAtegry');
      emit(GetProductsSuccessState());
    }).catchError((error) {
      emit(GetProductsErrorState());
    });
  }

  getAllProducts() {
    products.clear();
    productsID.clear();
    FirebaseFirestore.instance.collection('products').get().then((value) {
      for (var element in value.docs) {
        if (element.data()['state'] == 'Approved') {
          products.add(ShopProductsModel.fromJson(element.data()));
          productsID.add(element.id);
        } else {
          log('no');
        }
      }
      // log('$menCategory menCAtegry');
      emit(GetProductsSuccessState());
    }).catchError((error) {
      emit(GetProductsErrorState());
    });
  }

  getAllOffers() {
    FirebaseFirestore.instance.collection('offers').get().then((value) {
      offersProducts = [];
      for (var element in value.docs) {
        offersProducts.add(ShopProductsModel.fromJson(element.data()));
        offersProductsID.add(element.id);
      }
      // for(var element in offersProducts){
      //   log('Offersssssssssssssssss ${element.image}');
      // }
      // log('$menCategory menCAtegry');
      emit(GetProductsSuccessState());
    }).catchError((error) {
      // log(error.toString());
      emit(GetProductsErrorState());
    });
  }

  ShopLoginModel loginModel;

  void userLogin({
    @required context,
    @required String email,
    @required String password,
  }) {
    emit(ShopLoginLoadingState());
    FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password)
        .then((value) async {
      // await CacheHelper.saveData(key: 'UID', value: value.user?.uid);
      FirebaseFirestore.instance
          .collection('users')
          .doc(value.user.uid)
          .get()
          .then((value) async {
        // log(value.data()['favorites']);
        loginModel = ShopLoginModel.fromJson(value.data());
        favorites = value.data()['favorites'];
        cart = value.data()['cart'];
        size = value.data()['size'];
        log(favorites.toString());
        log(cart.toString());

        emit(ShopLoginSuccessState(loginModel));
      }).catchError((error) {
        log(error.toString());
        emit(ShopLoginErrorState((error.toString())));
      });
    }).catchError((error) {
      emit(ShopLoginErrorState(error.toString()));
    });
  }

  inFavorites({
    @required pid,
  }) {
    if (favorites.isEmpty) {
      favorites.add(pid);
      log(favorites.toString());
      FirebaseFirestore.instance
          .collection('users')
          .doc(CacheHelper.getData(key: 'token'))
          .update({
        'favorites': favorites,
      })
          .then((value) => emit(AddFavouritesSuccessState()))
          .catchError((error) {
        emit(AddFavouritesErrorState());
      });
    } else {
      if (favorites.contains(pid)) {
        favorites.remove(pid);
        log(favorites.toString());
        FirebaseFirestore.instance
            .collection('users')
            .doc(CacheHelper.getData(key: 'token'))
            .update({
          'favorites': favorites,
        })
            .then((value) => emit(RemoveFavouritesSuccessState()))
            .catchError((error) {
          emit(RemoveFavouritesErrorState());
        });
      } else {
        favorites.add(pid);
        log(favorites.toString());

        // favorites.add(pid);
        FirebaseFirestore.instance
            .collection('users')
            .doc(CacheHelper.getData(key: 'token'))
            .update({
          'favorites': favorites,
        })
            .then((value) => emit(UpdateFavouritesSuccessState()))
            .catchError((error) {
          emit(UpdateFavouritesErrorState());
        });
      }
    }
  }

  getFavourite() {
    favoritesModel.clear();
    FirebaseFirestore.instance.collection('products').get().then((value) {
      for (var element in favorites) {
        for (var ele in value.docs) {
          if (ele.id == element) {
            favoritesModel.add(ShopProductsModel.fromJson(ele.data()));
          }
        }
      }
      emit(GetProductsSuccessState());
    }).catchError((error) {
      log(error);
      emit(GetProductsErrorState());
    });
  }

  inCart({
    @required pid,
    @required s,
  }) {
    cart.add(pid);
    size.add(s);
    log(cart.toString());
    log(size.toString());
    FirebaseFirestore.instance
        .collection('users')
        .doc(CacheHelper.getData(key: 'token'))
        .update({
      'cart': cart,
      'size': size,
    })
        .then((value) => emit(AddCartSuccessState()))
        .catchError((error) {
      emit(AddCartErrorState());
    });
  }

  removeCart(pid) {
    if (cart.contains(pid)) {
      size.removeAt(cart.indexOf(pid));
      cart.remove(pid);
      log(cart.toString());
      log(size.toString());
      FirebaseFirestore.instance
          .collection('users')
          .doc(CacheHelper.getData(key: 'token'))
          .update({
        'cart': cart,
        'size': size,
      })
          .then((value) => emit(RemoveCartSuccessState()))
          .catchError((error) {
        emit(RemoveCartErrorState());
      });
    }
  }

  getCart() {
    emit(GetProductsLoadingState());
    cartModel.clear();
    // cartPrice =0;
    FirebaseFirestore.instance.collection('products').get().then((value) {
      for (var element in cart) {
        for (var ele in value.docs) {
          if (ele.id == element) {
            cartModel.add(ShopProductsModel.fromJson(ele.data()));
          }
        }
      }
      // for(var element in cartModel){
      //   log(element.name);
      // }
      // for(var element in cartModel){
      //     cartPrice+=element.price;
      // }
      emit(GetProductsSuccessState());
    }).catchError((error) {
      log(error.toString());
      emit(GetProductsErrorState());
    });
  }

  getCartPrice(List<ShopProductsModel> model) {
    // log(counters.toString());
    // log('counters.toString()');

    cartPriceList = [];
    cartPrice = 0;
    for (var element in model) {
      cartPriceList.add(
          (element.price - ((element.price / 100) * element.discount)).toInt() *
              counters[model.indexOf(element)]);
    }
    for (var element in cartPriceList) {
      cartPrice += element;
    }
    // counters.removeAt(0);

    // log('cartPriceList.toString()');
    // log(cartPriceList.toString());
    // log('cartPrice.toString()');
    // log(cartPrice.toString());
  }

  getPromoCodes() {
    promoModel.clear();
    promoCodesList.clear();
    promoCodesIDList.clear();
    discountList.clear();
    promoCodesStateList.clear();
    emit(GetPromoCodesLoadingState());
    FirebaseFirestore.instance.collection('promo').get().then((value) {
      for (var element in value.docs) {
        // log(element.data()['promo']);
        promoModel.add(PromoModel.fromJson(element.data()));
      }
      for (var element in promoModel) {
        promoCodesList.add(element.promo);
        promoCodesIDList.add(element.uid);
        discountList.add(element.discount);
        promoCodesStateList.add(element.state);
        // log(element.product.toString());
      }
      log(promoCodesStateList.toString());
      emit(GetPromoCodesSuccessState());
    }).catchError((err) {
      log(err.toString());
      emit(GetPromoCodesErrorState());
    });
  }

  createOrder({
    orderAddress,
    orderName,
    orderPromoCode,
    orderPromoDiscount,
    orderSize,
    orderCount,
    orderId,
    orderIndex,
    orderPhone,
    orderOtherPhone,
    orderCost,
    orderComment,
    orderImage,
  }) {
    emit(CreateOrderLoadingState());
    FirebaseFirestore.instance.collection('orders').doc().set({
      'address': orderAddress,
      'email': loginModel.email,
      'size': orderSize,
      'firstName': loginModel.firstName,
      'orderedProducts': orderId,
      'phoneNumber': orderPhone,
      'otherPhoneNumber': orderOtherPhone,
      'uid': CacheHelper.getData(key: 'token'),
      'orderedProductsCount': orderCount,
      'pState': 'Pending',
      'orderCost': orderCost,
      'orderComment': orderComment,
      'orderPromo': orderPromoCode,
      'orderPromoDiscount': orderPromoDiscount,
      'orderImage': orderImage,
      'orderName': orderName,
    }).then((value) {
      showToast(text: LocaleKeys.alerts_orderCreatedSuccessfully.tr(), state: ToastStates.success);
      removeCart(cart[orderIndex]);
      getCart();
      FirebaseFirestore.instance
          .collection('users')
          .doc(CacheHelper.getData(key: 'token'))
          .update({
        'cart': cart,
      })
          .then((value) => emit(RemoveCartSuccessState()))
          .catchError((error) {
        emit(RemoveCartErrorState());
      });
      emit(CreateOrderSuccessState());
    }).catchError((error) {
      log(error);
      showToast(text: LocaleKeys.alerts_orderErrorCreatingOrder.tr(), state: ToastStates.error);
      emit(CreateOrderErrorState());
    });
  }

  getOrders() {
    ordersModel.clear();
    FirebaseFirestore.instance
        .collection('orders')
        .where('uid', isEqualTo: CacheHelper.getData(key: 'token'))
        .get()
        .then((value) {
      for (var element in value.docs) {
        ordersModel.add(OrdersModel.fromJson(element.data()));
        log(element.data()['pState'].toString());
      }
      for (var ele in ordersModel) {
        log(ele.orderedProductsCount.toString());
      }
      // log('$menCategory menCAtegry');
      emit(GetProductsSuccessState());
    }).catchError((error) {
      log(error);
      emit(GetProductsErrorState());
    });
  }

  void search(String text) {
    productsSearched.clear();
    emit(SearchLoadingState());
    for (var element in products) {
      if (element.name.contains(text) || element.description.contains(text)) {
        productsSearched.add(element);
        productsSearchedID.add(productsID[products.indexOf(element)]);
      }
      // productsSearched.add(element);
    }
    // for(var element in productsSearched){
    //   log(element.name);
    // }
    // for(var element in products){
    //   log(element.name);
    // }
    // for(var element in productsSearched){
    //   log(element.name);
    // }
    // log(products);
    emit(SearchSuccessState());
  }

  updateData() {
    getAllProducts();
    getAllOffers();
    getFavourite();
    getCart();
    getOrders();
    getProducts('Men');
    getProducts('Women');
    getProducts('Children');
    getProducts('Bags');
    getProducts('Accessories');
    getProducts('Shoe');
    getProducts('Sports');
  }

  changeCount() {
    emit(ChangeCounterState());
  }

  changeCartPrice() {
    emit(ChangeCartPriceState());
  }

  void signOut(context) {
    CacheHelper.removeData(
      key: 'token',
    ).then((value) {
      if (value) {
        currentIndex = 0;
        emit(ShopLogoutState());
        navigateAndFinish(
          context,
          const LoginScreen(),
        );
      }
    });
  }

  updateUserData({nameFirst, nameSecond, address, phone, uid, context}) {
    emit(UpdateStateLoadingShopState());

    FirebaseFirestore.instance.collection('users').doc(uid).update({
      'address': address,
      'firstName': nameFirst,
      'secondName': nameSecond,
      'phone': phone,
    }).then((value) async {
      userLogin(
          context: context,
          email: CacheHelper.getData(key: 'user'),
          password: CacheHelper.getData(key: 'pass'));
      emit(UpdateStateSuccessShopState());
      Navigator.pop(context);
    }).catchError((err) {
      log(err.toString());
      emit(UpdateStateErrorShopState());
    });
  }

  changeUserPassword(newPassword,context) async {
    emit(UpdateStateLoadingShopState());
    await FirebaseAuth.instance.currentUser.updatePassword(newPassword).then((
        value) {
      emit(UpdateStateSuccessShopState());
      signOut(context);
    }).catchError((err) {
      log(err.toString());
      emit(UpdateStateErrorShopState());
    });
  }

  getData(context) {
    userLogin(
        context: context,
        email: CacheHelper.getData(key: 'user'),
        password: CacheHelper.getData(key: 'pass'));
    getOffers();
    getPromoCodes();
    getAllProducts();
    getProducts('Men');
    getProducts('Women');
    getProducts('Children');
    getProducts('Bags');
    getProducts('Accessories');
    getProducts('Shoe');
    getProducts('Sports');
  }

  int group = 1;

  changePaymentMethod(value) {
    group = value;
    emit(ChangePaymentMethodState());
  }

  counterChange() {
    emit(ChangeCartCounterState());
  }

  var productCaroIndex = 0;

  changeProductCarousel(index) {
    productCaroIndex = index;
    emit(ChangeCarouselState());
  }

  changeProductCarouselList() {
    emit(ChangeCarouselState());
  }

  changeLanguageValue(v, context) async {
    isEnglish = v;
    log(isEnglish.toString());
    emit(ChangeLanguageState());
  }
}
