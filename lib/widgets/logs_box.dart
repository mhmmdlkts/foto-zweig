import 'package:flutter/material.dart';
import 'package:foto_zweig/models/log.dart';
import 'package:foto_zweig/models/log_list.dart';

enum ValueTyp {
  TEXT,
  KEY,
  LIST
}

class LogsBox extends StatefulWidget {
  final String title;
  final LogList logs;
  final ValueTyp valueTyp;
  final Map json;

  LogsBox({
    this.title,
    this.logs,
    this.valueTyp,
    this.json
  });

  @override
  _LogsBoxState createState() => _LogsBoxState();
}

class _LogsBoxState extends State<LogsBox> {
  bool _isOpen = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        children: [
          _title(),
          Visibility(
            visible: _isOpen,
            child: Column(
              children: widget.logs.logs.map((e) => _getLogWidget(e)).toList(),
            ),
          )
        ],
      ),
    );
  }

  Widget _getLogWidget(Log log) => Container(
    margin: EdgeInsets.only(top: 10),
    child: InkWell(
      borderRadius: BorderRadius.all(Radius.circular(10)),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          color: Colors.black.withOpacity(0.04),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(log.time.toString().substring(0, 16), style: TextStyle(fontSize: 15),),
            Container(height: 8,),
            Row(
              children: [
                _getColoredPoint(log.user),
                Container(width: 5,),
                Text(log.user)
              ],
            ),
            Container(height: 8,),
            _getValueWidget(log.val)
          ],
        ),
      ),
    ),
  );

  Color _getColor(int i) {
    List<Color> colors = [
      Colors.blue,
      Colors.purple,
      Colors.cyan,
      Colors.orange,
      Colors.pink,
      Colors.red,
      Colors.lightGreenAccent,
      Colors.indigo,
      Colors.teal
    ];
    return colors[i%colors.length];
  }

  Widget _getColoredPoint(String seed) => Container(
    width: 6,
    height: 6,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.all(Radius.circular(20)),
      color: _getColor(seed.hashCode),
    ),
  );

  Widget _title() =>InkWell(
    borderRadius: BorderRadius.all(Radius.circular(10)),
    onTap: () => setState((){_isOpen = !_isOpen;}),
    child:  Container(
      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(10)),
        color: Colors.black54,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(widget.title, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),),
          IconButton(icon: Icon(!_isOpen?Icons.arrow_drop_up:Icons.arrow_drop_down, color: Colors.white,),),
        ],
      ),
    ),
  );

  Widget _getValueWidget(val) {
    switch (widget.valueTyp) {
      case ValueTyp.KEY:
        return Text(widget.json[val].toString());
      case ValueTyp.LIST:
        return Text(val.map((e) => widget.json[e]).toList().toString());
      default:
        return Text(val);
    }
  }
}