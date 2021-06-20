import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'dart:async';
import 'package:http/http.dart';

class Push extends StatefulWidget {
  @override
  _PushState createState() => _PushState();
}

class _PushState extends State<Push> {
  String tokenId;
  List<String> tokenIdList = [];
  TextEditingController tokenController = new TextEditingController();

  @override
  void initState() {
    super.initState();
    configOneSignel();
    setNotification();
  }

  Future<void> setNotification() async {
    var status = await OneSignal.shared.getPermissionSubscriptionState();
    setState(() {
      this.tokenId = status.subscriptionStatus.userId;
    });
    //tokenId != null ? this.tokenIdList.add(tokenId) : print("");
    tokenController.text=tokenId;
    // tokenId != null
    //     ? sendNotification(tokenIdList, 'How are you?', 'chandan')
    //     : print("not send notification");
  }

  Future<Response> sendNotification(
      List<String> tokenIdList, String contents, String heading) async {
    return await post(
      Uri.parse('https://onesignal.com/api/v1/notifications'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        "app_id":
            '7508957f-19ad-4dc4-b94c-9eecf5b173ce', //kAppId is the App Id that one get from the OneSignal When the application is registered.
        "include_player_ids":
            tokenIdList, //tokenIdList Is the List of All the Token Id to to Whom notification must be sent.

        // android_accent_color reprsent the color of the heading text in the notifiction
        "android_accent_color": "FF9976D2",

        "small_icon": "ic_stat_onesignal_default",

        "large_icon":
            "https://www.filepicker.io/api/file/zPloHSmnQsix82nlj9Aj?filename=name.jpg",

        "headings": {"en": heading},

        "contents": {"en": contents},
      }),
    );
  }

  void configOneSignel() {
    OneSignal.shared.init('7508957f-19ad-4dc4-b94c-9eecf5b173ce');
    OneSignal.shared.setInFocusDisplayType(OSNotificationDisplayType.notification);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextFormField(
            controller: tokenController,
            style: TextStyle(color: Colors.black),
          ),
          TextButton(
              onPressed: () {
                tokenId != null ? this.tokenIdList.add(tokenController.text) : print("");
                sendNotification(tokenIdList, 'Hello How are you', 'chandan');
              },
              child: Text('Pressed Me'))
        ],
      )),
    );
  }
}

class Token {
  String tokenId;
}
