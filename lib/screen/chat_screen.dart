import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => _ChatScreenState() ;
}
class _ChatScreenState extends State<ChatScreen>{


  final String ourUri =
      'https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash-latest:generateContent?key=AIzaSyC4t-_GkGdB3my0vfn0wxaiOhbzbfKinOE';

  final Map<String, String> header = {
    'Content-Type': 'application/json',
  };

  // User type message
  final ChatUser mySelf = ChatUser(
    id: "1",
    firstName: "Rahul",
  );

  // Bot type message
  final ChatUser bot = ChatUser(
    id: "2",
    firstName: "Gemini",
  );

  List<ChatMessage> messages = [];
  List<ChatUser> _typing = [];

  Future<void> getData(ChatMessage m) async {
    _typing.add(bot);
    messages.insert(0, m);
    setState(() {});

    var data = {
      "contents": [
        {
          "parts": [
            {"text": m.text}
          ]
        }
      ]
    };

    try {
      final response = await http.post(
        Uri.parse(ourUri),
        headers: header,
        body: jsonEncode(data),
      );

      if (response.statusCode == 200) {
        var result = jsonDecode(response.body);
        print("Response: $result");

        if (result != null && result.containsKey('candidates')) {
          String botResponseText =
          result['candidates'][0]['content']['parts'][0]['text'];

          ChatMessage botMessage = ChatMessage(
            text: botResponseText,
            user: bot,
            createdAt: DateTime.now(),
          );
          messages.insert(0, botMessage);
          setState(() {});
        } else {
          print("Unexpected response structure: $result");
        }
      } else {
        print("Error: ${response.statusCode}");
      }
    } catch (e) {
      print("Error: $e");
    } finally {
      _typing.remove(bot);
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
   return Scaffold(
     appBar: AppBar(title: Text("Chat"),centerTitle: true,
     ),
     body:DashChat(
       typingUsers: _typing,
       currentUser: mySelf,
       onSend: (ChatMessage m) {
         getData(m);
       },
       messages: messages,
       inputOptions: InputOptions(
         alwaysShowSend: true,
         autocorrect: true,
         inputTextStyle: TextStyle(fontSize: 20),
         cursorStyle: CursorStyle(color: Colors.tealAccent),
       ),
       messageOptions: MessageOptions(
         currentUserContainerColor: Colors.green,
         // showTime: true,
         borderRadius: 10, timePadding: EdgeInsets.all(8.0),
         avatarBuilder: (user, onAvatarTap, onAvatarLongPress) => Center(
           child: Padding(
             padding: const EdgeInsets.only(left: 5 , right: 3 , bottom: 10),
             child: Image.asset(
               "assets/images/boticon.png",alignment: Alignment.center,
               height: 40,
               width: 40,
             ),
           ),
         ),
       ),
     ),
   );
  }

}