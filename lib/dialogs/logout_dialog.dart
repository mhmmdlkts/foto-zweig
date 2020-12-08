import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:foto_zweig/decoration/button_colors.dart';
import 'package:foto_zweig/enums/auth_mode_enum.dart';
import 'package:foto_zweig/models/foto_user.dart';
import 'package:foto_zweig/services/init_fotos.dart';
import 'package:foto_zweig/widgets/rounded_button.dart';
import 'package:http/http.dart' as http;


class LogoutDialog extends StatefulWidget {
  final FotoUser fotoUser;
  LogoutDialog(this.fotoUser);

  @override
  _LogoutDialogState createState() => _LogoutDialogState();
}

class _LogoutDialogState extends State<LogoutDialog> {

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
          Text("Ausloggen", style: TextStyle(fontSize: 36),),
          Container(
            width: 400,
            child: Divider(),
          ),
          Text("Email: " + widget.fotoUser.email),
          Text("Name: " + widget.fotoUser.name),
          widget.fotoUser.authMode == AuthModeEnum.ADMIN?
              Text("Super User"):Container(),
          Container(width: 0, height: 10,),
          Row(
            mainAxisSize:  MainAxisSize.min,
            children: [
              RoundedButtonWidget(
                color: Colors.red,
                text: 'Ausloggen!',
                onPressed: () {
                  Navigator.pop(context, true);
                },
              ),
              Container(width: 10,),
              RoundedButtonWidget(
                color: Colors.grey,
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