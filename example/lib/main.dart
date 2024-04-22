import 'package:flutter/material.dart';
import 'package:siarashield_flutter/application_constants/app_constant.dart';
import 'package:siarashield_flutter/siarashield_flutter.dart';

void main() {
  runApp(const MaterialApp(home: MyApp()));
}
class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}
class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.blueColor,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: SaraShieldWidget(
            loginTap: (val) {
              //To-Do On LoginTap
            },
            cieraModel: CyberCieraModel(
                masterUrlId: 'Huhuowhfouwhfouwh', //Master URl ID
                requestUrl: 'com.app.testapp' //Package name,

                ),
          ),
        ),
      ),
    );
  }
}
