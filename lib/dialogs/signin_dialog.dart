import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:foto_zweig/decoration/button_colors.dart';
import 'package:foto_zweig/models/foto_user.dart';
import 'package:foto_zweig/services/init_fotos.dart';
import 'package:foto_zweig/widgets/rounded_button.dart';
import 'package:http/http.dart' as http;


class SigninDialog extends StatefulWidget {
  @override
  _SigninDialogState createState() => _SigninDialogState();
}

class _SigninDialogState extends State<SigninDialog> {
  String getUrl(name) => '$API_URL/$name';
  String _name = "";
  String _email = "";
  String _pwd = "";
  bool _obscureText = false;
  bool _isSignUp = false;
  int _errorCode;


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
          _isSignUp?_signUpWidget():Container(width: 0, height: 0,),
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
              },
            ),
          ),
          Text("Passwort:"),
          Container(
            width: 500,
            height: 40,
            child: TextField(
              onSubmitted: (val) => _login(),
              obscureText: !_obscureText,
              decoration: new InputDecoration(
                border: new OutlineInputBorder(
                    borderSide: new BorderSide(color: Colors.teal)),
                ),
              onChanged: (val) {
                _pwd = val;
                
              },
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
             Container(
            alignment: Alignment.bottomLeft,
            width: 30,
            height: 40,
            child: Checkbox(
            
            value: _obscureText,
            onChanged: (newValue) { 
                  setState(() {
                    _obscureText = newValue; 
                  }); 
                },
            )
            ),
            Container(
            alignment: Alignment.bottomLeft,
            width: 200,
            height: 25,
              child: Text(
                "Passwort anzeigen: "
              )
            )
          ],),
          Visibility(
            visible: _errorCode != null,
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Flexible(
                child: Text(_getErrorMessage(), style: TextStyle(color: Colors.redAccent),),
              )
            ),
          ),

          Container(height: 20, width: 0,),
          _getLogInSignUpText(),
          Row(
            mainAxisSize:  MainAxisSize.min,
            children: [
              RoundedButtonWidget(
                color: Colors.green,
                text: !_isSignUp?'Einloggen!':'Registrieren!',
                 onPressed: _login
              ),
              Container(width: 10,),
              RoundedButtonWidget(
                color: Colors.red,
                text: "Schließen",
                onPressed: () {
                  Navigator.pop(context, null);
                },
              ),
            ],
          )
        ],
      ),
      padding: EdgeInsets.all(10),
    );
  }

  String _getErrorMessage() {
    switch(_errorCode) {
      case 300:
        return "Benutzername oder Passwort wurde möglicherweise falsch eingegeben.";
    }
    return "";
  }

  _login() async {
    String url = getUrl('signIn') + '?email=${Uri.encodeComponent(_email)}&pwd=${Uri.encodeComponent(_pwd)}';
    if (_isSignUp)
      url += '&name=${Uri.encodeComponent(_name)}';
    print(_isSignUp);
    http.Response response = await http.get(url);
    Map<String, dynamic> jsonData = json.decode(response.body);
    FotoUser user;
    print(url);
    print(jsonData);
    if (jsonData['error'] != null) {
      setState(() {
        _errorCode = jsonData['error'];
      });
      return;
    }
    user = FotoUser.fromJson(jsonData);
    Navigator.pop(context, user);
  }

  Widget _signUpWidget() => Column(
    mainAxisSize:  MainAxisSize.min,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text("Name:"),
      Container(
        width: 500,
        height: 40,
        child: TextField(
          decoration: new InputDecoration(
            border: new OutlineInputBorder(
                borderSide: new BorderSide(color: Colors.teal)),
          ),
          onChanged: (val) {
            _name = val;
          },
        ),
      ),
    ],
  );

  Widget _getLogInSignUpText() {
    Color darkColor = Colors.black87;
    double fontSize = 18;
    return Container(
      padding: EdgeInsets.only(bottom: 20),
      child: InkWell(
        onTap: () => setState(() {
          _isSignUp = !_isSignUp;
        }),
        child: Container(
            child: RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                  text: 'Haben Sie ${_isSignUp?"k":""}einen Account? ',
                  style: TextStyle(
                      color: darkColor,
                      fontSize: fontSize
                  ),
                  children: [
                    TextSpan(
                      text: _isSignUp?'Einloggen!':'Registrieren!',
                      style: TextStyle(
                        color: ButtonColors.appBarColor,
                        fontSize: fontSize,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ]
              ),
            )
        ),
      ),
    );
  }

}