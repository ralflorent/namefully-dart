# namefully

[![Pub version][version-img]][version-url]
[![CI build][ci-img]][ci-url]
[![Coverage status][codecov-img]][codecov-url]

A Dart utility for handling person names.

## Motivation

Have you ever had to format a user's name in a particular order, way, or shape?
Probably yes. If not, it will come at some point. Be patient.

You may want to use this library if:

- you've been repeatedly dealing with users' given names and surnames;
- you need to occasionally format a name in a particular order, way, or shape;
- you keep copy-pasting your name-related business logic for every project;
- you're curious about trying new, cool stuff (e.g., learning Dart).

## Key features

1. Accept different data shapes as input
2. Use of optional parameters to access advanced features
3. Format a name as desired
4. Offer support for prefixes and suffixes
5. Access to names' initials
6. Support hyphenated names (and other special characters)
7. Offer predefined validation rules for many writing systems, including the
   Latin and European ones (e.g., German, Greek, Cyrillic, Icelandic characters)

## Advanced features

1. Alter the name order anytime
2. Handle various parts of a surname and a given name
3. Use tokens (separators) to reshape prefixes and suffixes
4. Accept customized parsers (do it yourself)
5. Build a name on the fly (via a builder)

## Dependencies

None

## Usage

See `example/namefully.dart`.

```dart
import 'package:namefully/namefully.dart';

void main() {
  var name = Namefully('Jon Stark Snow');
  print(name.format('L, f m')); // SNOW, Jon Stark
  print(name.shorten()); // Jon Snow
  print(name.zip()); // Jon S. S.
}
```

## `Config` and default values

`Config` is a single configuration to use across the other components.

The multiton pattern is used to keep one configuration across the `Namefully`
setup. This is useful for avoiding confusion when building other components such
as `FirstName`, `LastName`, or `Name` of distinct types (or `Namon`) that may
be of particular shapes.

Below are enlisted the options supported by `namefully`.

### orderedBy

`NameOrder` - default: `NameOrder.firstName`

Indicates in what order the names appear when set as raw string values or string
array values. That is, the first element/piece of the name is either the given
name (e.g., `Jon Snow`) or the surname (e.g.,`Snow Jon`).

```dart
// 'Smith' is the surname in this raw string case
var name1 = Namefully(
  'Smith John Joe',
  config: Config.inline(orderedBy: NameOrder.lastName),
);
print(name1.last); // Smith

// 'Edison' is the surname in this string array case
var name2 = Namefully.fromList(
  ['Edison', 'Thomas'],
  config: Config.inline(orderedBy: NameOrder.lastName),
);
print(name2.first); // Thomas
```

> NOTE: This option also affects all the other results of the API. In other
> words, the results will prioritize the order of appearance set in the first
> place for the other operations. Keep in mind that in some cases, it can be
> altered on the go. See the example below.

```dart
// 'Smith' is the surname in this raw string case
var name = Namefully(
  'Smith John Joe',
  config: Config.inline(orderedBy: NameOrder.lastName),
);
print(name.fullName()); // Smith John Joe

// Now alter the order by choosing the given name first
print(name.fullName(NameOrder.firstName)); // John Joe Smith
```

### separator

`Separator` - default: `Separator.space`

_Only valid for raw string values_, this option indicates how to split the parts
of a raw string name under the hood.

```dart
var name = Namefully(
  'John,Smith',
  config: Config.inline(separator: Separator.comma),
);
print(name.full); // John Smith
```

### title

`Title` - default: `Title.uk`

Abides by the ways the international community defines an abbreviated title.
American and Canadian English follow slightly different rules for abbreviated
titles than British and Australian English. In North American English, titles
before a name require a period: `Mr., Mrs., Ms., Dr.`. In British and Australian
English, no periods are used in these abbreviations.

```dart
var name = Namefully.fromJson({
  'prefix': 'Mr',
  'firstName': 'John',
  'lastName': 'Smith',
}, config: Config.inline(title: Title.us));
print(name.full); // Mr. John Smith
print(name.prefix); // Mr.
```

