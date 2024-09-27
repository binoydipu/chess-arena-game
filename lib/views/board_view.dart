import 'package:chessarena/constants/routes.dart';
import 'package:chessarena/enums/chess_piece_type.dart';
import 'package:chessarena/views/board_square.dart';
import 'package:chessarena/views/chess_piece.dart';
import 'package:flutter/material.dart';

class BoardView extends StatefulWidget {
  const BoardView({super.key});

  @override
  State<BoardView> createState() => _BoardViewState();
}

class _BoardViewState extends State<BoardView> {
  bool _isWhite(int index) {
    int x = index ~/ 8;
    int y = index % 8;
    bool isWhite = (x + y) % 2 == 0;
    return isWhite;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Board'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamedAndRemoveUntil(
                loginRoute,
                (route) => false,
              );
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      backgroundColor: Colors.white,
      body: GridView.builder(
        itemCount: 64,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate:
            const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 8),
        itemBuilder: (context, index) => Center(
          child: BoardSquare(
            isLight: _isWhite(index),
            piece: const ChessPiece(
              type: ChessPieceType.king,
              isWhite: true,
              imagePath: 'assets/images/piece/white/rook.png',
            ),
            isSelected: false,
            isValidMove: false,
            canKill: false,
            onTap: () {},
          ),
        ),
      ),
    );
  }
}
