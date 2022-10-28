// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shop_app/layout/shop_layout/cubit/cubit.dart';
import 'package:shop_app/layout/shop_layout/cubit/states.dart';
import 'package:shop_app/models/categories_model.dart';
import 'package:shop_app/shared/components/components.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopCubit, ShopStates>(
        listener: (context, state) { },
        builder: (context, state){
          return ListView.separated(
            physics: BouncingScrollPhysics(),
              itemBuilder: (context, index) => buildCatItem(ShopCubit.get(context).categoryModel!.data!.data[index]),
              separatorBuilder: (context, index) => myDivider(),
              itemCount: ShopCubit.get(context).categoryModel!.data!.data.length
          );
        },
    );
  }

  Widget buildCatItem(DataModel model) => Padding(
    padding:  EdgeInsets.all(20.0.w),
    child: Row(
      children: [
        Image(
          image: NetworkImage(
              model.image
          ),
          height: 90.0.h,
          width: 90.0.w,
          fit: BoxFit.cover,
        ),
        SizedBox(
          width: 20.0.w,
        ),
        Text(
          model.name,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
              fontSize: 20.0.sp,
              fontWeight: FontWeight.bold
          ),
        ),
        Spacer(),
        Icon(
            Icons.arrow_forward_ios_outlined
        ),
      ],
    ),
  );
}
