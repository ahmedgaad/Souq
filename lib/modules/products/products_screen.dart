// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, unnecessary_null_comparison, unnecessary_string_interpolations, avoid_print


import 'package:carousel_slider/carousel_slider.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/layout/shop_layout/cubit/cubit.dart';
import 'package:shop_app/models/categories_model.dart';
import 'package:shop_app/models/home_model.dart';
import 'package:shop_app/shared/components/components.dart';
import 'package:shop_app/shared/styles/colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../layout/shop_layout/cubit/states.dart';

class ProductsScreen extends StatelessWidget {
  const ProductsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopCubit, ShopStates>(
      listener: (context, state) {
        if (state is ShopSuccessChangeFavoritesState) {
          if(!state.model.status!){
            showToast(
                text: state.model.message!,
                state: ToastStates.ERROR
            );
          }
        }  
      },
      builder: (context, state) {
        return ConditionalBuilder(
          condition: ShopCubit.get(context).homeModel != null && ShopCubit.get(context).categoryModel != null,
          builder: (context) =>
              builderWidget(ShopCubit.get(context).homeModel!, ShopCubit.get(context).categoryModel!, context),
          fallback: (context) => Center(child: CircularProgressIndicator()),
        );
      },
    );
  }

  Widget builderWidget(HomeModel model, CategoryModel categoryModel, context) => SingleChildScrollView(
    physics: BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CarouselSlider(
              items: model.data.banners
                  .map(
                    (e) => Image(
                      image: NetworkImage('${e.image}'),
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  )
                  .toList(),
              options: CarouselOptions(
                height: 250.0.h,
                initialPage: 0,
                enableInfiniteScroll: true,
                viewportFraction: 1.0,
                reverse: false,
                autoPlay: true,
                autoPlayAnimationDuration: Duration(seconds: 1),
                autoPlayInterval: Duration(seconds: 3),
                autoPlayCurve: Curves.fastOutSlowIn,
                scrollDirection: Axis.horizontal,
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 10.0.w,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Categories',
                    style: TextStyle(
                      fontSize: 24.0.sp,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  SizedBox(
                    height: 15.0.h,
                  ),
                  SizedBox(
                    height: 100.0.h,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                        physics: BouncingScrollPhysics(),
                        itemBuilder: (context, index) => buildCategoryItem(categoryModel.data!.data[index]),
                        separatorBuilder: (context, index) => SizedBox(width: 5.0.w,),
                        itemCount: categoryModel.data!.data.length,
                    ),
                  ),
                  SizedBox(
                    height: 30.0.h,
                  ),
                  Text(
                    'New Products',
                    style: TextStyle(
                      fontSize: 24.0.sp,
                      fontWeight: FontWeight.w800
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 10.0.h,
            ),
            Container(
              color: Colors.grey[300],
              child: GridView.count(
                shrinkWrap: true,
                crossAxisCount: 2,
                mainAxisSpacing: 2.0,
                crossAxisSpacing: 2.0,
                childAspectRatio: MediaQuery.of(context).size.aspectRatio / 0.9,
                physics: NeverScrollableScrollPhysics(),
                children: List.generate(
                  model.data.products.length,
                  (index) => buildGridProduct(model.data.products[index], context),
                ),
              ),
            ),
          ],
        ),
      );

  Widget buildCategoryItem(DataModel model) => Stack(
    alignment: AlignmentDirectional.bottomCenter,
    children:
    [
      Image(
        image: NetworkImage(model.image),
        height: 100.0.h,
        width: 100.0.w,
        fit: BoxFit.cover,
      ),
      Container(
        width: 100.0.w,
        color: Colors.black.withOpacity(0.8),
        child: Text(
          model.name,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
              color: Colors.white,
              fontSize: 18.0.sp,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    ],
  );

  Widget buildGridProduct(ProductModel model, context) => Container(
    color: Colors.white,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              alignment: AlignmentDirectional.bottomStart,
              children: [
                Image(
                  image: NetworkImage('${model.image}'),
                  width: double.infinity,
                  height: 200.0.h,
                ),
                if(model.discount != 0)
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
            Padding(
              padding:  EdgeInsets.all(12.0.w.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${model.name}',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Row(
                    children: [
                      Text(
                        '${model.price.round()}',
                        style: TextStyle(
                          fontSize: 12.0.sp,
                          color: defaultColor,
                        ),
                      ),
                      SizedBox(
                        width: 5.0.w,
                      ),
                      if(model.discount != 0)
                        Text(
                        '${model.oldPrice.round()}',
                        style: TextStyle(
                          fontSize: 10.0.sp,
                          color: Colors.grey,
                          decoration: TextDecoration.lineThrough,
                        ),
                      ),
                      Spacer(),
                      IconButton(
                          onPressed: (){
                            ShopCubit.get(context).changeFavorites(model.id);
                            // print(model.id);
                          },
                          icon: CircleAvatar(
                            radius: 30.0.sp,
                            backgroundColor: ShopCubit.get(context).favorites[model.id]! ? defaultColor : Colors.grey,
                            child: Icon(
                              Icons.favorite_border,
                              color: Colors.white,
                            ),
                          )
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
  );
}
