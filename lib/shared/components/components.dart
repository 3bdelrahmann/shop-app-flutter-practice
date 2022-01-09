import 'package:flutter/material.dart';
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
