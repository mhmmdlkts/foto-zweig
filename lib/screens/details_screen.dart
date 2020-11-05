import 'package:flutter/material.dart';
import 'package:foto_zweig/models/main_foto.dart';

class DetailsScreen extends StatelessWidget {
  final SmallFotoItem smallFotoItem;
  DetailsScreen(this.smallFotoItem, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color.fromRGBO(86, 61, 124, 1),
          title: Text('Foto Zweig'),
        ),
        body: SingleChildScrollView(
          child: Row(
            children: [
              Flexible(
                  flex: 1,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Image.network(smallFotoItem.path),
                  )),
              Flexible(
                  flex: 1,
                  child: Container(
                    height: MediaQuery.of(context).size.height,
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SelectableText(
                          smallFotoItem.shortDescription,
                          style: TextStyle(
                            fontSize: 30,
                          ),
                        ),
                        SelectableText(smallFotoItem.description),
                        Divider(),
                        Row(
                          children: [
                            Container(
                              width: 150,
                              child: SelectableText("Zeitraum:"),
                            ),
                            Flexible(
                              child: SelectableText(
                                  smallFotoItem.date.getReadableTime()),
                            )
                          ],
                        ),
                        Divider(),
                        Row(
                          children: [
                            Container(
                              width: 150,
                              child: SelectableText("Abgebildete Personen:"),
                            ),
                            Flexible(
                              child: SelectableText(
                                  smallFotoItem.getReadablePersons()),
                            )
                          ],
                        ),
                        Divider(),
                        Row(
                          children: [
                            Container(
                              width: 150,
                              child: SelectableText("Ort:"),
                            ),
                            Flexible(
                              child: SelectableText(
                                  smallFotoItem.location?.name ?? ""),
                            )
                          ],
                        ),
                        Divider(),
                        Row(
                          children: [
                            Container(
                              width: 150,
                              child: SelectableText("Foto - Typ:"),
                            ),
                            Flexible(
                                child: SelectableText(
                                    smallFotoItem.itemSubType?.name ?? ""))
                          ],
                        ),
                        Divider(),
                        Row(
                          children: [
                            Container(
                              width: 150,
                              child: SelectableText("Rechteinhaber:"),
                            ),
                            Flexible(
                                child: SelectableText(
                                    smallFotoItem.rightOwner?.name ??
                                        "unbekannt"))
                          ],
                        ),
                        Divider(),
                        Row(
                          children: [
                            Container(
                              width: 150,
                              child: SelectableText("Institution:"),
                            ),
                            Flexible(
                                child: SelectableText(
                                    smallFotoItem.institution?.name ?? ""))
                          ],
                        ),
                        Divider(),
                        Row(
                          children: [
                            Container(
                              width: 150,
                              child: SelectableText("Vermerk:"),
                            ),
                            Flexible(
                                child: SelectableText(
                                    smallFotoItem.annotation ?? ""))
                          ],
                        ),
                        Divider(),
                        Row(
                          children: [
                            Container(
                              width: 150,
                              child: SelectableText("Stichworte:"),
                            ),
                            Flexible(
                                child: SelectableText(smallFotoItem.getTags()))
                          ],
                        ),
                        Divider(),
                      ],
                    ),
                  ))
            ],
          ),
        ));
  }
}
