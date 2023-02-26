# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [0.9.0] - 2023-02-26

### Changed

- Push minumum required Ruby version to `>= 2.6`; technically not breaking, as `antex` already had that bound.
- Lift restriction on required Ruby version to `< 3.1`.

### Fixed

- Solve `Psych::DisallowedClass` for ruby `>= 3.1` by explicitly allowing `Regexp` class.

## [0.8.2] - 2023-02-26

### Fixed

- Bound Ruby version to `< 3.1` to avoid confusing `Psych::DisallowedClass`.

## [0.8.1] - 2022-08-31

### Fixed

- Use unique prefixes on embedded SVG ids to avoid in-page conflicts.

## [0.8.0] - 2022-08-25

### Added

- Implement `inlining` boolean options to toggle SVG inlining (`false` by default).

## [0.7.0] - 2022-01-29

### Changed

- Avoid gathering all `page`s and `collection`s documents for processing; instead, filter them by suffix allowing only paths matching `.{html,md}`.

## [0.6.1] - 2022-01-11

### Fixed

- Avoid ugly crash in `--incremental` mode. Please note that aliases still does not work in `include`d files, while `antex` tags still do.

## [0.6.0] - 2018-12-12

## [0.5.1] - 2018-12-09

## [0.5.0] - 2018-09-12

## [0.4.0] - 2018-09-11

## [0.3.2] - 2018-09-04

## [0.3.1] - 2017-10-07

## [0.3.0] - 2017-10-07

## [0.2.2] - 2017-10-06

## [0.2.1] - 2017-10-01

## [0.2.0] - 2017-10-01

## [0.1.0] - 2017-10-01

[unreleased]: https://github.com/paolobrasolin/jekyll-antex/compare/0.9.0...HEAD
[0.9.0]: https://github.com/paolobrasolin/jekyll-antex/compare/0.8.2...0.9.0
[0.8.2]: https://github.com/paolobrasolin/jekyll-antex/compare/0.8.1...0.8.2
[0.8.1]: https://github.com/paolobrasolin/jekyll-antex/compare/0.8.0...0.8.1
[0.8.0]: https://github.com/paolobrasolin/jekyll-antex/compare/0.7.0...0.8.0
[0.7.0]: https://github.com/paolobrasolin/jekyll-antex/compare/0.6.1...0.7.0
[0.6.1]: https://github.com/paolobrasolin/jekyll-antex/compare/0.6.0...0.6.1
[0.6.0]: https://github.com/paolobrasolin/jekyll-antex/compare/0.5.1...0.6.0
[0.5.1]: https://github.com/paolobrasolin/jekyll-antex/compare/0.5.0...0.5.1
[0.5.0]: https://github.com/paolobrasolin/jekyll-antex/compare/0.4.0...0.5.0
[0.4.0]: https://github.com/paolobrasolin/jekyll-antex/compare/0.3.2...0.4.0
[0.3.2]: https://github.com/paolobrasolin/jekyll-antex/compare/0.3.1...0.3.2
[0.3.1]: https://github.com/paolobrasolin/jekyll-antex/compare/0.3.0...0.3.1
[0.3.0]: https://github.com/paolobrasolin/jekyll-antex/compare/0.2.2...0.3.0
[0.2.2]: https://github.com/paolobrasolin/jekyll-antex/compare/0.2.1...0.2.2
[0.2.1]: https://github.com/paolobrasolin/jekyll-antex/compare/0.2.0...0.2.1
[0.2.0]: https://github.com/paolobrasolin/jekyll-antex/compare/0.1.0...0.2.0
[0.1.0]: https://github.com/paolobrasolin/jekyll-antex/releases/tag/0.1.0
