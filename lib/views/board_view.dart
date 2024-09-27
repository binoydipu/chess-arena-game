import 'package:chessarena/constants/colors.dart';
import 'package:chessarena/constants/routes.dart';
import 'package:chessarena/helpers/board_initializer.dart';
import 'package:chessarena/helpers/moves/calculate_valid_moves.dart';
import 'package:chessarena/views/board_square.dart';
import 'package:chessarena/views/chess_piece.dart';
import 'package:chessarena/views/dead_piece.dart';
import 'package:flutter/material.dart';

class BoardView extends StatefulWidget {
  const BoardView({super.key});

  @override
  State<BoardView> createState() => _BoardViewState();
}

class _BoardViewState extends State<BoardView> {
  /// stores current chess board state
  late List<List<ChessPiece?>> board;

  /// currently tapped square
  late ChessPiece? selectedPiece;
  late int selectedRow;
  late int selectedCol;

  /// check who's turn it is
  late bool isWhiteTurn;

  /// list of pieces killed by black player
  List<ChessPiece> whitePieceTaken = [];

  /// list of pieces killed by white player
  List<ChessPiece> blackPieceTaken = [];

  /// a list of valid moves for currently selected piece i.e. in the square
  late List<List<int>> validMoves;

  bool _isWhite(int index) {
    int x = index ~/ 8;
    int y = index % 8;
    bool isWhite = (x + y) % 2 == 0;
    return isWhite;
  }

  void _tappedOnSquare(int row, int col) {
    setState(() {
      // tapped on empty square
      if (selectedPiece == null && board[row][col] == null) {
        return;
      } // tapped on opposite color piece
      else if (selectedPiece == null &&
          board[row][col] != null &&
          board[row][col]!.isWhite != isWhiteTurn) {
        return;
      } // no previous piece selected & square has a piece & his turn
      else if (selectedPiece == null &&
          board[row][col] != null &&
          board[row][col]!.isWhite == isWhiteTurn) {
        selectedPiece = board[row][col];
        selectedRow = row;
        selectedCol = col;
        validMoves = calculateValidMoves(
          row: row,
          col: col,
          piece: selectedPiece!,
          board: board,
        );
      } // tapped on a piece of same color, so selection changed
      else if (selectedPiece != null &&
          board[row][col] != null &&
          board[row][col]!.isWhite == isWhiteTurn) {
        // if previously selected piece tapped than unselect
        if (selectedPiece == board[row][col] &&
            row == selectedRow &&
            col == selectedCol) {
          selectedPiece = null;
          selectedRow = -1;
          selectedCol = -1;
          validMoves = [];
        } // else tapped on other pieces of same color
        else {
          selectedPiece = board[row][col];
          selectedRow = row;
          selectedCol = col;
          validMoves = calculateValidMoves(
            row: row,
            col: col,
            piece: selectedPiece!,
            board: board,
          );
        }
      } // selected a piece & tapped on a valid move square
      else if (selectedPiece != null &&
          validMoves.any((move) => move[0] == row && move[1] == col)) {
        _movePiece(row, col);
      }
    });
  }

  bool _canKillPiece(int row, int col) {
    if (selectedPiece != null && board[row][col] != null) {
      if (board[row][col]!.isWhite != isWhiteTurn &&
          validMoves.any((move) => move[0] == row && move[1] == col)) {
        return true;
      }
    }
    return false;
  }

  void _movePiece(int newRow, int newCol) {
    // killed a piece, so add it to appropriate Lists
    if (board[newRow][newCol] != null) {
      final capturedPiece = board[newRow][newCol];
      if (capturedPiece!.isWhite) {
        whitePieceTaken.add(capturedPiece);
      } else {
        blackPieceTaken.add(capturedPiece);
      }
    }

    // move the piece and clear the old square
    board[newRow][newCol] = selectedPiece;
    board[selectedRow][selectedCol] = null;

    setState(() {
      selectedPiece = null;
      selectedRow = -1;
      selectedCol = -1;
      validMoves = [];
    });

    // change turns
    isWhiteTurn ^= true;
  }

  @override
  void initState() {
    board = boardInitializer();
    selectedPiece = null;
    selectedRow = -1;
    selectedCol = -1;
    isWhiteTurn = true;
    validMoves = [];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Board'),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.settings),
          ),
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
      drawer: const Drawer(
        backgroundColor: lightSquareColor,
      ),
      backgroundColor: lightSquareColor,
      body: Column(
        children: [
          Expanded(
            child: GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              itemCount: whitePieceTaken.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 16),
              itemBuilder: (context, index) => DeadPiece(
                imagePath: whitePieceTaken[index].imagePath,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: GridView.builder(
              itemCount: 64,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 8),
              itemBuilder: (context, index) {
                // current row & column based on index
                int row = index ~/ 8;
                int col = index % 8;
                bool isSelected = selectedRow == row && selectedCol == col;

                bool isValidMove = false;
                for (final position in validMoves) {
                  if (position[0] == row && position[1] == col) {
                    isValidMove = true;
                    break;
                  }
                }
                return BoardSquare(
                  isLight: _isWhite(index),
                  piece: board[row][col],
                  isSelected: isSelected,
                  isValidMove: isValidMove,
                  canKill: _canKillPiece(row, col),
                  onTap: () => _tappedOnSquare(row, col),
                );
              },
            ),
          ),
          Expanded(
            child: GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              itemCount: blackPieceTaken.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 16),
              itemBuilder: (context, index) => DeadPiece(
                imagePath: blackPieceTaken[index].imagePath,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
