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
      fetchAuthorizedCode: (_) async => 'invalid',
    );
    expect(source.getCode('La Pau'), throwsFormatException);
  });
}
