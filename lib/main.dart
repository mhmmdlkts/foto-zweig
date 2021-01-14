import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:foto_zweig/enums/item_type_enum.dart';
import 'package:foto_zweig/enums/sorting_typs_enum.dart';
import 'package:foto_zweig/models/foto_user.dart';
import 'package:foto_zweig/models/item_infos/location.dart';
import 'package:foto_zweig/models/main_foto.dart';
import 'package:foto_zweig/screens/details_screen.dart';
import 'package:foto_zweig/screens/keyword_edit_screen.dart';
import 'package:foto_zweig/services/authentication.dart';
import 'package:foto_zweig/services/init_fotos.dart';
import 'package:foto_zweig/services/keyword_service.dart';
import 'package:foto_zweig/services/mobile_checker_service.dart';
import 'package:foto_zweig/services/sorting_service.dart';
import 'package:foto_zweig/widgets/image_content.dart';
import 'package:foto_zweig/widgets/rounded_button.dart';
import 'package:foto_zweig/dialogs/upload_dialog.dart';
import 'package:foto_zweig/dialogs/signin_dialog.dart';
import 'decoration/button_colors.dart';
import 'dialogs/logout_dialog.dart';
import 'enums/auth_mode_enum.dart';

void main() {
  runApp(
      MyApp()
  );
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
  final List<Location> _locationList = List();
  final AuthService _authService = AuthService();
  SortingService _sortingService = SortingService();
  ItemTypeEnum _itemType = ItemTypeEnum.FOTO;
  Color _myColor = Colors.white;
  bool _isFilterMenuOpen = false;
  FotoUser _fotoUser;
  final KeywordService _keywordService = KeywordService();
  Location _filterLocationValue;
  DateTime _filterVonDate;
  DateTime _filterBisDate;
  String _searchField = "";

  List<SmallFotoItem> _shownItems = List();

  @override
  void initState() {
    super.initState();
    _initContent();
  }
  void _initLocationList() {
    _locationList.clear();
    _keywordService.locationsJson?.forEach(
            (key, value) => _locationList.add(Location.fromJson(value, key)));
  }

  AuthModeEnum _getAuthMode() => _fotoUser?.authMode??AuthModeEnum.READ_ONLY;

  Future<void> _initContent() async {
    await _keywordService.initKeywords();

    InitFotos.getAllItems(
        _getAuthMode() == AuthModeEnum.ADMIN ? "admin":null, _keywordService
    ).then((value) => setState(() {
      _sortingService.list = value;
      _shownItems = _sortingService.sortList(_keywordService);
      _openAutoEditingScreen(0);
      _initLocationList();
    }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _myColor,
      appBar: AppBar(
        backgroundColor: ButtonColors.appBarColor,
        actions: <Widget>[
          Visibility(
            visible: !MbCheck.isMobile(context),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
              child: new TextButton(
                  child: Text('Foto Zweig',
                      style: TextStyle(color: Colors.white, fontSize: 20.0)),
                  onPressed: () {}),
            ),
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
              child: !MbCheck.isMobile(context)
                  ? Text('Fotos')
                  : Icon(Icons.photo),
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
                child: !MbCheck.isMobile(context)
                    ? Text('Dokumente')
                    : Icon(Icons.insert_drive_file_rounded),
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
              onChanged: (val) {
                _searchField = val;
                _sortFilterContent();
              },
            ),
          )),
          Visibility(
            visible: _getAuthMode() == AuthModeEnum.ADMIN,
            child: Center(
              child: RoundedButtonWidget(
                onPressed: () async {
                  final rtn = await showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return UploadDialog(_fotoUser);
                      });
                  if (rtn ?? false) _initContent();
                },
                color: Colors.white,
                secondColor: ButtonColors.appBarColor,
                text: "Hochladen",
                icon: MbCheck.isMobile(context) ? Icons.upload_rounded : null,
              ),
            ),
          ),
          Container(width: 10,),
          Visibility(
            visible: _getAuthMode() == AuthModeEnum.ADMIN,
            child: Center(
              child: RoundedButtonWidget(
                onPressed: () async {
                  await Navigator.push(context, MaterialPageRoute(builder: (context) =>
                      KeywordEditScreen(ks: _keywordService)));
                },
                color: Colors.white,
                secondColor: ButtonColors.appBarColor,
                text: "Einstellungen",
                icon: MbCheck.isMobile(context) ? Icons.settings : null,
              ),
            ),
          ),
          InkWell(
              onTap: () async {
                //_authService.signInWithGoogle();

                if (_fotoUser == null) {
                  _fotoUser = await showDialog(
                      context: context, builder: (BuildContext context) {
                    return SigninDialog();
                  });
                  if (_fotoUser != null)
                    _refreshContent();
                } else {
                  bool rtn = await showDialog(
                      context: context, builder: (BuildContext context) {
                    return LogoutDialog(_fotoUser);
                  });
                  if (rtn??false) {
                    _fotoUser = null;
                    _refreshContent();
                  }
                }
              },
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Center(
                  child: Stack(
                    children: [
                      Icon(
                        _fotoUser==null?Icons.account_circle:Icons.verified_user,
                        color: Colors.white,
                        size: 42,
                      ),
                    ],
                  ),
                ),
              )),
        ],
      ),
      body: ListView(
        children: [
          Container(
            padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            color: ButtonColors.backgroundColor,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Opacity(
                      opacity: _isFilterMenuOpen ? 1 : 0.6,
                      child: IconButton(
                        icon: Icon(Icons.sort),
                        onPressed: () => setState(() {
                          _isFilterMenuOpen = !_isFilterMenuOpen;
                          if (!_isFilterMenuOpen) {
                            _filterLocationValue = null;
                            _filterBisDate = null;
                            _filterVonDate = null;
                            _shownItems = _sortingService.sortList(_keywordService);
                            //_sortFilterContent();
                          }
                        }),
                      ),
                    ),
                    _sortingDropDown(),
                    IconButton(
                        icon: Icon(_sortingService.isDesc
                            ? Icons.arrow_upward
                            : Icons.arrow_downward),
                        onPressed: () => setState(() {
                          _sortingService.isDesc = !_sortingService.isDesc;
                          _sortFilterContent();
                        })),
                  ],
                ),
                Visibility(
                  visible: _isFilterMenuOpen,
                  child: _getFilters(),
                ),
              ],
            ),
            alignment: Alignment.centerLeft,
          ),
          Padding(
              padding: EdgeInsets.only(right: 16),
              child: ImageContentWidget(_fotoUser, _shownItems, _itemType, _getAuthMode(), _keywordService, onPop: () => _initContent())
          )
        ],
      ),
    );
  }

  void _openAutoEditingScreen(int i) {
    if (i == 0)
      return;
    else if (i == 1) {
      Navigator.push(context, MaterialPageRoute(builder: (context) =>
          KeywordEditScreen(ks: _keywordService)));
    }
    else if (i == 2) {
      setState(() {
        _fotoUser = FotoUser(name: "Ali", email: "mh", authMode: AuthModeEnum.ADMIN, uid: "id");
      });
      if (_shownItems.isEmpty)
        return;
      Navigator.push(context, MaterialPageRoute(builder: (context) =>
          DetailsScreen(_fotoUser, _shownItems[0], AuthModeEnum.ADMIN, _keywordService)));
    }
  }

  _refreshContent() {
    setState(() {
      _shownItems = List();
    });
    _initContent();
  }

  Widget _getFilters() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.only(right: 10),
          child: _filterOrt(),
        ),
        Container(
          margin: EdgeInsets.only(right: 10),
          child: _filterVon(),
        ),
        Container(
          margin: EdgeInsets.only(right: 10),
          child: _filterBis(),
        ),
        RaisedButton(
          child: Text('No Filter'),
          onPressed: () => setState(() {
            _shownItems = _sortingService.sortList(_keywordService);
          
            //print('You tapped on FlatButton');
          }),
        ),
        
      ],
    );
  }

  Widget _sortingDropDown() {
    return DropdownButton<String>(
      value: _sortingService.getTyp(),
      underline: Container(),
      onChanged: (String newValue) {
        SortingTypsEnum sortingTypEnum;
        if (newValue == 'Ort') sortingTypEnum = SortingTypsEnum.ORT;
        if (newValue == 'Datum') sortingTypEnum = SortingTypsEnum.DATE;
        if (newValue == 'Kurzbezeichnung') sortingTypEnum = SortingTypsEnum.DESCRIPTION;
        _sortingService.setTyp(sortingTypEnum);
        _sortingService.sortingTyp = sortingTypEnum;
        _sortFilterContent();
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
    return DropdownButton<Location>(
      hint: Text("Ort"),
      value: _filterLocationValue,
      elevation: 16,
      style: TextStyle(color: Colors.blue),
      underline: Container(),
      onChanged: (Location newValue) {
        setState(() {
          _filterLocationValue = newValue;
          _sortFilterContent();
        });
      },
      items: _locationList.map<DropdownMenuItem<Location>>((Location value) {
        return DropdownMenuItem<Location>(
          value: value,
          child: Text(value.name),
        );
      }).toList(),
    );
  }

  Widget _filterVon() {
    return DropdownButton<DateTime>(
      hint: Text("Von"),
      value: _filterVonDate,
      elevation: 16,
      style: TextStyle(color: Colors.blue),
      underline: Container(),
      onChanged: (DateTime newValue) {
        setState(() {
          _filterVonDate = newValue;
          _sortFilterContent();
        });
      },
      items: _getDateTimes().map<DropdownMenuItem<DateTime>>((DateTime value) {
        return DropdownMenuItem<DateTime>(
          value: value,
          child: Text(value.year.toString()),
        );
      }).toList(),
    );
  }

  Widget _filterBis() {
    return DropdownButton<DateTime>(
      hint: Text("Bis"),
      value: _filterBisDate,
      elevation: 16,
      style: TextStyle(color: Colors.blue),
      underline: Container(),
      onChanged: (DateTime newValue) {
        setState(() {
          _filterBisDate = newValue;
          _sortFilterContent();
        });
      },
      items: _getDateTimes().map<DropdownMenuItem<DateTime>>((DateTime value) {
        return DropdownMenuItem<DateTime>(
          value: value,
          child: Text(value.year.toString()),
        );
      }).toList(),
    );
  }

  List<DateTime> _getDateTimes() {
    List<DateTime> list = [];
    for (int i = 1880; i < 2022; i++)
      list.add(DateTime(i));
    return list;
  }

  void _sortFilterContent() {
    setState(() {
      _shownItems = _sortingService.sortList(_keywordService, searchText: _searchField, vonFilter: _filterVonDate, bisFilter: _filterBisDate, locationFilter: _filterLocationValue);
    });
  }
}
