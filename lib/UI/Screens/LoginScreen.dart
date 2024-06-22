import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:provider/provider.dart';
import 'package:spicetoon_app/UI/Screens/MessagesScreen.dart';

import '../../App_Router/App_Router.dart';
import '../../constants.dart';
import '../../providers/AppProvider.dart';
import '../Widgets/CustomElevatedButton.dart';
import '../Widgets/CustomFormField.dart';
import '../Widgets/TitleWidget.dart';
import 'SignUpScreen.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<AppProvider>(builder: (context, provider, x) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: provider.isDark ? Colors.black87 : backgroundColor,
          elevation: 0,
        ),
        backgroundColor: backgroundColor,
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Align(
                  alignment: Alignment.center,
                  child: Image.asset("assets/imgs/logorm.png"),
                ),
                TitleWidget(title: "Sign in".tr()),
                SizedBox(
                  height: 73.h,
                ),
                CustomFormField(
                    validation: provider.emailValidation,
                    label: "Phone".tr(),
                    controller: provider.emailController),
                CustomFormField(
                    validation: provider.passwordValidation,
                    label: "password".tr(),
                    controller: provider.passwordController),
                Align(
                    alignment: Alignment.centerRight,
                    child: Text("Forget Your Password?".tr())),
                SizedBox(
                  height: 32.h,
                ),
                CustomElevatedButton(
                    label: "LOGIN".tr(),
                    onPressed: () async {
                      final res = await provider.login();
                      if (res) {
                        AppRouter.router.push(MessagesScreen());
                      }
                      // AppRouter.router.push(HomeScreen());
                    }),
                Align(
                    alignment: Alignment.centerRight,
                    child: Row(
                      children: [
                        Text("Don't have an account? ".tr()),
                        TextButton(
                          child: Text("Sign Up".tr()),
                          onPressed: () {
                            AppRouter.router.push(SignUpScreen());
                          },
                        )
                      ],
                    )),
              ],
            ),
          ),
        ),
      );
    });
  }
}
