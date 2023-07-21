import 'package:flutter_test/flutter_test.dart';

import 'package:creator/creator.dart';


void main() {

  final number = Creator<int>(((ref, self) => 1));
  final double = Creator<int>((ref, self) => ref.watch(number, self) * 2);

  test('creator state propagation test', () {
    final ref = Ref();
    // 2
    ref.watch(double, null);
    expect(ref.watch(double, null), 2);
    
    ref.set(number, 10);
    // 20
    ref.watch(double, null);
    expect(ref.watch(double, null), 20);

    ref.update<int>(number, (n) => n + 1);
    // 22
    expect(ref.watch(double, null), 22);
  });

}
