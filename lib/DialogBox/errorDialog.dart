import 'package:flutter/material.dart';
import 'package:icar/authenticationScreen.dart';
class ErrorAlertDialog extends StatelessWidget {
  final String message;
  const ErrorAlertDialog({Key key,@required this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      key: key,
      content: Text(message),
      actions: [
        ElevatedButton(
          onPressed: (){
        Route newRoute = MaterialPageRoute(builder: (context) => AuthenticationScreen());
        },
          child: Center(
            child: Text("OK"),
          ),
          )
      ],
    );
  }
}
