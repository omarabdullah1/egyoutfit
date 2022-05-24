import 'dart:developer';
import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../layout/dashboard_layout/dashboard_layout.dart';
import '../../layout/shop_app/shop_layout.dart';
import '../../shared/components/components.dart';
import '../../shared/components/constants.dart';
import '../../shared/network/local/cache_helper.dart';
import '../register/register_screen.dart';
import 'cubit/cubit.dart';
import 'cubit/states.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  var emailController = TextEditingController();

  var passwordController = TextEditingController();

  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
  create: (context) => ShopLoginCubit(),
  child: BlocConsumer<ShopLoginCubit, ShopLoginStates>(
      listener: (context, state) {
        if (state is ShopLoginSuccessState) {
          log(state.loginModel.firstName);
          log(state.loginModel.uId);

          CacheHelper.saveData(
            key: 'token',
            value: state.loginModel.uId,
          ).then((value) {
            CacheHelper.saveData(key: 'user', value: emailController.text);
            CacheHelper.saveData(key: 'pass', value: passwordController.text);
            CacheHelper.saveData(
                key: 'isSeller', value: state.loginModel.isSeller);
            token = state.loginModel.uId;
            showToast(text: 'Login Successfully', state: ToastStates.success);
            state.loginModel.isSeller
                ? navigateAndFinish(
                    context,
                    const DashboardLayout(),
                  )
                : navigateAndFinish(
                    context,
                    const ShopLayout(),
                  );
          });

        }
      },
      builder: (context, state) {
        return Scaffold(
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 60.0,),
                  const Center(
                    child: Image(
                      image: AssetImage(
                        'assets/images/logo black.png',
                      ),
                      width: 125,
                      height: 125,
                    ),
                  ),
                  // const SizedBox(
                  //   height: 20.0,
                  // ),
                  Form(
                    key: formKey,
                    child: Column(
                      children: [
                        const Text(
                          'Login to your account',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 32.0,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        const SizedBox(
                          height: 30.0,
                        ),
                        defaultFormField(
                          controller: emailController,
                          type: TextInputType.emailAddress,
                          validate: (String value) {
                            if (value.isEmpty) {
                              return 'please enter your email address';
                            }
                          },
                          label: 'Email Address',
                          prefix: Icons.email_outlined,
                        ),
                        const SizedBox(
                          height: 20.0,
                        ),
                        defaultFormField(
                          controller: passwordController,
                          type: TextInputType.visiblePassword,
                          suffix: ShopLoginCubit.get(context).suffix,
                          onSubmit: (value) {
                            if (formKey.currentState.validate()) {
                              ShopLoginCubit.get(context).userLogin(
                                email: emailController.text,
                                password: passwordController.text,
                                context: context,
                              );
                            }
                          },
                          isPassword: ShopLoginCubit.get(context).isPassword,
                          suffixPressed: () {
                            ShopLoginCubit.get(context)
                                .changePasswordVisibility();
                          },
                          validate: (String value) {
                            if (value.isEmpty) {
                              return 'password must not to be Empty';
                            }
                          },
                          label: 'Password',
                          prefix: Icons.lock_outline,
                        ),
                        Container(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            style: TextButton.styleFrom(
                              textStyle: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                            ),
                            onPressed: () {},
                            child: const Text(
                              'Forget password ?',
                              style: TextStyle(color: Colors.deepOrange),
                            ),
                          ),
                        ),
                        state is ShopLoginErrorState
                            ? const Text(
                                'Invalid username or password !',
                                style: TextStyle(
                                    fontSize: 16.0, color: Colors.red),
                              )
                            : const SizedBox(
                                height: 1.0,
                              ),
                        const SizedBox(
                          height: 10.0,
                        ),
                        ConditionalBuilder(
                          condition: state is! ShopLoginLoadingState,
                          fallback: (context) =>
                              const Center(child: CircularProgressIndicator()),
                          builder: (context) => Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 70),
                            child: MaterialButton(
                              height: 55,
                              minWidth: 340,
                              elevation: 5.0,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20)),
                              onPressed: () {
                                if (formKey.currentState.validate()) {
                                  ShopLoginCubit.get(context).userLogin(
                                    email: emailController.text,
                                    password: passwordController.text,
                                    context: context,
                                  );
                                }
                                // Navigator.push(context,MaterialPageRoute(builder: (context)=> RegisterScreen()));
                              },
                              child: const Text(
                                "Sign In",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              color: Colors.black,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10.0,
                        ),
                        const Center(
                          child: Text(
                            'Or Sign In With',
                            style: TextStyle(
                              color: Colors.grey,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20.0,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            MaterialButton(
                              shape: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                                borderSide: const BorderSide(
                                  color: Colors.black26,
                                ),
                              ),
                              minWidth: 150.0,
                              height: 40,
                              onPressed: () {},
                              child: Row(
                                children: const [
                                  Image(
                                    image:
                                        AssetImage('assets/images/google.png'),
                                    width: 25,
                                    height: 23,
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    'Google',
                                    style: TextStyle(color: Colors.black45),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(
                              width: 10.0,
                            ),
                            MaterialButton(
                              shape: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                                borderSide: const BorderSide(
                                  color: Colors.black26,
                                ),
                              ),
                              minWidth: 150.0,
                              height: 40,
                              onPressed: () {},
                              child: Row(
                                children: const [
                                  Image(
                                    image: AssetImage(
                                        'assets/images/facebook.png'),
                                    width: 25,
                                    height: 25,
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    'Facebook',
                                    style: TextStyle(color: Colors.black45),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 10.0,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              'Don\'t have account ?',
                              style: TextStyle(
                                color: Colors.black,
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                navigateTo(context, const RegisterScreen());
                              },
                              child: const Text('Sign Up',
                                  style: TextStyle(
                                      color: Colors.deepOrange,
                                      fontWeight: FontWeight.bold)),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
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
