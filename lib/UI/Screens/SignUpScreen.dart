import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:spicetoon_app/App_Router/App_Router.dart';
import 'package:spicetoon_app/UI/Screens/MessagesScreen.dart';

import '../../constants.dart';
import '../../providers/AppProvider.dart';
import '../Widgets/CustomElevatedButton.dart';
import '../Widgets/CustomFormField.dart';
import '../Widgets/TitleWidget.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({Key? key}) : super(key: key);

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
                TitleWidget(title: "Sign Up".tr()),
                SizedBox(
                  height: 73.h,
                ),
                CustomFormField(
                    validation: provider.passwordValidation,
                    label: "username".tr(),
                    controller: provider.firstnameController),
                CustomFormField(
                    validation: provider.phoneValidation,
                    label: "Phone".tr(),
                    controller: provider.emailController),
                CustomFormField(
                    validation: provider.passwordValidation,
                    label: "password".tr(),
                    controller: provider.passwordController),
                SizedBox(
                  height: 32.h,
                ),
                CustomElevatedButton(
                    label: "Sign Up".tr(),
                    onPressed: () async {
                      final res = await provider.signUp();
                      if (res) {
                        AppRouter.router.push(MessagesScreen());
                      }
                    }),
                Align(
                    alignment: Alignment.centerRight,
                    child: Row(
                      children: [
                        Text("Already have an account? ".tr()),
                        TextButton(
                          child: Text("LOGIN".tr()),
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
