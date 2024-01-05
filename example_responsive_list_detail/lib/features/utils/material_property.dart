import 'package:flutter/material.dart';

MaterialStateProperty msp<T>() {
  return MaterialStateProperty.resolveWith((states) {
    if (states.contains(MaterialState.disabled)) {

    } else if (states.contains(MaterialState.disabled)) {
      
    }
  });
}
