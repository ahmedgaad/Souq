import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shop_app/modules/search/cubit/cubit.dart';
import 'package:shop_app/modules/search/cubit/states.dart';
import 'package:shop_app/shared/components/components.dart';

import '../../layout/shop_layout/cubit/cubit.dart';
import '../../shared/styles/colors.dart';

class SearchScreen extends StatelessWidget {

  var formKey = GlobalKey<FormState>();
  var searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => SearchCubit(),
      child: BlocConsumer<SearchCubit , SearchStates>(
        listener: (context,state){},
        builder: (context,state){
          return Scaffold(
            appBar: AppBar(),
            body: Form(
              key: formKey,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    defaultFormField(
                        controller: searchController,
                        keyboardType: TextInputType.text,
                        validate: (value){
                          if (value.isEmpty || value == null) {
                            return "enter text to search";
                          }
                          return null;
                        },
                        onSubmit: (text){
                          SearchCubit.get(context).search(text);
                        },
                        labelText: "Search",
                        prefix: Icons.search
                    ),
                    SizedBox(height: 10.0.h,),
                    if(state is SearchLoadingState)
                      const LinearProgressIndicator(),
                    SizedBox(height: 20.0.h,),
                    if(state is SearchSuccessState)
                      Expanded(
                        child: ListView.separated(
                          itemBuilder: (context, index) => buildListItemSearch(
                              SearchCubit.get(context).searchModel!.data!.data![index], context,
                              isOldPrice: false
                          ),
                          separatorBuilder: (context, index) => myDivider(),
                          itemCount: SearchCubit.get(context).searchModel!.data!.data!.length,
                        ),
                      )
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget buildListItemSearch(model, context, {bool isOldPrice = true}) => Padding(
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
              if (model.discount != 0 && isOldPrice)
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
                    if (model.discount != 0 && isOldPrice)
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

}
