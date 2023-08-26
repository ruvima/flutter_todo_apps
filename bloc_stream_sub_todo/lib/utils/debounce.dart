import 'dart:async';

import 'package:flutter/material.dart';

class Debounce {
  final int milliseconds;
  Debounce({this.milliseconds = 500});

  Timer? debounce;

  void run(VoidCallback action) {
    if (debounce != null) {
      debounce!.cancel();
    }

    debounce = Timer(Duration(milliseconds: milliseconds), action);
  }
}
