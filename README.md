# rouge-lexer-spl2

A Rouge lexer plugin for Splunk SPL2, the unified search and data preparation
language used by Splunk Cloud Platform. Rouge is the default syntax highlighter
for Jekyll (and therefore GitHub Pages). This gem adds Splunk SPL2 support to
Rouge.

## Installation

Install the gem directly:

```sh
gem install rouge-lexer-spl2
```

Or add it to your `Gemfile`:

```ruby
gem 'rouge-lexer-spl2'
```

Then run:

```sh
bundle install
```

## Usage

Once installed, Rouge will automatically discover the lexer. You can use
`spl2` as the language tag in fenced code blocks (the lexer also responds to
the alias `splunk-spl2`).

A SQL-shaped query with a backtick search literal, snap-to time math, and a
field template:

````markdown
```spl2
SELECT _time, host, count() AS hits
FROM main
WHERE sourcetype="access_combined" AND `status="500"` AND _time >= -7d@d
GROUP BY host, span(_time, 1h)
HAVING hits > 10
ORDER BY hits DESC
LIMIT 50
```
````

A pipeline-shaped query with array/object literals, a lambda, and a
string template:

````markdown
```spl2
| from $source
| eval thresholds = {warn: 200, crit: 500}
| eval slow = filter(spans, ($s) -> $s.duration > thresholds.crit)
| eval label = "host=${host} slow=${len(slow)}"
| stats count() AS hits, values(label) AS labels BY service
```
````

A custom typed function and a search statement, the kind of code that only
exists in SPL2 modules:

````markdown
```spl2
type http_error = int where $value in([400, 401, 403, 404, 500])

function is_error($code : http_error) : boolean {
  return $code >= 400
}

$recent_errors = FROM main
  WHERE _time >= -1h@h AND is_error(status)
  GROUP BY host
  SELECT host, count() AS errors
```
````

### Jekyll / GitHub Pages

Add the gem to your site's `Gemfile` inside the `:jekyll_plugins` group:

```ruby
group :jekyll_plugins do
  gem "rouge-lexer-spl2"
end
```

Run `bundle install`, then use the `spl2` language tag in fenced code blocks.
Jekyll will pick up the lexer automatically via Rouge's plugin discovery.

### Colors

The lexer tells Rouge how to identify tokens. Rouge wraps each token in a `span`
tag with a `class` related to that token type. If you want to change how the
tokens are highlighted, change themes or add custom CSS.

## Development

Install dependencies:

```sh
bundle install
```

Run the test suite:

```sh
bundle exec rake
```

Start the visual preview server (available at http://localhost:9292):

```sh
bundle exec rake server
```

Run the terminal preview script:

```sh
ruby preview.rb
```

Enable debug mode to print each token and its value:

```sh
DEBUG=1 ruby preview.rb
```

### Iterative testing workflow

1. Run `bundle exec rake` to check for test failures and error tokens.
2. Start the server with `bundle exec rake server`.
3. In another terminal, check for error tokens in the rendered output:

   ```sh
   curl -s http://localhost:9292 | grep 'class="err"'
   ```

4. Fix any error tokens in `lib/rouge/lexers/spl2.rb`.
5. Repeat until no error tokens remain.

## License

MIT
