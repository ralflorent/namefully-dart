import '../config.dart';
import '../models/full_name.dart';

abstract class Parser<T> {
  /// raw data to be parsed
  T raw;

  /// Configurations for parsing
  Config config;

  /// Parses the raw data into a full name
  FullName parse({Config options});
}
