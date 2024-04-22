import 'package:flutter/material.dart';

import '../application_constants/app_constant.dart';

extension Background on Widget {
  Widget putPadding(double right, double left) => Padding(
        padding: EdgeInsets.only(left: left, right: right),
        child: this,
      );

  Widget alertCard(context) => AlertDialog(backgroundColor: Colors.transparent, elevation: 0,
contentPadding: const EdgeInsets.only(left: 10,right: 10),
actionsPadding:  const EdgeInsets.only(left: 10,right: 10),insetPadding:  const EdgeInsets.only(left: 10,right: 10),
actions: [Container(
    decoration: BoxDecoration(color: AppColors.whiteColor, borderRadius: BorderRadius.circular(10)),
    margin: const EdgeInsets.only(right: 10),
    width: double.infinity,
    padding: const EdgeInsets.all(10),
    child: putPadding(
      20,
      10,
    ))],

      );
}
