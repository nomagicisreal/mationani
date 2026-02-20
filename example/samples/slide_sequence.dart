import 'package:flutter/material.dart';
import 'package:mationani/mationani.dart';

class MationItem {
  final double x2;
  final double x3;
  final double y2;
  final double y3;

  const MationItem(
    this.x2,
    this.y2,
    this.x3,
    this.y3,
  );
}

class SampleSlide extends StatelessWidget {
  const SampleSlide({super.key});

  static final List<MationItem> cubics = [
    MationItem(33, 33, 66, 66),
    ...List.generate(11, (i) {
      final x = i * 10.0;
      return MationItem(x, 0, 100 - x, 100);
    }),
    ...List.generate(11, (i) {
      final x = i * 5.0;
      return MationItem(x, 0, 100 - x, 100);
    }),
  ];

  Mamable _sMamable(MationItem previous, MationItem next, BiCurve curve) =>
      MamablePaint.path(
        BetweenTicks(
          BetweenTicks.depend(
            Between(
              (previous.x2, previous.y2, previous.x3, previous.y3),
              (next.x2, next.y2, next.x3, next.y3),
            ).transform,
            (record) => Path()
              ..cubicTo(record.$1, record.$2, record.$3, record.$4, 100, 100)
              ..addOval(Rect.fromCircle(center: Offset.zero, radius: 3))
              ..addOval(Rect.fromCircle(center: Offset(100, 100), radius: 3))
              ..addOval(Rect.fromCircle(
                center: Offset(record.$1, record.$2),
                radius: 3,
              ))
              ..addOval(Rect.fromCircle(
                center: Offset(record.$3, record.$4),
                radius: 3,
              )),
          ),
        ),
        pen: Paint()
          ..color = Colors.black
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2,
      );

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Masionani.mamion(
          steps: cubics,
          ani: const AniSequenceCommand(
            initialize: null,
            update: AniSequenceCommandUpdate.forwardStepExceptReverse,
          ),
          sMamable: _sMamable,
          child: SizedBox.expand(),
        ),
        Mationani.mamion(
          duration: const (Duration(seconds: 5), Duration(seconds: 5)),
          ani: Ani.initForward(),
          mamable: MamableTransition.align(
            BetweenTicks.sequence(
              [
                AlignmentGeometry.topStart,
                AlignmentGeometry.topEnd,
                AlignmentGeometry.bottomEnd,
                AlignmentGeometry.bottomStart,
                AlignmentGeometry.centerStart,
                AlignmentGeometry.center,
              ],
              weights: List.generate(5, (i) => 10.0 - i, growable: false),
            ),
          ),
          child: ColoredBox(
            color: Colors.green.shade100,
            child: SizedBox.square(
              dimension: 10,
            ),
          ),
        ),
      ],
    );
  }
}
