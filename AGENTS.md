# AGENTS.md

This file provides guidance to AI agents when working with code in this repository.

## Commands

```sh
bundle config set --local path vendor/bundle && bundle install  # Install dependencies
bundle exec rake        # Run the test suite (default task)
bundle exec rake server # Start visual preview server at http://localhost:9292
ruby preview.rb         # Terminal preview using Github theme
DEBUG=1 ruby preview.rb # Print each token and its type
```

To check for error tokens via the preview server:

```sh
curl -s http://localhost:9292 | grep 'class="err"'
```

## Architecture

This is a Rouge lexer plugin gem for Splunk SPL2, the unified search and data
preparation language used by Splunk Cloud Platform. Rouge is the default syntax
highlighter used by Jekyll/GitHub Pages.

**Key files:**

- [lib/rouge/lexers/spl2.rb](lib/rouge/lexers/spl2.rb) — The lexer implementation (`Rouge::Lexers::SPL2 < RegexLexer`)
- [lib/rouge/lexer/spl2.rb](lib/rouge/lexer/spl2.rb) — Entry point that `require`s the lexer; this is what consumers load
- [spec/rouge_lexer_spl2_spec.rb](spec/rouge_lexer_spl2_spec.rb) — Minitest test suite
- [spec/demos/spl2](spec/demos/spl2) — Short demo snippet used in tests and Rouge's demo pages
- [spec/visual/samples/spl2](spec/visual/samples/spl2) — Comprehensive sample used for visual testing and error-token checks

**Lexer structure:** The lexer uses class-level `Set` caches for keyword
classification. The `:root` state matches tokens in priority order; a catch-all
`\w+` rule does set-membership lookups to assign the correct token type. Sub-states
handle comments, strings, and any other paired constructs.

## Splunk SPL2 references

Use *ONLY* official documentation, *NOT* from memory, training, or inference.

### Documentation

**MANDATORY: Before writing or modifying the lexer, you MUST fetch and read every
URL in this list.** This is not background reading — it is a required prerequisite
step. Fetch each page, extract the keywords or function names, and verify them
against the lexer before declaring any work complete.

