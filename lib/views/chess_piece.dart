import 'package:chessarena/enums/chess_piece_type.dart';

class ChessPiece {
  final ChessPieceType type;
  final bool isWhite;
  final String imagePath;

  const ChessPiece({
    required this.type,
    required this.isWhite,
    required this.imagePath,
  });

  @override
  bool operator ==(covariant ChessPiece other) => other.imagePath == imagePath;

  @override
  int get hashCode => imagePath.hashCode;
}
