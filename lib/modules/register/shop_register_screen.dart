// ignore_for_file: prefer_const_constructors, must_be_immutable, avoid_print

import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shop_app/layout/shop_layout/shop_layout.dart';
import 'package:shop_app/modules/register/cubit/cubit.dart';
import 'package:shop_app/modules/register/cubit/states.dart';
import 'package:shop_app/shared/components/constants.dart';

import '../../shared/components/components.dart';
import '../../shared/network/local/cache_helper.dart';

class ShopRegisterScreen extends StatelessWidget {
  ShopRegisterScreen({Key? key}) : super(key: key);

  var formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => ShopRegisterCubit(),
      child: BlocConsumer<ShopRegisterCubit, ShopRegisterStates>(
        listener: (context, state)
        {
          if (state is ShopRegisterSuccessState)
          {
            if(state.loginModel.status)
            {
              print(state.loginModel.message);
              print(state.loginModel.data!.token);
              CacheHelper.saveData(
                  key: 'token',
                  value: state.loginModel.data!.token).then((value){
                    token = state.loginModel.data!.token!;
                    navigateAndFinish(context, ShopLayout());
              });
            }else{
              showToast(text: "${state.loginModel.message}",
                  state: ToastStates.ERROR
              );
            }
          }
        },
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(),
            body: Padding(
              padding: EdgeInsets.all(10.0.sp),
              child: Center(
                child: SingleChildScrollView(
                  child: Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Register',
                          style:
                              Theme.of(context).textTheme.headline3?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Jannah',
                                    color: Colors.black,
                                  ),
                        ),
                        Text(
                          'Register now to browse our list of highest trending products.',
                          style:
                              Theme.of(context).textTheme.subtitle1?.copyWith(
                                  // fontSize: 30.0,
                                  ),
                        ),
                        SizedBox(
                          height: 25.0.h,
                        ),
                        //User Name
                        defaultFormField(
                          controller: _nameController,
                          keyboardType: TextInputType.name,
                          validate: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your name';
                            }
                            return null;
                          },
                          labelText: 'User Name',
                          prefix: Icons.person,
                        ),
                        SizedBox(
                          height: 1.0.h,
                        ),
                        //Email Address
                        defaultFormField(
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            validate: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your email';
                              }
                              return null;
                            },
                            labelText: 'Email Address',
                            prefix: Icons.email),
                        SizedBox(
                          height: 1.0.h,
                        ),
                        //Password
                        defaultFormField(
                            controller: _passwordController,
                            keyboardType: TextInputType.visiblePassword,
                            validate: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Password is too short';
                              }
                              return null;
                            },
                            onSubmit: (value) {},
                            labelText: 'Password',
                            prefix: Icons.password),
                        SizedBox(
                          height: 1.0.h,
                        ),
                        //Phone Number
                        defaultFormField(
                          controller: _phoneController,
                          keyboardType: TextInputType.number,
                          validate: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your phone number';
                            }
                            return null;
                          },
                          labelText: 'Phone Number',
                          prefix: Icons.phone,
                        ),
                        ConditionalBuilder(
                          condition: state is! ShopRegisterLoadingState,
                          builder: (BuildContext context) => defaultButton(
                            text: 'register',
                            radius: 10.0.sp,
                            function: () {
                              if (formKey.currentState!.validate())
                              {
                                ShopRegisterCubit.get(context).userRegister(
                                  name: _nameController.text,
                                  email: _emailController.text,
                                  password: _passwordController.text,
                                  phone: _phoneController.text,
                                );
                              }
                            },
                          ),
                          fallback: (BuildContext context) => Center(child: CircularProgressIndicator()),
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