https://help.splunk.com/en/splunk-cloud-platform/search/spl2-overview/what-is-spl2
https://help.splunk.com/en/splunk-cloud-platform/search/spl2-overview/why-use-spl2
https://help.splunk.com/en/splunk-cloud-platform/search/spl2-overview/what-is-new-and-different-in-spl2-
https://help.splunk.com/en/splunk-cloud-platform/search/spl2-overview/specific-differences-between-spl-and-spl2
https://help.splunk.com/en/splunk-cloud-platform/search/spl2-overview/using-spl-commands-in-spl2-searches
https://help.splunk.com/?resourceId=SCS_Search_expressions_quick_reference
https://help.splunk.com/?resourceId=SCS_SearchReference_SPL2CommandQuickReference
https://help.splunk.com/?resourceId=SCS_SearchReference_EvalFunctionsQuickReference
https://help.splunk.com/?resourceId=SCS_SearchReference_StatsFunctionsQuickReference
https://help.splunk.com/?resourceId=SCS_SearchReference_UnderstandingSPLSyntax
https://help.splunk.com/en/splunk-cloud-platform/search
https://help.splunk.com/en/splunk-cloud-platform/search/spl2-search-reference
https://help.splunk.com/en/splunk-cloud-platform/search/spl2-search-reference/introduction
https://help.splunk.com/en/splunk-cloud-platform/search/spl2-search-reference/introduction/introduction
https://help.splunk.com/en/splunk-cloud-platform/search/spl2-search-reference/introduction/understanding-spl2-syntax
https://help.splunk.com/en/splunk-cloud-platform/search/spl2-search-reference/spl2-compatibility-profiles-and-quick-references
https://help.splunk.com/en/splunk-cloud-platform/search/spl2-search-reference/spl2-compatibility-profiles-and-quick-references/spl2-compatibility-profiles
https://help.splunk.com/en/splunk-cloud-platform/search/spl2-search-reference/spl2-compatibility-profiles-and-quick-references/compatibility-quick-reference-for-spl2-commands
https://help.splunk.com/en/splunk-cloud-platform/search/spl2-search-reference/spl2-compatibility-profiles-and-quick-references/compatibility-quick-reference-for-spl2-evaluation-functions
https://help.splunk.com/en/splunk-cloud-platform/search/spl2-search-reference/evaluation-functions
https://help.splunk.com/en/splunk-cloud-platform/search/spl2-search-reference/evaluation-functions/overview-of-spl2-eval-functions
https://help.splunk.com/en/splunk-cloud-platform/search/spl2-search-reference/evaluation-functions/quick-reference-for-spl2-eval-functions
https://help.splunk.com/en/splunk-cloud-platform/search/spl2-search-reference/evaluation-functions/comparison-and-conditional-functions
https://help.splunk.com/en/splunk-cloud-platform/search/spl2-search-reference/evaluation-functions/conversion-functions
https://help.splunk.com/en/splunk-cloud-platform/search/spl2-search-reference/evaluation-functions/cryptographic-functions
https://help.splunk.com/en/splunk-cloud-platform/search/spl2-search-reference/evaluation-functions/date-and-time-functions
https://help.splunk.com/en/splunk-cloud-platform/search/spl2-search-reference/evaluation-functions/informational-functions
https://help.splunk.com/en/splunk-cloud-platform/search/spl2-search-reference/evaluation-functions/json-functions
https://help.splunk.com/en/splunk-cloud-platform/search/spl2-search-reference/evaluation-functions/mathematical-functions
https://help.splunk.com/en/splunk-cloud-platform/search/spl2-search-reference/evaluation-functions/multivalue-eval-functions
https://help.splunk.com/en/splunk-cloud-platform/search/spl2-search-reference/evaluation-functions/statistical-eval-functions
https://help.splunk.com/en/splunk-cloud-platform/search/spl2-search-reference/evaluation-functions/text-functions
https://help.splunk.com/en/splunk-cloud-platform/search/spl2-search-reference/evaluation-functions/trig-and-hyperbolic-functions
https://help.splunk.com/en/splunk-cloud-platform/search/spl2-search-reference/statistical-and-charting-functions
https://help.splunk.com/en/splunk-cloud-platform/search/spl2-search-reference/statistical-and-charting-functions/overview-of-spl2-stats-and-chart-functions
https://help.splunk.com/en/splunk-cloud-platform/search/spl2-search-reference/statistical-and-charting-functions/quick-reference-for-spl2-stats-and-charting-functions
https://help.splunk.com/en/splunk-cloud-platform/search/spl2-search-reference/statistical-and-charting-functions/aggregate-functions
https://help.splunk.com/en/splunk-cloud-platform/search/spl2-search-reference/statistical-and-charting-functions/event-order-functions
https://help.splunk.com/en/splunk-cloud-platform/search/spl2-search-reference/statistical-and-charting-functions/multivalue-and-array-functions
https://help.splunk.com/en/splunk-cloud-platform/search/spl2-search-reference/statistical-and-charting-functions/time-functions
https://help.splunk.com/en/splunk-cloud-platform/search/spl2-search-reference/dataset-functions
https://help.splunk.com/en/splunk-cloud-platform/search/spl2-search-reference/dataset-functions/overview-of-spl2-dataset-functions
https://help.splunk.com/en/splunk-cloud-platform/search/spl2-search-reference/dataset-functions/repeat-dataset-function
https://help.splunk.com/en/splunk-cloud-platform/search/spl2-search-reference/quick-reference-for-spl2-commands
https://help.splunk.com/en/splunk-cloud-platform/search/spl2-search-reference/quick-reference-for-spl2-commands/quick-reference-for-spl2-commands
https://help.splunk.com/en/splunk-cloud-platform/search/spl2-search-reference/addinfo-command
https://help.splunk.com/en/splunk-cloud-platform/search/spl2-search-reference/addinfo-command/addinfo-command-overview-syntax-and-usage
https://help.splunk.com/en/splunk-cloud-platform/search/spl2-search-reference/addinfo-command/addinfo-command-examples
https://help.splunk.com/en/splunk-cloud-platform/search/spl2-search-reference/append-command
https://help.splunk.com/en/splunk-cloud-platform/search/spl2-search-reference/append-command/append-command-overview-syntax-and-usage
https://help.splunk.com/en/splunk-cloud-platform/search/spl2-search-reference/append-command/append-command-examples
https://help.splunk.com/en/splunk-cloud-platform/search/spl2-search-reference/appendcols-command
https://help.splunk.com/en/splunk-cloud-platform/search/spl2-search-reference/appendcols-command/appendcols-command-overview-syntax-and-usage
https://help.splunk.com/en/splunk-cloud-platform/search/spl2-search-reference/appendcols-command/appendcols-command-examples
https://help.splunk.com/en/splunk-cloud-platform/search/spl2-search-reference/appendpipe-command
https://help.splunk.com/en/splunk-cloud-platform/search/spl2-search-reference/appendpipe-command/appendpipe-command-overview-syntax-and-usage
https://help.splunk.com/en/splunk-cloud-platform/search/spl2-search-reference/appendpipe-command/appendpipe-command-examples
https://help.splunk.com/en/splunk-cloud-platform/search/spl2-search-reference/bin-command
https://help.splunk.com/en/splunk-cloud-platform/search/spl2-search-reference/bin-command/bin-command-overview-syntax-and-usage
https://help.splunk.com/en/splunk-cloud-platform/search/spl2-search-reference/bin-command/bin-command-examples
https://help.splunk.com/en/splunk-cloud-platform/search/spl2-search-reference/branch-command
https://help.splunk.com/en/splunk-cloud-platform/search/spl2-search-reference/branch-command/branch-command-overview-syntax-and-usage
https://help.splunk.com/en/splunk-cloud-platform/search/spl2-search-reference/branch-command/branch-command-examples
https://help.splunk.com/en/splunk-cloud-platform/search/spl2-search-reference/convert-command
https://help.splunk.com/en/splunk-cloud-platform/search/spl2-search-reference/convert-command/convert-command-overview-syntax-and-usage
https://help.splunk.com/en/splunk-cloud-platform/search/spl2-search-reference/convert-command/convert-command-examples
https://help.splunk.com/en/splunk-cloud-platform/search/spl2-search-reference/decrypt-command
https://help.splunk.com/en/splunk-cloud-platform/search/spl2-search-reference/decrypt-command/decrypt-command-overview
https://help.splunk.com/en/splunk-cloud-platform/search/spl2-search-reference/dedup-command
https://help.splunk.com/en/splunk-cloud-platform/search/spl2-search-reference/dedup-command/dedup-command-overview-syntax-and-usage
https://help.splunk.com/en/splunk-cloud-platform/search/spl2-search-reference/dedup-command/dedup-command-examples
https://help.splunk.com/en/splunk-cloud-platform/search/spl2-search-reference/eval-command
https://help.splunk.com/en/splunk-cloud-platform/search/spl2-search-reference/eval-command/eval-command-overview-and-syntax
https://help.splunk.com/en/splunk-cloud-platform/search/spl2-search-reference/eval-command/eval-command-usage
https://help.splunk.com/en/splunk-cloud-platform/search/spl2-search-reference/eval-command/eval-command-examples
https://help.splunk.com/en/splunk-cloud-platform/search/spl2-search-reference/eventstats-command
https://help.splunk.com/en/splunk-cloud-platform/search/spl2-search-reference/eventstats-command/eventstats-command-overview-syntax-and-usage
https://help.splunk.com/en/splunk-cloud-platform/search/spl2-search-reference/eventstats-command/eventstats-command-examples
https://help.splunk.com/en/splunk-cloud-platform/search/spl2-search-reference/expand-command
https://help.splunk.com/en/splunk-cloud-platform/search/spl2-search-reference/expand-command/expand-command-overview-syntax-and-usage
https://help.splunk.com/en/splunk-cloud-platform/search/spl2-search-reference/expand-command/expand-command-examples
https://help.splunk.com/en/splunk-cloud-platform/search/spl2-search-reference/fields-command
https://help.splunk.com/en/splunk-cloud-platform/search/spl2-search-reference/fields-command/fields-command-overview-syntax-and-usage
https://help.splunk.com/en/splunk-cloud-platform/search/spl2-search-reference/fields-command/fields-command-examples
https://help.splunk.com/en/splunk-cloud-platform/search/spl2-search-reference/fieldsummary-command
https://help.splunk.com/en/splunk-cloud-platform/search/spl2-search-reference/fieldsummary-command/fieldsummary-command-overview-syntax-and-usage
https://help.splunk.com/en/splunk-cloud-platform/search/spl2-search-reference/fieldsummary-command/fieldsummary-command-examples
https://help.splunk.com/en/splunk-cloud-platform/search/spl2-search-reference/fillnull-command
https://help.splunk.com/en/splunk-cloud-platform/search/spl2-search-reference/fillnull-command/fillnull-command-overview-syntax-and-usage
https://help.splunk.com/en/splunk-cloud-platform/search/spl2-search-reference/fillnull-command/fillnull-command-examples
https://help.splunk.com/en/splunk-cloud-platform/search/spl2-search-reference/flatten-command
https://help.splunk.com/en/splunk-cloud-platform/search/spl2-search-reference/flatten-command/flatten-command-overview-syntax-and-usage
https://help.splunk.com/en/splunk-cloud-platform/search/spl2-search-reference/flatten-command/flatten-command-examples
https://help.splunk.com/en/splunk-cloud-platform/search/spl2-search-reference/from-command
https://help.splunk.com/en/splunk-cloud-platform/search/spl2-search-reference/from-command/from-command-overview
https://help.splunk.com/en/splunk-cloud-platform/search/spl2-search-reference/from-command/from-command-syntax
https://help.splunk.com/en/splunk-cloud-platform/search/spl2-search-reference/from-command/from-command-usage
https://help.splunk.com/en/splunk-cloud-platform/search/spl2-search-reference/from-command/from-command-examples
https://help.splunk.com/en/splunk-cloud-platform/search/spl2-search-reference/head-command
https://help.splunk.com/en/splunk-cloud-platform/search/spl2-search-reference/head-command/head-command-overview-syntax-and-usage
https://help.splunk.com/en/splunk-cloud-platform/search/spl2-search-reference/head-command/head-command-examples
https://help.splunk.com/en/splunk-cloud-platform/search/spl2-search-reference/into-command
https://help.splunk.com/en/splunk-cloud-platform/search/spl2-search-reference/into-command/into-command-overview-syntax-and-usage
https://help.splunk.com/en/splunk-cloud-platform/search/spl2-search-reference/into-command/into-command-examples
https://help.splunk.com/en/splunk-cloud-platform/search/spl2-search-reference/iplocation-command
https://help.splunk.com/en/splunk-cloud-platform/search/spl2-search-reference/iplocation-command/iplocation-command-overview-syntax-and-usage
https://help.splunk.com/en/splunk-cloud-platform/search/spl2-search-reference/iplocation-command/iplocation-command-examples
https://help.splunk.com/en/splunk-cloud-platform/search/spl2-search-reference/join-command
https://help.splunk.com/en/splunk-cloud-platform/search/spl2-search-reference/join-command/join-command-overview-syntax-and-usage
https://help.splunk.com/en/splunk-cloud-platform/search/spl2-search-reference/join-command/join-command-examples
https://help.splunk.com/en/splunk-cloud-platform/search/spl2-search-reference/loadjob-command
https://help.splunk.com/en/splunk-cloud-platform/search/spl2-search-reference/loadjob-command/loadjob-command-overview-syntax-and-usage
https://help.splunk.com/en/splunk-cloud-platform/search/spl2-search-reference/loadjob-command/loadjob-command-examples
https://help.splunk.com/en/splunk-cloud-platform/search/spl2-search-reference/lookup-command
https://help.splunk.com/en/splunk-cloud-platform/search/spl2-search-reference/lookup-command/lookup-command-overview-syntax-and-usage
https://help.splunk.com/en/splunk-cloud-platform/search/spl2-search-reference/lookup-command/lookup-command-examples
https://help.splunk.com/en/splunk-cloud-platform/search/spl2-search-reference/makemv-command
https://help.splunk.com/en/splunk-cloud-platform/search/spl2-search-reference/makemv-command/makemv-command-overview-syntax-and-usage
https://help.splunk.com/en/splunk-cloud-platform/search/spl2-search-reference/makemv-command/makemv-command-examples
https://help.splunk.com/en/splunk-cloud-platform/search/spl2-search-reference/makeresults-command
https://help.splunk.com/en/splunk-cloud-platform/search/spl2-search-reference/makeresults-command/makeresults-command-overview-syntax-and-usage
https://help.splunk.com/en/splunk-cloud-platform/search/spl2-search-reference/makeresults-command/makeresults-command-examples
https://help.splunk.com/en/splunk-cloud-platform/search/spl2-search-reference/mstats-command
https://help.splunk.com/en/splunk-cloud-platform/search/spl2-search-reference/mstats-command/mstats-command-overview-syntax-and-usage
https://help.splunk.com/en/splunk-cloud-platform/search/spl2-search-reference/mstats-command/mstats-command-examples
https://help.splunk.com/en/splunk-cloud-platform/search/spl2-search-reference/mvcombine-command
https://help.splunk.com/en/splunk-cloud-platform/search/spl2-search-reference/mvcombine-command/mvcombine-command-overview-syntax-and-usage
https://help.splunk.com/en/splunk-cloud-platform/search/spl2-search-reference/mvcombine-command/mvcombine-command-examples
https://help.splunk.com/en/splunk-cloud-platform/search/spl2-search-reference/mvexpand-command
https://help.splunk.com/en/splunk-cloud-platform/search/spl2-search-reference/mvexpand-command/mvexpand-command-overview-syntax-and-usage
https://help.splunk.com/en/splunk-cloud-platform/search/spl2-search-reference/mvexpand-command/mvexpand-command-examples
https://help.splunk.com/en/splunk-cloud-platform/search/spl2-search-reference/nomv-command
https://help.splunk.com/en/splunk-cloud-platform/search/spl2-search-reference/nomv-command/nomv-command-overview-syntax-and-usage
https://help.splunk.com/en/splunk-cloud-platform/search/spl2-search-reference/nomv-command/nomv-command-examples
https://help.splunk.com/en/splunk-cloud-platform/search/spl2-search-reference/ocsf-command
https://help.splunk.com/en/splunk-cloud-platform/search/spl2-search-reference/ocsf-command/ocsf-command-overview
https://help.splunk.com/en/splunk-cloud-platform/search/spl2-search-reference/rename-command
https://help.splunk.com/en/splunk-cloud-platform/search/spl2-search-reference/rename-command/rename-command-overview-syntax-and-usage
https://help.splunk.com/en/splunk-cloud-platform/search/spl2-search-reference/rename-command/rename-command-examples
https://help.splunk.com/en/splunk-cloud-platform/search/spl2-search-reference/replace-command
https://help.splunk.com/en/splunk-cloud-platform/search/spl2-search-reference/replace-command/replace-command-overview-syntax-and-usage
https://help.splunk.com/en/splunk-cloud-platform/search/spl2-search-reference/replace-command/replace-command-examples
https://help.splunk.com/en/splunk-cloud-platform/search/spl2-search-reference/reverse-command
https://help.splunk.com/en/splunk-cloud-platform/search/spl2-search-reference/reverse-command/reverse-command-overview-syntax-and-usage
https://help.splunk.com/en/splunk-cloud-platform/search/spl2-search-reference/reverse-command/reverse-command-examples
https://help.splunk.com/en/splunk-cloud-platform/search/spl2-search-reference/rex-command
https://help.splunk.com/en/splunk-cloud-platform/search/spl2-search-reference/rex-command/rex-command-overview-syntax-and-usage
https://help.splunk.com/en/splunk-cloud-platform/search/spl2-search-reference/rex-command/rex-command-examples
https://help.splunk.com/en/splunk-cloud-platform/search/spl2-search-reference/route-command
https://help.splunk.com/en/splunk-cloud-platform/search/spl2-search-reference/route-command/route-command-overview
https://help.splunk.com/en/splunk-cloud-platform/search/spl2-search-reference/search-command
https://help.splunk.com/en/splunk-cloud-platform/search/spl2-search-reference/search-command/search-command-overview-and-syntax
https://help.splunk.com/en/splunk-cloud-platform/search/spl2-search-reference/search-command/search-command-usage
https://help.splunk.com/en/splunk-cloud-platform/search/spl2-search-reference/search-command/search-command-examples
https://help.splunk.com/en/splunk-cloud-platform/search/spl2-search-reference/sort-command
https://help.splunk.com/en/splunk-cloud-platform/search/spl2-search-reference/sort-command/sort-command-overview-syntax-and-usage
https://help.splunk.com/en/splunk-cloud-platform/search/spl2-search-reference/sort-command/sort-command-examples
https://help.splunk.com/en/splunk-cloud-platform/search/spl2-search-reference/spath-command
https://help.splunk.com/en/splunk-cloud-platform/search/spl2-search-reference/spath-command/spath-command-overview-syntax-and-usage
https://help.splunk.com/en/splunk-cloud-platform/search/spl2-search-reference/spath-command/spath-command-examples
https://help.splunk.com/en/splunk-cloud-platform/search/spl2-search-reference/spl1-command
https://help.splunk.com/en/splunk-cloud-platform/search/spl2-search-reference/spl1-command/spl1-command-overview-syntax-and-usage
https://help.splunk.com/en/splunk-cloud-platform/search/spl2-search-reference/spl1-command/spl1-command-examples
https://help.splunk.com/en/splunk-cloud-platform/search/spl2-search-reference/stats-command
https://help.splunk.com/en/splunk-cloud-platform/search/spl2-search-reference/stats-command/stats-command-overview-syntax-and-usage
https://help.splunk.com/en/splunk-cloud-platform/search/spl2-search-reference/stats-command/stats-command-examples
https://help.splunk.com/en/splunk-cloud-platform/search/spl2-search-reference/streamstats-command
https://help.splunk.com/en/splunk-cloud-platform/search/spl2-search-reference/streamstats-command/streamstats-command-overview-syntax-and-usage
https://help.splunk.com/en/splunk-cloud-platform/search/spl2-search-reference/streamstats-command/streamstats-command-examples
https://help.splunk.com/en/splunk-cloud-platform/search/spl2-search-reference/table-command
https://help.splunk.com/en/splunk-cloud-platform/search/spl2-search-reference/table-command/table-command-overview-syntax-and-usage
https://help.splunk.com/en/splunk-cloud-platform/search/spl2-search-reference/table-command/table-command-examples
https://help.splunk.com/en/splunk-cloud-platform/search/spl2-search-reference/tags-command
https://help.splunk.com/en/splunk-cloud-platform/search/spl2-search-reference/tags-command/tags-command-overview-syntax-and-usage
https://help.splunk.com/en/splunk-cloud-platform/search/spl2-search-reference/tags-command/tags-command-examples
https://help.splunk.com/en/splunk-cloud-platform/search/spl2-search-reference/thru-command
https://help.splunk.com/en/splunk-cloud-platform/search/spl2-search-reference/thru-command/thru-command-overview-syntax-and-usage
https://help.splunk.com/en/splunk-cloud-platform/search/spl2-search-reference/thru-command/thru-command-examples
https://help.splunk.com/en/splunk-cloud-platform/search/spl2-search-reference/timechart-command
https://help.splunk.com/en/splunk-cloud-platform/search/spl2-search-reference/timechart-command/timechart-command-overview-and-syntax
https://help.splunk.com/en/splunk-cloud-platform/search/spl2-search-reference/timechart-command/timechart-command-usage
https://help.splunk.com/en/splunk-cloud-platform/search/spl2-search-reference/timechart-command/timechart-command-examples
https://help.splunk.com/en/splunk-cloud-platform/search/spl2-search-reference/timewrap-command
https://help.splunk.com/en/splunk-cloud-platform/search/spl2-search-reference/timewrap-command/timewrap-command-overview-syntax-and-usage
https://help.splunk.com/en/splunk-cloud-platform/search/spl2-search-reference/timewrap-command/timewrap-command-examples
https://help.splunk.com/en/splunk-cloud-platform/search/spl2-search-reference/tstats-command
https://help.splunk.com/en/splunk-cloud-platform/search/spl2-search-reference/tstats-command/tstats-command-overview-syntax-usage
https://help.splunk.com/en/splunk-cloud-platform/search/spl2-search-reference/tstats-command/tstats-command-examples
https://help.splunk.com/en/splunk-cloud-platform/search/spl2-search-reference/typer-command
https://help.splunk.com/en/splunk-cloud-platform/search/spl2-search-reference/typer-command/typer-command-examples
https://help.splunk.com/en/splunk-cloud-platform/search/spl2-search-reference/typer-command/typer-command-overview-syntax-and-usage
https://help.splunk.com/en/splunk-cloud-platform/search/spl2-search-reference/union-command
https://help.splunk.com/en/splunk-cloud-platform/search/spl2-search-reference/union-command/union-command-overview-syntax-and-usage
https://help.splunk.com/en/splunk-cloud-platform/search/spl2-search-reference/union-command/union-command-examples
https://help.splunk.com/en/splunk-cloud-platform/search/spl2-search-reference/untable-command
https://help.splunk.com/en/splunk-cloud-platform/search/spl2-search-reference/untable-command/untable-command-overview-syntax-and-usage
https://help.splunk.com/en/splunk-cloud-platform/search/spl2-search-reference/untable-command/untable-command-examples
https://help.splunk.com/en/splunk-cloud-platform/search/spl2-search-reference/where-command
https://help.splunk.com/en/splunk-cloud-platform/search/spl2-search-reference/where-command/where-command-overview-syntax-and-usage
https://help.splunk.com/en/splunk-cloud-platform/search/spl2-search-reference/where-command/where-command-examples

