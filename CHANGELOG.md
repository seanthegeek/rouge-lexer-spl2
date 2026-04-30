# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.2.0] - 2026-04-29

### Added

#### Eval functions

- `getfields`, `mvmap`, `object_to_array`, `object_to_xml`, `tan`, `tanh`,
  `xml_to_object`

#### Stats and dataset functions

- `c`, `dc`, `exactperc` aggregate aliases
- `unpivot` multivalue/array function
- `repeat` dataset function

#### Clause keywords

- `FROM`, `JOIN`, `SELECT`, `WHERE` — uppercase SQL-style clauses used inside
  the `from` command syntax. Distinct from the lowercase pipeline commands of
  the same name.

### Changed

- The time-modifier regex now requires a sign (`+`/`-`), digit, or `@` snap-to
  prefix and ends at a word boundary. The previous form greedily consumed
  single-letter time-unit prefixes from identifiers (e.g. `stats` → `s` + `tats`,
  `host` → `h` + `ost`), silently misclassifying many tokens as `Num::Other`
  while the Error-token count stayed at zero.

## [0.1.0] - 2026-04-29

### Added

- Initial release of the `rouge-lexer-spl2` gem
- `Rouge::Lexers::SPL2` lexer with tag `spl2`, alias `splunk-spl2`, filename
  extension `*.spl2`, and MIME type `text/x-spl2`
- Auto-detection heuristics for pipelines starting with `|`, `from $source`,
  field=value filters, and `_time` comparisons
- Token classification for SPL2 commands, clause keywords, boolean and word
  operators, eval/stats/charting built-in functions, magic fields, pipeline
  variables, decorator-style annotations, time-math literals, raw and quoted
  string literals, numeric literals, and Boolean/null constants

[0.2.0]: https://github.com/seanthegeek/rouge-lexer-spl2/releases/tag/v0.2.0
[0.1.0]: https://github.com/seanthegeek/rouge-lexer-spl2/releases/tag/v0.1.0
