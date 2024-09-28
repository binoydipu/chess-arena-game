const rookMoves = [
  [-1, 0],
  [1, 0],
  [0, -1],
  [0, 1],
];

const knightMoves = [
  [-2, -1],
  [-2, 1],
  [-1, -2],
  [-1, 2],
  [1, 2],
  [1, -2],
  [2, -1],
  [2, 1],
];

const bishopMoves = [
  [-1, -1],
  [-1, 1],
  [1, -1],
  [1, 1],
];

const queenMoves = [
  [-1, 0],
  [1, 0],
  [0, -1],
  [0, 1],
  [-1, -1],
  [-1, 1],
  [1, -1],
  [1, 1],
];

const kingMoves = [
  [-1, 0],
  [1, 0],
  [0, -1],
  [0, 1],
  [-1, -1],
  [-1, 1],
  [1, -1],
  [1, 1],
];

bool isInBoard(int row, int col) {
  return row >= 0 && col >= 0 && row <= 7 && col <= 7;
}