### SPL2 Search Manual (docs.splunk.com)

These pages cover SPL2 syntax features that are not in the search-reference
quick references — comments, expressions, literals, lambdas, templates,
modules and statements, time math, escaping, and built-in data types.

https://docs.splunk.com/Documentation/SCS/latest/Search/Comments
https://docs.splunk.com/Documentation/SCS/current/Search/Introduction
https://docs.splunk.com/Documentation/SCS/current/Search/StartSearchingSPL2
https://docs.splunk.com/Documentation/SCS/current/Search/Whatsadataset
https://docs.splunk.com/Documentation/SCS/current/Search/Searchingdatasets
https://docs.splunk.com/Documentation/SCS/current/Search/Specifyingtimeranges
https://docs.splunk.com/Documentation/SCS/current/Search/Combiningcommands
https://docs.splunk.com/Documentation/SCS/current/Search/Groupingsearchresults
https://docs.splunk.com/Documentation/SCS/current/Search/Filteringaggregateddata
https://docs.splunk.com/Documentation/SCS/current/Search/MoreSPL2searching
https://docs.splunk.com/Documentation/SCS/current/Search/ModulesandSPL2statements
https://docs.splunk.com/Documentation/SCS/current/Search/Views
https://docs.splunk.com/Documentation/SCS/current/Search/Extendandbranchsearchstatements
https://docs.splunk.com/Documentation/SCS/current/Search/Exportingmoduleitems
https://docs.splunk.com/Documentation/SCS/current/Search/Importingitems
https://docs.splunk.com/Documentation/SCS/current/Search/Namingconflictsonimport
https://docs.splunk.com/Documentation/SCS/current/Search/Specifyingimportpaths
https://docs.splunk.com/Documentation/SCS/current/Search/Scopeandprecedenceimportingitems
https://docs.splunk.com/Documentation/SCS/current/Search/UnderstandingSPL2namespaces
https://docs.splunk.com/Documentation/SCS/current/Search/Datasets
https://docs.splunk.com/Documentation/SCS/current/Search/Datasetliterals
https://docs.splunk.com/Documentation/SCS/current/Search/Datasetfunctions
https://docs.splunk.com/Documentation/SCS/current/Search/Expressions
https://docs.splunk.com/Documentation/SCS/current/Search/Predicates
https://docs.splunk.com/Documentation/SCS/current/Search/Searchliterals
https://docs.splunk.com/Documentation/SCS/current/Search/Arrayandobjectliterals
https://docs.splunk.com/Documentation/SCS/current/Search/Arrayandobjectexpressions
https://docs.splunk.com/Documentation/SCS/current/Search/Stringtemplates
https://docs.splunk.com/Documentation/SCS/current/Search/Fieldtemplates
https://docs.splunk.com/Documentation/SCS/current/Search/Lambdaexpressions
https://docs.splunk.com/Documentation/SCS/current/Search/AboutSplunkregularexpressions
https://docs.splunk.com/Documentation/SCS/current/Search/SPL2andregularexpressions
https://docs.splunk.com/Documentation/SCS/current/Search/Built-inandcustomfunctions
https://docs.splunk.com/Documentation/SCS/current/Search/Namingarguments
https://docs.splunk.com/Documentation/SCS/current/Search/Customevalfunctions
https://docs.splunk.com/Documentation/SCS/current/Search/Customcommandfunctions
https://docs.splunk.com/Documentation/SCS/current/Search/Documentingcustomfunctions
https://docs.splunk.com/Documentation/SCS/current/Search/Built-indatatypes
https://docs.splunk.com/Documentation/SCS/current/Search/Customdatatypes
https://docs.splunk.com/Documentation/SCS/current/Search/Timestampsandtimeranges
https://docs.splunk.com/Documentation/SCS/current/Search/Timemodifiers
https://docs.splunk.com/Documentation/SCS/current/Search/Specifyrelativetime
https://docs.splunk.com/Documentation/SCS/current/Search/Specifytimespans
https://docs.splunk.com/Documentation/SCS/current/Search/Timevariables
https://docs.splunk.com/Documentation/SCS/current/Search/Timezones
https://docs.splunk.com/Documentation/SCS/current/Search/Lexicographicalorder
https://docs.splunk.com/Documentation/SCS/current/Search/Wildcards
https://docs.splunk.com/Documentation/SCS/current/Search/Quotations
https://docs.splunk.com/Documentation/SCS/current/Search/Escapecharacters
https://docs.splunk.com/Documentation/SCS/current/Search/Eventsegmentationandsearching

