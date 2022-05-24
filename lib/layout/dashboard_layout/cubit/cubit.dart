import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'dart:math' as math;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:egyoutfit/layout/dashboard_layout/cubit/states.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import '../../../models/orders/orders_model.dart';
import '../../../models/promo/promo_model.dart';
import '../../../models/shop_app/login_model.dart';
import '../../../models/shop_app/products_model.dart';
import '../../../modules/login/login_screen.dart';
import '../../../modules/service_provider/dashboard_screen/dashboard_screen.dart';
import '../../../modules/service_provider/profile_screen/profile_screen.dart';
import '../../../modules/service_provider/sales_screen/sales_screen.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

import '../../../shared/components/components.dart';
import '../../../shared/network/local/cache_helper.dart';

class DashboardCubit extends Cubit<DashboardStates> {
  DashboardCubit() : super(DashboardInitialState());

  static DashboardCubit get(context) => BlocProvider.of(context);

  int currentIndex = 0;
  List listImage = [];
  List<String> firebaseLink;
  List firebaseLinkEdit;
  List<ShopProductsModel> products = [];
  List productsID = [];
  List allProductsID = [];
  List offersProductsID = [];
  List<OrdersModel> orderedProducts = [];

  List<OrdersModel> requestOrderModel = [];

  List<OrdersModel> pendingOrderedProductsList = [];
  List<OrdersModel> completedOrderedProductsList = [];
  List<OrdersModel> scheduledOrderedProductsList = [];
  List<OrdersModel> canceledOrderedProductsList = [];

  List<ShopProductsModel> myOrderedProducts = [];
  List<ShopProductsModel> requestModel = [];
  List<ShopProductsModel> pendingOrderedProducts = [];
  List<ShopProductsModel> completedOrderedProducts = [];
  List<ShopProductsModel> scheduledOrderedProducts = [];
  List<ShopProductsModel> canceledOrderedProducts = [];

  // List<ShopProductsModel> model = [];
  List orderedProductsIDList = [];

  List allOrderedProductsID = [];
  List pendingOrderedProductsID = [];
  List scheduledOrderedProductsID = [];
  List completedOrderedProductsID = [];
  List canceledOrderedProductsID = [];
  List requestedOrderedProductsID = [];

  List pendingOrderedProductsIDList = [];
  List completedOrderedProductsIDList = [];
  List scheduledOrderedProductsIDList = [];
  List canceledOrderedProductsIDList = [];

  List offers = [];

  List orderedProductsStateList = [];

  List pendingOrderedProductsStateList = [];
  List completedOrderedProductsStateList = [];
  List scheduledOrderedProductsStateList = [];
  List canceledOrderedProductsStateList = [];
  List requestModelStateList = [];

  List orderedProductsCountList = [];

  List pendingOrderedProductsCountList = [];
  List completedOrderedProductsCountList = [];
  List scheduledOrderedProductsCountList = [];
  List canceledOrderedProductsCountList = [];
  List requestModelCountList = [];

  List<PromoModel> promoModel = [];

  List allPromoCodesIDList = [];

  List promoCodesList = [];

  List promoCodesStateList = [];

  List myPromoCodesStateList = [];

  List myPromoCodesList = [];

  List promoCodesIDList = [];

  List myPromoCodesIDList = [];

  List discountList = [];

  List myDiscountList = [];

  bool isS = false;
  bool isM = false;
  bool isL = false;
  bool isXL = false;
  bool is2XL = false;
  bool is3XL = false;
  bool is4XL = false;
  bool is5XL = false;
  bool promoToggle = false;
  bool discountToggle = false;
  bool deliveryToggle = false;
  bool promoDiscountToggle = false;
  bool stateChanged = false;
  bool isUpdate = false;

  List<Widget> bottomScreens = [
    const DashboardScreen(),
    const SalesScreen(),
    const ProfileScreen(),
  ];

  void changeBottom(int index) {
    currentIndex = index;
    emit(DashboardChangeBottomNavState());
  }

