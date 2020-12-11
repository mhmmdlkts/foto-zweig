import 'package:flutter/material.dart';
import 'package:foto_zweig/enums/editing_typ_enum.dart';
import 'package:foto_zweig/enums/item_type_enum.dart';
import 'package:foto_zweig/models/item_infos/location.dart';
import 'package:foto_zweig/models/main_foto.dart';
import 'package:foto_zweig/services/keyword_service.dart';
import 'package:foto_zweig/services/upload_service.dart';
import 'package:foto_zweig/widgets/rounded_button.dart';
import 'package:image_picker_web_redux/image_picker_web_redux.dart';
import 'package:dropdown_search/dropdown_search.dart';

class LocationDialog extends StatefulWidget {
  final Location location;
  final KeywordService ks;
  final String name;

  LocationDialog({this.location, this.name, this.ks});

  @override
  _LocationDialogState createState() => _LocationDialogState();
}

class _LocationDialogState extends State<LocationDialog> {
  Location location;
  bool _isActive = true;
  String dropdownValue = 'Österreich';

  @override
  void initState() {
    super.initState();
    location =
        widget.location == null ? Location(name: widget.name) : widget.location;
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
      padding: EdgeInsets.all(10),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 400,
            child: Text(
              "Ort",
              style: TextStyle(fontSize: 36),
            ),
          ),
          Container(
            height: 10,
            width: 0,
          ),
          Text("Name"),
          Container(
            width: 400,
            child: TextField(
              controller: TextEditingController(text: location.name),
              decoration: new InputDecoration(
                border: new OutlineInputBorder(
                    borderSide: new BorderSide(color: Colors.teal)),
              ),
              onChanged: (val) {
                location.name = val;
              },
            ),
          ),
          Container(
            height: 10,
            width: 0,
          ),
          Text("Land"),
          Container(
              width: 400,
              child: DropdownSearch<String>(
                  mode: Mode.MENU,
                  showSelectedItem: true,
                  items: [
                    "Österreich",
                    "Deutschland",
                    "Brasilien",
                    "USA",
                    "Frankreich",
                    "Italien",
                    "Schweiz",
                    "Abchasien",
                    "Afghanistan",
                    "Ägypten",
                    "Albanien",
                    "Algerien",
                    "Andorra",
                    "Angola",
                    "Anguilla",
                    "Antarktis",
                    "Antigua und Barbuda",
                    "Äquatorialguinea",
                    "Argentinien",
                    "Arktis",
                    "Armenien",
                    "Aruba",
                    "Aserbaidschan",
                    "Äthiopien",
                    "Australien",
                    "Azoren",
                    "Bahamas",
                    "Bahrain",
                    "Bangladesch",
                    "Barbados",
                    "Belarus",
                    "Belgien",
                    "Belize",
                    "Benin",
                    "Bhutan",
                    "Bolivien",
                    "Bosnien und Herzegowina",
                    "Botsuana",
                    "Brunei",
                    "Bulgarien",
                    "Burkina Faso",
                    "Birma/Burma",
                    "Burundi",
                    "Bali",
                    "Chile",
                    "China",
                    "Cookinseln",
                    "Costa Rica",
                    "Dänemark",
                    "Demokratische Republik Kongo",
                    "Dominica",
                    "Dominikanische Republik",
                    "Dschibuti",
                    "Ecuador",
                    "Elfenbeinküste",
                    "El Salvador",
                    "Eritrea",
                    "Estland",
                    "Eswatini",
                    "Falklandinseln",
                    "Fidschi",
                    "Finnland",
                    "Föderierte Staaten von Mikronesien",
                    "Französisch-Polynesien",
                    "Französisch-Guayana",
                    "Gabun",
                    "Gambia",
                    "Georgien",
                    "Ghana",
                    "Grenada",
                    "Griechenland",
                    "Großbritannien",
                    "Grönland",
                    "Guadeloupe",
                    "Guatemala",
                    "Guinea",
                    "Guinea-Bissau",
                    "Guyana",
                    "Haiti",
                    "Honduras",
                    "Indien",
                    "Indonesien",
                    "Irak",
                    "Iran",
                    "Irland",
                    "Island",
                    "Israel",
                    "Jamaika",
                    "Japan",
                    "Jemen",
                    "Jordanien",
                    "Kambodscha",
                    "Kamerun",
                    "Kanada",
                    "Kap Verde",
                    "Kasachstan",
                    "Katar",
                    "Kenia",
                    "Kirgisistan",
                    "Kiribati",
                    "Kolumbien",
                    "Komoren",
                    "Kongo (Republik)",
                    "Kroatien",
                    "Kuba",
                    "Kuwait",
                    "Kosovo",
                    "Laos",
                    "Lesotho",
                    "Lettland",
                    "Libanon",
                    "Liberia",
                    "Libyen",
                    "Liechtenstein",
                    "Litauen",
                    "Luxemburg",
                    "Madagaskar",
                    "Madeira",
                    "Malawi",
                    "Malaysia",
                    "Malediven",
                    "Mali",
                    "Malta",
                    "Marokko",
                    "Marshallinseln",
                    "Martinique",
                    "Mauretanien",
                    "Mauritius",
                    "Mexiko",
                    "(Föderierte Staaten von) Mikronesien",
                    "Moldau",
                    "Monaco",
                    "Mongolei",
                    "Montenegro",
                    "Mosambik",
                    "Myanmar",
                    "Namibia",
                    "Nauru",
                    "Nepal",
                    "Neuseeland",
                    "Nicaragua",
                    "Niederlande",
                    "Niederländische Antillen",
                    "Niger",
                    "Nigeria",
                    "Nordkorea",
                    "Nordmazedonien",
                    "Nordzypern",
                    "Norwegen",
                    "Oman",
                    "Osttimor",
                    "Pakistan",
                    "Palau",
                    "Palästina",
                    "Panama",
                    "Papua-Neuguinea",
                    "Paraguay",
                    "Peru",
                    "Philippinen",
                    "Polen",
                    "Portugal",
                    "Puerto Rico",
                    "Réunion",
                    "Ruanda",
                    "Rumänien",
                    "Russland",
                    "Saint Kitts und Nevis",
                    "Saint Lucia",
                    "Saint Pierre und Miquelon",
                    "Saint Vincent und die Grenadinen",
                    "Salomonen",
                    "Sambia",
                    "Samoa",
                    "San Marino",
                    "São Tomé und Príncipe",
                    "Saudi-Arabien",
                    "Schweden",
                    "Senegal",
                    "Serbien",
                    "Seychellen",
                    "Sierra Leone",
                    "Singapur",
                    "Simbabwe",
                    "Slowakei",
                    "Slowenien",
                    "Somalia",
                    "Spanien",
                    "Sri Lanka",
                    "Südafrika",
                    "Sudan",
                    "Südkorea",
                    "Südsudan",
                    "Suriname",
                    "Syrien",
                    "Tadschikistan",
                    "Taiwan",
                    "Tansania",
                    "Thailand",
                    "Togo",
                    "Tokelau",
                    "Tonga",
                    "Trinidad und Tobago",
                    "Tschad",
                    "Tschechien",
                    "Tunesien",
                    "Türkei",
                    "Turkmenistan",
                    "Tuvalu",
                    "Uganda",
                    "Ukraine",
                    "Ungarn",
                    "Uruguay",
                    "Usbekistan",
                    "Vanuatu",
                    "Vatikan",
                    "Venezuela",
                    "Vereinigte Arabische Emirate",
                    "Vereinigtes Königreich",
                    "Vereinigte Staaten von Amerika",
                    "Vietnam",
                    "Wallis und Futuna",
                    "Weißrussland",
                    "Westsahara",
                    "Zentralafrikanische Republik",
                    "Zypern"
                  ],
                  onChanged: (val) {
                    print(val);
                    location.country = val;
                  },
                  selectedItem: "keine Auswahl",
                  showSearchBox: true,
                  searchBoxDecoration: InputDecoration(
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.fromLTRB(12, 12, 8, 0),
                    labelText: "Land suchen",
                  ))),
          Container(
            height: 10,
            width: 0,
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              RoundedButtonWidget(
                onPressed: () {
                  Navigator.pop(context, null);
                },
                text: "Schließen",
                color: Colors.red,
              ),
              Container(
                width: 10,
              ),
              RoundedButtonWidget(
                onPressed: () async {
                  setState(() {
                    _isActive = false;
                  });
                  if (location != null) {
                    location = Location.copy(location);
                    await widget.ks
                        .editLocation(EditingTypEnum.UPDATE, location);
                  } else {
                    await widget.ks
                        .editLocation(EditingTypEnum.CREATE, location);
                  }
                  Navigator.pop(context, location);
                },
                text: "Speichern",
                color: Colors.green,
                isActive: _isActive,
              )
            ],
          )
        ],
      ),
    );
  }
}
