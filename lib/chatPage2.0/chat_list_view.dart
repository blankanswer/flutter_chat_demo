import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:getwidget/getwidget.dart';
import 'message.dart';
import 'my_info_card.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final List<Message> _messages = <Message>[Message(role: 'assistant', content: '好久不见，是我，你的AI小助手，有什么可以帮助你的吗？')];


  final _textController = TextEditingController();

  // late List<Map<String, String>> _list;

  void _addMessage(String message) async {
    setState(() {
      _messages.insert(
          0, Message(role: 'user', content: message));
    });
    _textController.clear();

    // _list = _messages.map((e) => {'role':e.role, 'content':e.content}).toList();
    // reverse(_list);

    final dio = Dio();
    dio.options.headers['Authorization'] =
        'Bearer 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';
    dio.options.headers['Content-Type'] = 'application/json; charset=utf-8';

    final response = await dio.post(
      'https://api.openai.com/v1/chat/completions',
      data: jsonEncode({
        'model': 'gpt-3.5-turbo',
        // 'messages': [
        //   {'role': 'user', 'content': message}
        // ],
        'messages': _messages
            .map((e) => {'role': e.role, 'content': e.content})
            .toList().reversed.toList()
      }),
    );
    if (response.statusCode == 200) {
      final json = response.data;
      final String message = json['choices'][0]['message']['content'];
      setState(() {
        _messages.insert(
            0, Message(role: 'assistant', content: message));
      });
    } else {
      if (kDebugMode) {
        print('Error: ${response.statusMessage}');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GFAppBar(
        backgroundColor: Colors.black,
        leading:  GFIconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {},
          type: GFButtonType.transparent,
        ),
        title: Text("BlankAnswer\'chat"),
        actions: <Widget>[
          MyInfoCard(),
        ],
      ),
      //多层无限延申组件嵌套，用flexible来替代expanded
      body: Column(
        children: <Widget>[
          Expanded(
            child: ListView.builder(
              itemCount: _messages.length,
              reverse: true,
              itemBuilder: (context, index) {
                final message = _messages[index];
                return Container(
                  margin: EdgeInsets.symmetric(vertical: 6.0,horizontal: 8.0),
                  child: Flexible(

                    child:
                    DecoratedBox(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(colors: [Colors.white,Colors.white]),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            offset: Offset(0,2.0),
                            blurRadius: 4.0
                          )
                        ]
                      ),
                      child:
                      GFListTile(
                          avatar: GFAvatar(
                            backgroundColor: Colors.white,
                            backgroundImage: message.role == 'assistant'
                                ? AssetImage('images/ic_launcher.png')
                                : AssetImage('images/myHeadImage.jpg'),
                            shape: GFAvatarShape.standard,
                          ),

                          titleText: message.content.trim(),
                          subTitleText:
                              'tips:长按复制',
                          icon: const Icon(Icons.favorite),
                        //实现长按复制
                        onLongPress: () {
                          // Copy the text to clipboard
                          Clipboard.setData(ClipboardData(text: message.content.trim()));
                          // Show a snackbar to indicate the copy action
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("已复制到剪贴板"),
                            ),
                          );
                        },
                      ),
                    ),
                    // Container(
                    //   margin: const EdgeInsets.symmetric(
                    //       vertical: 10, horizontal: 16),
                    //   decoration: BoxDecoration(
                    //     color: message.role == 'assistant'
                    //         ? Colors.green.shade100
                    //         : Colors.blue.shade100,
                    //     borderRadius: BorderRadius.circular(8),
                    //   ),
                    //   child: Padding(
                    //     padding: const EdgeInsets.all(12),
                    //     child: SelectableText(
                    //       message.content.trim(),
                    //       style: const TextStyle(
                    //         fontFamily: 'NotoSans',
                    //         fontSize: 16,
                    //         fontWeight: FontWeight.w500,
                    //       ),
                    //       //自动换行处理
                    //       // softWrap: true,
                    //     ),
                    //   ),
                    // ),
                  ),
                );
              },
            ),
          ),
          const Divider(height: 2.5),
          SafeArea(
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
              ),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: _textController,
                      decoration: const InputDecoration(
                        hintText: 'Enter a message',
                        contentPadding: EdgeInsets.all(16.0),
                      ),
                      onSubmitted: _addMessage,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.send),
                    //避免输入无效信息
                    onPressed: () => _textController.text.trim() != ''
                        ? _addMessage(_textController.text)
                        : {},
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
