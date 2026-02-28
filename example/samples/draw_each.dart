import 'dart:math' as math;
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:mationani/mationani.dart';

class SampleDraw extends StatelessWidget {
  const SampleDraw({super.key});

  @override
  Widget build(BuildContext context) {
    return Mationani.n(
      ani: Ani.updateForwardOrReverse(),
      manable: ManableSet.each([
        MamablePaint.path(
          BetweenTicks(
            // strokes are implicit closing if Path.combine
                (t) => Path.combine(
              PathOperation.union,
              _Arc.arcA.extractPath(0, _Arc.arcA.length * t),
              _Arc.arcB.extractPath(0, _Arc.arcB.length * t),
            ),
          ),
          pen: Paint()
            ..style = PaintingStyle.stroke
            ..color = Colors.green.shade100
            ..strokeWidth = 3,
        ),
        MamablePaint.path(
          BetweenTicks(
            BetweenTicks.pathRPCOnEdge(
              5,
              40,
              cornerRadius: Between(0, 120),
            ),
          ),
          pen: Paint()
            ..style = PaintingStyle.fill
            ..color = Colors.brown,
        ),
        MamablePaint.path(
          BetweenTicks(_Arc.transform),
          pen: Paint()
            ..style = PaintingStyle.stroke
            ..color = Colors.black
            ..strokeWidth = 2,
        ),
        MamablePaint(
          Path()
            ..moveTo(5, 120)
            ..lineTo(100, 50),
          Paint()
            ..style = PaintingStyle.stroke
            ..color = Colors.red.shade100
            ..strokeWidth = 4,
        ),
        MamableClip(
          Path()
            ..moveTo(70, 150)
            ..lineTo(80, 150 - 10 * math.sqrt(3))
            ..arcToPoint(
              Offset(80, 150 + 10 * math.sqrt(3)),
              radius: Radius.circular(40),
              clockwise: false,
              largeArc: true,
            )
            ..close(),
        ),
      ]),
      parenting: (children) => Stack(children: children),
      children: [
        SizedBox.expand(),
        SizedBox.expand(),
        SizedBox.expand(),
        SizedBox.expand(),
        SizedBox.expand(child: ColoredBox(color: Colors.blue.shade100)),
      ],
    );
  }
}

class _Arc {
  const _Arc();

  static const Offset end = Offset(100, 100);
  static const double r = 50 * math.sqrt2;
  static final PathMetric arcA = () {
    final path = Path()
      ..arcToPoint(
        end,
        radius: Radius.circular(r),
        clockwise: true,
      );
    return path.computeMetrics().first;
  }();
  static final PathMetric arcB = () {
    final path = Path()
      ..arcToPoint(
        end,
        radius: Radius.circular(r),
        clockwise: false,
      );
    return path.computeMetrics().first;
  }();

  ///
  /// [r] = 50√2
  /// r(cosθ, sinθ) represents the circle with center be on (0, 0).
  /// let [t] linearize the angle change from -3π/4 to π/4.
  /// t_θ = -3π/4 ± πt
  ///
  static const double rStart = -3 * math.pi / 4;

  static Path transform(double t) {
    final dt = 2 * math.pi * t;
    return Path()
      ..addOval(
        Rect.fromCircle(
          center: Offset(
            50 + r * math.cos(rStart + dt),
            50 + r * math.sin(rStart + dt),
          ),
          radius: 3,
        ),
      );
  }
}
