import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../layout/dashboard_layout/cubit/cubit.dart';
import '../../../layout/dashboard_layout/cubit/states.dart';
import '../../../shared/components/components.dart';

class CreateOfferScreen extends StatelessWidget {
  const CreateOfferScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var formKey = GlobalKey<FormState>();
    var discountController = TextEditingController();
    var promoController = TextEditingController();

    return BlocProvider(
      create: (BuildContext context) => DashboardCubit(),
      child: BlocConsumer<DashboardCubit, DashboardStates>(
        listener: (context, state) {
          // if (state is CreateProductSuccessState) {
          // }
        },
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(),
            backgroundColor: Colors.white,
            body: SafeArea(
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(
                      height: 15.0,
                    ),
                    SingleChildScrollView(
                      child: Form(
                        key: formKey,
                        child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Column(
                            children: [
                              Row(children: const [
                                Text('Promo Code'),
                              ]),
                              defaultFormField(
                                type: TextInputType.text,
                                prefix: Icons.local_offer_outlined,
                                isValidate: true,
                                validate: (value) {
                                  if (value.isEmpty) {
                                    return 'please enter Promo Code ';
                                  }
                                },
                                isPassword: false,
                                controller: promoController,
                                label: "Promo Code",
                              ),
                              const SizedBox(
                                height: 15.0,
                              ),
                              Row(
                                children: [
                                  const Text(
                                    'Discount:',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w900,
                                        fontSize: 15.0,
                                        color: Colors.black45),
                                  ),
                                  Switch(
                                      value: DashboardCubit.get(context)
                                          .promoDiscountToggle,
                                      onChanged: (v) {
                                        DashboardCubit.get(context)
                                            .changePromoDiscountValue(v);
                                      }),
                                ],
                              ),
                              defaultFormField(
                                type: TextInputType.number,
                                prefix: Icons.local_offer_outlined,
                                isValidate: true,
                                validate: (value) {
                                  if (value.isEmpty) {
                                    if (DashboardCubit.get(context)
                                        .promoDiscountToggle) {
                                      return 'please enter discount ';
                                    }
                                  }
                                },
                                isClickable: DashboardCubit.get(context)
                                    .promoDiscountToggle,
                                isPassword: false,
                                controller: discountController,
                                label: "Discount %",
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const Expanded(child: SizedBox()),
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: defaultButton(
                          function: () {
                            if (formKey.currentState.validate()) {
                              log('message');
                              DashboardCubit.get(context).createPromo(
                                discount: int.parse(discountController.text),
                                isDiscount: DashboardCubit.get(context)
                                    .promoDiscountToggle,
                                promo: promoController.text.toUpperCase(),
                              );
                              DashboardCubit.get(context).getAllProducts();
                              DashboardCubit.get(context).getAllOrdered();
                              DashboardCubit.get(context).getPromoCodes();
                              Navigator.pop(context);
                            }
                          },
                          text: 'Submit',
                          isUpperCase: true,
                          width: 300.0,
                          height: 50.0,
                          radius: 15.0),
                    )
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
