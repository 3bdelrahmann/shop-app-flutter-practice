import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shop_app/shared/cubit/cubit.dart';
import 'package:shop_app/shared/styles/colors.dart';

Widget onBoardingButton({
  required IconData icon,
  required VoidCallback onPressed,
  Color color = kMainColor,
  Color iconColor = Colors.white,
}) =>
    RawMaterialButton(
      elevation: 0.0,
      child: Icon(
        icon,
        color: iconColor,
      ),
      onPressed: onPressed,
      constraints: const BoxConstraints.tightFor(
        width: 70.0,
        height: 50.0,
      ),
      fillColor: color,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
    );

void navigateTo(
        {required BuildContext context,
        required Widget newRoute,
        required bool backRoute}) =>
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => newRoute),
      (route) => backRoute,
    );

Widget defaultFormField({
  required TextEditingController controller,
  required TextInputType type,
  required FormFieldValidator<String> validate,
  required IconData prefix,
  ValueChanged<String>? onSubmit,
  ValueChanged<String>? onChange,
  GestureTapCallback? onTap,
  bool isPassword = false,
  String? label,
  String? hint,
  IconData? suffix,
  VoidCallback? suffixPressed,
  bool isClickable = true,
  bool readOnly = false,
  int? maxLength,
}) =>
    Container(
      color: Colors.white,
      child: TextFormField(
        maxLength: maxLength,
        readOnly: readOnly,
        controller: controller,
        keyboardType: type,
        obscureText: isPassword,
        enabled: isClickable,
        onFieldSubmitted: onSubmit,
        onChanged: onChange,
        onTap: onTap,
        validator: validate,
        decoration: InputDecoration(
          hintText: hint,
          labelText: label,
          prefixIcon: Icon(
            prefix,
          ),
          suffixIcon: suffix != null
              ? IconButton(
                  onPressed: suffixPressed,
                  icon: Icon(
                    suffix,
                  ),
                )
              : null,
          border: OutlineInputBorder(),
        ),
      ),
    );

Widget defaultButton({
  required VoidCallback onPressed,
  required String text,
  double width = double.infinity,
  double height = 50.0,
  Color background = kMainColor,
  bool isUpperCase = true,
  double radius = 3.0,
  double textSize = 14.0,
}) =>
    Container(
      width: width,
      height: height,
      child: MaterialButton(
        onPressed: onPressed,
        child: Text(
          isUpperCase ? text.toUpperCase() : text,
          style: TextStyle(
            color: Colors.white,
            fontSize: textSize,
          ),
        ),
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(
          radius,
        ),
        color: background,
      ),
    );

Widget defaultTextButton({
  required VoidCallback onPressed,
  required String text,
}) =>
    TextButton(
      onPressed: onPressed,
      child: Text(
        text.toUpperCase(),
      ),
    );

void showToast({
  required String text,
  required ToastStates states,
}) =>
    Fluttertoast.showToast(
        msg: text,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 5,
        backgroundColor: chooseToastColor(states),
        textColor: Colors.white,
        fontSize: 16.0);

enum ToastStates { SUCCESS, ERROR, WARNING, GREY }

Color chooseToastColor(ToastStates states) {
  Color color;
  switch (states) {
    case ToastStates.SUCCESS:
      color = Colors.green;
      break;
    case ToastStates.ERROR:
      color = Colors.red;
      break;
    case ToastStates.WARNING:
      color = Colors.amber;
      break;
    case ToastStates.GREY:
      color = Colors.grey;
      break;
  }
  return color;
}

Widget RoundIconButton({
  required IconData icon,
  required VoidCallback onPressed,
  required Color color,
  Color? iconColor,
}) =>
    RawMaterialButton(
      elevation: 0.0,
      child: Icon(
        icon,
        color: iconColor,
      ),
      onPressed: onPressed,
      constraints: const BoxConstraints.tightFor(
        width: 40.0,
        height: 40.0,
      ),
      shape: const CircleBorder(),
      fillColor: color,
    );

Widget BuildFavoritesItem(
  model,
  BuildContext context,
) =>
    Padding(
      padding: const EdgeInsets.all(10.0),
      child: Row(
        children: [
          Stack(
            alignment: AlignmentDirectional.bottomStart,
            children: [
              Image(
                height: 120.0,
                width: 120.0,
                image: NetworkImage('${model.product!.image}'),
              ),
              if (model.product!.discount! > 0)
                Container(
                    padding: EdgeInsets.symmetric(horizontal: 5.0),
                    color: Colors.red,
                    child: Text(
                      'DISCOUNT',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.white,
                      ),
                    )),
            ],
          ),
          Expanded(
            child: Container(
              height: 120,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${model.product!.name}',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(height: 1.3),
                  ),
                  Spacer(),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '${model.product!.price.round()}',
                        style: TextStyle(
                          fontSize: 16.0,
                          color: kMainColor,
                        ),
                      ),
                      SizedBox(
                        width: 5.0,
                      ),
                      if (model.product!.discount! > 0)
                        Text(
                          '${model.product!.oldPrice.round()}',
                          style: TextStyle(
                            color: Colors.grey,
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                      Spacer(),
                      IconButton(
                        onPressed: () {
                          AppCubit.get(context).changeCart(model.product!.id!);
                        },
                        icon: AppCubit.get(context).inCart[model.product!.id]!
                            ? Icon(
                                Icons.remove_shopping_cart,
                                color: Colors.red,
                              )
                            : Icon(
                                Icons.add_shopping_cart,
                                color: Colors.green,
                              ),
                      ),
                      IconButton(
                        onPressed: () {
                          AppCubit.get(context)
                              .changeFavorites(model.product!.id!);
                        },
                        icon:
                            AppCubit.get(context).favourites[model.product!.id]!
                                ? Icon(
                                    Icons.favorite,
                                    color: Colors.red,
                                  )
                                : Icon(
                                    Icons.favorite_outline,
                                  ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
