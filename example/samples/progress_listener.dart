import 'package:flutter/material.dart';
import 'package:mationani/mationani.dart';

class SampleProgressListener extends StatefulWidget {
  const SampleProgressListener({super.key});

  @override
  State<SampleProgressListener> createState() => _SampleProgressListenerState();
}

class _SampleProgressListenerState extends State<SampleProgressListener> {
  static const double max = 100;
  late final ValueNotifier<double> _notifier;

  @override
  void initState() {
    _notifier = ValueNotifier(0);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          left: 5,
          top: 10,
          child: ValueListenableBuilder( // todo: try to hide listener logic into widget.dart
            valueListenable: _notifier,
            builder: (context, value, child) {
              return Mationani.m(
                updater: Ani.updaterWhatever((c) => c.animateTo(value / max)),
                duration: (
                const Duration(milliseconds: 100),
                const Duration(milliseconds: 100)
                ),
                mamable: MamablePaint.path(
                  BetweenTicks(BetweenTicks.pathLine(
                    Offset.zero,
                    Offset(0, 100),
                    3,
                    strokeCap: StrokeCap.butt,
                  )),
                  pen: Paint()
                    ..color = Colors.brown
                    ..style = PaintingStyle.fill,
                ),
                child: const SizedBox.shrink(),
              );
            }
          ),
        ),
        Positioned(
          left: 10,
          child: SizedBox(
            height: 50,
            width: 100,
            child: ValueListenableBuilder(
              valueListenable: _notifier,
              builder: (context, value, child) => Slider(
                max: max,
                value: value,
                onChanged: (value) => _notifier.value = value,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
