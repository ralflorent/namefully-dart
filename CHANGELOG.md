# 0.1.6

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
