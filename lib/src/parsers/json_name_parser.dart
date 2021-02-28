import '../config.dart';
import '../models/enums.dart';
import '../models/full_name.dart';
import '../util.dart';
import '../validators/nama_validator.dart';
import 'parser.dart';

class JsonNameParser implements Parser<Map<String, String>> {
  @override
  Map<String, String> raw;

  @override
  Config config;

  Map<Namon, String> _nama;

  JsonNameParser(this.raw) {
    _asNama();
  }

  @override
  FullName parse({Config options}) {
    /// Given this setting;
    config = Config.mergeWith(options);

    /// Try to validate first;
    if (!config.bypass) NamaValidator().validate(_nama);

    /// Then create a [FullName] from json.
    return FullName.fromJson(raw, config: config);
  }

  void _asNama() {
    raw.forEach((key, value) {
      var namon = NamonKey.castTo(key);
      if (namon != null) _nama[namon] = value;
    });
  }
}
