# 0.1.5

* Fix bugs in `Config`
* Add usage notes for `NameBuilder`
* Update outdated dev dependencies
* Reconfigure build setup.

## 0.1.4

* Improve error handling: `NameException` (includes breaking changes):
  * `ValidationError` has been removed and replaced by `ValidationException`
  * `NotAllowedError` has been removed and replaced by `NotAllowedException`
  * `InputException` is thrown instead of `ArgumentError` for input failures
  * `UnknownException` is the fallback
* Make `NameBuilder` a standalone library
* Abstract `Config` out and allow extended versions of it
* `Config.bypass` is by default set to `true` now.

## 0.1.3

* Improve API documentation
* Apply small refactoring: introduce additional class members
* Breaking changes: `prefix` and `suffix` are now available as class members.

## 0.1.2

* Add name builder
* Add support for initials in `format`.

## 0.1.1

* Extract a `Summarizable` mixin from `Summary`
* Add `raw` constructor to `FullName`
* Add support for name flattening with or without period
* Add copy capabilities to `Config`.

## 0.1.0+1

* Fix badges in README.

## 0.1.0

* First stable release.

## 0.1.0-beta.1

* First beta release.
