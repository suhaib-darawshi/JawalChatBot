import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:spicetoon_app/UI/Screens/LoginScreen.dart';
import 'package:spicetoon_app/UI/Screens/MessagesScreen.dart';

import 'App_Router/App_Router.dart';
import 'constants.dart';
import 'providers/AppProvider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return EasyLocalization(
      supportedLocales: const [Locale('en'), Locale('ar')],
      path: 'assets/languages',
      startLocale: const Locale('en'),
      fallbackLocale: const Locale('en'),
      child: MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (contet) => AppProvider())
          ],
          child: ScreenUtilInit(
              designSize: Size(393, 851),
              builder: (context, x) {
                final ThemeData theme = ThemeData(
                  scaffoldBackgroundColor:
                      Provider.of<AppProvider>(context).isDark
                          ? Colors.black
                          : backgroundColor,
                  primaryColor: Color(0xFF6ABF4B),
                );
                return MaterialApp(
                  title: 'Spicetoon',
                  localizationsDelegates: context.localizationDelegates,
                  supportedLocales: context.supportedLocales,
                  locale: context.locale,
                  debugShowCheckedModeBanner: false,
                  theme: Provider.of<AppProvider>(context).isDark
                      ? ThemeData.dark().copyWith(
                          scaffoldBackgroundColor: darkbackgroundColor,
                          primaryColor: Color(0xFF6ABF4B),
                          colorScheme: theme.colorScheme
                              .copyWith(secondary: Color(0x3FD32525)))
                      : ThemeData(
                          scaffoldBackgroundColor: backgroundColor,
                          primaryColor: Color(0xFF6ABF4B),
                        ).copyWith(
                          colorScheme: theme.colorScheme
                              .copyWith(secondary: Color(0x3FD32525)),
                        ),
                  navigatorKey: AppRouter.router.navigatorKey,
                  home: LoginScreen(),
                );
              })),
    );
  }
}
