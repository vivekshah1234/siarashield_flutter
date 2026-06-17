import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:siarashield_flutter/constants/app_constant.dart';

screenHeight(BuildContext context) => MediaQuery.of(context).size.height;

screenWidth(BuildContext context) => MediaQuery.of(context).size.width;

Future<bool?> toast(String txt) => Fluttertoast.showToast(
    msg: txt,
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.BOTTOM,
    timeInSecForIosWeb: 1,
    backgroundColor: AppColors.blueColor,
    textColor: AppColors.whiteColor,
    fontSize: 16.0);

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
        child: CircularProgressIndicator(
      color: AppColors.blueColor,
      strokeWidth: 3,
    ));
  }
}

class LoadingStateWidget extends StatelessWidget {
  final Widget child;
  final bool isLoading;

  const LoadingStateWidget({required this.isLoading, required this.child, super.key});

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
        ignoring: isLoading, child: Stack(alignment: Alignment.center, children: [child, isLoading ? const LoadingWidget() : const SizedBox()]));
  }
}

class AppButton extends StatelessWidget {
  final GestureTapCallback onTap;

  final String title;

  const AppButton({super.key, required this.onTap, required this.title});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: onTap,
        style: ButtonStyle(
          shape: WidgetStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(7.0),
          )),
          shadowColor: WidgetStateProperty.all<Color>(AppColors.orangeColor),
          elevation: WidgetStateProperty.all<double>(0),
          backgroundColor: WidgetStateProperty.all<Color>(AppColors.orangeColor),
          padding: WidgetStateProperty.all<EdgeInsetsGeometry>(const EdgeInsets.symmetric(vertical: 15, horizontal: 15)),
        ),
        child: Text(title,
            textAlign: TextAlign.center,
            maxLines: 1,
            style: const TextStyle(fontWeight: FontWeight.w600, color: AppColors.whiteColor, fontSize: 18)));
  }
}
