import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';

import 'package:space_invaders/game_items/myspace.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Home(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  static int numberOfSquares = 600;
  static int numberInRow = 20;
  static bool alienGotHit = true;
  static bool meGotHit = true;
  static bool isPlaying = false;
  List<int> barriers = [
    numberOfSquares - 160 + 2,
    numberOfSquares - 160 + 3,
    numberOfSquares - 160 + 4,
    numberOfSquares - 160 + 5,
    numberOfSquares - 160 + 2 + 6,
    numberOfSquares - 160 + 3 + 6,
    numberOfSquares - 160 + 4 + 6,
    numberOfSquares - 160 + 5 + 6,
    numberOfSquares - 160 + 2 + 12,
    numberOfSquares - 160 + 3 + 12,
    numberOfSquares - 160 + 4 + 12,
    numberOfSquares - 160 + 5 + 12,
    numberOfSquares - 160 + 2 + 20,
    numberOfSquares - 160 + 3 + 20,
    numberOfSquares - 160 + 4 + 20,
    numberOfSquares - 160 + 5 + 20,
    numberOfSquares - 160 + 2 + 6 + 20,
    numberOfSquares - 160 + 3 + 6 + 20,
    numberOfSquares - 160 + 4 + 6 + 20,
    numberOfSquares - 160 + 5 + 6 + 20,
    numberOfSquares - 160 + 2 + 12 + 20,
    numberOfSquares - 160 + 3 + 12 + 20,
    numberOfSquares - 160 + 4 + 12 + 20,
    numberOfSquares - 160 + 5 + 12 + 20,
  ];
  static int alienStartPos = 30;
  List<int> alien = [
    alienStartPos,
    alienStartPos + 1,
    alienStartPos + 2,
    alienStartPos + 3,
    alienStartPos + 4,
    alienStartPos + 5,
    alienStartPos + 6,
    alienStartPos + 20,
    alienStartPos + 20 + 1,
    alienStartPos + 20 + 2,
    alienStartPos + 20 + 3,
    alienStartPos + 20 + 4,
    alienStartPos + 20 + 5,
    alienStartPos + 20 + 6
  ];
  int me = numberOfSquares - 80 + 4;
  void startGame() {
    firealienMissile();
    isPlaying = true;
    const alienspaceDuration = const Duration(milliseconds: 700);
    Timer.periodic(alienspaceDuration, (timer) {
      alienspaceMoves();
      // firealienMissile();
    });
  }

  void resetGame() {
    setState(() {
      alienStartPos = 30;
      alien = [
        alienStartPos,
        alienStartPos + 1,
        alienStartPos + 2,
        alienStartPos + 3,
        alienStartPos + 4,
        alienStartPos + 5,
        alienStartPos + 6,
        alienStartPos + 20,
        alienStartPos + 20 + 1,
        alienStartPos + 20 + 2,
        alienStartPos + 20 + 3,
        alienStartPos + 20 + 4,
        alienStartPos + 20 + 5,
        alienStartPos + 20 + 6
      ];
      alienGotHit = true;
      meGotHit = true;
      me = numberOfSquares - 80 + 4;
      barriers = [
        numberOfSquares - 160 + 2,
        numberOfSquares - 160 + 3,
        numberOfSquares - 160 + 4,
        numberOfSquares - 160 + 5,
        numberOfSquares - 160 + 2 + 6,
        numberOfSquares - 160 + 3 + 6,
        numberOfSquares - 160 + 4 + 6,
        numberOfSquares - 160 + 5 + 6,
        numberOfSquares - 160 + 2 + 12,
        numberOfSquares - 160 + 3 + 12,
        numberOfSquares - 160 + 4 + 12,
        numberOfSquares - 160 + 5 + 12,
        numberOfSquares - 160 + 2 + 20,
        numberOfSquares - 160 + 3 + 20,
        numberOfSquares - 160 + 4 + 20,
        numberOfSquares - 160 + 5 + 20,
        numberOfSquares - 160 + 2 + 6 + 20,
        numberOfSquares - 160 + 3 + 6 + 20,
        numberOfSquares - 160 + 4 + 6 + 20,
        numberOfSquares - 160 + 5 + 6 + 20,
        numberOfSquares - 160 + 2 + 12 + 20,
        numberOfSquares - 160 + 3 + 12 + 20,
        numberOfSquares - 160 + 4 + 12 + 20,
        numberOfSquares - 160 + 5 + 12 + 20,
      ];
      timeForNextShot = false;
      alienGunAtBack = true;
      playerMissileShot = me;
    });
  }

  String direction = 'left';
  var txt = "Start";
  void alienspaceMoves() {
    setState(() {
      // alien[0] = 21 | alien.last = 58
      if ((alien[0] - 1) % 20 == 0) {
        direction = 'right';
        // txt = ((alien[0])).toString();
      } else if ((alien.last + 2) % 20 == 0) {
        direction = 'left';
        // txt = ((alien.last)).toString();
      }
      if (direction == 'right') {
        for (int i = 0; i < alien.length; i++) {
          alien[i] += 1;
        }
      } else {
        for (int i = 0; i < alien.length; i++) {
          alien[i] -= 1;
        }
      }
    });
  }

  void myMovementLeft() {
    setState(() {
      if (me > 521) {
        me -= 1;
      }
    });
  }

  void updateDamage() {
    setState(() {
      if (alien.contains(playerMissileShot)) {
        // remove alien hitted part
        if (alien.length > 1) {
          alien.remove(playerMissileShot);
          // To remove missile after being hitted
          playerMissileShot = -1;
          alienGotHit = true;
        } else if (alien.length == 1) {
          _winnerScreen();
        }
      }
      if (me == alienMissileShot) {
        _gameOverScreen();
      }
      if (playerMissileShot == alienMissileShot) {
        playerMissileShot = -1;
        alienMissileShot = alien.first;
        alienGotHit = true;
      }
      if (barriers.contains(alienMissileShot)) {
        barriers.remove(alienMissileShot);
        alienMissileShot = alien.first;
      }
      if (barriers.contains(playerMissileShot)) {
        playerMissileShot = -1;
        alienGotHit = true;
      }
    });
  }

  void myMovementRight() {
    setState(() {
      if (me < 538) {
        me += 1;
      }
    });
  }

  int playerMissileShot;

  void firePlayerMissile() {
    // Setting Missile to the 1st box of myspace
    playerMissileShot = me;
    // setting alien got hit to false
    alienGotHit = false;

    const durationMissile = const Duration(milliseconds: 50);
    Timer.periodic(durationMissile, (timer) {
      // Every time the missile decreases by 20
      playerMissileShot -= 20;
      updateDamage();
      // Every Time Check either alien got hitted or playerMissileShot has
      // crossed The boundry Which is executed in update Damage Function
      if (alienGotHit || playerMissileShot < 0) {
        timer.cancel();
      }
    });
  }

