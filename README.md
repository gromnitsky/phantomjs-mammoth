# phantomjs-mammoth

A tiny TDD test framework for phantomjs 1.7.1+.

## Invocation

<pre>
Usage: phantomjs-mammoth.coffee: [options] file.coffee ...

Available options:
  -h, --help              output usage information & exit
  -V, --version           output the version number & exit
  -v, --verbose           increase a verbosity level
  -R, --reporter [NAME]   specify the reporter to use
  -g, --grep [PATTERN]    only run tests matching pattern
  -i, --invert            inverts --grep matches
  -b, --bail              bail after first test failure
      --list-reporters    display available reporters & exit
</pre>

## Example

<pre>
$ cat test/smoke.coffee
assert = require '../lib/assert'

suite = {
    setup: ->
        console.log '(setup)'
        @one = 1
        @two = 2

    teardown: ->
        console.log '(teardown)'
        @one--
        @two--

    '2+2 is 4': ->
        assert.equal 2+2, 4

    'water is wet': ->
        assert.equal 'wet', 'dry'

    'war is peace': ->
        assert.ok @one

    # will fail
    'ignorance is strength': ->
        assert 1

    'freedom is slavery': ->
        assert.ok 1
}

module.exports = suite

$ phantomjs-mammoth.coffee test/smoke.coffee
Freak show begins

Suite smoke.coffee:
(setup)
+ 2+2 is 4: ok
- water is wet: FAIL
Error: assert.equal failed: wet != dry
    at /home/alex/lib/software/alex/phantomjs-mammoth/lib/assert.coffee:10
    at /home/alex/lib/software/alex/phantomjs-mammoth/test/smoke.coffee:21
    at /home/alex/lib/software/alex/phantomjs-mammoth/lib/suite.coffee:119
    at /home/alex/lib/software/alex/phantomjs-mammoth/lib/suite.coffee:73
    at Suite (/home/alex/lib/software/alex/phantomjs-mammoth/lib/suite.coffee:30)
    at bin/phantomjs-mammoth.coffee:114
    at bin/phantomjs-mammoth.coffee:121
+ war is peace: ok
- ignorance is strength: FAIL
TypeError: '[object Object]' is not a function (evaluating 'assert(1)')
    at /home/alex/lib/software/alex/phantomjs-mammoth/test/smoke.coffee:27
    at /home/alex/lib/software/alex/phantomjs-mammoth/lib/suite.coffee:119
    at /home/alex/lib/software/alex/phantomjs-mammoth/lib/suite.coffee:73
    at Suite (/home/alex/lib/software/alex/phantomjs-mammoth/lib/suite.coffee:30)
    at bin/phantomjs-mammoth.coffee:114
    at bin/phantomjs-mammoth.coffee:121
+ freedom is slavery: ok
(teardown)

Suits total / :( / tests total / skipped / :(
1 0 5 0 2
</pre>

## TODO

- time
- add more succinct reporter

## License

MIT.
