

import '../../../models/shop_app/change_favorites_model.dart';
import '../../../models/shop_app/login_model.dart';

abstract class ShopStates {}

class ShopInitialState extends ShopStates {}

class ShopChangeBottomNavState extends ShopStates {}

class ShopLoadingHomeDataState extends ShopStates {}

class ShopSuccessHomeDataState extends ShopStates {}

class ShopErrorHomeDataState extends ShopStates {}

class ShopSuccessCategoriesState extends ShopStates {}

class ShopErrorCategoriesState extends ShopStates {}

class ShopChangeFavoritesState extends ShopStates {}

class ShopSuccessChangeFavoritesState extends ShopStates {
  final ChangeFavoritesModel model;

  ShopSuccessChangeFavoritesState(this.model);
}

class ShopErrorChangeFavoritesState extends ShopStates {}

class ShopLoadingGetFavoritesState extends ShopStates {}

class ShopSuccessGetFavoritesState extends ShopStates {}

class ShopErrorGetFavoritesState extends ShopStates {}

class ShopLoadingUserDataState extends ShopStates {}

class ShopSuccessUserDataState extends ShopStates {
  final ShopLoginModel loginModel;

  ShopSuccessUserDataState(this.loginModel);
}

class ShopErrorUserDataState extends ShopStates {}

class ShopLoadingUpdateUserState extends ShopStates {}

class ShopSuccessUpdateUserState extends ShopStates {
  final ShopLoginModel loginModel;

  ShopSuccessUpdateUserState(this.loginModel);
}

class ShopErrorUpdateUserState extends ShopStates {}

class SearchLoadingState extends ShopStates {}

class SearchSuccessState extends ShopStates {}

class SearchErrorState extends ShopStates {}

class ChangeDropState extends ShopStates {}

class ChangeModelState extends ShopStates {}

class GetOffersSuccessState extends ShopStates {}

class GetOffersErrorState extends ShopStates {}

class GetProductsSuccessState extends ShopStates {}

class GetProductsErrorState extends ShopStates {}

class GetProductsLoadingState extends ShopStates {}

class ShopLoginLoadingState extends ShopStates {}
class GetCartPriceState extends ShopStates {}

class ShopLoginSuccessState extends ShopStates
{
  final ShopLoginModel loginModel;

  ShopLoginSuccessState(this.loginModel);
}

class ShopLoginErrorState extends ShopStates
{
  final String error;

  ShopLoginErrorState(this.error);
}

class AddFavouritesSuccessState extends ShopStates {}

class AddFavouritesErrorState extends ShopStates {}

class UpdateFavouritesSuccessState extends ShopStates {}

class UpdateFavouritesErrorState extends ShopStates {}

class RemoveFavouritesSuccessState extends ShopStates {}

class RemoveFavouritesErrorState extends ShopStates {}

class AddCartSuccessState extends ShopStates {}

class AddCartErrorState extends ShopStates {}

class UpdateCartSuccessState extends ShopStates {}

class UpdateCartErrorState extends ShopStates {}

class RemoveCartSuccessState extends ShopStates {}

class RemoveCartErrorState extends ShopStates {}

class ChangeCounterState extends ShopStates {}

class ChangeCartPriceState extends ShopStates {}

class ChangeCartProductPriceState extends ShopStates {}

class CreateOrderSuccessState extends ShopStates {}

class CreateOrderErrorState extends ShopStates {}

class CreateOrderLoadingState extends ShopStates {}

class ShopLogoutState extends ShopStates {}

class UpdateStateLoadingShopState extends ShopStates {}

class UpdateStateSuccessShopState extends ShopStates {}

class UpdateStateErrorShopState extends ShopStates {}

class ChangePaymentMethodState extends ShopStates {}

class ChangeCartCounterState extends ShopStates {}

class ChangeCarouselState extends ShopStates {}

class ChangeLanguageState extends ShopStates {}

class ChangeSizedState extends ShopStates {}

class GetPromoCodesLoadingState extends ShopStates {}

class GetPromoCodesSuccessState extends ShopStates {}

class GetPromoCodesErrorState extends ShopStates {}

class ShopSendMessagesSuccessState extends ShopStates {}

class ShopSendMessagesErrorState extends ShopStates {}

class ShopGetAllMessagesSuccessState extends ShopStates {}

class LoadingPickImageState extends ShopStates {}

class SuccessPickImageState extends ShopStates {}

class ErrorPickImageState extends ShopStates {}

class LoadingUploadImageState extends ShopStates {}

class SuccessUploadImageState extends ShopStates {}

class ErrorUploadImageState extends ShopStates {}

class GetSellerIDLoadingState extends ShopStates {}

class GetSellerIDSuccessState extends ShopStates {}
