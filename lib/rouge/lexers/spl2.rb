# frozen_string_literal: true

module Rouge
  module Lexers
    class SPL2 < RegexLexer
      title 'Splunk SPL2'
      desc 'Splunk Search Processing Language v2 (SPL2), used by Splunk Cloud Platform'
      tag 'spl2'
      aliases 'splunk-spl2'
      filenames '*.spl2'
      mimetypes 'text/x-spl2'

      # Pipelines very often start with `| <command>` or use `from $source`
      # and feature distinctive `_time`, `index=`, or `sourcetype=` clauses.
      def self.detect?(text)
        return true if text.shebang?('spl2')

        head = text.lines.first(50).join

        return true if head =~ /\|\s*(?:search|from|stats|eval|where|fields|table|rex|spath)\b/i
        return true if head =~ /\bfrom\s+\$source\b/i
        return true if head =~ /\b(?:index|sourcetype|source|host)\s*=/
        return true if head =~ /\b_time\s*[=<>]/

        false
      end

      # SPL2 commands (verb-like operators that drive a pipeline). Sourced from
      # the SPL2 command quick reference.
      def self.commands
        @commands ||= Set.new %w(
          addinfo append appendcols appendpipe bin branch convert decrypt
          dedup eval eventstats expand fields fieldsummary fillnull flatten
          from head into iplocation join loadjob lookup makemv makeresults
          mstats mvcombine mvexpand nomv ocsf rename replace reverse rex route
          search select sort spath spl1 stats streamstats table tags thru
          timechart timewrap tstats typer union untable where
        )
      end

      # Clause/structural keywords used inside commands and statements.
      # Includes uppercase SQL-style clauses used in `from` syntax (FROM,
      # JOIN, SELECT, WHERE) — these are distinct from the lowercase
      # pipeline commands of the same name.
      def self.keywords
        @keywords ||= Set.new %w(
          AFTER APPLY AS ASC BEFORE BY DESC DISTINCT EXPORT FIT FROM FUNCTION
          GROUP GROUPBY HAVING IMPORT INNER JOIN LEFT LIMIT OFFSET ON ONCHANGE
          ORDER ORDERBY OUTER OUTPUT OUTPUTNEW RESET RETURN SELECT THROUGH TYPE
          WHERE WHILE
        )
      end

      # Operator-style word keywords. Treated as operators rather than
      # statement keywords because they participate in expressions.
      def self.word_operators
        @word_operators ||= Set.new %w(BETWEEN EXISTS IN IS LIKE)
      end

      # Boolean / logical operators. Splunk requires uppercase for these.
      def self.boolean_operators
        @boolean_operators ||= Set.new %w(AND OR NOT XOR)
      end

      # Boolean and null literals.
      def self.constants
        @constants ||= Set.new %w(true false null)
      end

      # Built-in data types (used in custom function signatures, type
      # statements, and constrained types).
      def self.data_types
        @data_types ||= Set.new %w(
          any array boolean dataset double float int log_span long mv
          number object regex relative_time string time time_span
        )
      end

      # Eval functions from the SPL2 eval functions quick reference.
      def self.eval_functions
        @eval_functions ||= Set.new %w(
          abs acos acosh all any asin asinh atan atan2 atanh batch_id
          batch_time case ceil ceiling cidrmatch cluster coalesce cos cosh
          exact exp filter floor getfields hypot if in instance_id ipmask
          isarray isbool isdouble isint ismv isnotnull isnull isnum isobject
          isstr json json_append json_array json_array_to_mv json_delete
          json_entries json_extend json_extract json_extract_exact
          json_has_key_exact json_keys json_object json_set json_set_exact
          json_valid len like ln log lower ltrim map match max md5 min
          mv_to_json_array mvappend mvcount mvdedup mvfilter mvfind mvindex
          mvjoin mvmap mvrange mvsort mvzip now null nullif object_to_array
          object_to_xml pi pow printf random reduce relative_time replace
          round rtrim searchmatch sha1 sha256 sha512 sigfig sin sinh spath
          split sqrt strftime strptime substr tan tanh time to_ocsf toarray
          tobool todouble toint tojson tomv tonumber toobject tostring trim
          typeof upper urldecode validate xml_to_object
        )
      end

      # Stats / charting / aggregate / event-order / dataset functions.
      def self.stats_functions
        @stats_functions ||= Set.new %w(
          avg c count dataset dc distinct_count earliest earliest_time estdc
          estdc_error exactperc first last latest latest_time list max mean
          median min mode per_day per_hour per_minute per_second perc pivot
          range rate repeat span sparkline stdev stdevp sum sumsq unpivot
          values var varp
        )
      end

      # Built-in / magic field names referenced in the SPL2 search reference.
      def self.magic_fields
        @magic_fields ||= Set.new %w(
          _time _raw _index _indextime _sourcetype _source _host _path
          _bkt _cd _kv _meta _serial _si _subsecond
        )
      end

      id = /[A-Za-z_][A-Za-z0-9_]*/

      # Time math literal as documented in "Specifying relative time". Time
      # units accept short or long abbreviations; snap-to (@) supports day-of-
      # week anchors w0–w7 in addition to the standard units.
      time_unit = /
        s|sec|secs|second|seconds
        |m|min|mins|minute|minutes
        |h|hr|hrs|hour|hours
        |d|day|days
        |w[0-7]?|week|weeks
        |mon|month|months
        |q|qtr|qtrs|quarter|quarters
        |y|yr|yrs|year|years
        |us|ms|cs|ds|M
      /x

      # The bare-unit branch (`[+-](?:time_unit)`) requires a sign so that
      # plain identifiers starting with a unit letter (stats, main, host,
      # users, ...) are not consumed by the time_modifier rule. The trailing
      # `(?!\w)` lookahead guarantees the matched literal ends at a word
      # boundary, blocking partial-prefix matches like `-us` from `-users`.
      time_modifier = /
        (?:
          (?:[+-]?\d+(?:#{time_unit.source})|[+-](?:#{time_unit.source}))
          (?:@(?:#{time_unit.source})(?:[+-]\d+(?:#{time_unit.source}))?)?
          |
          @(?:#{time_unit.source})(?:[+-]\d+(?:#{time_unit.source}))?
        )
        (?!\w)
      /x

      state :root do
        rule %r/\s+/m, Text

        # Comments. Block comments support nesting per common SPL2 style.
        rule %r(//.*?$), Comment::Single
        rule %r(/\*), Comment::Multiline, :block_comment

        # Raw string literal: @"..."
        rule %r/@"/, Str::Double, :raw_double_string

        # Pipeline-scope and statement variables: $source, $search1, etc.
        rule %r/\$#{id}/, Name::Variable

        # Pipeline annotations / decorators: @maxdelay("10m"), @maxdisk("1GB")
        rule %r/@#{id}(?=\s*\()/, Name::Decorator

        # Time math literal (must be tried before plain numbers and operators).
        rule time_modifier, Num::Other

        # Numeric literals with type suffixes per the built-in data types page.
        rule %r/\d+\.\d+(?:[eE][+-]?\d+)?[FfDd]?/, Num::Float
        rule %r/\d+[eE][+-]?\d+[FfDd]?/, Num::Float
        rule %r/\d+[FfDd]/, Num::Float
        rule %r/\d+[Ll]/, Num::Integer
        rule %r/\d+/, Num::Integer

        # Strings
        rule %r/"/, Str::Double, :double_string
        rule %r/'/, Str::Single, :single_string
        # Backtick search literals contain free-form search terms.
        rule %r/`/, Str::Backtick, :search_literal

        # Lambda arrow must precede the bare `-` operator.
        rule %r/->/, Operator

        # Comparison and arithmetic operators (multi-char first).
        rule %r/(?:==|!=|<>|<=|>=)/, Operator
        rule %r/[+\-*\/%=<>]/, Operator

        # Punctuation. The pipe separates commands.
        rule %r/\|/, Punctuation
        rule %r/[(),;\[\]{}.:]/, Punctuation

        # Magic fields like _time, _raw — these begin with underscore.
        rule %r/_[A-Za-z0-9_]+/ do |m|
          if self.class.magic_fields.include?(m[0])
            token Name::Variable::Magic
          else
            token Name
          end
        end

        # Identifiers. Order: constants → functions → commands → boolean ops
        # → word operators → data types → keywords → plain Name.
        rule %r/#{id}/o do |m|
          word = m[0]
          upper = word.upcase

          if self.class.constants.include?(word)
            token Keyword::Constant
          elsif self.class.eval_functions.include?(word) || self.class.stats_functions.include?(word)
            token Name::Builtin
          elsif self.class.commands.include?(word)
            token Keyword::Reserved
          elsif self.class.boolean_operators.include?(upper)
            token Keyword::Pseudo
          elsif self.class.word_operators.include?(upper)
            token Operator::Word
          elsif self.class.data_types.include?(word)
            token Keyword::Type
          elsif self.class.keywords.include?(upper)
            token Keyword
          else
            token Name
          end
        end
      end

      state :block_comment do
        rule %r(/\*), Comment::Multiline, :block_comment
        rule %r(\*/), Comment::Multiline, :pop!
        rule %r([^*/]+), Comment::Multiline
        rule %r([*/]), Comment::Multiline
      end

      state :double_string do
        # String template interpolation: ${expression}
        rule %r/\$\{/, Str::Interpol, :string_interpolation
        rule %r/\\./, Str::Escape
        rule %r/""/, Str::Escape
        rule %r/"/, Str::Double, :pop!
        rule %r/[^\\"$]+/, Str::Double
        rule %r/\$/, Str::Double
      end

      state :raw_double_string do
        rule %r/""/, Str::Escape
        rule %r/"/, Str::Double, :pop!
        rule %r/[^"]+/, Str::Double
      end

      state :single_string do
        # Field templates appear inside single-quoted field-name literals as
        # `'${expression}'`. The wrapping single quotes remain Str::Single;
        # the inner ${...} is interpolation.
        rule %r/\$\{/, Str::Interpol, :string_interpolation
        rule %r/\\./, Str::Escape
        rule %r/''/, Str::Escape
        rule %r/'/, Str::Single, :pop!
        rule %r/[^\\'$]+/, Str::Single
        rule %r/\$/, Str::Single
      end

      state :string_interpolation do
        rule %r/\}/, Str::Interpol, :pop!
        # Strings inside an interpolation expression
        rule %r/"/, Str::Double, :double_string
        rule %r/'/, Str::Single, :single_string
        rule %r/\s+/, Text
        rule %r/\d+\.\d+/, Num::Float
        rule %r/\d+/, Num::Integer
        rule %r/(?:==|!=|<>|<=|>=|->)/, Operator
        rule %r/[+\-*\/%=<>]/, Operator
        rule %r/[(),\[\].]/, Punctuation
        rule %r/#{id}/o do |m|
          word = m[0]
          if self.class.eval_functions.include?(word) || self.class.stats_functions.include?(word)
            token Name::Builtin
          elsif self.class.constants.include?(word)
            token Keyword::Constant
          else
            token Name
          end
        end
      end

      state :search_literal do
        rule %r/``/, Str::Escape
        rule %r/`/, Str::Backtick, :pop!
        rule %r/[^`]+/, Str::Backtick
      end
    end
  end
end
