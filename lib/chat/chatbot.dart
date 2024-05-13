import 'dart:convert';

import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart'as http;


class ChatBot extends StatefulWidget {
  const ChatBot({super.key});

  @override
  State<ChatBot> createState() => _ChatBotState();
}

class _ChatBotState extends State<ChatBot> {
  ChatUser currentUser= ChatUser(id: '1',firstName: 'Arafat');
  ChatUser Gemini= ChatUser(id: '2',firstName: 'Gemini');
  List<ChatMessage> allmessage= [];
  List<ChatUser>typing=[];
  //AIzaSyDYcyhgl7Sc713NVpAHl28s79mYhFW3K6c
//url link a space dile alphabetic error asbe
  String url= 'https://generativelanguage.googleapis.com/v1/models/gemini-pro:generateContent?key=AIzaSyDYcyhgl7Sc713NVpAHl28s79mYhFW3K6c';
final header = {
    "Content-Type":" application/json"
  };


  getData(ChatMessage m)async{
    typing.add(Gemini);
      allmessage.insert(0, m);
      setState(() {
        
      });
      var data= {
        "contents":[

          {
          "parts": [
            {"text": m.text}
          ]
        }
      ]
      };
      await http.post(Uri.parse(url),
          headers: header,
          body: jsonEncode(data)).then((value) {
             if(value.statusCode==200){
               var results= jsonDecode(value.body);
               print(results['candidates'][0]['content']['parts'][0]['text']);

               //show chat reply
               ChatMessage message= ChatMessage(
                 text: results['candidates'][0]['content']['parts'][0]['text'],
                   user: Gemini,
                   createdAt: DateTime.now());
               allmessage.insert(0, message);

             }else{
               print('error');
             }
      })
          .catchError((e){
      });
    typing.remove(Gemini);
    setState(() {

    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey[100],
        centerTitle: true,
        elevation: 0,
        title: Text('AI Chat Bot '),
      ),
      body: DashChat(
        typingUsers:typing,
          currentUser: currentUser,
          onSend: (ChatMessage m){
            getData(m);
          },
          messages: allmessage),
    );
  }
}
