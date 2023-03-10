
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'chatPage2.0/chat_list_view.dart';



void main() {
  runApp(ChatApp());
}

class ChatApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(
            fontFamily: 'microsoftBlack'
        ),
        debugShowCheckedModeBanner: false,
        title: 'BlankCharDemo',
        home: AnimatedSplashScreen(

          splash: Image.asset('images/chat.png',height: 500,width: 500,),
          // splashIconSize: 500.0,
          splashTransition: SplashTransition.fadeTransition,
          // backgroundColor: Colors.white,
          nextScreen: ChatScreen(),

        ));

  }
}
