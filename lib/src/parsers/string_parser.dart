import '../config.dart';
import '../models/full_name.dart';
import '../util.dart';
import 'list_string_parser.dart';
import 'parser.dart';

class StringParser implements Parser<String> {
  @override
  String raw;

  @override
  Config config;

  StringParser(this.raw);

  @override
  FullName parse({Config options}) {
    config = Config.mergeWith(options);
    final names = raw.split(SeparatorChar.extract(config.separator));
    return ListStringParser(names).parse(options: options);
  }
}
