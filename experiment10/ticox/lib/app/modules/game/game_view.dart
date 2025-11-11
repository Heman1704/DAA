import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ticox/app/routes/app_pages.dart';
import 'game_controller.dart';

class GameView extends StatelessWidget {
  final GameController controller = Get.put(GameController());

  @override
  Widget build(BuildContext context) {
    final args = Get.arguments ?? {};
    controller.setMode(args['mode'] ?? 'pvp');
    // Only show name dialog once per entry to game screen
    final _nameDialogShown = RxBool(false);
    return Obx(() {
      if (!_nameDialogShown.value &&
          controller.player1.value == 'P1' &&
          (controller.mode.value == 'ai' || controller.player2.value == 'P2')) {
        _nameDialogShown.value = true;
        Future.delayed(Duration.zero, () => _askNames(context));
      }
      return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Text('Tic Tac Toe'),
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios_new),
            onPressed: () => Get.offAllNamed(Routes.MENU),
          ),
        ),
        body: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.blue[300]!,
                    Colors.purple[200]!,
                    Colors.pink[100]!,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildPlayers(),
                SizedBox(height: 20),
                _buildBoard(),
                SizedBox(height: 20),
                if (controller.winner.value != '' || controller.isDraw.value)
                  _buildResult(context),
              ],
            ),
          ],
        ),
      );
    });
  }

  Widget _buildPlayers() {
    return Obx(
      () => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _playerCard(
              controller.player1.value,
              'X',
              controller.currentPlayer.value == 'X',
            ),
            _playerCard(
              controller.mode.value == 'ai' ? 'AI' : controller.player2.value,
              'O',
              controller.currentPlayer.value == 'O',
            ),
          ],
        ),
      ),
    );
  }

  Widget _playerCard(String name, String symbol, bool isActive) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      padding: EdgeInsets.symmetric(horizontal: 18, vertical: 10),
      decoration: BoxDecoration(
        color: isActive ? Colors.blue[100] : Colors.grey[200],
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isActive ? Colors.blue : Colors.grey,
          width: isActive ? 2 : 1,
        ),
        boxShadow: isActive
            ? [BoxShadow(color: Colors.blue.withOpacity(0.2), blurRadius: 8)]
            : [],
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: symbol == 'X' ? Colors.blue : Colors.red,
            child: Text(symbol, style: TextStyle(color: Colors.white)),
          ),
          SizedBox(width: 8),
          Text(
            name,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: isActive ? Colors.blue[900] : Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBoard() {
    return Obx(() {
      List<List<int>> winCells = _getWinningCells();
      return Container(
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          // boxShadow: [
          //   BoxShadow(
          //     // color: Colors.black12,
          //     blurRadius: 12,
          //     offset: Offset(0, 4),
          //   ),
          // ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(3, (row) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(3, (col) {
                bool isWinCell = winCells.any(
                  (cell) => cell[0] == row && cell[1] == col,
                );
                return AnimatedContainer(
                  duration: Duration(milliseconds: 250),
                  margin: EdgeInsets.all(6),
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: isWinCell
                        ? Colors.greenAccent.withOpacity(0.7)
                        : controller.board[row][col] == ''
                        ? Colors.grey[100]
                        : (controller.board[row][col] == 'X'
                              ? Colors.blue[50]
                              : Colors.red[50]),
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(
                      color: isWinCell
                          ? Colors.green
                          : (controller.board[row][col] == ''
                                ? Colors.grey[400]!
                                : (controller.board[row][col] == 'X'
                                      ? Colors.blue
                                      : Colors.red)),
                      width: isWinCell ? 3 : 1.5,
                    ),
                    boxShadow: isWinCell
                        ? [
                            BoxShadow(
                              color: Colors.green.withOpacity(0.2),
                              blurRadius: 8,
                            ),
                          ]
                        : [],
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(18),
                      onTap: () {
                        if (controller.mode.value == 'ai' &&
                            controller.currentPlayer.value == 'O' &&
                            controller.winner.value == '')
                          return;
                        controller.makeMove(row, col);
                        if (controller.mode.value == 'ai' &&
                            controller.currentPlayer.value == 'O' &&
                            controller.winner.value == '' &&
                            !controller.isDraw.value) {
                          Future.delayed(Duration(milliseconds: 300), () {
                            _aiMove();
                          });
                        }
                      },
                      child: Center(
                        child: AnimatedSwitcher(
                          duration: Duration(milliseconds: 200),
                          transitionBuilder: (child, anim) =>
                              ScaleTransition(scale: anim, child: child),
                          child: controller.board[row][col] == ''
                              ? SizedBox.shrink()
                              : Text(
                                  controller.board[row][col],
                                  key: ValueKey(
                                    controller.board[row][col] +
                                        row.toString() +
                                        col.toString(),
                                  ),
                                  style: TextStyle(
                                    fontSize: 44,
                                    fontWeight: FontWeight.bold,
                                    color: controller.board[row][col] == 'X'
                                        ? Colors.blue[800]
                                        : Colors.red[700],
                                    shadows: [
                                      Shadow(
                                        color: Colors.black12,
                                        blurRadius: 4,
                                        offset: Offset(1, 2),
                                      ),
                                    ],
                                  ),
                                ),
                        ),
                      ),
                    ),
                  ),
                );
              }),
            );
          }),
        ),
      );
    });
  }

  // Returns a list of winning cell coordinates if there is a winner
  List<List<int>> _getWinningCells() {
    final b = controller.board;
    String winner = controller.winner.value;
    if (winner == '') return [];
    // Check rows
    for (int i = 0; i < 3; i++) {
      if (b[i][0] == winner && b[i][1] == winner && b[i][2] == winner) {
        return [
          [i, 0],
          [i, 1],
          [i, 2],
        ];
      }
    }
    // Check columns
    for (int j = 0; j < 3; j++) {
      if (b[0][j] == winner && b[1][j] == winner && b[2][j] == winner) {
        return [
          [0, j],
          [1, j],
          [2, j],
        ];
      }
    }
    // Check diagonals
    if (b[0][0] == winner && b[1][1] == winner && b[2][2] == winner) {
      return [
        [0, 0],
        [1, 1],
        [2, 2],
      ];
    }
    if (b[0][2] == winner && b[1][1] == winner && b[2][0] == winner) {
      return [
        [0, 2],
        [1, 1],
        [2, 0],
      ];
    }
    return [];
  }

  Widget _buildResult(BuildContext context) {
    String text = controller.isDraw.value
        ? 'Draw!'
        : '${controller.winner.value == 'X' ? controller.player1.value : (controller.mode.value == 'ai' ? 'AI' : controller.player2.value)} Wins!';
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Card(
        color: controller.isDraw.value ? Colors.orange[50] : Colors.green[50],
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 18.0),
          child: Column(
            children: [
              Text(
                text,
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: controller.isDraw.value
                      ? Colors.orange[900]
                      : Colors.green[900],
                  letterSpacing: 1.2,
                ),
              ),
              SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton.icon(
                    icon: Icon(Icons.refresh),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue[600],
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () {
                      controller.resetBoard();
                      if (controller.mode.value == 'ai' &&
                          controller.currentPlayer.value == 'O') {
                        _aiMove();
                      }
                    },
                    label: Text('Restart'),
                  ),
                  SizedBox(width: 16),
                  OutlinedButton.icon(
                    icon: Icon(Icons.home),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.blue[800],
                      side: BorderSide(color: Colors.blue[200]!),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () => Get.offAllNamed(Routes.MENU),
                    label: Text('Go to Menu'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _askNames(BuildContext context) {
    if (controller.mode.value == 'ai') {
      _askSingleName(context);
    } else {
      _askTwoNames(context);
    }
  }

  void _askSingleName(BuildContext context) {
    String name = controller.player1.value;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: Colors.white,
        title: Row(
          children: [
            Icon(Icons.person, color: Colors.blue, size: 28),
            SizedBox(width: 8),
            Text(
              'Enter your name',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        content: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: TextField(
            autofocus: true,
            decoration: InputDecoration(
              hintText: 'Player 1',
              prefixIcon: Icon(Icons.edit, color: Colors.blueAccent),
              filled: true,
              fillColor: Colors.blue[50],
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onChanged: (v) => name = v,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0, bottom: 4.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () {
                controller.setPlayers(name.isEmpty ? 'P1' : name);
                Get.back();
                if (controller.mode.value == 'ai' &&
                    controller.currentPlayer.value == 'O') {
                  _aiMove();
                }
              },
              child: Text('OK', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }

  void _askTwoNames(BuildContext context) {
    String name1 = controller.player1.value;
    String name2 = controller.player2.value;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: Colors.white,
        title: Row(
          children: [
            Icon(Icons.people, color: Colors.pink, size: 28),
            SizedBox(width: 8),
            Text(
              'Enter player names',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              autofocus: true,
              decoration: InputDecoration(
                hintText: 'Player 1',
                prefixIcon: Icon(Icons.person, color: Colors.blueAccent),
                filled: true,
                fillColor: Colors.blue[50],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onChanged: (v) => name1 = v,
            ),
            SizedBox(height: 12),
            TextField(
              decoration: InputDecoration(
                hintText: 'Player 2',
                prefixIcon: Icon(Icons.person, color: Colors.pinkAccent),
                filled: true,
                fillColor: Colors.pink[50],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onChanged: (v) => name2 = v,
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0, bottom: 4.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.pinkAccent,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () {
                controller.setPlayers(
                  name1.isEmpty ? 'P1' : name1,
                  name2.isEmpty ? 'P2' : name2,
                );
                Get.back();
              },
              child: Text('OK', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }

  void _aiMove() {
    // Simple AI: pick first available cell
    for (int i = 0; i < 3; i++) {
      for (int j = 0; j < 3; j++) {
        if (controller.board[i][j] == '') {
          controller.makeMove(i, j);
          return;
        }
      }
    }
  }
}