### ending

`bool` - default: `false`

Sets an ending character after the full name (a comma before the suffix
actually).

```dart
var name = Namefully.fromJson(
  {
    'firstName': 'John',
    'lastName': 'Smith',
    'suffix': 'Ph.D',
  },
  config: Config.inline(ending: true),
);
print(name.full); // John Smith, Ph.D
print(name.suffix); // Ph.D
```

### surname

`Surname` - default: `Surname.father`

Defines the distinct formats to output a compound surname (e.g., Hispanic
surnames).

```dart
var name = Namefully.of(
  [FirstName('John'), LastName('Doe', 'Smith')],
  config: Config.inline(surname: Surname.hyphenated),
);
print(name.full); // John Doe-Smith
```

### bypass

`bool` - default: `true`

Skips all the validators (i.e., validation rules, regular expressions).

```dart
var name = Namefully.fromJson(
  {
    'firstName': 'John',
    'lastName': 'Smith',
    'suffix': 'M.Sc.', // will fail the validation rule and throw an exception.
  },
  config: Config.inline(bypass: false, ending: true),
);
```

To sum it all up, the default values are:

```dart
Config._default(this.name)
    : orderedBy = NameOrder.firstName,
      separator = Separator.space,
      title = Title.uk,
      ending = false,
      bypass = true,
      surname = Surname.father;
```

## Do It Yourself

Customize your own parser to indicate the full name yourself.

```dart
import 'package:namefully/namefully.dart';

// Suppose you want to cover this '#' separator
class SimpleParser implements Parser<String> {
  const SimpleParser(this.raw);

  @override
  final String raw;

  @override
  FullName parse({Config? options}) {
    final names = raw.split('#'); // simple parsing logic :P
    return FullName.fromJson({
      'firstName': names[0].trim(),
      'lastName': names[1].trim(),
    }, config: options);
  }
}

var name = Namefully.fromParser(
  SimpleParser('Juan#Garcia'),
  config: Config.inline(name: 'simpleParser'),
);
print(name.full); // Juan Garcia
```

## Concepts and examples

The name standards used for the current version of this library are as
follows:

`[prefix] firstName [middleName] lastName [suffix]`

The opening `[` and closing `]` brackets mean that these parts are optional. In
other words, the most basic/typical case is a name that looks like this:
`John Smith`, where `John` is the _firstName_ and `Smith`, the _lastName_.

> NOTE: Do notice that the order of appearance matters and (as shown
> [orderedBy](#orderedBy)) can be altered through configured parameters. By default,
> the order of appearance is as shown above and will be used as a basis for
> future examples and use cases.

Once imported, all that is required to do is to create an instance of
`Namefully` and the rest will follow.

### Basic cases

Let us take a common example:

`Mr John Joe Smith PhD`

So, this utility understands the name parts as follows:

- prefix: `Mr`
- first name: `John`
- middle name: `Joe`
- last name: `Smith`
- suffix: `PhD`
- full name: `Mr John Joe Smith PhD`
- birth name: `John Joe Smith`
- short version: `John Smith`
- flattened: `John J. S.`
- initials: `J J S`

### Limitations

`namefully` does not have support for certain use cases:

- mononame: `Plato`. A workaround is to set the mononame as both first and last name;
- multiple prefixes: `Prof. Dr. Einstein`.

See the [test cases](test) for further details or the
[API Reference](https://pub.dev/documentation/namefully).

## License

The underlying content of this utility is licensed under [MIT](LICENSE).

<!-- References -->

[version-img]: https://img.shields.io/pub/v/namefully
[version-url]: https://pub.dev/packages/namefully
[ci-img]: https://github.com/ralflorent/namefully-dart/workflows/build/badge.svg
[ci-url]: https://github.com/ralflorent/namefully-dart/actions/workflows/config.yml
[codecov-img]: https://codecov.io/gh/ralflorent/namefully-dart/branch/main/graph/badge.svg?token=G4P25DZSIN
[codecov-url]: https://codecov.io/gh/ralflorent/namefully-dart
