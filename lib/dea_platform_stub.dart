import 'dea_code_source.dart';
Future<String> fetchAuthorizedCode(String station) async =>
    throw StateError('Protected DEA service requires the web application');
void registerCodeClear(void Function() clear) {}
DeaCodeSource protectedCodeSource() =>
    BackendDeaCodeSource(fetchAuthorizedCode: fetchAuthorizedCode);
