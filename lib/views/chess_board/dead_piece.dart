import 'package:flutter/material.dart';

class DeadPiece extends StatelessWidget {
  final String imagePath;
  const DeadPiece({
    super.key,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      imagePath,
    );
  }
}
