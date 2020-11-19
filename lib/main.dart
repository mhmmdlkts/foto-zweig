import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:foto_zweig/enums/item_type_enum.dart';
import 'package:foto_zweig/enums/sorting_typs_enum.dart';
import 'package:foto_zweig/models/item_infos/item_type.dart';
import 'package:foto_zweig/models/main_foto.dart';
import 'package:foto_zweig/services/authentication.dart';
import 'package:foto_zweig/services/init_fotos.dart';
import 'package:foto_zweig/services/sorting_service.dart';
import 'package:foto_zweig/widgets/image_content.dart';
import 'package:foto_zweig/widgets/rounded_button.dart';
import 'package:foto_zweig/widgets/upload_dialog.dart';
import 'decoration/button_colors.dart';
import 'enums/auth_mode_enum.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "FotoZweig",
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final AuthService _authService = AuthService();
  SortingService _sortingService = SortingService();
  ItemTypeEnum _itemType = ItemTypeEnum.FOTO;
  Color _myColor = Colors.white;
  bool _isFilterMenuOpen = false;
  AuthModeEnum _authModeEnum = AuthModeEnum.ADMIN;

  List<SmallFotoItem> _shownItems = List();

  @override
  void initState() {
    super.initState();

    InitFotos.getAllItems().then((value) => setState(() {
          _sortingService.list = (value);
          _shownItems = _sortingService.sortFilterList();
        }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _myColor,
      appBar: AppBar(
        backgroundColor: ButtonColors.appBarColor,
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
            child: new TextButton(
                child: Text('Foto Zweig',
                    style: TextStyle(color: Colors.white, fontSize: 20.0)),
                onPressed: () {}),
          ),
          Container(
            decoration: _itemType == ItemTypeEnum.FOTO
                ? BoxDecoration(
                    border: Border(
                        bottom: BorderSide(color: Colors.white, width: 5)))
                : null,
            child: new FlatButton(
              onPressed: () => setState(() {
                _itemType = ItemTypeEnum.FOTO;
              }),
              child: Text('Fotos'),
              textColor: Colors.white,
            ),
          ),
          Container(
            decoration: _itemType == ItemTypeEnum.DOCUMENT
                ? BoxDecoration(
                    border: Border(
                        bottom: BorderSide(color: Colors.white, width: 5)))
                : null,
            child: new FlatButton(
                onPressed: () => setState(() {
                      _itemType = ItemTypeEnum.DOCUMENT;
                    }),
                child: Text('Dokumente'),
                textColor: Colors.white),
          ),
          Flexible(
              child: Container(
            margin: EdgeInsets.all(5),
            child: TextField(
              decoration: InputDecoration(
                hintText: ' Suche...',
                filled: true,
                fillColor: Colors.white,
              ),
              onChanged: (val) => setState(() {
                _shownItems = _sortingService.sortFilterList(searchText: val);
              }),
            ),
          )),
          Visibility(
            visible: _authModeEnum == AuthModeEnum.ADMIN,
            child: Center(
              child: RoundedButtonWidget(
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return UploadDialog();
                      });
                },
                color: Colors.white,
                secondColor: ButtonColors.appBarColor,
                text: "Hochladen",
              ),
            ),
          ),
          GestureDetector(
              onTap: () {
                // start for Test
                setState(() {
                  _authModeEnum =
                      _authModeEnum == null ? AuthModeEnum.ADMIN : null;
                });
                // end   for Test
                //_authService.signInWithGoogle();
              },
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Center(
                  child: Stack(
                    children: [
                      Icon(
                        Icons.account_circle,
                        color: Colors.white,
                        size: 42,
                      ),
                      Visibility(
                        visible: _authModeEnum == AuthModeEnum.ADMIN,
                        child: CircleAvatar(
                          radius: 20,
                          backgroundImage: NetworkImage(
                              'https://cdnb.artstation.com/p/assets/images/images/011/693/779/large/youssef-hesham-heisenberg-upres.jpg?1530893146'),
                          backgroundColor: Colors.transparent,
                        ),
                      )
                    ],
                  ),
                ),
              )),
        ],
      ),
      body: ListView(
        children: [
          Container(
            // TODO Sort filter field
            padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            color: ButtonColors.backgroundColor,
            child: Row(
              children: [
                Opacity(
                  opacity: _isFilterMenuOpen ? 1 : 0.6,
                  child: IconButton(
                    icon: Icon(Icons.sort),
                    onPressed: () => setState(() {
                      _isFilterMenuOpen = !_isFilterMenuOpen;
                    }),
                  ),
                ),
                Visibility(
                  visible: _isFilterMenuOpen,
                  child: _getFilters(),
                ),
                _sortingDropDown(),
                IconButton(
                    icon: Icon(_sortingService.isDesc
                        ? Icons.arrow_upward
                        : Icons.arrow_downward),
                    onPressed: () => setState(() {
                          _shownItems = _sortingService.sortFilterList(
                              isDesc: !_sortingService.isDesc);
                        })),
              ],
            ),
            alignment: Alignment.centerLeft,
          ),
          Padding(
              padding: EdgeInsets.only(right: 16),
              child: ImageContentWidget(_shownItems, _itemType, _authModeEnum))
        ],
      ),
    );
  }

  Widget _getFilters() {
    return Row(
      children: [
        Container(
          margin: EdgeInsets.only(right: 10),
          width: 100,
          child: _filterOrt(),
        ),
        Container(
          margin: EdgeInsets.only(right: 10),
          width: 100,
          child: _filterVon(),
        ),
        Container(
          margin: EdgeInsets.only(right: 10),
          width: 100,
          child: _filterBis(),
        )
      ],
    );
  }

  Widget _sortingDropDown() {
    return DropdownButton<String>(
      value: _sortingService.getTyp(),
      underline: Container(),
      onChanged: (String newValue) {
        SortingTypsEnum a;
        if (newValue == 'Ort') a = SortingTypsEnum.ORT;
        if (newValue == 'Datum') a = SortingTypsEnum.DATE;
        if (newValue == 'Kurzbezeichnung') a = SortingTypsEnum.DESCRIPTION;
        setState(() {
          _sortingService.sortingTyp = a;
          _shownItems = _sortingService.sortFilterList();
        });
      },
      items: <String>['Ort', 'Datum', 'Kurzbezeichnung']
          .map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }

  Widget _filterOrt() {
    return DropdownButton<String>(
      value: "Ort",
      elevation: 16,
      style: TextStyle(color: Colors.blue),
      underline: Container(),
      onChanged: (String newValue) {
        setState(() {});
      },
      items: <String>['Ort'].map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }

  Widget _filterVon() {
    return DropdownButton<String>(
      value: "Von",
      elevation: 16,
      style: TextStyle(color: Colors.blue),
      underline: Container(),
      onChanged: (String newValue) {
        setState(() {});
      },
      items: <String>['Von'].map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }

  Widget _filterBis() {
    return DropdownButton<String>(
      value: "Bis",
      elevation: 16,
      style: TextStyle(color: Colors.blue),
      underline: Container(),
      onChanged: (String newValue) {
        setState(() {});
      },
      items: <String>['Bis'].map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }
}
