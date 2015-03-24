part of crash;

class Exit extends Piece {
  static const num defaultWidth = 75;
  static const num defaultHeight = 30;
  static const String greenColorCode = '#00FF00';

  Exit(int id): super(id) {
    color = greenColorCode;
    shape = PieceShape.RECT;
    width = defaultWidth;
    height = defaultHeight;
  }
}

abstract class Car extends MovablePiece {
  static const num defaultWidth = 75;
  static const num defaultHeight = 30;

  Car(int id): super(id) {
    shape = PieceShape.VEHICLE;
    width = defaultWidth;
    height = defaultHeight;
  }
}

class BlueCar extends Car {
  static const String blueColorCode = '#0000FF';

  BlueCar(int id): super(id) {
    color = blueColorCode;
    speed = Speed.random();
  }
}

class RedCar extends Car {
  static const String redColorCode = '#E40000';

  RedCar(int id): super(id) {
    color = redColorCode;
  }

  move([Direction direction]) {
    if (x > space.width - width) {
      x = space.width - width;
    }
    if (x < 0) {
      x = 0;
    }
    if (y > space.height - height) {
      y = space.height - height;
    }
    if (y < 0) {
      y = 0;
    }
  }
}

class Cars extends MovablePieces {
  RedCar redCar;
  Exit exit;

  Cars(int count) : super(count) {
    redCar = new RedCar(0);
    exit = new Exit(count);
  }

  createMovablePieces(int count) {
    for (var i = 0; i < count - 1; i++) {
      add(new BlueCar(i + 1));
    }
  }
}

