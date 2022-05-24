import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../layout/dashboard_layout/cubit/cubit.dart';
import '../../../layout/dashboard_layout/cubit/states.dart';
import '../../../shared/components/components.dart';

class UploadProductImageScreen extends StatelessWidget {
  const UploadProductImageScreen({
    Key key,
    this.pListImage,
    this.pId,
  }) : super(key: key);
  final String pId;
  final List pListImage;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<DashboardCubit, DashboardStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: const Icon(Icons.arrow_back_ios_outlined)),
          ),
          backgroundColor: Colors.white,
          body: SingleChildScrollView(
            child: Center(
              child: defaultButton(
                  function: () {
                    showDialog(
                        context: context,
                        builder: (context) => const SimpleDialog(
                              children: [CircularProgressIndicator()],
                            ));
                    List x =DashboardCubit.get(context).firebaseLinkEdit+pListImage;
                    log(x.toString());
                    DashboardCubit.get(context).updateProductImage(
                        id: pId,
                        images: x).whenComplete(() {
                      Navigator.pop(context);
                      Navigator.pop(context);
                      Navigator.pop(context);
                      Navigator.pop(context);
                      Navigator.pop(context);
                      DashboardCubit.get(context).getAllProducts();
                      DashboardCubit.get(context).getAllOrdered();
                    });

                    // DashboardCubit.get(context).firebaseLinkEdit=[];
                  },
                  text: 'upload',
                  height: 50.0,
                  width: 300.0,
                  radius: 14.0),
            ),
          ),
        );
      },
    );
  }
}
