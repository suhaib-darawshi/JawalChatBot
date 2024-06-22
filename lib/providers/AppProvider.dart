import 'dart:convert';
import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sound/public/flutter_sound_recorder.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:spicetoon_app/APIHandler/API.dart';
import 'package:spicetoon_app/models/Chat.dart';
import 'package:spicetoon_app/models/MessageModel.dart';
import 'package:spicetoon_app/models/UserModel.dart';
import 'package:string_validator/string_validator.dart';

import '../models/Message.dart';

class AppProvider extends ChangeNotifier {
  bool isDark = false;
  setDarkMode() {
    isDark = !isDark;
    notifyListeners();
  }

  GlobalKey<FormState> signinKey = GlobalKey();
  GlobalKey<FormState> signupKey = GlobalKey();

  TextEditingController emailController = TextEditingController();
  TextEditingController messagesController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  TextEditingController firstnameController = TextEditingController();
  TextEditingController lastnameController = TextEditingController();
  TextEditingController fullnameController = TextEditingController();
  TextEditingController oldPassController = TextEditingController();
  TextEditingController newPassController = TextEditingController();
  TextEditingController newPassRController = TextEditingController();
  TextEditingController addressNameController = TextEditingController();
  TextEditingController addressAddressController = TextEditingController();
  TextEditingController addressCityController = TextEditingController();
  TextEditingController addressPostalController = TextEditingController();
  TextEditingController addressStateController = TextEditingController();
  TextEditingController ratingController = TextEditingController();
  int homePageIndex = 0;
  List<String> orderFilters = ["Delivered", "Processing", "Idle", "Cancled"];
  String orderFilter = "Delivered";
  List<String> states = ["West Bank", "Jarusalem", "48 Land"];
  int chosenAddress = 0;
  List<MessageModel> messagesList = [];
  int id = 11;
  late User loggedUser;
  Chat? selectedChat;
//   final FlutterSoundRecorder recorder = FlutterSoundRecorder();
//   savePath(String? x){
//     path=x;
//     notifyListeners();
//   }
// Future<void> requestPermission() async {
//   var status = await Permission.microphone.request();
//   if (status != PermissionStatus.granted) {
//     // Handle the case when permission is not granted
//     throw RecordingPermissionException('Microphone permission not granted');
//   }
// }
// Future<void> initRecorder() async {
//   await recorder.openRecorder();
//   await requestPermission();  
// }
// String? path;
  changeChat(int i) {
    selectedChat = loggedUser.chats![i];
    notifyListeners();
  }

  String state = "idle";
  changeState(String s) {
    state = s;
    notifyListeners();
  }

  List<MessageModel> chatMessages = [
    // MessageModel(
    //   id: 1,
    //   sender_id: 11,
    //   receiver_id: 1,
    //   message_text: 'Hi, I need some help with a coding problem.',
    //   send_date: DateTime.now().subtract(Duration(minutes: 10)),
    // ),
    // MessageModel(
    //   id: 2,
    //   sender_id: 1,
    //   receiver_id: 11,
    //   message_text: 'Sure, I\'d be happy to help! What seems to be the issue?',
    //   send_date: DateTime.now().subtract(Duration(minutes: 9)),
    // ),
    // MessageModel(
    //   id: 3,
    //   sender_id: 11,
    //   receiver_id: 1,
    //   message_text:
    //       'I am working on a Flutter app and I am facing an error with the build.',
    //   send_date: DateTime.now().subtract(Duration(minutes: 8)),
    // ),
    // MessageModel(
    //   id: 4,
    //   sender_id: 1,
    //   receiver_id: 11,
    //   message_text:
    //       'Can you please provide more details or share the error message?',
    //   send_date: DateTime.now().subtract(Duration(minutes: 7)),
    // ),
    // MessageModel(
    //   id: 5,
    //   sender_id: 11,
    //   receiver_id: 1,
    //   message_text:
    //       'Here is the error message: "Failed to compile lib/main.dart".',
    //   send_date: DateTime.now().subtract(Duration(minutes: 6)),
    // ),
    // MessageModel(
    //   id: 6,
    //   sender_id: 1,
    //   receiver_id: 11,
    //   message_text:
    //       'It looks like there might be a syntax error in your code. Have you checked for any missing semicolons or mismatched brackets?',
    //   send_date: DateTime.now().subtract(Duration(minutes: 5)),
    // ),
    // MessageModel(
    //   id: 7,
    //   sender_id: 11,
    //   receiver_id: 1,
    //   message_text: 'Yes, I have checked for those. Everything seems fine.',
    //   send_date: DateTime.now().subtract(Duration(minutes: 4)),
    // ),
    // MessageModel(
    //   id: 8,
    //   sender_id: 1,
    //   receiver_id: 11,
    //   message_text:
    //       'In that case, could you share the relevant part of your code?',
    //   send_date: DateTime.now().subtract(Duration(minutes: 3)),
    // ),
    // MessageModel(
    //   id: 9,
    //   sender_id: 11,
    //   receiver_id: 1,
    //   message_text:
    //       'Sure, here it is:\n\nvoid main() {\n runApp(MyApp());\n}\n\nclass MyApp extends StatelessWidget {\n @override\n Widget build(BuildContext context) {\n return MaterialApp(\n home: Scaffold(\n appBar: AppBar(\n title: Text(\'Flutter Demo\'),\n ),\n body: Center(\n child: Text(\'Hello World\'),\n ),\n ),\n );\n }\n}',
    //   send_date: DateTime.now().subtract(Duration(minutes: 2)),
    // ),
    // MessageModel(
    //   id: 10,
    //   sender_id: 1,
    //   receiver_id: 11,
    //   message_text:
    //       'The code looks good at a glance. Have you tried running "flutter clean" and then "flutter pub get" before building the app?',
    //   send_date: DateTime.now().subtract(Duration(minutes: 1)),
    // ),
    // MessageModel(
    //   id: 11,
    //   sender_id: 11,
    //   receiver_id: 1,
    //   message_text: 'No, I haven\'t tried that yet. Let me give it a shot.',
    //   send_date: DateTime.now(),
    // ),
  ];
  login() async {
    final res = await API.api.login(<String, dynamic>{
      "phone": emailController.text,
      "password": passwordController.text
    });
    log(res.body);
    if (res.statusCode == 200) {
      final data = jsonDecode(res.body);
      API.api.token = data['token'];
      loggedUser = User.fromMap(data['user']);
      // await initRecorder();
      return true;
    }
    return false;
  }

