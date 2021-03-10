# namefully

A Dart utility for handling person names.

## Motivation

Have you ever had to format a user's name in a particular order, way, or shape?
Probably yes. If not, it will come at some point. Be patient.

## Key features

1. Offer supports for many writing systems, including Latin and European ones
(e.g., German, Greek, Cyrillic, Icelandic characters)
2. Accept different data shapes as input
3. Use of optional parameters to access advanced features
4. Format a name as desired
5. Offer support for prefixes and suffixes
6. Access to names' initials
7. Support hyphenated names, including with apostrophes

## Advanced features

1. Alter the order of appearance of a name: by given name or surname
2. Handle various subparts of a surname and given name
3. Use tokens (separators) to reshape prefixes and suffixes
4. Accept customized parsers (do it yourself)

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

This is a single configuration `Config` to use across the other components.

A singleton pattern is used to keep one configuration across the `Namefully`
setup. This is useful to avoid confusion when building other components such
as `FirstName`, `LastName`, or `Name` of distinct types (or `Namon`) that may
be of particular shapes.

Below are enlisted the options supported by `namefully`.

### orderedBy

`NameOrder` - default: `NameOrder.firstName`

Indicates in what order the names appear when set as raw string values or
string array values. That is, the first element/piece of the name is either the
given name (e.g., `Jon Snow`)  or the surname (e.g.,`Snow Jon`).

```dart
// 'Smith' is the surname in this raw string case
var name1 = Namefully(
  'Smith John Joe',
  config: Config.inline(orderedBy: NameOrder.lastName),
);
print(name1.lastName()); // Smith

// 'Edison' is the surname in this string array case
var name2 = Namefully.fromList(
  ['Edison', 'Thomas'],
  config: Config.inline(orderedBy: NameOrder.lastName),
);
print(name2.firstName()); // Thomas
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

*Only valid for raw string values*, this option indicates how to split the parts
of a raw string name under the hood.

```dart
var name = Namefully(
  'Adam,Sandler',
  config: Config.inline(separator: Separator.comma),
);
print(name.fullName()); // Adam Sandler
```

### titling

`AbbrTitle` - default: `AbbrTitle.uk`

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
}, config: Config.inline(titling: AbbrTitle.us));
print(name.fullName()); // Mr. John Smith
print(name.prefix()); // Mr.
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
print(name.fullName()); // John Smith, Ph.D
print(name.suffix()); // Ph.D
```

### lastNameFormat

`LastNameFormat` - default: `LastNameFormat.father`

Defines the distinct formats to output a compound surname (e.g., Hispanic
surnames).

```dart
var name = Namefully.fromJson(
  {
    'firstName': 'John',
    'lastName': 'Smith',
    'suffix': 'M.Sc.', // would fail the validation rule.
  },
  config: Config.inline(bypass: true, ending: true),
);
print(name.fullName()); // John Smith, M.Sc.
```

### bypass

`bool` - default: `false`

Skips all the validators (i.e., validation rules, regular expressions).

```dart
var name = Namefully.fromJson(
  {
    'firstName': 'John',
    'lastName': 'Smith',
    'suffix': 'M.Sc.', // would fail the validation rule.
  },
  config: Config.inline(bypass: true, ending: true),
);
print(name.fullName()); // John Smith, M.Sc.
```

To sum up, the default values are:

```dart
Config._default(this.name)
    : orderedBy = NameOrder.firstName,
      separator = Separator.space,
      titling = AbbrTitle.uk,
      ending = false,
      bypass = false,
      lastNameFormat = LastNameFormat.father;
```

## Do It Yourself

Customize your own parser to indicate the full name yourself.

```dart
import 'package:namefully/namefully.dart';

// Suppose you want to cover this '#' separator
class SimpleParser implements Parser<String> {
  @override
  Config? config;

  @override
  String raw;

  SimpleParser(this.raw);

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
print(name.fullName()); // Juan Garcia
```

## Concepts and examples

The name standards used for the current version of this library are as
follows:

```[prefix] firstName [middleName] lastName [suffix]```

The opening `[` and closing `]` brackets mean that these parts are optional. In
other words, the most basic/typical case is a name that looks like this:
`John Smith`, where `John` is the *firstName* and `Smith`, the *lastName*.

> NOTE: Do notice that the order of appearance matters and (as shown
> [here](#orderedBy)) can be altered through configured parameters. By default,
> the order of appearance is as shown above and will be used as a basis for
> future examples and use cases.

Once imported, all that is required to do is to create an instance of
`Namefully` and the rest will follow.

### Basic cases

Let us take a common example:

```Mr John Joe Smith PhD```

So, this utility understands the name parts as follows:

- typical name: `John Smith`
- first name: `John`
- middle name: `Joe`
- last name: `Smith`
- prefix: `Mr`
- suffix: `PhD`
- full name: `Mr John Joe Smith PhD`
- birth name: `John Joe Smith`
- flattened: `John J. Smith`
- initials: `J J S`

### Limitations

`namefully` does not have support for certain use cases:

- mononame:  `Plato`. It can be tricked though by setting the mononame as both
first and last name;
- multiple surnames: `De La Cruz`, `Da Vinci`. You can also trick it using your
own parsing method or setting separately each name part via the `Nama|Name` type
or the string array input;
- multiple prefixes: `Prof. Dr. Einstein`. An alternative would be to use the
`bypass` option.

See the [test cases](test) for further details.

## API

| Name | Arguments | Default Values | Returns | Description |
|---|---|---|---|---|
|*prefix*|-|-|`String?`|Gets the prefix part of the full name, if any|
|*firstName*|`includeAll`|`true`|`String`|Gets the first name part of the full name|
|*middleNames*|-|-|`List<String>`|Gets the middle name part of the full name, if any|
|*lastName*|`LastNameFormat?`||`String`|Gets the last name part of the full name|
|*suffix*|-|-|`String?`|Gets the suffix part of the full name, if any|
|*fullName*|`NameOrder?`|-|`String`|Gets the full name|
|*birthName*|`NameOrder?`|-|`String`|Gets the birth name, no prefix or suffix|
|*initials*|`NameOrder?`, `withMid`| -, `false`|`String`|Gets the initials of the first and last names|
|*stats*|`NameType?`|-|`Summary?`|Gives some descriptive statistics of the characters' distribution.|
|*shorten*|`NameOrder?`|-|`String`|Returns a typical name (e.g. first and last name)|
|*flatten*|`limit`, `by`|`20`, `midLast`|`String`|Compresses a name using different forms of variants|
|*zip*|`NameType?`|`midLast`|`String`|Shortens a full name|
|*format*|`how?`|-|`String`|Formats the name as desired|
|*to*|`Capitalization`|-|`String`|Transforms a birth name to a specific title case|
|*passwd*|`NameType?`|-|`String`|Returns a password-like representation of a name|

## Related packages

This package is also written in [TypeScript](https://www.typescriptlang.org/)
and made available for:

- [JavaScript](https://www.npmjs.com/package/namefully)
- [React](https://www.npmjs.com/package/@namefully/react)
- [Angular](https://www.npmjs.com/package/@namefully/ng)

## Author

Developed by [Ralph Florent](https://github.com/ralflorent).

## License

The underlying content of this utility is licensed under [MIT](LICENSE).
