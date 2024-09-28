import 'package:chessarena/constants/colors.dart';
import 'package:chessarena/constants/routes.dart';
import 'package:chessarena/enums/chess_piece_type.dart';
import 'package:chessarena/helpers/board_initializer.dart';
import 'package:chessarena/helpers/moves/move_constants.dart';
import 'package:chessarena/views/chess_board/board_square.dart';
import 'package:chessarena/views/chess_board/chess_piece.dart';
import 'package:chessarena/views/chess_board/dead_piece.dart';
import 'package:flutter/material.dart';

class BoardView extends StatefulWidget {
  const BoardView({super.key});

  @override
  State<BoardView> createState() => _BoardViewState();
}

class _BoardViewState extends State<BoardView> {
  /// stores current chess board state
  late List<List<ChessPiece?>> board;

  /// currently selected chess piece
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

  /// keeps track of white king's position
  List<int> whiteKingPosition = [7, 4];

  /// keeps track of black king's position
  List<int> blackKingPosition = [0, 4];

  /// Current King is in check or not
  bool kingInCheck = false;

  /// Checks if current piece is white < true: white;  false: black >
  bool _isWhite(int index) {
    int x = index ~/ 8;
    int y = index % 8;
    bool isWhite = (x + y) % 2 == 0;
    return isWhite;
  }

