// ignore_for_file: prefer_const_constructors

import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shop_app/layout/shop_layout/cubit/cubit.dart';
import 'package:shop_app/layout/shop_layout/cubit/states.dart';
import 'package:shop_app/shared/components/components.dart';
import 'package:shop_app/shared/components/constants.dart';

class SettingScreen extends StatelessWidget {
   SettingScreen({Key? key}) : super(key: key);

   var formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopCubit, ShopStates>(
        listener: (context, state) => { },
        builder: (context, state) {
          var model = ShopCubit.get(context).userDataModel;

          _nameController.text = model.data!.name!;
          _emailController.text = model.data!.email!;
          _phoneController.text = model.data!.phone!;
          return ConditionalBuilder(
            condition: ShopCubit.get(context).userDataModel != null,
            builder: (context) => Padding(
              padding:  EdgeInsets.all(15.0.sp),
              child: Form(
                key: formKey,
                child: Column(
                  children: [
                    if(state is ShopLoadingUpdateUserState)
                      LinearProgressIndicator(),
                    SizedBox(
                      height: 30.h,
                    ),
                    defaultFormField(
                        controller: _nameController,
                        keyboardType: TextInputType.name,
                        validate: (value){
                          if (value.isEmpty)
                          {
                            return "name must not be empty";
                          }
                          return null;
                        },
                        labelText: "Name",
                        prefix: Icons.person
                    ),
                    SizedBox(
                      height: 6.0.h,
                    ),
                    defaultFormField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        validate: (value){
                          if (value.isEmpty)
                          {
                            return "email must not be empty";
                          }
                          return null;
                        },
                        labelText: "Email Address",
                        prefix: Icons.email
                    ),
                    SizedBox(
                      height: 6.0.h,
                    ),
                    defaultFormField(
                        controller: _phoneController,
                        keyboardType: TextInputType.number,
                        validate: (value){
                          if (value.isEmpty)
                          {
                            return "phone number must not be empty";
                          }
                          return null;
                        },
                        labelText: "Phone Number",
                        prefix: Icons.phone
                    ),
                    SizedBox(
                      height: 10.0.h,
                    ),
                    defaultButton(
                      text: "update",
                      function: ()
                      {
                        if (formKey.currentState!.validate()) {
                          ShopCubit.get(context).updateUserData(
                            name: _nameController.text,
                            email: _emailController.text,
                            phone: _phoneController.text,
                          );
                        }
                      },
                    ),
                    SizedBox(
                      height: 10.0.h,
                    ),
                    defaultButton(
                        text: "logout",
                        function: (){
                          signOut(context);
                        },
                    )
                  ],
                ),
              ),
            ),
            fallback: (context) => Center(child: CircularProgressIndicator()),
          );
        },
    );
  }
}
