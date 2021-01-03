import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:foto_zweig/decoration/button_colors.dart';
import 'package:foto_zweig/enums/auth_mode_enum.dart';
import 'package:foto_zweig/models/foto_user.dart';
import 'package:foto_zweig/services/init_fotos.dart';
import 'package:foto_zweig/widgets/rounded_button.dart';
import 'package:http/http.dart' as http;

class TagDeleteDialog extends StatefulWidget {
  final String tagVal;
  final String tagKey;
  TagDeleteDialog(this.tagVal, this.tagKey);

  @override
  _TagDeleteDialogState createState() => _TagDeleteDialogState();
}

class _TagDeleteDialogState extends State<TagDeleteDialog> {
  int _countOfTags;

  @override
  void initState() {
    super.initState();
    _countTags();
  }

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
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _countOfTags == null ? CircularProgressIndicator() : _warnText(),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              RoundedButtonWidget(
                color: Colors.red,
                isActive: _countOfTags != null,
                text: 'Löschen!',
                onPressed: () {
                  Navigator.pop(context, true);
                },
              ),
              Container(
                width: 10,
              ),
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

  Widget _warnText() {
    double fontSize = 17;
    Color darkColor = Colors.black87;
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
          text: 'Das Schlüsselwort "${widget.tagVal}" wird ',
          style: TextStyle(fontSize: fontSize, color: darkColor),
          children: [
            TextSpan(
              text: '$_countOfTags mal',
              style: TextStyle(
                color: Colors.red,
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextSpan(
              text:
                  ' verwendet.\nSind Sie sicher dass Sie es trotzdem löschen wollen?',
              style: TextStyle(fontSize: fontSize, color: darkColor),
            ),
          ]),
    );
  }

  _countTags() async {
    final http.Response response =
        await http.get(API_URL + 'countKeyword?key=${widget.tagKey}');
    final Map<String, dynamic> data = json.decode(response.body);
    setState(() {
      _countOfTags = data['count'];
    });
  }
}
