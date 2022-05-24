import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../layout/shop_app/cubit/cubit.dart';
import '../../../layout/shop_app/cubit/states.dart';
import '../../../shared/components/components.dart';

class SettingsScreen extends StatefulWidget {

  const SettingsScreen({Key key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  var formKey = GlobalKey<FormState>();

  var nameController = TextEditingController();

  var emailController = TextEditingController();

  var phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopCubit, ShopStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var model = ShopCubit.get(context).loginModel;
        if (model != null) {
          nameController.text = model.firstName;
          emailController.text = model.email;
          phoneController.text = model.phone;
        }
        return Scaffold(
          appBar: AppBar(),
          body: ConditionalBuilder(
            condition: ShopCubit.get(context).loginModel != null,
            builder: (context) => Padding(
              padding: const EdgeInsets.all(20.0),
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (state is ShopLoadingUpdateUserState)
                      const LinearProgressIndicator(),
                    const CircleAvatar(
                      radius: 50.0,
                      backgroundColor: Colors.grey,
                      child:  Icon(Icons.person)
                    ),
                    const SizedBox(
                      height: 20.0,
                    ),
                    defaultFormField(
                      controller: nameController,
                      type: TextInputType.name,
                      validate: (String value) {
                        if (value.isEmpty) {
                          return 'name must not be empty';
                        }

                        return null;
                      },
                      label: 'Name',
                      prefix: Icons.person,
                    ),
                    const SizedBox(
                      height: 20.0,
                    ),
                    defaultFormField(
                      controller: emailController,
                      type: TextInputType.emailAddress,
                      validate: (String value) {
                        if (value.isEmpty) {
                          return 'email must not be empty';
                        }

                        return null;
                      },
                      label: 'Email Address',
                      prefix: Icons.email,
                    ),
                    const SizedBox(
                      height: 20.0,
                    ),
                    defaultFormField(
                      controller: phoneController,
                      type: TextInputType.phone,
                      validate: (String value) {
                        if (value.isEmpty) {
                          return 'phone must not be empty';
                        }

                        return null;
                      },
                      label: 'Phone',
                      prefix: Icons.phone,
                    ),
                    const SizedBox(
                      height: 20.0,
                    ),
                    defaultButton(
                      height: 60.0,
                      radius: 14.0,
                      function: () {
                        // if (formKey.currentState.validate()) {
                        //   ShopCubit.get(context).updateUserData(
                        //     name: nameController.text,
                        //     phone: phoneController.text,
                        //     email: emailController.text,
                        //   );
                        // }

                      },
                      text: 'update',
                    ),
                    const SizedBox(
                      height: 20.0,
                    ),
                    defaultButton(
                      height: 60.0,
                      radius: 14.0,
                      function: () {
                        ShopCubit.get(context).signOut(context);
                      },
                      text: 'Logout',
                    ),
                  ],
                ),
              ),
            ),
            fallback: (context) => const Center(child: CircularProgressIndicator()),
          ),
        );
      },
    );
  }
}
