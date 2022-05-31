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
                    defaultButton(
                        function: () async {
                          await ShopCubit.get(context).changeUserPassword(
                              newPasswordController.text, context);
                        },
                        text: 'Update',
                        height: 50.0,
                        width: 300,
                        isUpperCase: true)
                  ],
                )),
          ),
        );
      },
    );
  }
}

//                           ),
//                           defaultFormField(
//                             controller: secondNameController,
//                             type: TextInputType.text,
//                             label: 'Second Name',
//                             prefix: Icons.person,
//                           ),
//                           defaultFormField(
//                             controller: addressController,
//                             type: TextInputType.text,
//                             label: 'Address',
//                             prefix: Icons.location_on,
//                           ),
//                           defaultFormField(
//                             controller: phoneController,
//                             type: TextInputType.number,
//                             label: 'Phone',
//                             prefix: Icons.phone,
//                           ),
//                           defaultButton(
//                               function: () async {
//                                 await ShopCubit.get(context).updateUser(
//                                     firstNameController.text,
//                                     secondNameController.text,
//                                     addressController.text,
//                                     phoneController.text,
//                                     context);
//                               },
//                               text: 'Update',
//                               height: 50.0,
//                               width: 300,
//                               isUpperCase: true),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           );
//         }
//         return Scaffold(
//           appBar: AppBar(),
//           body: Center(
//             child: Text('Please login to see your profile'),
//           ),
//         );
//       },
//     );
//   }
// }
