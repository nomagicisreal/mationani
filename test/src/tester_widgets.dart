part of 'tester.dart';

class TestFabExpandable extends StatefulWidget {
  const TestFabExpandable({super.key});

  @override
  State<TestFabExpandable> createState() => _TestFabExpandableState();
}

class _TestFabExpandableState extends State<TestFabExpandable> {
  bool toggle = false;
  int count = 0;

  void _onPressed({bool update = true}) {
    count++;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black45,
      body: SizedBox.expand(
        child: GridPaper(
          interval: 100,
          divisions: 2,
          subdivisions: 1,
          color: Colors.white54,
        ),
      ),
      floatingActionButton: FloatingActionButton(onPressed: _onPressed),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerTop,
    );
  }
}