  var dropDownValue = 'All Requests';
  var lastDropDownValue = 'All Requests';
  var requestDropDownValue = 'Pending';
  var createScreenDropDownValue = 'None';
  Color dropDownValueColor = Colors.white;
  Color requesdtDropDownValueColor = Colors.white;

  ShopLoginModel loginModel;

  userLogin({
    @required context,
    @required String email,
    @required String password,
  }) {
    emit(DashboardLoginLoadingState());
    FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password)
        .then((value) async {
      FirebaseFirestore.instance
          .collection('users')
          .doc(value.user.uid)
          .get()
          .then((value) async {
        loginModel = ShopLoginModel.fromJson(value.data());

        emit(DashboardLoginSuccessState(loginModel));
      }).catchError((error) {
        log(error.toString());
        emit(DashboardLoginErrorState((error.toString())));
      });
    }).catchError((error) {
      emit(DashboardLoginErrorState(error.toString()));
    });
  }

  getOffers() {
    FirebaseFirestore.instance.collection('banners').get().then((value) {
      for (var element in value.docs) {
        offers = element.data().values.first;
        for (var ele in offers) {
          log(ele);
        }
        emit(GetOffersSuccessState());
      }
    }).catchError((error) {
      emit(GetOffersErrorState());
    });
  }

  getAllProducts() {
    productsID.clear();
    products.clear();
    offersProductsID.clear();

    /////////// products//////////////
    FirebaseFirestore.instance.collection('products').get().then((value) {
      for (var element in value.docs) {
        allProductsID.add(element.id);
        if (element.data()['uid'] == CacheHelper.getData(key: 'token')) {
          products.add(ShopProductsModel.fromJson(element.data()));
          productsID.add(element.id);
        }
        // log(element.id);
      }
      emit(GetProductsSuccessState());
    }).catchError((error) {
      log(error.toString());
      emit(GetProductsErrorState());
    });
  }

  changeDropButtonValue(String newValue) {
    dropDownValue = newValue;
    if (newValue == 'Completed') {
      dropDownValueColor = Colors.green;
      requestModel = completedOrderedProducts;
      requestOrderModel = completedOrderedProductsList;
      requestModelCountList = completedOrderedProductsCountList;
      requestModelStateList = completedOrderedProductsStateList;
      requestedOrderedProductsID = completedOrderedProductsID;
      log('completed from');
    } else if (newValue == 'Scheduled') {
      dropDownValueColor = Colors.blue;
      requestModel = scheduledOrderedProducts;
      requestOrderModel = scheduledOrderedProductsList;
      requestModelCountList = scheduledOrderedProductsCountList;
      requestModelStateList = scheduledOrderedProductsStateList;
      requestedOrderedProductsID = scheduledOrderedProductsID;
      log('Scheduled from');
    } else if (newValue == 'Cancelled') {
      dropDownValueColor = Colors.red;
      requestModel = canceledOrderedProducts;
      requestOrderModel = canceledOrderedProductsList;
      requestModelCountList = canceledOrderedProductsCountList;
      requestModelStateList = canceledOrderedProductsStateList;
      requestedOrderedProductsID = canceledOrderedProductsID;
      log('Cancelled from');
    } else if (newValue == 'Pending') {
      dropDownValueColor = Colors.orange;
      requestModel = pendingOrderedProducts;
      requestOrderModel = pendingOrderedProductsList;
      requestModelCountList = pendingOrderedProductsCountList;
      requestModelStateList = pendingOrderedProductsStateList;
      requestedOrderedProductsID = pendingOrderedProductsID;
      log('Pending from');
    } else if (newValue == 'All Requests') {
      dropDownValueColor = Colors.white;
      requestModel = myOrderedProducts;
      requestOrderModel = orderedProducts;
      requestModelCountList = orderedProductsCountList;
      requestModelStateList = orderedProductsStateList;
      requestedOrderedProductsID = allOrderedProductsID;
      log(requestOrderModel.toString());
      log('All Requests from');
    }
    emit(ChangeDropDashboardState());
  }

  changeRequestDropButtonValue(String newValue, String id) {
    requestDropDownValue = newValue;
    if (newValue == 'Completed') {
      requesdtDropDownValueColor = Colors.green;
    } else if (newValue == 'Scheduled') {
      requesdtDropDownValueColor = Colors.blue;
    } else if (newValue == 'Cancelled') {
      requesdtDropDownValueColor = Colors.red;
    } else if (newValue == 'Pending') {
      requesdtDropDownValueColor = Colors.orange;
    } else if (newValue == 'All Requests') {
      requesdtDropDownValueColor = Colors.white;
    }
    emit(ChangeDropDashboardState());
  }

  changeOrderState(value, id, dropVal) {
    emit(UpdateStateLoadingDashboardState());
    FirebaseFirestore.instance.collection('orders').doc(id).update({
      'pState': value,
    }).then((val) {
      log(value.toString());
      log('updated');
      changeState(
        false,
        state: requestDropDownValue,
      );
      getAllOrdered();
      // DashboardCubit.get(context).dropDownValue=widget.dropValue;
      changeDropButtonValue(dropVal);
      lastDropDownValue = dropVal;
      emit(UpdateStateSuccessDashboardState());
    }).catchError((error) {
      log('error in updated');
      emit(UpdateStateErrorDashboardState());
    });
  }

  changeState(bool value, {state}) {
    stateChanged = value;
    if (!value) {
      requestDropDownValue = state;
      if (state == 'Completed') {
        requesdtDropDownValueColor = Colors.green;
      } else if (state == 'Scheduled') {
        requesdtDropDownValueColor = Colors.blue;
      } else if (state == 'Cancelled') {
        requesdtDropDownValueColor = Colors.red;
      } else if (state == 'Pending') {
        requesdtDropDownValueColor = Colors.orange;
      } else if (state == 'All Requests') {
        requesdtDropDownValueColor = Colors.white;
      }
    }
    emit(ChangeStateDashboardState());
  }

  changeCreateProductDropButtonValue(String newValue) {
    createScreenDropDownValue = newValue;
    emit(ChangeCreateProductDropDashboardState());
  }

  changeEditProductDropButtonValue(String newValue) {
    createScreenDropDownValue = newValue;
    emit(ChangeCreateProductDropDashboardState());
  }

  changeEditDropButtonValue() {
    emit(ChangeCreateProductDropDashboardState());
  }

  createProduct({
    @required String category,
    @required String description,
    @required List image,
    @required String name,
    @required double discount,
    @required int oldPrice,
    @required int price,
    @required String pbid,
    @required bool isS,
    @required bool isM,
    @required bool isL,
    @required bool isXL,
    @required bool is2XL,
    @required bool is3XL,
    @required bool is4XL,
    @required bool is5XL,
    @required bool isShipping,
    @required bool isDiscount,
    @required String shippingPrice,
    @required String state,
  }) async {
    emit(CreateProductLoadingState());
    var create = FirebaseFirestore.instance.collection('products').doc();
    create.set({
      'category': category,
      'description': description,
      'image': image,
      'name': name,
      'discount': discount,
      'oldPrice': oldPrice,
      'price': price,
      'pbid': pbid,
      'uid': await CacheHelper.getData(key: 'token'),
      'isS': isS,
      'isM': isM,
      'isL': isL,
      'isXL': isXL,
      'is2XL': is2XL,
      'is3XL': is3XL,
      'is4XL': is4XL,
      'is5XL': is5XL,
      'isShipping': isShipping,
      'shippingPrice': shippingPrice,
      'state': 'Pending',
    }).then((value) {
      log(create.id);
      emit(CreateProductSuccessState());
      // firebaseLink=[];
    }).catchError((err) {
      log(err.toString());
      emit(CreateProductErrorState());
    });
  }
  createPromo({
    @required String promo,
    @required int discount,
    @required bool isDiscount,

  }) async {
    emit(CreatePromoLoadingState());
     FirebaseFirestore.instance.collection('promo').doc().set({
      'global': false,
      'discount': discount,
      'uid': await CacheHelper.getData(key: 'token'),
      'state': isDiscount?'Active':'NotActive',
      'product': '',
      'promo': promo,
    }).then((value) {
      emit(CreatePromoSuccessState());
      // firebaseLink=[];
    }).catchError((err) {
      log(err.toString());
      emit(CreatePromoErrorState());
    });
  }
  updatePromo({
    @required String id,
    @required String promo,
    @required int discount,
    @required bool isDiscount,

  }) async {
    emit(CreatePromoLoadingState());
     FirebaseFirestore.instance.collection('promo').doc(id).update({
      'global': false,
      'discount': discount,
      'uid': await CacheHelper.getData(key: 'token'),
      'state': isDiscount?'Active':'NotActive',
      'product': '',
      'promo': promo,
    }).then((value) {
      emit(CreatePromoSuccessState());
      // firebaseLink=[];
    }).catchError((err) {
      log(err.toString());
      emit(CreatePromoErrorState());
    });
  }

  updateProduct({
    @required String category,
    @required String description,
    @required String name,
    @required double discount,
    @required int oldPrice,
    @required int price,
    @required String pbid,
    @required bool isS,
    @required bool isM,
    @required bool isL,
    @required bool isXL,
    @required bool is2XL,
    @required bool is3XL,
    @required bool is4XL,
    @required bool is5XL,
    @required bool isShipping,
    @required bool isDiscount,
    @required String shippingPrice,
    @required String state,
    @required String id,
  }) async {
    emit(UpdateProductLoadingState());
    var create = FirebaseFirestore.instance.collection('products').doc(id);
    create.update({
      'category': category,
      'description': description,
      'name': name,
      'discount': discount,
      'oldPrice': oldPrice,
      'price': price,
      'pbid': pbid,
      'uid': await CacheHelper.getData(key: 'token'),
      'isS': isS,
      'isM': isM,
      'isL': isL,
      'isXL': isXL,
      'is2XL': is2XL,
      'is3XL': is3XL,
      'is4XL': is4XL,
      'is5XL': is5XL,
      'isShipping': isShipping,
      'shippingPrice': shippingPrice,
      'state': 'Pending',
    }).then((value) {
      log(create.id);
      emit(UpdateProductSuccessState());
    }).catchError((err) {
      log(err.toString());
      emit(UpdateProductErrorState());
    });
  }

  Future<void>updateProductImage({
    @required String id,
    @required List images,
  }) async {
    emit(UpdateProductImageLoadingState());
    var create = FirebaseFirestore.instance.collection('products').doc(id);
    create.update({
      'image': images,
    }).then((value) {
      log(create.id);
      emit(UpdateProductImageSuccessState());
      firebaseLink = [];
    }).catchError((err) {
      log(err.toString());
      emit(UpdateProductImageErrorState());
    });
  }

  Future<void> getImage(bool isCamera) async {
    emit(LoadingPickImageState());
    var picker = ImagePicker();
    final pickedFile = await picker.pickImage(
        source: isCamera ? ImageSource.camera : ImageSource.gallery);
    if (pickedFile != null) {
      listImage.add(pickedFile.path);
      emit(SuccessPickImageState());
    } else {
      log('No image selected.');
      emit(ErrorPickImageState());
    }
  }

  changeUpdateState(value) {
    isUpdate = value;
    emit(ChangeUpdateDashboardState());
  }

  Future<void> getMultiImage(bool isCamera) async {
    var picker = ImagePicker();
    emit(LoadingPickImageState());
    final List<XFile> pickedFileList = await picker.pickMultiImage(
      maxWidth: 300,
      maxHeight: 300,
      imageQuality: 100,
    );
    // final pickedFile = await picker.pickImage(
    //     source: ImageSource.gallery);
    if (pickedFileList != null) {
      // listImage = File(pickedFile.path);
      for (var ele in pickedFileList) {
        listImage.add(ele.path);
      }
      emit(SuccessPickImageState());
    } else {
      log('No image selected.');
      emit(ErrorPickImageState());
    }
  }

  removeImageFromList(index) {
    listImage.removeAt(index);
    caroIndex = 0;
    emit(SuccessRemoveImageState());
  }

  Future<void> uploadToFireBase() async {
    emit(LoadingUploadImageState());
    firebaseLink = [];
    for (var element in listImage) {
      firebase_storage.FirebaseStorage.instance
          .ref()
          .child('products/${Uri.file(element).pathSegments.last}')
          .putFile(File(element))
          .then((value) {
        value.ref
            .getDownloadURL()
            .then((value) {
              firebaseLink.add(value.toString());
              log(value.toString());
            })
            .whenComplete(() => emit(SuccessUploadImageState()))
            .catchError((err) {
              log(err.toString());
              emit(ErrorUploadImageState());
            });
      });
    }
  }

  Future<void> uploadEditToFireBase() async {
    emit(LoadingUploadImageState());
    firebaseLinkEdit = [];
    for (var element in listImage) {
      firebase_storage.FirebaseStorage.instance
          .ref()
          .child('products/${Uri.file(element).pathSegments.last}')
          .putFile(File(element))
          .then((value) {
        value.ref
            .getDownloadURL()
            .then((value) {
          firebaseLinkEdit.add(value.toString());
              log(value.toString());
            })
            .whenComplete(() => emit(SuccessUploadImageState()))
            .catchError((err) {
              log(err.toString());
              emit(ErrorUploadImageState());
            });
      });
    }
    emit(SuccessUploadAllImageState());
  }

  // Future<List> uploadEditToFireBase() async {
  //   emit(LoadingUploadImageState());
  //   for (var element in listImage) {
  //     firebase_storage.FirebaseStorage.instance
  //         .ref()
  //         .child('products/${Uri.file(element).pathSegments.last}')
  //         .putFile(File(element))
  //         .then((value) {
  //       value.ref
  //           .getDownloadURL()
  //           .then((value) {
  //             firebaseLink.add(value.toString());
  //             log(value.toString());
  //             // emit(SuccessUploadImageState());
  //           })
  //           .whenComplete(() => emit(SuccessUploadImageState()))
  //           .catchError((err) {
  //             log(err.toString());
  //             emit(ErrorUploadImageState());
  //           });
  //     });
  //   }
  //   emit(SuccessUploadAllImageState());
  //   return firebaseLink;
  // }

