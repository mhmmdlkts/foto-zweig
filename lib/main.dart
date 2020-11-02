import 'package:flutter/material.dart';
import 'package:foto_zweig/enums/item_type_enum.dart';
import 'package:foto_zweig/image_urls.dart';
import 'package:foto_zweig/models/main_foto.dart';
import 'package:foto_zweig/services/init_fotos.dart';
import 'package:foto_zweig/widgets/image_content.dart';
import 'package:foto_zweig/widgets/small_foto_item_widget.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Foto Zweig',
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
  Color _myColor = Colors.white;
  List<SmallFotoItem> _allItems = List();

  @override
  void initState() {
    super.initState();

    InitFotos.getAllItems().then((value) => setState((){
      _allItems = value;
    }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _myColor,
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(86, 61, 124, 1),
        title: Text('Foto Zweig'),
      ),
      body: Padding(
        padding: EdgeInsets.only(right: 16),
        child: ListView(
          children: [
            Container( // TODO Sort filter field
              padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              color: Color.fromRGBO(248, 249, 250, 1),
              child: IconButton(icon: Icon(Icons.sort),),
              alignment: Alignment.centerLeft,
            ),
            _getContent()
          ],
        ),
      )
    );
  }

  Widget _getContent() {
    return ImageContentWidget(_allItems, ItemTypeEnum.FOTO);
  }
}
