import 'dart:async';
import 'package:flutter/material.dart';

class CustomDebounceHelper{

  final int milliseconds;
  Timer? _timer;
  CustomDebounceHelper({required this.milliseconds});
  void run(VoidCallback action) {
    if (_timer != null) {
      _timer!.cancel();
    }
    _timer = Timer(Duration(milliseconds: milliseconds), action);
  }

}