## Rouge references

- Lexer development guide: <https://github.com/rouge-ruby/rouge/blob/main/docs/LexerDevelopment.md>
- Existing lexers for reference: <https://github.com/rouge-ruby/rouge/tree/main/lib/rouge/lexers>
- JSON lexer (simple example): <https://github.com/rouge-ruby/rouge/blob/main/lib/rouge/lexers/json.rb>
- SQL lexer (keyword-heavy analog): <https://github.com/rouge-ruby/rouge/blob/main/lib/rouge/lexers/sql.rb>
- Token types: <https://github.com/rouge-ruby/rouge/blob/main/lib/rouge/token.rb>

## Verification workflow (MANDATORY — do this BEFORE adding anything)

Before writing or modifying the lexer, fetch **every URL in the documentation
list** above. Do not begin implementation until all pages have been read.

Before adding ANY individual keyword, function, or syntax element:

1. **Fetch the relevant documentation page** using the WebFetch tool or curl.
2. **Extract and confirm** the element exists in the fetched content. Do not rely
   on training data, memory, or assumptions about what "should" exist.
3. **Only add** elements that appear in the fetched content. **Only remove**
   elements confirmed absent.

### What NOT to do

- **Do NOT add keywords or syntax from training data or memory.** Every addition
  must be traced to a specific URL from the reference list in this file.
