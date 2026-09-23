import 'package:flutter_test/flutter_test.dart';
import 'package:dea_codi_l4/dea_code_source.dart';

void main() {
  test('public source always returns a visibly non-operational example', () async {
    final result = await const DemoDeaCodeSource().getCode('La Pau');
    expect(result.isDemo, isTrue);
    expect(result.displayCode, 'C + ---- + X');
    expect(RegExp(r'\d').hasMatch(result.displayCode), isFalse);
  });

  test('backend denial propagates without a demo or local code fallback', () {
    final source = BackendDeaCodeSource(
      fetchAuthorizedCode: (_) async => throw StateError('Not approved'),
    );
    expect(source.getCode('La Pau'), throwsStateError);
  });

  test('invalid backend response is rejected', () {
    final source = BackendDeaCodeSource(
      fetchAuthorizedCode: (_) async => '',
    );
    expect(source.getCode('La Pau'), throwsFormatException);
  });

  test('backend text is preserved exactly', () async {
    final source = BackendDeaCodeSource(
      fetchAuthorizedCode: (_) async => 'TEST_ONLY',
    );
    final result = await source.getCode('La Pau');
    expect(result.displayCode, 'TEST_ONLY');
    expect(result.isDemo, isFalse);
  });
}
