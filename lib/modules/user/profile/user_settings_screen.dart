import 'package:conditional_builder/conditional_builder.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:egyoutfit/translations/locale_keys.g.dart';
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

  var firstNameController = TextEditingController();

  var secondNameController = TextEditingController();

  var addressController = TextEditingController();

  var phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopCubit, ShopStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var model = ShopCubit.get(context).loginModel;
        if (model != null) {
          firstNameController.text = model.firstName;
          secondNameController.text = model.secondName;
          addressController.text = model.address;
          phoneController.text = model.phone;
        }
        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.arrow_back_ios)),
          ),
          body: ConditionalBuilder(
            condition: ShopCubit.get(context).loginModel != null,
            builder: (context) => Padding(
              padding: const EdgeInsets.all(20.0),
              child: Form(
                key: formKey,
                child: SingleChildScrollView(
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
                        controller: firstNameController,
                        type: TextInputType.name,
                        validate: (String value) {
                          if (value.isEmpty) {
                            return LocaleKeys.userAccountScreen_firstNameMustNotBeEmpty.tr();
                          }

                          return null;
                        },
                        label: LocaleKeys.userAccountScreen_firstName.tr(),
                        prefix: Icons.person,
                      ),
                      const SizedBox(
                        height: 20.0,
                      ),
                      defaultFormField(
                        controller: secondNameController,
                        type: TextInputType.name,
                        validate: (String value) {
                          if (value.isEmpty) {
                            return LocaleKeys.userAccountScreen_lastNameMustNotBeEmpty.tr();
                          }

                          return null;
                        },
                        label: LocaleKeys.userAccountScreen_lastName.tr(),
                        prefix: Icons.person,
                      ),
                      const SizedBox(
                        height: 20.0,
                      ),
                      defaultFormField(
                        controller: addressController,
                        type: TextInputType.text,
                        validate: (String value) {
                          if (value.isEmpty) {
                            return LocaleKeys.userCartScreen_addressMustNotBeEmptyValidation.tr();
                          }

                          return null;
                        },
                        label: LocaleKeys.userAccountScreen_address.tr(),
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
                            return LocaleKeys.userCartScreen_phoneMustNotBeEmpty.tr();
                          }

                          return null;
                        },
                        label: LocaleKeys.userAccountScreen_phone.tr(),
                        prefix: Icons.phone,
                      ),
                      const SizedBox(
                        height: 20.0,
                      ),
                      defaultButton(
                        height: 60.0,
                        radius: 14.0,
                        function: () {
                          if (formKey.currentState.validate()) {
                            ShopCubit.get(context).updateUserData(
                              nameFirst: firstNameController.text,
                              nameSecond: secondNameController.text,
                              phone: phoneController.text,
                              address: addressController.text,
                              context: context,
                              uid: model.uId,
                            );
                          }

                        },
                        text: LocaleKeys.userAccountScreen_update.tr(),
                      ),
                      
                    ],
                  ),
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
