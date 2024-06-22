import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:spicetoon_app/UI/Widgets/ChatBody.dart';
import 'package:spicetoon_app/UI/Widgets/CustomDrawer.dart';
import 'package:spicetoon_app/providers/AppProvider.dart';

class MessagesScreen extends StatefulWidget {
  const MessagesScreen({Key? key}) : super(key: key);

  @override
  State<MessagesScreen> createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen> {
  SpeechToText _speechToText = SpeechToText();
  bool _speechEnabled = false;
  String _lastWords = '';

  @override
  void initState() {
    super.initState();
    _initSpeech();
  }

  /// This has to happen only once per app
  void _initSpeech() async {
    _speechEnabled = await _speechToText.initialize();
    setState(() {});
  }

  /// Each time to start a speech recognition session
  _startListening() async {
    await _speechToText.listen(onResult: _onSpeechResult);
    setState(() {});
  }

  /// Manually stop the active speech recognition session
  /// Note that there are also timeouts that each platform enforces
  /// and the SpeechToText plugin supports setting timeouts on the
  /// listen method.
  _stopListening() async {
    await _speechToText.stop();
    log(_lastWords);
    setState(() {});
  }

  /// This is the callback that the SpeechToText plugin calls when
  /// the platform returns recognized words.
  void _onSpeechResult(SpeechRecognitionResult result) {
    setState(() {
      _lastWords = result.recognizedWords;
    });
  }

  @override
  Widget build(BuildContext context) {
    ScrollController scrollController = ScrollController();
    return Consumer<AppProvider>(builder: (context, provider, x) {
      if (provider.selectedChat != null) {
        provider.selectedChat!.messages.sort(
          (b, a) => a.updatedAt.compareTo(b.updatedAt),
        );
      }
      return Scaffold(
        drawer: CustomDrawer(),
        appBar: AppBar(
          title: Text(
            "Jawal".tr(),
            style:
                TextStyle(color: provider.isDark ? Colors.black : Colors.white),
          ),
          backgroundColor: Color(0xFF6ABF4B),
          leading: Builder(builder: (context) {
            return InkWell(
              onTap: () {
                Scaffold.of(context).openDrawer();
              },
              child: Icon(
                Icons.filter_list,
                size: 36.r,
                color: provider.isDark ? Colors.black : Colors.white,
              ),
            );
          }),
          actions: [
            InkWell(
              onTap: () {
                if (context.locale == Locale("ar")) {
                  context.setLocale(Locale('en'));
                } else {
                  context.setLocale(Locale('ar'));
                }
              },
              child: Icon(
                Icons.language,
                size: 25.r,
                color: provider.isDark ? Colors.black : Colors.white,
              ),
            ),
            SizedBox(
              width: 16.w,
            ),
            InkWell(
              onTap: () {
                provider.setDarkMode();
              },
              child: Icon(
                Icons.dark_mode,
                size: 25.r,
                color: provider.isDark ? Colors.black : Colors.white,
              ),
            ),
            SizedBox(
              width: 8.w,
            ),
          ],
        ),
        body: Column(
          children: [
            ChatBody(
              scrollController: scrollController,
            ),
            Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    if (provider.state != 'idle')
                      Row(
                        children: [
                          Text("Generating".tr()),
                        ],
                      ),
                    TextFormField(
                      controller: provider.messagesController,
                      style: Theme.of(context).textTheme.bodyMedium,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Color(0xff222648).withOpacity(.2),
                        hintText: 'Type here...'.tr(),
                        hintStyle: Theme.of(context).textTheme.bodyMedium,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15.0),
                          borderSide: provider.isDark
                              ? BorderSide(color: Colors.white)
                              : BorderSide.none,
                        ),
                        suffixIcon: provider.state != 'idle'
                            ? CircularProgressIndicator()
                            : Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    onPressed: () async {
                                      _speechToText.isNotListening
                                          ? _startListening
                                          : _stopListening;
                                    },
                                    icon: Icon(_speechToText.isNotListening
                                        ? Icons.mic_off
                                        : Icons.mic), // Your microphone icon
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.send),
                                    color: Theme.of(context).iconTheme.color,
                                    onPressed: () async {
                                      int senderId = provider.id as int;
                                      int receiverId = 11;
                                      provider.sendMessage();

                                      scrollController.animateTo(
                                        scrollController
                                            .position.minScrollExtent,
                                        duration:
                                            const Duration(milliseconds: 300),
                                        curve: Curves.easeIn,
                                      );
                                      provider.messagesController.clear();
                                    },
                                  ),
                                ],
                              ),
                        contentPadding: const EdgeInsets.all(20.0),
                      ),
                    ),
                  ],
                )),
          ],
        ),
      );
    });
  }
}
