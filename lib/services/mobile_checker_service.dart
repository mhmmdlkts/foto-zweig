import 'package:flutter/cupertino.dart';

class MbCheck {
  static bool isMobile(BuildContext context) => MediaQuery.of(context).size.width <= 600;
}