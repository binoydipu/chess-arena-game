import 'package:chessarena/enums/chess_piece_type.dart';
import 'package:chessarena/views/chess_piece.dart';

String getImagePath(ChessPieceType type, bool isWhite) {
  String prefix = 'assets/images/piece/';
  String color = isWhite ? 'white/' : 'black/';
  String suffix = '${type.name}.png';
  return '$prefix$color$suffix';
}

List<List<ChessPiece?>> boardInitializer() {
  List<List<ChessPiece?>> board =
      List.generate(8, (index) => List.generate(8, (index) => null));

  // pawn
  for (int i = 0; i < 8; i++) {
    // black pawn
    board[1][i] = ChessPiece(
      type: ChessPieceType.pawn,
      isWhite: false,
      imagePath: getImagePath(ChessPieceType.pawn, false),
    );
    // white pawn
    board[6][i] = ChessPiece(
      type: ChessPieceType.pawn,
      isWhite: true,
      imagePath: getImagePath(ChessPieceType.pawn, true),
    );
  }

  // rook
  board[0][0] = board[0][7] = ChessPiece(
    type: ChessPieceType.rook,
    isWhite: false,
    imagePath: getImagePath(ChessPieceType.rook, false),
  );
  board[7][0] = board[7][7] = ChessPiece(
    type: ChessPieceType.rook,
    isWhite: true,
    imagePath: getImagePath(ChessPieceType.rook, true),
  );

  // knight
  board[0][1] = board[0][6] = ChessPiece(
    type: ChessPieceType.knight,
    isWhite: false,
    imagePath: getImagePath(ChessPieceType.knight, false),
  );
  board[7][1] = board[7][6] = ChessPiece(
    type: ChessPieceType.knight,
    isWhite: true,
    imagePath: getImagePath(ChessPieceType.knight, true),
  );

  // bishop
  board[0][2] = board[0][5] = ChessPiece(
    type: ChessPieceType.bishop,
    isWhite: false,
    imagePath: getImagePath(ChessPieceType.bishop, false),
  );
  board[7][5] = board[7][2] = ChessPiece(
    type: ChessPieceType.bishop,
    isWhite: true,
    imagePath: getImagePath(ChessPieceType.bishop, true),
  );

  // queen init place
  board[0][3] = ChessPiece(
    type: ChessPieceType.queen,
    isWhite: false,
    imagePath: getImagePath(ChessPieceType.queen, false),
  );
  board[7][3] = ChessPiece(
    type: ChessPieceType.queen,
    isWhite: true,
    imagePath: getImagePath(ChessPieceType.queen, true),
  );

  // king init place
  board[0][4] = ChessPiece(
    type: ChessPieceType.king,
    isWhite: false,
    imagePath: getImagePath(ChessPieceType.king, false),
  );
  board[7][4] = ChessPiece(
    type: ChessPieceType.king,
    isWhite: true,
    imagePath: getImagePath(ChessPieceType.king, true),
  );

  return board;
}
