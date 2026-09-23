/// Data boundary for the future authenticated TMB Agent backend.
abstract interface class DeaCodeSource {
  Future<DeaCodeResult> getCode(String station);
}

class DeaCodeResult {
  const DeaCodeResult({required this.displayCode, required this.isDemo});
  final String displayCode;
  final bool isDemo;
}

/// Public builds contain a visibly non-operational example, never real codes.
class DemoDeaCodeSource implements DeaCodeSource {
  const DemoDeaCodeSource();

  @override
  Future<DeaCodeResult> getCode(String station) async =>
      const DeaCodeResult(displayCode: 'C + ---- + X', isDemo: true);
}

/// Returns the original backend text verbatim; never persists it.
/// The future transport must use the common login session. The server must
/// validate both authentication and approval on EVERY request, deny by default,
/// and return Cache-Control: no-store. Never supply a static client secret.
/// This client adapter is not an authorization boundary and stores nothing.
class BackendDeaCodeSource implements DeaCodeSource {
  const BackendDeaCodeSource({required this.fetchAuthorizedCode});

  final Future<String> Function(String station) fetchAuthorizedCode;

  @override
  Future<DeaCodeResult> getCode(String station) async {
    final code = await fetchAuthorizedCode(station);
    if (code.isEmpty || code.length > 80) {
      throw const FormatException('Invalid DEA service response');
    }
    return DeaCodeResult(displayCode: code, isDemo: false);
  }
}
