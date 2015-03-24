part of crash;

class Board extends Surface {
  static const int carCount = 9;

  Cars cars;
  RedCar redCar;
  Exit exit;
  Size space;

  int milliseconds;
  bool isGameRunning = false;

  int totalGames = 0;
  int totalGamesWon = 0;
  int highScore = 0;

  SpanElement gameStatusLabel;
  SpanElement gamesTotalLabel;
  SpanElement gamesTotalWonLabel;
  SpanElement gamesHighScoreLabel;

  Board(CanvasElement canvas) : super(canvas) {
    gameStatusLabel = querySelector('#game-status');
    gamesTotalLabel = querySelector('#game-total');
    gamesTotalWonLabel = querySelector('#game-total-won');
    gamesHighScoreLabel = querySelector('#game-high-score');

    gameStatusLabel.text = 'Cliquez sur la voiture rouge à jouer';

    initGame();

    document.onMouseDown.listen((MouseEvent e) {
      if (redCar.contains(e.offset.x, e.offset.y)) {
        startGame();
      }
    });
    document.onMouseMove.listen((MouseEvent e) {
      if (isGameRunning) {
        redCar.x = e.offset.x - redCar.width  / 2;
        redCar.y = e.offset.y - redCar.height / 2;
        redCar.move();
      }
    });
  }

  initGame() {
    space = new Size(width, height);
    cars = new Cars(carCount);

    cars.forEach((Car car) {
      car.space = space;
      car.jump();
    });

    redCar = cars.redCar;
    redCar.space = space;
    redCar.box.position = new Position(0, height / 2);

    exit = cars.exit;
    exit.space = space;
    exit.box.position = new Position(width - exit.box.width, height / 2);
  }

  startGame() {
    gameStatusLabel.text = 'GO GO GO!';
    milliseconds = new DateTime.now().millisecondsSinceEpoch;
    isGameRunning = true;
  }

  stopGame(bool won) {
    isGameRunning = false;

    int currentScore = 5000 - (new DateTime.now().millisecondsSinceEpoch - milliseconds);
    currentScore = currentScore > 0 ? currentScore : 0;

    totalGames++;

    if (won) {
      totalGamesWon++;

      bool isNewHighScore = false;
      if (currentScore > highScore) {
        if (highScore > 0) {
          isNewHighScore = true;
        }
        highScore = currentScore;
      }

      if (isNewHighScore) {
        gameStatusLabel.text = 'Vous avez gagné avec un nouveau record: ' + currentScore.toString();
      } else {
        gameStatusLabel.text = 'Vous avez gagné avec un pointage: ' + currentScore.toString();
      }
    } else {
      gameStatusLabel.text = 'Vous avez perdu';
    }

    gamesTotalLabel.text = totalGames.toString();
    gamesTotalWonLabel.text = totalGamesWon.toString();
    gamesHighScoreLabel.text = highScore.toString();
  }

  draw() {
    clear();
    bool isAccident = false;

    for (BlueCar car in cars) {
      if (isGameRunning) {
        car.move();
        cars.avoidCollisions(car);

        cars.forEach((car) {
          if (redCar.hit(car)) {
            isAccident = true;
          }
        });
      }
      drawPiece(car);
    }

    if (isAccident) {
      stopGame(false);
      initGame();
      return;
    }
    if (redCar.hit(exit)) {
      stopGame(true);
      initGame();
      return;
    }
    
    drawPiece(redCar);
    drawPiece(exit);
  }
}
