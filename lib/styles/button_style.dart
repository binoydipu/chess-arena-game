import 'package:flutter/material.dart';

final elevatedButtonStyle = ElevatedButton.styleFrom(
  backgroundColor: const Color.fromARGB(255, 199, 124, 54),
  foregroundColor: Colors.white,
  elevation: 0,
  textStyle: const TextStyle(
    fontSize: 18,
  ),
  padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 12),
);

final textButtonStyle = TextButton.styleFrom(
  textStyle: const TextStyle(
    fontSize: 16,
  ),
);
