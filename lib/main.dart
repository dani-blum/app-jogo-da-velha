import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(TicTacToeApp());
}

class TicTacToeApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Jogo da Velha',
      home: TicTacToeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class TicTacToeScreen extends StatefulWidget {
  @override
  _TicTacToeScreenState createState() => _TicTacToeScreenState();
}

class _TicTacToeScreenState extends State<TicTacToeScreen> {
  List<String> board = List.filled(9, '');
  bool isXTurn = true;
  bool isGameOver = false;
  String winner = '';
  bool isPlayingWithAI = false;

  void _toggleGameMode() {
    setState(() {
      isPlayingWithAI = !isPlayingWithAI;
      _resetGame();
    });
  }

  void _handleTap(int index) {
    if (board[index] == '' && !isGameOver) {
      setState(() {
        board[index] = isXTurn ? 'X' : 'O';
        isXTurn = !isXTurn;
        _checkGameStatus();
        if (!isXTurn && isPlayingWithAI && !isGameOver) {
          _playAI();
        }
      });
    }
  }

  void _checkGameStatus() {
    List<List<int>> winningCombos = [
      [0, 1, 2], [3, 4, 5], [6, 7, 8], // Linhas
      [0, 3, 6], [1, 4, 7], [2, 5, 8], // Colunas
      [0, 4, 8], [2, 4, 6]  // Diagonais
    ];

    for (var combo in winningCombos) {
      if (board[combo[0]] != '' &&
          board[combo[0]] == board[combo[1]] &&
          board[combo[1]] == board[combo[2]]) {
        setState(() {
          isGameOver = true;
          winner = board[combo[0]];
        });
        return;
      }
    }

    if (!board.contains('')) {
      setState(() {
        isGameOver = true;
        winner = 'Empate';
      });
    }
  }

  void _playAI() {
    var emptyCells = board.asMap().entries
        .where((e) => e.value == '')
        .map((e) => e.key)
        .toList();

    if (emptyCells.isNotEmpty) {
      int randomIndex = Random().nextInt(emptyCells.length);
      setState(() {
        board[emptyCells[randomIndex]] = 'O';
        isXTurn = true;
        _checkGameStatus();
      });
    }
  }

  void _resetGame() {
    setState(() {
      board = List.filled(9, '');
      isXTurn = true;
      isGameOver = false;
      winner = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    // Calcula a proporção para as células da grade com base no tamanho da tela
    double gridSize = screenWidth > 600 ? screenWidth * 0.5 : screenWidth * 0.8; // Para telas maiores, ocupa 50% da largura, e 80% em dispositivos móveis

    return Scaffold(
      appBar: AppBar(title: Text('Jogo da Velha')),
      body: SingleChildScrollView(  // Permite rolar em telas menores
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: _toggleGameMode,
                child: Text(isPlayingWithAI ? 'Jogar contra Humano' : 'Jogar contra Computador'),
              ),
              SizedBox(height: 20),

              // Grid do Jogo da Velha
              Container(
                width: gridSize, // Tamanho da grade proporcional ao tamanho da tela
                height: gridSize, // Manter proporção para altura
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 2,
                    mainAxisSpacing: 2,
                    childAspectRatio: 1.0,  // Mantém a proporção quadrada
                  ),
                  itemCount: 9,
                  itemBuilder: (context, index) => GestureDetector(
                    onTap: () => _handleTap(index),
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black),
                        color: Colors.blueGrey[50],
                      ),
                      child: Center(
                        child: Text(
                          board[index],
                          style: TextStyle(fontSize: gridSize * 0.15, fontWeight: FontWeight.bold),  // Ajusta o tamanho da fonte com base na largura
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              // Exibe a mensagem de vitória ou empate
              if (isGameOver)
                Column(
                  children: [
                    Text(
                      winner == 'Empate' ? 'Empate!' : 'Vencedor: $winner',
                      style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _resetGame,
                      child: Text('Reiniciar Jogo'),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
