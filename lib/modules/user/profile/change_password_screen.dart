import 'package:egyoutfit/modules/user/profile/user_order_screen_opened.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../layout/shop_app/cubit/cubit.dart';
import '../../../layout/shop_app/cubit/states.dart';
import '../../../shared/components/components.dart';

class ChangePasswordScreen extends StatelessWidget {
  const ChangePasswordScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var formKey = GlobalKey<FormState>();
    var newPasswordController = TextEditingController();

    return BlocConsumer<ShopCubit, ShopStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.arrow_back_ios)),
          ),
          body: Form(
            key: formKey,
            child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    defaultFormField(
                        controller: newPasswordController,
                        type: TextInputType.visiblePassword,
                        label: 'New Password',
                        prefix: Icons.lock,
                    ),
                    defaultButton(function: () async {
                      await ShopCubit.get(context).updateUserPassword(newPasswordController.text,context);
                    }, text: 'Update',
                        height: 50.0,
                        width: 300,
                      isUpperCase: true
                    )
                  ],
                )),
          ),
        );
      },
    );
  }
}
