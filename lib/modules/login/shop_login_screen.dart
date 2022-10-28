// ignore_for_file: prefer_const_constructors, avoid_print, use_key_in_widget_constructors, must_be_immutable, unused_import

import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shop_app/shared/components/constants.dart';

import '../../layout/shop_layout/shop_layout.dart';
import '../../shared/components/components.dart';
import '../../shared/network/local/cache_helper.dart';
import '../register/shop_register_screen.dart';
import 'cubit/cubit.dart';
import 'cubit/states.dart';

class ShopLoginScreen extends StatelessWidget {
  ShopLoginScreen({super.key});

  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => ShopLoginCubit(),
      child: BlocConsumer<ShopLoginCubit, ShopLoginStates>(
        listener: (BuildContext context, state)
        {
          if(state is ShopLoginSuccessState){
            if(state.loginModel.status)
            {
              print(state.loginModel.message);
              print(state.loginModel.data!.token);

              CacheHelper.saveData(
                  key: 'token',
                  value: state.loginModel.data!.token
              ).then((value){
                token = state.loginModel.data!.token!;
                navigateAndFinish(context, ShopLayout());
              });

            }else
            {
              print(state.loginModel.message);
              showToast(
                text: "${state.loginModel.message}",
                state: ToastStates.ERROR,
              );
            }
          }
        },
        builder: (BuildContext context, state) {
          ShopLoginCubit cubit = ShopLoginCubit.get(context);
          return Scaffold(
            appBar: AppBar(),
            body: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Center(
                child: SingleChildScrollView(
                  child: Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'LOGIN',
                          style:
                          Theme.of(context).textTheme.headline3?.copyWith(
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Jannah',
                            color: Colors.black,
                          ),
                        ),
                        Text(
                          'Login now to browse our list of highest trending products.',
                          style:
                          Theme.of(context).textTheme.subtitle1?.copyWith(
                            // fontSize: 30.0,
                          ),
                        ),
                        SizedBox(
                          height: 35.0.h,
                        ),
                        defaultFormField(
                          controller: emailController,
                          keyboardType: TextInputType.emailAddress,
                          validate: (value)
                          {
                            if (value == null || value.isEmpty)
                            {
                              return 'Please enter your valid email';
                            }
                            return null;
                          },
                          labelText: 'Email Address',
                          prefix: Icons.email_outlined,
                        ),

                        // TextFormField(
                        //   controller: emailController,
                        //   validator: (value) {
                        //     if (value == null || value.isEmpty) {
                        //       return 'Please enter your valid email';
                        //     }
                        //     return null;
                        //   },
                        //   keyboardType: TextInputType.emailAddress,
                        //   decoration: InputDecoration(
                        //     prefixIcon: Icon(Icons.email_outlined),
                        //     border: OutlineInputBorder(
                        //       borderRadius: BorderRadius.circular(25.0),
                        //     ),
                        //     labelText: 'Email Address',
                        //   ),
                        // ),
                        SizedBox(
                          height: 16.0,
                        ),
                        // TextFormField(
                        //   controller: passwordController,
                        //   validator: (value) {
                        //     if (value == null || value.isEmpty) {
                        //       return 'Please enter your valid password';
                        //     }
                        //     return null;
                        //   },
                        //   onFieldSubmitted: (value){
                        //     if (formKey.currentState!.validate()) {
                        //       cubit.userLogin(
                        //         email: emailController.text,
                        //         password: passwordController.text,
                        //       );
                        //     }
                        //   },
                        //   keyboardType: TextInputType.visiblePassword,
                        //   decoration: InputDecoration(
                        //     prefixIcon: Icon(Icons.lock_outline_rounded),
                        //     suffixIcon: IconButton(
                        //       icon: Icon(Icons.visibility),
                        //       onPressed: () {
                        //
                        //       },
                        //     ),
                        //     border: OutlineInputBorder(
                        //       borderRadius: BorderRadius.circular(25.0),
                        //     ),
                        //     labelText: 'Password',
                        //   ),
                        // ),
                        defaultFormField(
                          controller: passwordController,
                          keyboardType: TextInputType.visiblePassword,
                          validate: (value)
                          {
                            if (value == null || value.isEmpty)
                            {
                              return 'Please enter your valid password';
                            }
                            return null;
                          },
                          onSubmit: (value){
                            if (formKey.currentState!.validate()) {
                              cubit.userLogin(
                                email: emailController.text,
                                password: passwordController.text,
                              );
                            }
                          },
                          labelText: 'Password',
                          isPassword: cubit.isPassword,
                          prefix: Icons.lock_outline,
                          suffix: cubit.suffix,
                          suffixPressed: (){
                            cubit.changePasswordVisibility();
                          },
                        ),
                        SizedBox(
                          height: 20.0.h,
                        ),
                        ConditionalBuilder(
                          condition: state is! ShopLoginLoadingState,
                          builder: (BuildContext context) => defaultButton(
                            text: 'login',
                            radius: 10.0,
                            function: () {
                              if (formKey.currentState!.validate()) {
                                cubit.userLogin(
                                  email: emailController.text,
                                  password: passwordController.text,
                                );
                              }
                            },
                          ),
                          fallback: (BuildContext context) =>
                              Center(child: CircularProgressIndicator()),
                        ),
                        SizedBox(
                          height: 10.0.h,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Don\'t have an account?',
                            ),
                            TextButton(
                                onPressed: () {
                                  navigateTo(context, ShopRegisterScreen());
                                },
                                child: Text('Register Now')),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
