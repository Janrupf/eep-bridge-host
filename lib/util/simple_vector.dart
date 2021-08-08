import 'dart:math' as math;
import 'dart:ui';

class SimpleVector {
  double _xLength;
  double _yLength;
  double _length;

  double get xLength => _xLength;

  double get yLength => _yLength;

  set xLength(double value) {
    _xLength = value;
    _length = math.sqrt(_xLength * _xLength + _yLength * _yLength);
  }

  set yLength(double value) {
    _yLength = value;
    _length = math.sqrt(_xLength * _xLength + _yLength * _yLength);
  }

  SimpleVector(double xLength, double yLength)
      : _xLength = xLength,
        _yLength = yLength,
        _length = math.sqrt(xLength * xLength + yLength * yLength);

  factory SimpleVector.between(Offset a, Offset b) {
    return SimpleVector(a.dx - b.dx, a.dy - b.dy);
  }

  double get length => _length;

  RotationValue get rotation => RotationValue.radians(math.atan2(yLength, xLength));

  SimpleVector shrink(double amount) => extend(-amount);

  SimpleVector extend(double amount) {
    var newXLength = xLength;
    var newYLength = yLength;

    if (length > 0) {
      newXLength /= length;
      newYLength /= length;
    }

    newXLength *= amount;
    newYLength *= amount;

    return SimpleVector(newXLength, newYLength);
  }

  SimpleVector invert() => SimpleVector(-xLength, -yLength);

  SimpleVector rotate(RotationValue amount,
      [Offset origin = const Offset(0, 0)]) {
    final c = math.cos(amount.radians);
    final s = math.sin(amount.radians);

    final translatedX = xLength - origin.dx;
    final translatedY = yLength - origin.dy;

    return SimpleVector((translatedX * c - translatedY * s) + origin.dx, (translatedX * s + translatedY * c) + origin.dy);
  }

  Offset apply(Offset offset) {
    return offset.translate(xLength, yLength);
  }

  Offset applyInverted(Offset offset) {
    return offset.translate(-xLength, -yLength);
  }
}

const double RADIANS_TO_DEGREE = 180 / math.pi;
const double DEGREE_TO_RADIANS = math.pi / 180;

class RotationValue {
  final double radians;
  final double degree;

  const RotationValue.radians(this.radians)
      : degree = radians * RADIANS_TO_DEGREE;

  const RotationValue.degree(double degree)
      : degree = degree >= 0 ? degree : 360 + degree,
        radians = degree * DEGREE_TO_RADIANS;
}
