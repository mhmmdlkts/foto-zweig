import 'package:flutter/material.dart';
import 'package:foto_zweig/decoration/button_colors.dart';
import 'package:foto_zweig/models/main_foto.dart';
import 'package:foto_zweig/screens/admin_view_edit.dart';
import 'package:foto_zweig/widgets/rounded_button.dart';
import 'package:foto_zweig/enums/auth_mode_enum.dart';

class DetailsScreen extends StatefulWidget {
  final SmallFotoItem smallFotoItem;
  final AuthModeEnum authModeEnum;

  DetailsScreen(this.smallFotoItem, this.authModeEnum);

  @override
  _DetailsScreenState createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  bool _isEditing = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: ButtonColors.appBarColor,
          title: Text('Foto Zweig'),
        ),
        body: SingleChildScrollView(
          child: Row(
            children: [
              Flexible(
                  flex: 1,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Image.network(widget.smallFotoItem.path),
                  )),
              Flexible(
                  flex: 1,
                  child: _isEditing
                      ? Container(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          child:
                              AdminViewEdit(_cancelEdit, widget.smallFotoItem))
                      : _showContent(context))
            ],
          ),
        ));
  }

  void _cancelEdit() {
    setState(() {
      _isEditing = false;
    });
  }

  Widget _showContent(BuildContext context) => Container(
        height: MediaQuery.of(context).size.height,
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Visibility(
              visible: widget.authModeEnum == AuthModeEnum.ADMIN,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  RoundedButtonWidget(
                    color: Colors.redAccent,
                    text: "Löschen",
                  ),
                  Container(
                    width: 10,
                  ),
                  RoundedButtonWidget(
                    text: "Editieren",
                    onPressed: () {
                      setState(() {
                        _isEditing = !_isEditing;
                      });
                    },
                  )
                ],
              ),
            ),
            SelectableText(
              widget.smallFotoItem.shortDescription,
              style: TextStyle(
                fontSize: 30,
              ),
            ),
            SelectableText(widget.smallFotoItem.description),
            Divider(
              thickness: 2,
            ),
            Row(
              children: [
                Container(
                  width: 150,
                  child: SelectableText("Zeitraum:"),
                ),
                Flexible(
                  child: SelectableText(
                      widget.smallFotoItem.date.getReadableTime()),
                )
              ],
            ),
            Divider(
              thickness: 2,
            ),
            Row(
              children: [
                Container(
                  width: 150,
                  child: SelectableText("Abgebildete Personen:"),
                ),
                Flexible(
                  child:
                      SelectableText(widget.smallFotoItem.getReadablePersons()),
                )
              ],
            ),
            Divider(
              thickness: 2,
            ),
            Row(
              children: [
                Container(
                  width: 150,
                  child: SelectableText("Ort:"),
                ),
                Flexible(
                  child:
                      SelectableText(widget.smallFotoItem.location?.name ?? ""),
                )
              ],
            ),
            Divider(
              thickness: 2,
            ),
            Row(
              children: [
                Container(
                  width: 150,
                  child: SelectableText("Foto - Typ:"),
                ),
                Flexible(
                    child: SelectableText(
                        widget.smallFotoItem.itemSubType?.name ?? ""))
              ],
            ),
            Divider(
              thickness: 2,
            ),
            Row(
              children: [
                Container(
                  width: 150,
                  child: SelectableText("Rechteinhaber:"),
                ),
                Flexible(
                    child: SelectableText(
                        widget.smallFotoItem.rightOwner?.name ?? "unbekannt"))
              ],
            ),
            Divider(
              thickness: 2,
            ),
            Row(
              children: [
                Container(
                  width: 150,
                  child: SelectableText("Institution:"),
                ),
                Flexible(
                    child: SelectableText(
                        widget.smallFotoItem.institution?.name ?? ""))
              ],
            ),
            Divider(
              thickness: 2,
            ),
            Row(
              children: [
                Container(
                  width: 150,
                  child: SelectableText("Vermerk:"),
                ),
                Flexible(
                    child:
                        SelectableText(widget.smallFotoItem.annotation ?? ""))
              ],
            ),
            Divider(
              thickness: 2,
            ),
            Row(
              children: [
                Container(
                  width: 150,
                  child: SelectableText("Stichworte:"),
                ),
                Flexible(child: SelectableText(widget.smallFotoItem.getTags()))
              ],
            ),
            Divider(
              thickness: 2,
            ),
          ],
        ),
      );
}
