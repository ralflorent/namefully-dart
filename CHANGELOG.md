# 0.2.1

- Apply minor improvements in code docs
- `NameBuilder` now supports lifecycle hooks
- Make `FirstName.more` and `LastName.mother` nullable `Name` objects instead of strings
- Add support for salutations (e.g., `Mr Smith`).

## 0.2.0

- Improve usability of `Config` (now accepts named args directly).
- Upgrade package for Dart SDK 2.18
- Upgrade dev dependencies
- Apply new recommended lint rules
- Update name builder (includes breaking changes)
- Fix name derivative builder.

## 0.2.0-dev.3

- Improve usability of `Config` (now accepts named args directly).

## 0.2.0-dev.2

- Upgrade package for Dart SDK 2.18
- Upgrade dev dependencies
- Apply new recommended lint rules.

## 0.2.0-dev.1

- Update name builder (includes breaking changes)
- Fix name derivative builder.

## 0.1.8+1

- Fix list string validator issue
- Add copy capabilities to `FirstName` and `LastName`.

## 0.1.8

- Add named constructors for `Name`
- Add text parser for dynamic birth names (ordered by first name)
- Apply minor improvements and add more test coverage
- Add more support for middle name handling (e.g., flattening, parsing)
- Fix automatic validation for json names (now relies on `bypass`).

## 0.1.7

- Remove support for summary and password fields (breaking changes).
- Add iterable of name parts.

## 0.1.6

- Add String extension support for quick starters
- Use effective Dart in `NameException`
- Use convenient getters (e.g., `FirstName.hasMore`, `LastName.hasMother`)
- No longer support `Namebuilder.asString`
- Use semantic names instead for types (breaking changes)
  - `AbbrTitle` -> `Title`
  - `FlattenedBy` -> `Flat`
  - `LastNameFormat` -> `Surname`
  - `Capitalization` -> `Case`

## 0.1.5+2

- Fix `FirstName.length` bad state error
- Fix `Config.bypass` validation check and related bugs
- Improve performance (by removing unnecessary `Config.merge()` calls)
- Add more tests

## 0.1.5+1

- Improve performance (See `Separator`, `Namon`, etc.)
- Add hash utils
- Upgrade dependencies
- Migrate from `pedantic` to official Dart lint rules.

## 0.1.5

- Fix bugs in `Config`
- Add usage notes for `NameBuilder`
- Update outdated dev dependencies
- Reconfigure build setup.

## 0.1.4

- Improve error handling: `NameException` (includes breaking changes):
  - `ValidationError` has been removed and replaced by `ValidationException`
  - `NotAllowedError` has been removed and replaced by `NotAllowedException`
  - `InputException` is thrown instead of `ArgumentError` for input failures
  - `UnknownException` is the fallback
- Make `NameBuilder` a standalone library
- Abstract `Config` out and allow extended versions of it
- `Config.bypass` is by default set to `true` now.

## 0.1.3

- Improve API documentation
- Apply small refactoring: introduce additional class members
- Breaking changes: `prefix` and `suffix` are now available as class members.

## 0.1.2

- Add name builder
- Add support for initials in `format`.

## 0.1.1

- Extract a `Summarizable` mixin from `Summary`
- Add `raw` constructor to `FullName`
- Add support for name flattening with or without period
- Add copy capabilities to `Config`.

## 0.1.0+1

- Fix badges in README.

## 0.1.0

- First stable release.

## 0.1.0-beta.1

- First beta release.
