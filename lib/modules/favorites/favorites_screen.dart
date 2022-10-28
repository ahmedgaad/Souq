// ignore_for_file: prefer_const_constructors

import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shop_app/models/favorites_model.dart';

import '../../layout/shop_layout/cubit/cubit.dart';
import '../../layout/shop_layout/cubit/states.dart';
import '../../shared/components/components.dart';
import '../../shared/styles/colors.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopCubit, ShopStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return ConditionalBuilder(
            condition: state is! ShopLoadingGetFavoritesState,
            fallback: (context) => Center(
                  child: CircularProgressIndicator(),
                ),
            builder: (context) {
              return ListView.separated(
                  physics: BouncingScrollPhysics(),
                  itemBuilder: (context, index) => buildFavItem(
                      ShopCubit.get(context)
                          .favoritesModel!
                          .data!
                          .data![index].product!,
                      context),
                  separatorBuilder: (context, index) => myDivider(),
                  itemCount: ShopCubit.get(context)
                      .favoritesModel!
                      .data!
                      .data!
                      .length);
            });
      },
    );
  }

  Widget buildFavItem(model, context) => Padding(
        padding: EdgeInsets.all(15.0.sp),
        child: SizedBox(
          height: 120.0.h,
          child: Row(
            children: [
              Stack(
                alignment: AlignmentDirectional.bottomStart,
                children: [
                  Image(
                    image: NetworkImage("${model.image}"),
                    width: 120.0.w,
                    height: 120.0.h,
                    fit: BoxFit.cover,
                  ),
                  if (model.discount != 0)
                    Container(
                      color: Colors.red,
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 6.0.h),
                        child: Text(
                          'DISCOUNT',
                          style: TextStyle(
                            fontSize: 10.0.sp,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              SizedBox(
                width: 20.0.w,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${model.name}",
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Spacer(),
                    Row(
                      children: [
                        Text(
                          model.price.toString(),
                          style: TextStyle(
                            fontSize: 12.0.sp,
                            color: defaultColor,
                          ),
                        ),
                        SizedBox(
                          width: 5.0.w,
                        ),
                        if (model.discount != 0)
                          Text(
                            '${model.oldPrice}',
                            style: TextStyle(
                              fontSize: 10.0.sp,
                              color: Colors.grey,
                              decoration: TextDecoration.lineThrough,
                            ),
                          ),
                        Spacer(),
                        IconButton(
                            onPressed: () {
                              ShopCubit.get(context)
                                  .changeFavorites(model.id!);
                            },
                            icon: CircleAvatar(
                              radius: 30.0.sp,
                              backgroundColor: ShopCubit.get(context)
                                      .favorites[model.id]!
                                  ? defaultColor
                                  : Colors.grey,
                              child: Icon(
                                Icons.favorite_border,
                                color: Colors.white,
                              ),
                            )),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );

  Widget buildListProduct(model, context, {bool isOldPrice = true}) => Padding(
        padding: const EdgeInsets.all(20.0),
        child: SizedBox(
          height: 120.0,
          child: Row(
            children: [
              SizedBox(
                height: 120.0,
                width: 120.0,
                child: Stack(
                    alignment: AlignmentDirectional.bottomStart,
                    children: [
                      Image(
                        image: NetworkImage(model.image!),
                        width: double.infinity,
                        height: 120.0,
                        fit: BoxFit.cover,
                      ),
                      if (model.discount != 0 && isOldPrice)
                        Container(
                          color: Colors.red,
                          padding: EdgeInsets.symmetric(horizontal: 5.0),
                          child: Text(
                            'DISCOUNT',
                            style: TextStyle(
                              fontSize: 14.0,
                              color: Colors.white,
                            ),
                          ),
                        ),
                    ]),
              ),
              SizedBox(
                width: 10.0,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      model.name!,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 14.0,
                        height: 1.3,
                        color: Colors.black,
                      ),
                    ),
                    Spacer(),
                    Row(
                      children: [
                        Text(
                          model.price.toString(),
                          style: TextStyle(
                            fontSize: 12.0,
                            color: defaultColor,
                          ),
                        ),
                        SizedBox(
                          width: 5.0,
                        ),
                        if (model.discount != 0 && isOldPrice)
                          Text(
                            model.oldPrice.toString(),
                            style: TextStyle(
                                fontSize: 10.0,
                                color: Colors.grey,
                                decoration: TextDecoration.lineThrough),
                          ),
                        Spacer(),
                        IconButton(
                          onPressed: () {
                            ShopCubit.get(context).changeFavorites(model.id!);
                          },
                          icon: Icon(
                            Icons.favorite,
                            size: 22,
                            color: Colors.grey,
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
}
