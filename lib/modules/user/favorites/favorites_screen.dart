import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../layout/shop_app/cubit/cubit.dart';
import '../../../layout/shop_app/cubit/states.dart';
import '../../../shared/components/components.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({Key key}) : super(key: key);

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  @override
  void initState() {
    ShopCubit.get(context).getFavourite();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopCubit, ShopStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return ShopCubit.get(context).favorites.isEmpty ||
                ShopCubit.get(context).favorites == null
            ? const Center(
                child: Text('No Products added to favourites'),
              )
            : ListView.separated(
                itemBuilder: (context, index) => buildListProduct(
                  context: context,
                  model: ShopCubit.get(context).favoritesModel[index],
                  // index: index,
                  idList: ShopCubit.get(context).favorites,
                  index: index,
                ),
                separatorBuilder: (context, index) => myDivider(),
                itemCount: ShopCubit.get(context).favoritesModel.length,
              );
      },
    );
  }
}
