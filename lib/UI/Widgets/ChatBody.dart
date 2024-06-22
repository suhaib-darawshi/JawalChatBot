import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:spicetoon_app/APIHandler/API.dart';
import 'package:spicetoon_app/constants.dart';
import 'package:spicetoon_app/models/Message.dart';
import 'package:spicetoon_app/providers/AppProvider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../models/MessageModel.dart';

class ChatBody extends StatelessWidget {
  const ChatBody({
    Key? key,
    required this.scrollController,
  }) : super(key: key);
  final ScrollController scrollController;
  launchInBrowserView(Uri url) async {
    if (!await launchUrl(url, mode: LaunchMode.inAppBrowserView)) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppProvider>(builder: (context, provider, child) {
      return Expanded(
        child: provider.selectedChat == null
            ? Center(
                child: ListView.builder(
                  reverse: true,
                  controller: scrollController,
                  itemCount: 1,
                  itemBuilder: (context, index) => Center(
                    child: Image.asset(provider.isDark
                        ? "assets/imgs/logodark.png"
                        : "assets/imgs/logorm.png"),
                  ),
                ),
              )
            : ListView.builder(
                reverse: true,
                controller: scrollController,
                itemCount: provider.selectedChat!.messages.length,
                itemBuilder: (context, index) {
                  Message message = provider.selectedChat!.messages![index];
                  return Align(
                    alignment:
                        (message.isSender ?? false) //replace 1 with userid
                            ? Alignment.centerLeft
                            : Alignment.centerRight,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: message.isSender ?? false
                            ? MainAxisAlignment.end
                            : MainAxisAlignment.start,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Container(
                                constraints: BoxConstraints(
                                  maxWidth:
                                      MediaQuery.of(context).size.width * 0.66,
                                ),
                                padding: const EdgeInsets.all(10.0),
                                margin:
                                    const EdgeInsets.symmetric(vertical: 5.0),
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey),
                                  color: (message.isSender ??
                                          false) //replace 1 with userid
                                      ? const Color(0xff679958)
                                      : (provider.isDark
                                          ? Colors.black
                                          : Colors.white),
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(10)),
                                ),
                                child: Column(
                                  children: [
                                    Text(
                                      message.text ?? "",
                                      style: TextStyle(
                                          color: (message.isSender ?? false)
                                              ? Colors.white
                                              : (provider.isDark
                                                  ? Colors.white
                                                  : Colors.black),
                                          fontSize: 15),
                                    ),
                                    if (message.file != null)
                                      Row(
                                        children: [
                                          TextButton(
                                            child: Text(
                                                message.file!.split("/").last +
                                                    "  Check Q:" +
                                                    message.index.toString()),
                                            onPressed: () async {
                                              // await API.api
                                              //     .downloadFile(message.file!);
                                              String url = API.api.server +
                                                  message.file!;
                                              await launchInBrowserView(
                                                  Uri.parse(url));
                                            },
                                          )
                                        ],
                                      ),
                                  ],
                                ),
                              ),
                              if (message.isSender ?? false)
                                Row(
                                  children: [
                                    Icon(
                                      Icons.copy,
                                      size: 18.r,
                                    ),
                                    SizedBox(
                                      width: 5.w,
                                    ),
                                    Icon(
                                      Icons.thumb_up,
                                      size: 18.r,
                                    ),
                                    SizedBox(
                                      width: 5.w,
                                    ),
                                    Icon(Icons.thumb_down, size: 18.r),
                                    SizedBox(
                                      width: 5.w,
                                    ),
                                    Icon(Icons.replay_outlined, size: 18.r),
                                  ],
                                ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
      );
    });
  }
}
