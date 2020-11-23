import 'package:flutter/material.dart';

class RoundedButtonWidget extends StatefulWidget {
  final VoidCallback onPressed;
  final String text;
  final Color color;
  final Color secondColor;
  final IconData icon;
  RoundedButtonWidget({
    this.onPressed,
    this.color = Colors.grey,
    this.secondColor = Colors.white,
    this.text,
    this.icon
    });

  @override
  _RoundedButtonState createState() => _RoundedButtonState();
}

class _RoundedButtonState extends State<RoundedButtonWidget> {
  bool _isHover = false;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onHover: (val) => setState(() {
        _isHover = val;
      }),
      onTap: () => widget.onPressed.call(),
      child: Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          border: Border.all(color: widget.color, width: 1.5),
          borderRadius: BorderRadius.all(Radius.circular(5)),
          color: _getSecondaryColor()
        ),
        child: widget.icon!=null?Icon(widget.icon, color: _getPrimaryColor(),):Text(widget.text, style: TextStyle(color: _getPrimaryColor()),),
      ),
    );
  }

  Color _getPrimaryColor() => _isHover?widget.secondColor:widget.color;
  Color _getSecondaryColor() => !_isHover?widget.secondColor:widget.color;
}