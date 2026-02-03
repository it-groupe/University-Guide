import 'dart:convert';

String encode_json(Object value) => jsonEncode(value);

dynamic decode_json(String raw) => jsonDecode(raw);
