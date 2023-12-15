import 'package:flutter_test/flutter_test.dart';
import 'package:memegeneraterappusingstacked/app/app.locator.dart';

import '../helpers/test_helpers.dart';

void main() {
  group('AdmobServiceTest -', () {
    setUp(() => registerServices());
    tearDown(() => locator.reset());
  });
}