  /// User tapped on one of the 64 squares < responds accordingly by changing board state >
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
        validMoves = _calculateValidMoves(
          row: row,
          col: col,
          piece: selectedPiece!,
          needToFilter: true,
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
          validMoves = _calculateValidMoves(
            row: row,
            col: col,
            piece: selectedPiece!,
            needToFilter: true,
          );
        }
      } // selected a piece & tapped on a valid move square
      else if (selectedPiece != null &&
          validMoves.any((move) => move[0] == row && move[1] == col)) {
        _movePiece(row, col);
      }
    });
  }

  /// Checks if for the current piece if there is an Enemy piece among its valid moves
  bool _canKillPiece(int row, int col) {
    if (selectedPiece != null && board[row][col] != null) {
      if (board[row][col]!.isWhite != isWhiteTurn &&
          validMoves.any((move) => move[0] == row && move[1] == col)) {
        return true;
      }
    }
    return false;
  }

  /// User tapped on a valid move squares; so move piece
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

    // if moving king than change king's position
    if (selectedPiece!.type == ChessPieceType.king) {
      if (selectedPiece!.isWhite) {
        whiteKingPosition = [newRow, newCol];
      } else {
        blackKingPosition = [newRow, newCol];
      }
    }

    // move the piece and clear the old square
    board[newRow][newCol] = selectedPiece;
    board[selectedRow][selectedCol] = null;

    kingInCheck = _isKingInCheck(!isWhiteTurn);

    setState(() {
      selectedPiece = null;
      selectedRow = -1;
      selectedCol = -1;
      validMoves = [];
    });

    // change turns
    isWhiteTurn ^= true;
  }

  /// Checks if any Enemy piece on the board can target the king
  bool _isKingInCheck(bool isWhiteKing) {
    List<int> kingPosition =
        isWhiteKing ? whiteKingPosition : blackKingPosition;

    for (int row = 0; row < 8; row++) {
      for (int col = 0; col < 8; col++) {
        if (board[row][col] == null) {
          continue;
        } else if (board[row][col]!.isWhite == isWhiteKing) {
          continue;
        } else {
          List<List<int>> curValidMoves = _calculateValidMoves(
            row: row,
            col: col,
            piece: board[row][col]!,
            needToFilter: false,
          );
          // false cause these moves are just raw for checking kings check condition
          // as all possible moves can check the king
          // there will be STACK OVERFLOW exception if given true; < creates a cycle >
          if (curValidMoves.any(
            (move) => move[0] == kingPosition[0] && move[1] == kingPosition[1],
          )) {
            return true;
          }
        }
      }
    }
    return false;
  }

  /// Calculates all possible moves that can be made by the piece 
  List<List<int>> _calculateValidMoves({
    required int row,
    required int col,
    required ChessPiece piece,
    required bool needToFilter,
  }) {
    List<List<int>> validMoves = [];

    // white pieces moves up (-1) and black pieces moves down (+1)
    int direction = piece.isWhite ? -1 : 1;

    switch (piece.type) {
      case ChessPieceType.pawn:
        // pawn can moves forward +1 if not occupied
        if (isInBoard(row + direction, col) &&
            board[row + direction][col] == null) {
          validMoves.add([row + direction, col]);
        }
        // pawn can moves +2 from starting position
        if ((row == 1 && !piece.isWhite) || (row == 6 && piece.isWhite)) {
          if (isInBoard(row + 2 * direction, col) &&
              board[row + 2 * direction][col] == null) {
            validMoves.add([row + 2 * direction, col]);
          }
        }
        // pawn kills other pieces diagolally
        if (isInBoard(row + direction, col - 1) &&
            board[row + direction][col - 1] != null &&
            board[row + direction][col - 1]!.isWhite != piece.isWhite) {
          validMoves.add([row + direction, col - 1]);
        }
        if (isInBoard(row + direction, col + 1) &&
            board[row + direction][col + 1] != null &&
            board[row + direction][col + 1]!.isWhite != piece.isWhite) {
          validMoves.add([row + direction, col + 1]);
        }
        break;
      case ChessPieceType.rook:
        for (final move in rookMoves) {
          int i = 1;
          while (true) {
            final newRow = row + i * move[0];
            final newCol = col + i * move[1];
            if (!isInBoard(newRow, newCol)) {
              break;
            }
            if (board[newRow][newCol] != null) {
              if (board[newRow][newCol]!.isWhite != piece.isWhite) {
                validMoves.add([newRow, newCol]); // kill position
              }
              break; // blocked
            }
            validMoves.add([newRow, newCol]);
            i++;
          }
        }
        break;
      case ChessPieceType.knight:
        for (final move in knightMoves) {
          final newRow = row + move[0];
          final newCol = col + move[1];
          if (!isInBoard(newRow, newCol)) {
            continue;
          }
          if (board[newRow][newCol] != null) {
            if (board[newRow][newCol]!.isWhite != piece.isWhite) {
              validMoves.add([newRow, newCol]); // kill
            }
            continue;
          }
          validMoves.add([newRow, newCol]);
        }
        break;
      case ChessPieceType.bishop:
        for (final move in bishopMoves) {
          int i = 1;
          while (true) {
            final newRow = row + i * move[0];
            final newCol = col + i * move[1];
            if (!isInBoard(newRow, newCol)) {
              break;
            }
            if (board[newRow][newCol] != null) {
              if (board[newRow][newCol]!.isWhite != piece.isWhite) {
                validMoves.add([newRow, newCol]); // kill
              }
              break; // blocked
            }
            validMoves.add([newRow, newCol]);
            i++;
          }
        }
        break;
      case ChessPieceType.queen:
        for (final move in queenMoves) {
          int i = 1;
          while (true) {
            final newRow = row + i * move[0];
            final newCol = col + i * move[1];
            if (!isInBoard(newRow, newCol)) {
              break;
            }
            if (board[newRow][newCol] != null) {
              if (board[newRow][newCol]!.isWhite != piece.isWhite) {
                validMoves.add([newRow, newCol]); // kill
              }
              break; // blocked
            }
            validMoves.add([newRow, newCol]);
            i++;
          }
        }
        break;
      case ChessPieceType.king:
        for (final move in kingMoves) {
          final newRow = row + move[0];
          final newCol = col + move[1];
          if (!isInBoard(newRow, newCol)) {
            continue;
          }
          if (board[newRow][newCol] != null) {
            if (board[newRow][newCol]!.isWhite != piece.isWhite) {
              validMoves.add([newRow, newCol]); // kill
            }
            continue; // blocked
          }
          validMoves.add([newRow, newCol]);
        }
        break;
      default:
    }
    
    if (needToFilter) {
      validMoves = _filterValidMoves(
        validMoves: validMoves,
        curRow: row,
        curCol: col,
        piece: piece,
      );
    }
    return validMoves;
  }

  List<List<int>> _filterValidMoves({
    required List<List<int>> validMoves,
    required int curRow,
    required int curCol,
    required ChessPiece? piece,
  }) {
    List<List<int>> filteredMoves = [];
    for (final move in validMoves) {
      if (_isSafeToMove(
        piece: piece!,
        curRow: curRow,
        curCol: curCol,
        endRow: move[0],
        endCol: move[1],
      )) {
        filteredMoves.add(move);
      }
    }
    return filteredMoves;
  }

  /// Checks if we perform this move than is our king stays safe or not
  bool _isSafeToMove({
    required ChessPiece piece,
    required int curRow,
    required int curCol,
    required int endRow,
    required int endCol,
  }) {
    // do the swap and than restore values
    ChessPiece? curEndPiece = board[endRow][endCol];
    List<int>? originalKingPosition;

    if (piece.type == ChessPieceType.king) {
      originalKingPosition =
          piece.isWhite ? whiteKingPosition : blackKingPosition;

      if (piece.isWhite) {
        whiteKingPosition = [endRow, endCol];
      } else {
        blackKingPosition = [endRow, endCol];
      }
    }

    board[endRow][endCol] = piece;
    board[curRow][curCol] = null;

    bool kingInCheck = _isKingInCheck(piece.isWhite);

    board[curRow][curCol] = piece;
    board[endRow][endCol] = curEndPiece;

    if (piece.type == ChessPieceType.king) {
      if (piece.isWhite) {
        whiteKingPosition = originalKingPosition!;
      } else {
        blackKingPosition = originalKingPosition!;
      }
    }
    // if king is in check than move is INVALID
    return kingInCheck == false;
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
                bool isInCheck = (isWhiteTurn
                        ? whiteKingPosition[0] == row &&
                            whiteKingPosition[1] == col
                        : blackKingPosition[0] == row &&
                            blackKingPosition[1] == col) &&
                    kingInCheck;

                return BoardSquare(
                  isLight: _isWhite(index),
                  piece: board[row][col],
                  isSelected: isInCheck ? false : isSelected,
                  isValidMove: isValidMove,
                  canKill: _canKillPiece(row, col),
                  isInCheck: isInCheck,
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
