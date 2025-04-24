// ignore_for_file: unused_local_variable

void main() {
  print(0 / 10);
  final world = Hey;
  final what = What()..say();
}

final class World {
  void say() => print('say');
}

final class What extends World {
  @override
  void say() => print('hi');
}

sealed class Hey {}