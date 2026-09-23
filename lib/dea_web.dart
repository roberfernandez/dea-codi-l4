import 'dart:js_interop';
import 'dea_code_source.dart';

@JS('window.deaFetchCode')
external JSPromise<JSString> _fetchCode(JSString station);
@JS('window.deaClearCode')
external set _clearCode(JSFunction callback);

Future<String> fetchAuthorizedCode(String station) async =>
    (await _fetchCode(station.toJS).toDart).toDart;
void registerCodeClear(void Function() clear) => _clearCode = clear.toJS;
DeaCodeSource protectedCodeSource() =>
    BackendDeaCodeSource(fetchAuthorizedCode: fetchAuthorizedCode);
