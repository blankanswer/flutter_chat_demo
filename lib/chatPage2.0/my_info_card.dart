import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:getwidget/getwidget.dart';

class MyInfoCard extends StatefulWidget {
  // late final bool showCard;
  MyInfoCard({Key? key}) : super(key: key);


  @override
  _MyInfoCardState createState() => _MyInfoCardState();
}

class _MyInfoCardState extends State<MyInfoCard> {
  // get showCard => null;


  @override
  Widget build(BuildContext context) {
    return GFIconButton(
      icon: Icon(
        Icons.share,
        color: Colors.white,
      ),
      onPressed: () => _dialogBuilder(context),
      type: GFButtonType.transparent,
    );
  }


  Future<void> _dialogBuilder(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('关于BlankAnswer和他的demo'),
          content: Flexible(
            child: Text('你好鸭，很高兴你发现了我的小demo，图一乐，感谢理解捏。'),
          ),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('联系我鸭'),
              onPressed: () {
                // Navigator.of(context).pop();
                Clipboard.setData(const ClipboardData(text: '2452841017'));
                // Show a snackbar to indicate the copy action
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("已复制到剪贴板"),
                  ),
                );
              },
            ),
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('关闭'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
