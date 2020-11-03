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
              child: Image.network(smallFotoItem.path),
            ),
            Flexible(
              flex: 1,
              child: Column(
                children: [
                  Text(smallFotoItem.shortDescription, style: TextStyle(fontSize: 30),),
                  Text(smallFotoItem.description),
                  Divider(),
                  Row(
                    children: [
                      Container(
                        width: 300,
                        child: Text("Zeitraum:"),
                      ),
                      Text(smallFotoItem.date.getReadableTime()),
                    ],
                  ),
                  Divider(),
                  Row(
                    children: [
                      Container(
                        width: 300,
                        child: Text("Abgebildete Personen:"),
                      ),
                      Text(smallFotoItem.getReadablePersons()),
                    ],
                  ),
                  Divider(),
                  Row(
                    children: [
                      Container(
                        width: 300,
                        child: Text("Ort:"),
                      ),
                      Text(smallFotoItem.location?.country ?? "")
                    ],
                  ),
                  Divider(),
                  Row(
                    children: [
                      Container(
                        width: 300,
                        child: Text("Foto - Typ:"),
                      ),
                      Text(smallFotoItem.itemType?.name ?? "")
                    ],
                  ),
                  Divider(),
                  Row(
                    children: [
                      Container(
                        width: 300,
                        child: Text("Foto - Typ:"),
                      ),
                      Text("")
                    ],
                  ),
                  Divider(),
                  Row(
                    children: [
                      Container(
                        width: 300,
                        child: Text("Rechteinhaber:"),
                      ),
                      Text(smallFotoItem.rightOwner?.name ?? "")
                    ],
                  ),
                  Divider(),
                  Row(
                    children: [
                      Container(
                        width: 300,
                        child: Text("Institution:"),
                      ),
                      Text(smallFotoItem.institution?.name ?? "")
                    ],
                  ),
                  Divider(),
                  Row(
                    children: [
                      Container(
                        width: 300,
                        child: Text("Vermerk:"),
                      ),
                    ],
                  ),
                  Divider(),
                  Row(
                    children: [
                      Container(
                        width: 300,
                        child: Text("Stichworte:"),
                      ),
                      Text(smallFotoItem.getTags())
                    ],
                  ),
                  Divider(),
                ],
              ),
            )
          ],
        ),
      )
    );
  }
}