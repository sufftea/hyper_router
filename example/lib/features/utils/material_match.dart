import 'package:flutter/material.dart';

MaterialStateProperty<T> materialMatch<T>({
  required T all,
  T? hovered,
  T? pressed,
}) {
  return MaterialStateProperty.resolveWith(
    (states) {
      if (hovered != null && states.contains(MaterialState.hovered)) {
        return hovered;
      } else if (pressed != null && states.contains(MaterialState.pressed)) {
        return pressed;
      }
      return all;
    },
  );
}
