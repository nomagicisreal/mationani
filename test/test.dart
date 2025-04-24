import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'src/tester.dart';

///
/// [main]
/// [MationaniTestOption]
/// [MationaniTestApp]
///
void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MationaniTestApp(
      option: MationaniTestOption.mamionTransition,
    ));

    // Verify that our counter starts at 0.
    expect(find.text('0'), findsOneWidget);
    expect(find.text('1'), findsNothing);

    // Tap the '+' icon and trigger a frame.
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    // Verify that our counter has incremented.
    expect(find.text('0'), findsNothing);
    expect(find.text('1'), findsOneWidget);
  });
}

///
///
///
enum MationaniTestOption {
  mamionTransition,
  mamionTransform,
  mamionClipper,
  fabExpandable;
}

///
///
///
class MationaniTestApp extends StatelessWidget {
  const MationaniTestApp({super.key, required this.option});

  final MationaniTestOption option;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: true,
      home: switch (option) {
        MationaniTestOption.fabExpandable => const TestFabExpandable(),
        _ => throw UnimplementedError(),
      },
    );
  }
}
