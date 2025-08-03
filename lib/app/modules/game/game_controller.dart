import 'package:get/get.dart';

class GameController extends GetxController {
  var board = List.generate(3, (_) => List.filled(3, ''), growable: false).obs;
  var currentPlayer = 'X'.obs;
  var winner = ''.obs;
  var isDraw = false.obs;
  var player1 = 'P1'.obs;
  var player2 = 'P2'.obs;
  var mode = 'pvp'.obs;

  void setPlayers(String p1, [String? p2]) {
    player1.value = p1;
    if (p2 != null) player2.value = p2;
  }

  void setMode(String m) {
    mode.value = m;
  }

  void resetBoard() {
    for (var row in board) {
      for (var i = 0; i < row.length; i++) {
        row[i] = '';
      }
    }
    winner.value = '';
    isDraw.value = false;
    currentPlayer.value = 'X';
  }

  void makeMove(int row, int col) {
    if (board[row][col] == '' && winner.value == '') {
      board[row][col] = currentPlayer.value;
      board.refresh();
      if (_checkWinner(row, col)) {
        winner.value = currentPlayer.value;
      } else if (_isDraw()) {
        isDraw.value = true;
      } else {
        currentPlayer.value = currentPlayer.value == 'X' ? 'O' : 'X';
      }
    }
  }

  bool _checkWinner(int row, int col) {
    String p = board[row][col];
    // Check row
    if (board[row].every((cell) => cell == p)) return true;
    // Check column
    if (board.every((r) => r[col] == p)) return true;
    // Check diagonals
    if (row == col &&
        List.generate(3, (i) => board[i][i]).every((cell) => cell == p)) {
      return true;
    }
    if (row + col == 2 &&
        List.generate(3, (i) => board[i][2 - i]).every((cell) => cell == p)) {
      return true;
    }
    return false;
  }

  bool _isDraw() {
    for (var row in board) {
      for (var cell in row) {
        if (cell == '') return false;
      }
    }
    return winner.value == '';
  }
}
