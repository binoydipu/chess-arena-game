import 'package:chessarena/enums/chess_piece_type.dart';
import 'package:chessarena/helpers/moves/move_constants.dart';
import 'package:chessarena/views/chess_board/chess_piece.dart';

bool _isInBoard(int row, int col) {
  return row >= 0 && col >= 0 && row <= 7 && col <= 7;
}

List<List<int>> calculateValidMoves({
  required int row,
  required int col,
  required ChessPiece piece,
  required List<List<ChessPiece?>> board,
}) {
  List<List<int>> validMoves = [];

  // white pieces moves up (-1) and black pieces moves down (+1)
  int direction = piece.isWhite ? -1 : 1;

  switch (piece.type) {
    case ChessPieceType.pawn:
      // pawn can moves forward +1 if not occupied
      if (_isInBoard(row + direction, col) &&
          board[row + direction][col] == null) {
        validMoves.add([row + direction, col]);
      }
      // pawn can moves +2 from starting position
      if ((row == 1 && !piece.isWhite) || (row == 6 && piece.isWhite)) {
        if (_isInBoard(row + 2 * direction, col) &&
            board[row + 2 * direction][col] == null) {
          validMoves.add([row + 2 * direction, col]);
        }
      }
      // pawn kills other pieces diagolally
      if (_isInBoard(row + direction, col - 1) &&
          board[row + direction][col - 1] != null &&
          board[row + direction][col - 1]!.isWhite != piece.isWhite) {
        validMoves.add([row + direction, col - 1]);
      }
      if (_isInBoard(row + direction, col + 1) &&
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
          if (!_isInBoard(newRow, newCol)) {
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
        if (!_isInBoard(newRow, newCol)) {
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
          if (!_isInBoard(newRow, newCol)) {
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
          if (!_isInBoard(newRow, newCol)) {
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
        if (!_isInBoard(newRow, newCol)) {
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
  validMoves = _filterValidMoves(validMoves);
  return validMoves;
}

List<List<int>> _filterValidMoves(List<List<int>> validMoves) {
  List<List<int>> filteredMoves = validMoves;
  return filteredMoves;
}