// Setting alien Missile
  int alienMissileShot;
// Checking weather it is time for next shot or not
  bool timeForNextShot = false;
  bool alienGunAtBack = true;
  // bool missileHittedEachOther = false;
// Updating Alien Missile function

  void updateAlienMissile() {
    setState(() {
      // Setted alien missile increases but 20 every 100 millisecond
      alienMissileShot += 20;

      // if alien missileshot cross the boundary then this is the time for next
      // shot
      if (alienMissileShot > numberOfSquares) {
        // Set Gun At Back then ant front and vice versa
        alienGunAtBack = !alienGunAtBack;

        timeForNextShot = true;
      }
    });
  }

  void firealienMissile() {
    // setting alien gun at back
    alienMissileShot = alien.last;
    const durationMissile = const Duration(milliseconds: 50);
    Timer.periodic(durationMissile, (timer) {
      updateAlienMissile();
      updateDamage();
      if (timeForNextShot) {
        // setting if gun is at ist then at last and vice versa
        if (alienGunAtBack) {
          alienMissileShot = alien.last;
        } else {
          alienMissileShot = alien.first;
        }
        timeForNextShot = false;
      }
    });
  }

  void _winnerScreen() {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Winner'),
            actions: [
              ElevatedButton(
                  onPressed: () {
                    resetGame();
                    startGame();
                    Navigator.pop(context);
                  },
                  child: Text('Play Again'))
            ],
          );
        });
  }

  void _gameOverScreen() {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Game Over'),
            actions: [
              ElevatedButton(
                  onPressed: () {
                    resetGame();
                    startGame();
                    Navigator.pop(context);
                  },
                  child: Text('Play Again'))
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff455A64),
      body: Column(
        children: [
          Expanded(
            child: GridView.builder(
                physics: NeverScrollableScrollPhysics(),
                itemCount: numberOfSquares,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: numberInRow),
                itemBuilder: (context, index) {
                  if (alien.contains(index)) {
                    return MySpace(
                      color: Color(0xff7C4DFF),
                      clipper: HexagonalClipper(reverse: true),
                    );
                  } else if (alienMissileShot == index) {
                    return MySpace(
                      color: Colors.green,
                      clipper: StarClipper(8),
                    );
                  } else if (barriers.contains(index)) {
                    return MySpace(
                      color: Color(0xffBDBDBD),
                      clipper: PointsClipper(),
                    );
                  } else if (me == index) {
                    return MySpace(
                      color: Color(0xffCFD8DC),
                      clipper: ArrowClipper(20, 300, Edge.TOP),
                    );
                  } else if (playerMissileShot == index) {
                    return MySpace(
                      color: Colors.red,
                      clipper: StarClipper(8),
                    );
                  } else {
                    return MySpace(color: Color(0xff455A64));
                  }
                }),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 20.0, left: 20.0, right: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        primary: isPlaying ? Colors.red : Colors.green,
                        onPrimary: Colors.white),
                    onPressed: isPlaying
                        ? null
                        : () {
                            startGame();
                          },
                    child: isPlaying ? Text('Playing') : Text('Start')),
                IconButton(
                  onPressed: isPlaying
                      ? () {
                          myMovementLeft();
                        }
                      : () {},
                  icon: Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                  ),
                ),
                IconButton(
                  onPressed: isPlaying
                      ? () {
                          firePlayerMissile();
                        }
                      : () {},
                  icon: Icon(
                    Icons.airplanemode_on_rounded,
                    color: Colors.white,
                  ),
                ),
                IconButton(
                  onPressed: isPlaying
                      ? () {
                          myMovementRight();
                        }
                      : () {},
                  icon: Icon(
                    Icons.arrow_forward,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
