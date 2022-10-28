// ignore_for_file: constant_identifier_names, sized_box_for_whitespace

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';

Widget defaultFormField({
  required TextEditingController controller,
  required TextInputType keyboardType,
  required FormFieldValidator validate,
  required String labelText,
  required IconData prefix,
  String? hintText,
  VoidCallback? suffixPressed,
  IconData? suffix,
  bool isPassword = false,
  ValueChanged? onSubmit,
  ValueChanged? onChange,
  GestureTapCallback? onTap,
}) =>
    Container(
      height: 90.0,
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        onFieldSubmitted: onSubmit,
        onChanged: onChange,
        onTap: onTap,
        validator: validate,
        obscureText: isPassword,
        decoration: InputDecoration(
          labelText: labelText,
          prefixIcon: Icon(
            prefix,
            size: 30.0.sp,
          ),
          suffixIcon: IconButton(
            onPressed: suffixPressed,
            icon: Icon(
              suffix,
            ),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25.0),
          ),
        ),
        cursorColor: Colors.deepOrange,
        cursorRadius: const Radius.circular(30.0),
      ),
    );



Widget defaultButton({
  double width = double.infinity,
  Color color = Colors.blue,
  double height = 40.0,
  double radius = 0.0,
  bool isUpper = true,
  required String text,
  required VoidCallback function,
}) =>
    Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
        color: color,
      ),
      child: MaterialButton(
        onPressed: function,
        child: Text(
          isUpper ? text.toUpperCase() : text,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20.0,
          ),
        ),
      ),
    );


Widget myDivider() => Padding(
  padding: const EdgeInsetsDirectional.only(
    start: 20.0,
  ),
  child: Container(
    width: double.infinity,
    height: 1.0,
    color: Colors.grey[400],
  ),
);


void navigateTo(context, widget) => Navigator.push(
  context,
  MaterialPageRoute(builder: (context) => widget),
);

void navigateAndFinish(context, widget) => Navigator.pushAndRemoveUntil(
    context, MaterialPageRoute(builder: (context) => widget), (route) => false);


void showToast({
  required String text,
  required ToastStates state,
}) =>
    Fluttertoast.showToast(
        msg: text,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 5,
        backgroundColor: chooseToastColor(state),
        textColor: Colors.white,
        fontSize: 16.0);

//enum
enum ToastStates { SUCCESS, ERROR, WARNING }

Color chooseToastColor(ToastStates state) {
  Color color;
  switch (state) {
    case ToastStates.SUCCESS:
      color = Colors.green;
      break;
    case ToastStates.ERROR:
      color = Colors.red;
      break;
    case ToastStates.WARNING:
      color = Colors.amberAccent;
      break;
  }
  return color;
}