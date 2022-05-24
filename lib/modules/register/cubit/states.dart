
import '../../../models/user/user_model.dart';

abstract class ShopRegisterStates {}

class ShopRegisterInitialState extends ShopRegisterStates {}

class ShopRegisterLoadingState extends ShopRegisterStates {}

class ShopRegisterSuccessState extends ShopRegisterStates {}

class ShopCreateUserSuccessState extends ShopRegisterStates {
  final UserModel userModel;

  ShopCreateUserSuccessState(this.userModel);
}

class ShopRegisterErrorState extends ShopRegisterStates
{
  final String error;

  ShopRegisterErrorState(this.error);
}
class ShopCreateUserErrorState extends ShopRegisterStates
{
  final String error;

  ShopCreateUserErrorState(this.error);
}

class ShopRegisterChangePasswordVisibilityState extends ShopRegisterStates {}

class ShopRegisterChangeDropValueState extends ShopRegisterStates {}
