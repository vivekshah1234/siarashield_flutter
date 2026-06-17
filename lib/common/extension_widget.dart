import 'package:flutter/material.dart';
import 'package:siarashield_flutter/constants/app_constant.dart';

extension Background on Widget {
  Widget putPadding(double right, double left) => Padding(
        padding: EdgeInsets.only(left: left, right: right),
        child: this,
      );

  Widget alertCard(context) => AlertDialog(
          backgroundColor: Colors.transparent,
          elevation: 0,
          contentPadding: EdgeInsets.zero,
          actionsPadding: EdgeInsets.zero,
          insetPadding: EdgeInsets.zero,
          actions: [
            Container(
                decoration: BoxDecoration(color: AppColors.whiteColor, borderRadius: BorderRadius.circular(10)),
                // width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                child: this),
          ]);
}
