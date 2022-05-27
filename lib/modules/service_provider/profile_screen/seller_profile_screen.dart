import 'dart:developer';
import 'dart:io';

import 'package:conditional_builder/conditional_builder.dart';
import 'package:egyoutfit/layout/dashboard_layout/cubit/cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import '../../../layout/dashboard_layout/cubit/states.dart';

import '../../../models/shop_app/login_model.dart';
import '../../../shared/components/components.dart';

class SellerProfileScreen extends StatefulWidget {
  const SellerProfileScreen({Key key, this.logModel}) : super(key: key);
  final ShopLoginModel logModel;

  @override
  State<SellerProfileScreen> createState() => _SellerProfileScreenState();
}

class _SellerProfileScreenState extends State<SellerProfileScreen> {
  var formKey = GlobalKey<FormState>();

  var nameController = TextEditingController();

  var addressController = TextEditingController();

  var organizationController = TextEditingController();

  var phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    ValueNotifier<bool> isDialOpen = ValueNotifier(false);

    log(widget.logModel.uId);
    return BlocConsumer<DashboardCubit, DashboardStates>(
      listener: (context, state) {},
      builder: (context, state) {
        if (widget.logModel != null) {
          nameController.text = widget.logModel.firstName;
          organizationController.text = widget.logModel.organization;
          phoneController.text = widget.logModel.phone;
          addressController.text = widget.logModel.address;
        }
        return WillPopScope(
          onWillPop: () async {
            if (isDialOpen.value) {
              isDialOpen.value = false;
              return false;
            } else {
              return true;
            }
          },
          child: Scaffold(
            appBar: AppBar(
              leading: IconButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: const Icon(Icons.arrow_back_ios_outlined)),
            ),
            body: ConditionalBuilder(
              condition: widget.logModel.image != null,
              builder: (context) => SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Form(
                    key: formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (state is LoadingUploadImageState)
                          const LinearProgressIndicator(),
                        widget.logModel.image != null
                            ? Stack(
                                children: [
                                  DashboardCubit.get(context).image == null
                                      ? CircleAvatar(
                                          radius: 80.0,
                                          backgroundColor: Colors.grey,
                                          backgroundImage: NetworkImage(
                                              widget.logModel.image),
                                          child: const Icon(Icons.person),
                                        )
                                      : CircleAvatar(
                                          radius: 80.0,
                                          backgroundColor: Colors.grey,
                                          backgroundImage: Image.file(
                                            File(
                                              DashboardCubit.get(context).image,
                                            ),
                                          ).image,
                                        ),
                                  Positioned(
                                    bottom: 2.0,
                                    right: 2.0,
                                    child: SizedBox(
                                      width: 50.0,
                                      height: 50.0,
                                      child: SpeedDial(
                                        animatedIcon: AnimatedIcons.menu_close,
                                        openCloseDial: isDialOpen,
                                        backgroundColor: Colors.blueAccent,
                                        overlayColor: Colors.grey,
                                        overlayOpacity: 0.5,
                                        spacing: 15,
                                        spaceBetweenChildren: 15,
                                        closeManually: true,
                                        children: [
                                          SpeedDialChild(
                                              child: const Icon(
                                                Icons.image,
                                              ),
                                              label: 'Photos',
                                              onTap: () {
                                                DashboardCubit.get(context)
                                                    .getImage(false);
                                              }),
                                          SpeedDialChild(
                                              child: const Icon(
                                                Icons.camera_alt_outlined,
                                              ),
                                              label: 'Camera',
                                              onTap: () {
                                                DashboardCubit.get(context)
                                                    .getImage(true);
                                              }),
                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              )
                            : const Icon(Icons.person),
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
                          controller: addressController,
                          type: TextInputType.text,
                          validate: (String value) {
                            if (value.isEmpty) {
                              return 'address must not be empty';
                            }

                            return null;
                          },
                          label: 'Address',
                          prefix: Icons.location_on_rounded,
                        ),
                        const SizedBox(
                          height: 20.0,
                        ),
                        defaultFormField(
                          controller: organizationController,
                          type: TextInputType.text,
                          validate: (String value) {
                            if (value.isEmpty) {
                              return 'Organization must not be empty';
                            }

                            return null;
                          },
                          label: 'Organization',
                          prefix: Icons.home_repair_service,
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
                            if (formKey.currentState.validate()) {
                              if(DashboardCubit.get(context).image!=null) {
                                DashboardCubit.get(context)
                                  .uploadProfileImageToFireBase(
                                uid: widget.logModel.uId,
                                name: nameController.text,
                                phone: phoneController.text,
                                organization: organizationController.text,
                                address: addressController.text,
                                context: context,
                              );
                              }else{
                                DashboardCubit.get(context)
                                    .updateSellerData(
                                  uid: widget.logModel.uId,
                                  name: nameController.text,
                                  phone: phoneController.text,
                                  organization: organizationController.text,
                                  address: addressController.text,
                                  image: DashboardCubit.get(context)
                                      .firebaseImagesEdit,
                                  context: context,
                                );
                              }
                            }
                          },
                          text: 'update',
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              fallback: (context) =>
                  const Center(child: CircularProgressIndicator()),
            ),
          ),
        );
      },
    );
  }
}
