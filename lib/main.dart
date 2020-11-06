import 'package:flutter/material.dart';
import 'package:foto_zweig/enums/item_type_enum.dart';
import 'package:foto_zweig/enums/sorting_typs_enum.dart';
import 'package:foto_zweig/models/main_foto.dart';
import 'package:foto_zweig/services/init_fotos.dart';
import 'package:foto_zweig/services/sorting_service.dart';
import 'package:foto_zweig/widgets/image_content.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
  SortingService _sortingService = SortingService();
  ItemTypeEnum _itemType = ItemTypeEnum.FOTO;
  Color _myColor = Colors.white;
  bool _isFilterMenuOpen = false;

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
        backgroundColor: Color.fromRGBO(86, 61, 124, 1),
        centerTitle: false,
        title: Text('Foto Zweig'),
        actions: <Widget>[
          new FlatButton(
                    onPressed: () => setState(() {
                      _itemType = ItemTypeEnum.FOTO;
                    }),
                  child: Text('Fotos'),
                  textColor: Colors.white,
                ),
                new FlatButton(
                    onPressed: () => setState(() {
                      _itemType = ItemTypeEnum.DOCUMENT;
                    }),
                    child: Text('Dokumente'), 
                    textColor: Colors.white),
                Flexible(
                    child: Container(
                      margin: EdgeInsets.all(5),
                      child: TextField(
                          decoration: InputDecoration (
                            hintText: ' Suche...',     
                            filled: true,
                            fillColor: Colors.white,      
                          ),
                          onChanged: (val) => setState((){
                            _shownItems = _sortingService.sortFilterList(searchText: val);
                          }),
                        ),
                    )),
                SignInButton(
                  Buttons.Google,
                  text: 'Anmelden',
                  onPressed: () {},
                ),
        ],
      ),
      body: ListView(
        children: [
          Container(
            // TODO Sort filter field
            padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            color: Color.fromRGBO(248, 249, 250, 1),
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
              child: ImageContentWidget(_shownItems, _itemType))
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
      icon: Icon(Icons.arrow_downward),
      iconSize: 24,
      elevation: 16,
      style: TextStyle(color: Colors.deepPurple),
      underline: Container(
        height: 2,
        color: Colors.deepPurpleAccent,
      ),
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
      style: TextStyle(color: Colors.deepPurple),
      underline: Container(
        height: 2,
        color: Colors.deepPurpleAccent,
      ),
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
      style: TextStyle(color: Colors.deepPurple),
      underline: Container(
        height: 2,
        color: Colors.deepPurpleAccent,
      ),
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
      style: TextStyle(color: Colors.deepPurple),
      underline: Container(
        height: 2,
        color: Colors.deepPurpleAccent,
      ),
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
