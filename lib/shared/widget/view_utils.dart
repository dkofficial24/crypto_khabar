import 'package:flutter/material.dart';

showActionDialog(BuildContext context,
    {@required String title,
    @required String content,
    @required String positiveTextButton,
    @required String negativeTextButton,
    @required Function positiveAction}) {
  showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: Text(title), // To display the title it is optional
          content: Text(content), // Message which will be pop up on the screen
          // Action widget which will provide the user to acknowledge the choice
          actions: [
            TextButton(
              // FlatButton widget is used to make a text to work like a button
              onPressed: () {
                Navigator.pop(context);
              },
              // function used to perform after pressing the button
              child: Text(negativeTextButton),
            ),
            TextButton(
              onPressed: positiveAction,
              child: Text(positiveTextButton),
            ),
          ],
        );
      });
}
