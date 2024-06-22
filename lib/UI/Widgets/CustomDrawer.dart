import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:spicetoon_app/constants.dart';
import 'package:spicetoon_app/providers/AppProvider.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    // UserProvider provider = Provider.of<UserProvider>(context, listen: false);
    return Consumer<AppProvider>(builder: (context, provider, x) {
      return Drawer(
        backgroundColor: provider.isDark ? darkbackgroundColor : Colors.white,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            SizedBox(
              height: 50.h,
            ),
            // UserAccountsDrawerHeader(
            //   accountName: Text(
            //     '${UserProvider.user.firstName!} ${UserProvider.user.lastName!}',
            //     style: const TextStyle(
            //       fontSize: 20.0,
            //       fontWeight: FontWeight.bold,
            //     ),
            //   ),
            //   accountEmail: Text(
            //     UserProvider.user.email!,
            //     style: const TextStyle(
            //       fontSize: 14.0,
            //     ),
            //   ),
            //   currentAccountPicture: CircleAvatar(
            //     backgroundImage: NetworkImage(
            //         '${Constants.uri}/imgs/${UserProvider.user.ProfileImg}'),
            //   ),
            //   decoration: const BoxDecoration(
            //     gradient: LinearGradient(
            //       begin: Alignment.topLeft,
            //       end: Alignment.bottomRight,
            //       colors: [
            //         Color(0xff222648),
            //         Color.fromARGB(255, 65, 109, 145),
            //       ],
            //     ),
            //   ),
            // ),
            ListTile(
              leading: Icon(Icons.message,
                  color: provider.isDark ? Colors.white : Colors.black),
              title: Text(
                'New Chat'.tr(),
                style: TextStyle(
                    color: provider.isDark ? Colors.white : Colors.black),
              ),
              trailing: Icon(Icons.note_alt_outlined,
                  color: provider.isDark ? Colors.white : Colors.black),
              onTap: () {
                provider.newChat();
                // Navigator.push(
                //     context,
                //     MaterialPageRoute(
                //         builder: (context) =>
                //             MyProperties(user_id: UserProvider.user.id!)));
              },
            ),
            Divider(
              color: provider.isDark ? Colors.white : Colors.grey,
            ),
            for (int i = 0; i < provider.loggedUser.chats!.length; i++)
              Column(
                children: [
                  ListTile(
                    leading: Icon(Icons.article_rounded,
                        color: provider.isDark ? Colors.white : Colors.black),
                    title: Text(provider.loggedUser.chats![i].title ?? "",
                        style: TextStyle(
                            color:
                                provider.isDark ? Colors.white : Colors.black)),
                    onTap: () {
                      provider.changeChat(i);
                      // Navigator.push(
                      //     context,
                      //     MaterialPageRoute(
                      //         builder: (context) =>
                      //             MyProperties(user_id: UserProvider.user.id!)));
                    },
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                ],
              ),
            Divider(height: 5, color: Colors.grey.shade500),
            const SizedBox(
              height: 5,
            ),
            ListTile(
              leading: Icon(Icons.exit_to_app,
                  color: provider.isDark ? Colors.white : Colors.black),
              title: Text('Logout'.tr(),
                  style: TextStyle(
                      color: provider.isDark ? Colors.white : Colors.black)),
              onTap: () {
                // provider.logout();
              },
            ),
            const SizedBox(height: 16.0),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                '© 2024 Spicetoon',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 12.0,
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}
