import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';

class API {
  API._();
  Future<void> downloadFile(String fileurl) async {
    final url = '${server}rest/user/download';
    final response = await http.post(Uri.parse(url), body: {"url": fileurl});

    if (response.statusCode == 200) {
      final dir = await getApplicationDocumentsDirectory();
      final filePath = '${dir.path}/file.pdf';
      final file = File(filePath);

      await file.writeAsBytes(response.bodyBytes);
      OpenFile.open(filePath);
    } else {}
  }

  static API api = API._();
  String server = "http://10.0.2.2:8083/";
  String token = "";
  login(Map<String, dynamic> map) async {
    final res = await http.post(Uri.parse("${server}rest/user/signin"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(map));
    return res;
  }

  sendMessage(Map<String, dynamic> map) async {
    final res =
        await http.post(Uri.parse("${server}rest/chat/${map['chatId']}"),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
              'authorization': token,
            },
            body: jsonEncode(map));
    return res;
  }

  signup(Map<String, dynamic> map) async {
    final res = await http.put(Uri.parse("${server}rest/user/signup"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(map));
    return res;
  }
}