timeProgress() {
    emit(LoadingState());
      // log(firebaseLinkEdit.toString());
      //  updateProductImage(
      //     id: id,
      //     images: list);
      //  getAllProducts();
      //  getAllOrdered();
    var tim =Timer(const Duration(seconds: 5), (){emit(SuccessState());});
tim.cancel();
    // firebaseLinkEdit = [];
    // Navigator.pop(context);
    //   Navigator.pop(context);
}
  getAllOrdered() {
    orderedProducts.clear();
    orderedProductsIDList.clear();
    allOrderedProductsID.clear();
    pendingOrderedProductsID.clear();
    scheduledOrderedProductsID.clear();
    requestedOrderedProductsID.clear();
    completedOrderedProductsID.clear();
    canceledOrderedProductsID.clear();
    pendingOrderedProductsIDList.clear();
    scheduledOrderedProductsList.clear();
    pendingOrderedProductsCountList.clear();
    pendingOrderedProductsStateList.clear();
    scheduledOrderedProductsStateList.clear();
    scheduledOrderedProductsCountList.clear();
    scheduledOrderedProductsIDList.clear();
    completedOrderedProductsList.clear();
    canceledOrderedProductsIDList.clear();
    completedOrderedProductsIDList.clear();
    orderedProductsCountList.clear();
    myOrderedProducts.clear();
    pendingOrderedProducts.clear();
    pendingOrderedProductsList.clear();
    scheduledOrderedProducts.clear();
    completedOrderedProducts.clear();
    canceledOrderedProducts.clear();
    orderedProductsStateList.clear();
    completedOrderedProductsCountList.clear();
    completedOrderedProductsStateList.clear();
    canceledOrderedProductsList.clear();
    canceledOrderedProductsCountList.clear();
    canceledOrderedProductsStateList.clear();

    dropDownValue = 'All Requests';
    dropDownValueColor = Colors.white;
    requestModel.clear();
    requestOrderModel.clear();
    // myOrderedProducts.clear();
    FirebaseFirestore.instance.collection('orders').get().then((value) {
      for (var element in value.docs) {
        if (productsID.contains(element.data()['orderedProducts'])) {
          orderedProducts.add(OrdersModel.fromJson(element.data()));
          orderedProductsStateList.add(element.data()['pState'].toString());
          log(element.id);

          allOrderedProductsID.add(element.id);
          if (element.data()['pState'] == 'Pending') {
            pendingOrderedProductsID.add(element.id);
          } else if (element.data()['pState'] == 'Scheduled') {
            scheduledOrderedProductsID.add(element.id);
          } else if (element.data()['pState'] == 'Completed') {
            completedOrderedProductsID.add(element.id);
          } else if (element.data()['pState'] == 'Cancelled') {
            canceledOrderedProductsID.add(element.id);
          }
        }
      }
      for (var element in orderedProducts) {
        log(element.pState.toString());
        if (productsID.contains(element.orderedProduct)) {
          orderedProductsIDList.add(element.orderedProduct);
          if (element.pState == 'Pending') {
            pendingOrderedProductsList.add(element);
            pendingOrderedProductsIDList.add(element.orderedProduct);
            pendingOrderedProductsCountList.add(element.orderedProductsCount);
            pendingOrderedProductsStateList.add(element.pState);
          } else if (element.pState == 'Scheduled') {
            scheduledOrderedProductsList.add(element);
            scheduledOrderedProductsIDList.add(element.orderedProduct);
            scheduledOrderedProductsCountList.add(element.orderedProductsCount);
            scheduledOrderedProductsStateList.add(element.pState);
          } else if (element.pState == 'Completed') {
            completedOrderedProductsList.add(element);
            completedOrderedProductsIDList.add(element.orderedProduct);
            completedOrderedProductsCountList.add(element.orderedProductsCount);
            completedOrderedProductsStateList.add(element.pState);
          } else if (element.pState == 'Cancelled') {
            canceledOrderedProductsList.add(element);
            canceledOrderedProductsIDList.add(element.orderedProduct);
            canceledOrderedProductsCountList.add(element.orderedProductsCount);
            canceledOrderedProductsStateList.add(element.pState);
          }
        } else {
          log('this product is not mine');
        }
        orderedProductsCountList.add(element.orderedProductsCount);
      }
      for (var element in orderedProductsIDList) {
        myOrderedProducts.add(products[productsID.indexOf(element)]);
      }
      for (var element in pendingOrderedProductsIDList) {
        pendingOrderedProducts.add(products[productsID.indexOf(element)]);
      }
      for (var element in scheduledOrderedProductsIDList) {
        scheduledOrderedProducts.add(products[productsID.indexOf(element)]);
      }
      for (var element in completedOrderedProductsIDList) {
        completedOrderedProducts.add(products[productsID.indexOf(element)]);
      }
      for (var element in canceledOrderedProductsIDList) {
        canceledOrderedProducts.add(products[productsID.indexOf(element)]);
      }
      requestModel = myOrderedProducts;
      requestOrderModel = orderedProducts;
      requestModelCountList = orderedProductsCountList;
      requestModelStateList = orderedProductsStateList;
      requestedOrderedProductsID = allOrderedProductsID;

      log('omar');
      log(productsID.toString());
      // log(orderedProducts.toString());
      log(orderedProductsIDList.toString());
      // myOrderedProducts
      //   ..forEach((element) {
      //     log(element.state.toString());
      //   });
      log(requestModelCountList.toString());
      log(requestModelStateList.toString());
      log(myOrderedProducts.toString());
      // log(productsID.toString());
      // orderedProducts.forEach((element) {log(element.orderedProduct.toString());});
      // for (var e in myOrderedProducts) {
      //   log(e.name);
      //   log(e.state);
      // }
      // for (var e in orderedProductsIDList) {
      //   log(e);
      // }
      // for (var e in orderedProductsCountList) {
      //   log(e.toString());
      // }
      emit(GetProductsSuccessState());
    }).catchError((error) {
      emit(GetProductsErrorState());
    });
  }
  getPromoCodes() {
    promoModel.clear();
    promoCodesList.clear();
    promoCodesIDList.clear();
    discountList.clear();
    myPromoCodesIDList.clear();
    myPromoCodesList.clear();
    myDiscountList.clear();
    allPromoCodesIDList.clear();
    promoCodesStateList.clear();
    myPromoCodesStateList.clear();
    emit(GetPromoCodesLoadingState());
    FirebaseFirestore.instance.collection('promo').get().then((value) async {
      for (var element in value.docs) {
        // log(element.data()['promo']);
        promoModel.add(PromoModel.fromJson(element.data()));
        allPromoCodesIDList.add(element.id);
      }
      for (var element in promoModel) {
        promoCodesList.add(element.promo);
        promoCodesIDList.add(element.uid);
        discountList.add(element.discount);
        promoCodesStateList.add(element.state);
        log(element.product.toString());
      }
      for(var element in promoCodesList){
        if(promoCodesIDList[promoCodesList.indexOf(element)]==await CacheHelper.getData(key: 'token')){
          myPromoCodesList.add(element);
          myDiscountList.add(discountList[promoCodesList.indexOf(element)]);
          myPromoCodesStateList.add(promoCodesStateList[promoCodesList.indexOf(element)]);
        }
      }
      for(var ele in promoCodesStateList){
        log(ele.toString());
        log('');
      }
      for(var ele in myPromoCodesStateList){
        log(ele.toString());
        // log('');
      }
      // for(var ele in promoCodesIDList){
      //   if(ele == await CacheHelper.getData(key: 'token')){
      //     myPromoCodesIDList.add(ele);
      //     myPromoCodesList.add(promoCodesList[promoCodesIDList.indexOf(ele)]);
      //     myDiscountList.add(discountList[promoCodesIDList.indexOf(ele)]);
      //   }
      // }
      emit(GetPromoCodesSuccessState());
    }).catchError((err) {
      log(err.toString());
      emit(GetPromoCodesErrorState());
    });
  }
  saveState(drop) {
    if (drop == 'Completed') {
      dropDownValueColor = Colors.green;
      requestModel = completedOrderedProducts;
      requestOrderModel = completedOrderedProductsList;
      requestModelCountList = completedOrderedProductsCountList;
      requestModelStateList = completedOrderedProductsStateList;
      requestedOrderedProductsID = completedOrderedProductsID;
    } else if (drop == 'Scheduled') {
      dropDownValueColor = Colors.blue;
      requestModel = scheduledOrderedProducts;
      requestOrderModel = scheduledOrderedProductsList;
      requestModelCountList = scheduledOrderedProductsCountList;
      requestModelStateList = scheduledOrderedProductsStateList;
      requestedOrderedProductsID = scheduledOrderedProductsID;
    } else if (drop == 'Cancelled') {
      dropDownValueColor = Colors.red;
      requestModel = canceledOrderedProducts;
      requestOrderModel = canceledOrderedProductsList;
      requestModelCountList = canceledOrderedProductsCountList;
      requestModelStateList = canceledOrderedProductsStateList;
    } else if (drop == 'Pending') {
      dropDownValueColor = Colors.orange;
      requestModel = pendingOrderedProducts;
      requestOrderModel = pendingOrderedProductsList;
      requestModelCountList = pendingOrderedProductsCountList;
      requestModelStateList = pendingOrderedProductsStateList;
      requestedOrderedProductsID = pendingOrderedProductsID;
    } else if (drop == 'All Requests') {
      dropDownValueColor = Colors.white;
      requestModel = myOrderedProducts;
      requestOrderModel = orderedProducts;
      requestModelCountList = orderedProductsCountList;
      requestModelStateList = orderedProductsStateList;
      requestedOrderedProductsID = allOrderedProductsID;
      log(requestOrderModel.toString());
    }
  }

  signOut(context) {
    CacheHelper.removeData(
      key: 'token',
    ).then((value) {
      if (value) {
        emit(DashboardLogoutState());
        navigateAndFinish(
          context,
          const LoginScreen(),
        );
      }
    });
  }

  changeSize(size) {
    if (size == 'isS') {
      isS = !isS;
      emit(ChangeSizedState());
    } else if (size == 'isM') {
      isM = !isM;
      emit(ChangeSizedState());
    } else if (size == 'isL') {
      isL = !isL;
      emit(ChangeSizedState());
    } else if (size == 'isXL') {
      isXL = !isXL;
      emit(ChangeSizedState());
    } else if (size == 'is2XL') {
      is2XL = !is2XL;
      emit(ChangeSizedState());
    } else if (size == 'is3XL') {
      is3XL = !is3XL;
      emit(ChangeSizedState());
    } else if (size == 'is4XL') {
      is4XL = !is4XL;
      emit(ChangeSizedState());
    } else if (size == 'is5XL') {
      is5XL = !is5XL;
      emit(ChangeSizedState());
    }
  }

  removeProduct(pid) {
    List id = [];
    if (allProductsID.contains(pid)) {
      products.removeAt(productsID.indexOf(pid));
      productsID.remove(pid);
      allProductsID.remove(pid);
      log(products.toString());
      log(productsID.toString());
      log(allProductsID.toString());
      FirebaseFirestore.instance
          .collection('products')
          .doc(pid)
          .delete()
          .then((value) {
        emit(RemoveProductSuccessState());
        FirebaseFirestore.instance
            .collection('orders')
            .get()
            .then((value) {
              for (var element in value.docs) {
                if (element.data()['orderedProducts'] == pid) {
                  id.add(element.id);
                }
              }
              for (var ele in id) {
                FirebaseFirestore.instance
                    .collection('orders')
                    .doc(ele)
                    .delete()
                    .then((value) => emit(RemoveProductSuccessState()))
                    .catchError((err) {
                  log(err.toString());
                  emit(RemoveProductErrorState());
                });
              }
            })
            .then((value) => emit(RemoveProductSuccessState()))
            .catchError((err) {
              log(err.toString());
              emit(RemoveProductErrorState());
            });
      }).catchError((error) {
        emit(RemoveProductErrorState());
      });
    }
  }

  var caroIndex = 0;
  var productCaroIndex = 0;

  changeCarousel(index) {
    caroIndex = index;
    emit(ChangeCarouselState());
  }

  changeProductCarousel(index) {
    productCaroIndex = index;
    emit(ChangeCarouselState());
  }

  changeProductCarouselList() {
    emit(ChangeCarouselState());
  }

  changeToggleValue(val) {
    promoToggle = val;
    emit(ChangeToggleValueState());
  }

  changeDiscountValue(val) {
    discountToggle = val;
    emit(ChangeToggleValueState());
  }

  changeDeliveryValue(val) {
    deliveryToggle = val;
    emit(ChangeToggleValueState());
  }
  changePromoDiscountValue(val) {
    promoDiscountToggle = val;
    emit(ChangeToggleValueState());
  }

  createId(length) {
    const _chars =
        'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
    math.Random _rnd = math.Random();
    String id = String.fromCharCodes(Iterable.generate(
        length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));
    emit(ChangeToggleValueState());
    return id;
  }
}