- **Do NOT use preview/beta features** unless explicitly asked. Only add GA
  (generally available) features.
- **Do NOT fabricate or modify reference URLs.** Use ONLY the exact URLs listed
  in this file. If a URL doesn't work, say so — do not guess an alternative.
- **Do NOT assume a function exists because a similar one does.**

### Self-verification

After making changes, verify correctness by **re-fetching the source documentation**
and confirming every added element appears in the fetched HTML. Do not verify by
re-reading your own changes.

### Constraints (applies to all work)

- **No hallucinated syntax.** Every keyword, function, operator, and language
  construct in the lexer must come from the official documentation listed above.
- **Follow Rouge conventions exactly.** Study existing lexers (especially JSON and
  SQL) for patterns. Don't invent novel approaches.
- **The Error token count is the ground truth.** The visual preview server is the
  authoritative test. `bundle exec rake` passing is necessary but not sufficient —
  you must also have zero `class="err"` spans.
- **Iterate until clean.** Do not declare the task complete until both
  `bundle exec rake` passes AND the Error token count is zero for both demo and
  visual sample.
- **Update the visual sample** (`spec/visual/samples/spl2`)
  whenever new tokens are added to the lexer, so every token type has coverage.

The markdownlint configuration in [.vscode/settings.json](.vscode/settings.json)
sets `MD024` to `siblings_only: true`, allowing repeated heading text under
different parent headings (e.g. `### Added` appearing under multiple version
sections in the changelog).

## Changelog

The changelog ([CHANGELOG.md](CHANGELOG.md)) follows the
[Keep a Changelog](https://keepachangelog.com/en/1.1.0/) format and
[Semantic Versioning](https://semver.org/spec/v2.0.0.html). When updating the
changelog:

- Use `## [version] - YYYY-MM-DD` for release headings
- Use `### Added`, `### Changed`, `### Removed` as second-level section headings
- Use `#### Category name` as optional third-level headings within a section
- Ensure blank lines surround all headings to satisfy markdownlint
