import 'package:chessarena/constants/colors.dart';
import 'package:chessarena/views/chess_board/chess_piece.dart';
import 'package:flutter/material.dart';

typedef TapOnSquare = void Function()?;

class BoardSquare extends StatelessWidget {
  final ChessPiece? piece;
  final bool isLight;
  final bool isSelected;
  final bool isValidMove;
  final bool canKill;
  final bool isInCheck;
  final TapOnSquare onTap;

  const BoardSquare({
    super.key,
    this.piece,
    required this.isLight,
    required this.isSelected,
    required this.isValidMove,
    required this.canKill,
    required this.isInCheck,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    Color? squareColor;

    if (isSelected) {
      squareColor = selectedPieceColor;
    } else if (isValidMove && canKill) {
      squareColor = canKillColor;
    } else if (isValidMove) {
      squareColor = validMovesColor;
    } else if (isInCheck) {
      squareColor = kingInCheckColor;
    } else {
      squareColor = isLight ? lightSquareColor : darkSquareColor;
    }

    return GestureDetector(
      onTap: onTap,
      child: Container(
        color: squareColor,
        margin: EdgeInsets.all(isValidMove ? 2 : 0),
        child: piece != null ? Image.asset(piece!.imagePath) : null,
      ),
    );
  }
}
