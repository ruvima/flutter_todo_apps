import 'dart:async';

import 'package:flutter/material.dart';

class Debounce {
  final int milliseconds;
  Debounce({
    this.milliseconds = 500,
  });

  Timer? duration;
  void run(VoidCallback action) {
    if (duration != null) {
      duration!.cancel();
    }

    duration = Timer(
      Duration(milliseconds: milliseconds),
      action,
    );
  }
}