  signUp() async {
    final res = await API.api.signup(<String, dynamic>{
      "phone": emailController.text,
      "password": passwordController.text,
      "username": firstnameController.text
    });
    log(res.body);
    if (res.statusCode == 200) {
      final data = jsonDecode(res.body);
      API.api.token = data['token'];
      loggedUser = User.fromMap(data['user']);
      // await initRecorder();
      return true;
    }
    return false;
  }

  newChat() {
    selectedChat = null;
    notifyListeners();
  }

  sendMessage() async {
    if (messagesController.text.isNotEmpty) {
      changeState("generating");
      Map<String, dynamic> mes = {
        "text": messagesController.text,
        "chatId": selectedChat == null ? "1" : selectedChat!.id
      };
      final res = await API.api.sendMessage(mes);
      log(res.body);
      if (res.statusCode == 200) {
        if (selectedChat == null) {
          loggedUser.chats!.add(Chat.fromMap(jsonDecode(res.body)[0]));
          selectedChat = loggedUser.chats![loggedUser.chats!.length - 1];
          loggedUser.chats!.sort(
            (b, a) => a.updatedAt.compareTo(b.updatedAt),
          );
        } else {
          Map<String, dynamic> data = jsonDecode(res.body)[0];
          for (int i = 0; i < loggedUser.chats!.length; i++) {
            if (loggedUser.chats![i].id == data['_id']) {
              for (int j = 0; j < (data['messages'] as List).length; j++) {
                loggedUser.chats![i].messages!
                    .add(Message.fromMap((data['messages'][j])));
              }
              loggedUser.chats!.sort(
                (b, a) => a.updatedAt.compareTo(b.updatedAt),
              );
            }
          }
        }
        notifyListeners();
      }
      changeState("idle");

      log(messagesList.length.toString());
      notifyListeners();
    }
  }

  changeAddress(int x) {
    chosenAddress = x;
    notifyListeners();
  }

  changeOrderFilter(value) {
    orderFilter = value;
    notifyListeners();
  }

  bool showExpandedItems = false;
  changeShowExpandedItems() {
    showExpandedItems = !showExpandedItems;
    notifyListeners();
  }

  List<String> sorts = [
    'Popular',
    'Newest',
    'Customer Review',
    'Price: Lowest to high',
    'Price: Highest to low'
  ];
  String selectedSort = 'Price: Lowest to high';
  List<String> categories = ["Women", "Men", "Unisex"];
  RangeValues currentRangeValues = const RangeValues(78, 143);
  String chosedCategory = "Women";
  bool withPhoto = false;
  double initialRating = 4;
  changeRating(x) {
    initialRating = x;
    notifyListeners();
  }

  changeWithPhoto(bool x) {
    withPhoto = x;
    notifyListeners();
  }

  changeCategory(String text) {
    chosedCategory = text;
    notifyListeners();
  }

  changeRangeValues(values) {
    currentRangeValues = values;
    notifyListeners();
  }

  changeSort(String s) {
    selectedSort = s;
    notifyListeners();
  }

  changeHomeIndex(int x) {
    homePageIndex = x;
    log(homePageIndex.toString());
    notifyListeners();
  }

  String? isANumber(String? string) {
    if (string == null || string.isEmpty) {
      return 'Required field'.tr();
    }
    if (!isNumeric(string)) {
      return 'Only Numbers Allowed'.tr();
    }
    return null;
  }

  String? passwordValidation(String? password) {
    if (password == null || password.isEmpty) {
      return "Required field".tr();
    } else if (password.length < 6) {
      return 'Error, the password must be larger than 6 letters'.tr();
    }
    return null;
  }

  String? passwordSignValidation(String? password) {
    if (password == null || password.isEmpty) {
      return "Required field".tr();
    } else if (password.length < 6) {
      return 'Error, the password must be larger than 6 letters'.tr();
    }
    if (passwordController.text != confirmPasswordController.text) {
      return 'passwords are not the same';
    }

    return null;
  }

  String? requiredValidation(String? content) {
    if (content == null || content.isEmpty) {
      return "Required field".tr();
    }
    return null;
  }

  String? phoneValidation(String? content) {
    if (content == null || content.isEmpty) {
      return 'Required field'.tr();
    }
    if (!isNumeric(content)) {
      return "InCorrect phone number syntax".tr();
    }
    return null;
  }

  String? emailValidation(String? email) {
    if (email == null || email.isEmpty) {
      return 'Required field'.tr();
    } else if (!isEmail(email)) {
      return 'Enter A valid Email'.tr();
    }
    return null;
  }
}
