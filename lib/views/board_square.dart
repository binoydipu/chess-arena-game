import 'package:chessarena/constants/colors.dart';
import 'package:chessarena/views/chess_piece.dart';
import 'package:flutter/material.dart';

typedef TapOnSquare = void Function();

class BoardSquare extends StatelessWidget {
  final ChessPiece? piece;
  final bool isLight;
  final bool isSelected;
  final bool isValidMove;
  final bool canKill;
  final TapOnSquare onTap;

  const BoardSquare({
    super.key,
    this.piece,
    required this.isLight,
    required this.isSelected,
    required this.isValidMove,
    required this.canKill,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    Color? squareColor;

    if (isSelected) {
      squareColor = Colors.green;
    } else if (isValidMove && canKill) {
      squareColor = Colors.red;
    } else if (isValidMove) {
      squareColor = Colors.green[200];
    } else {
      squareColor = isLight ? lightSquareColor : darkSquareColor;
    }

    return GestureDetector(
      onTap: onTap,
      child: Container(
        color: squareColor,
        margin: EdgeInsets.all(isValidMove ? 4 : 0),
        child: piece != null ? Image.asset(piece!.imagePath) : null,
      ),
    );
  }
}
