import 'package:flutter/material.dart';

class RoundedButtonWidget extends StatefulWidget {
  final VoidCallback onPressed;
  final String text;
  final Color color;
  final Color secondColor;
  final IconData icon;
  final bool isActive;
  RoundedButtonWidget({
    this.onPressed,
    this.color = Colors.grey,
    this.secondColor = Colors.white,
    this.text,
    this.icon,
    this.isActive = true
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
      onTap: widget.isActive?() => widget.onPressed.call():null,
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

  Color _getPrimaryColor() => (_isHover?widget.secondColor:widget.color).withOpacity(widget.isActive?1:0.3);
  Color _getSecondaryColor() => !_isHover?widget.secondColor:widget.color.withOpacity(widget.isActive?1:0.3);
}