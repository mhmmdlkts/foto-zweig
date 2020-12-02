import 'package:flutter/material.dart';
import 'package:foto_zweig/widgets/rounded_button.dart';


class SigninDialog extends StatefulWidget {
  @override
  _SigninDialogState createState() => _SigninDialogState();
}

class _SigninDialogState extends State<SigninDialog> {
  String _email = "";
  String _pwd = "";


  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
      ),      
      elevation: 0.0,
      backgroundColor: Colors.white,
      child: dialogContent(context),
    );
  }
  dialogContent(BuildContext context) {
    return Container(
      child: Column(
        mainAxisSize:  MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text("Einloggen", style: TextStyle(fontSize: 36),),
          Container(
            width: 400,
            child: Divider(),
          ),
          Text("Email:"),
          Container(
            width: 500,
            height: 40,
            child: TextField(
              decoration: new InputDecoration(
                border: new OutlineInputBorder(
                    borderSide: new BorderSide(color: Colors.teal)),
                ),
              onChanged: (val) {
                _email = val;
                print(_email);
              },
            ),
          ),
          Text("Passwort:"),
          Container(
            width: 500,
            height: 40,
            child: TextField(
              decoration: new InputDecoration(
                border: new OutlineInputBorder(
                    borderSide: new BorderSide(color: Colors.teal)),
                ),
              onChanged: (val) {
                _pwd = val;
              },
            ),
          ),

          Container(height: 20, width: 0,),
          Row(
            mainAxisSize:  MainAxisSize.min,
            children: [
              RoundedButtonWidget(
                color: Colors.green,
                text: "Login",
                 onPressed: () {
                  Navigator.pop(context, false);
                },
              ),
              Container(width: 10,),
              RoundedButtonWidget(
                color: Colors.red,
                text: "Schließen",
                onPressed: () {
                  Navigator.pop(context, false);
                },
              ),
            ],
          )
        ],
      ),
      padding: EdgeInsets.all(10),
    );
  }

}