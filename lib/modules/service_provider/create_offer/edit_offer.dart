import 'dart:developer';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../layout/dashboard_layout/cubit/cubit.dart';
import '../../../layout/dashboard_layout/cubit/states.dart';
import '../../../shared/components/components.dart';

class EditOfferScreen extends StatelessWidget {
  const EditOfferScreen(
      {Key key, this.state, this.promo, this.discount, this.id})
      : super(key: key);
  final String promo;
  final String state;
  final num discount;
  final String id;

  @override
  Widget build(BuildContext context) {
    var formKey = GlobalKey<FormState>();
    var discountController = TextEditingController();
    var promoController = TextEditingController();
    discountController.text = discount.toString();
    promoController.text = promo;
    log(state);
    log(id);
    if (state == 'Active') {
      DashboardCubit.get(context).promoDiscountToggle = true;
    } else if (state == 'NotActive') {
      DashboardCubit.get(context).promoDiscountToggle = false;
    }

    return BlocConsumer<DashboardCubit, DashboardStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            actions: [
              IconButton(
                onPressed: () async {
                  AwesomeDialog(
                      context: context,
                      dialogType: DialogType.WARNING,
                      animType: AnimType.BOTTOMSLIDE,
                      title: 'Warning',
                      desc:
                          'Your Offer will be deleted if you want to continue press ok.',
                      btnOkOnPress: () async {
                        await DashboardCubit.get(context).deletePromo(id);
                        await DashboardCubit.get(context).getPromoCodes();
                        DashboardCubit.get(context)
                            .changePromoDiscountValue(false);
                        Navigator.pop(context);
                        // Navigator.of(context).pop();
                      },
                      btnCancelOnPress: () {
                        // Navigator.pop(context);
                      }).show();
                },
                icon: const Icon(Icons.delete),
              ),
            ],
          ),
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
                            Row(
                              children: const [
                                Text('Promo Code'),
                              ],
                            ),
                            defaultFormField(
                              type: TextInputType.text,
                              prefix: Icons.local_offer_outlined,
                              isValidate: true,
                              onChange: (String v) {
                                promoController.text.toUpperCase();

                                if (v.length > 6) {
                                  log('true');
                                  promoController.text = promoController.text
                                      .substring(
                                          0, promoController.text.length - 1);
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
                                  },
                                ),
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
                      function: () async {
                        if (formKey.currentState.validate()) {
                          log('message');
                          DashboardCubit.get(context).updatePromo(
                            id: id,
                            discount: int.parse(discountController.text),
                            isDiscount:
                                DashboardCubit.get(context).promoDiscountToggle,
                            promo: promoController.text.toUpperCase(),
                          );
                          DashboardCubit.get(context)
                              .changePromoDiscountValue(false);
                          await DashboardCubit.get(context).getPromoCodes();
                          Navigator.pop(context);
                        }
                      },
                      text: 'Submit',
                      isUpperCase: true,
                      width: 300.0,
                      height: 50.0,
                      radius: 15.0,
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
