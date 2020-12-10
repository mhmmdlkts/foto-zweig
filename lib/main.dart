import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:foto_zweig/enums/item_type_enum.dart';
import 'package:foto_zweig/enums/sorting_typs_enum.dart';
import 'package:foto_zweig/models/foto_user.dart';
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
  final AuthService _authService = AuthService();
  SortingService _sortingService = SortingService();
  ItemTypeEnum _itemType = ItemTypeEnum.FOTO;
  Color _myColor = Colors.white;
  bool _isFilterMenuOpen = false;
  FotoUser _fotoUser;
  final KeywordService _keywordService = KeywordService();

  List<SmallFotoItem> _shownItems = List();

  @override
  void initState() {
    super.initState();
    _initContent();
  }

  AuthModeEnum _getAuthMode() => _fotoUser?.authMode??AuthModeEnum.READ_ONLY;

  Future<void> _initContent() async {
    await _keywordService.initKeywords();

    InitFotos.getAllItems(
        _getAuthMode() == AuthModeEnum.ADMIN ? "admin":null, _keywordService
    ).then((value) => setState(() {
      _sortingService.list = value;
      _shownItems = _sortingService.sortFilterList(_keywordService);
      _openAutoEditingScreen(0);
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
              onChanged: (val) => setState(() {
                _shownItems = _sortingService.sortFilterList(_keywordService, searchText: val);
              }),
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
                              _keywordService,
                              isDesc: !_sortingService.isDesc);
                        })),
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
          _shownItems = _sortingService.sortFilterList(_keywordService);
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
