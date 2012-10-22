# phantomjs-mammoth

A tiny TDD test framework for phantomjs 1.7.1+. (Beware of a bug in
phantomjs 1.7.0 with <code>phantom.exit()</code> function.)

Tests consist of 'suits', where each suite is a file (in CoffeeSript or
JavaScript). Also, every suite is a standalone module in CommonJS terms.

A suite may have <code>setup</code> & <code>teardown</code> hooks & any number
of actual unit tests.

phantomjs-mammoth doesn't provide assertions for you--use chai for that
(install it separately as any other npm package, but make sure you
'require' it in a proper manner for phantomjs; see an example below).

If you don't like chai, make sure that your assertion library throws
<code>AssertionError</code>, otherwise a backtrace would be garbled with
redundant data.

If you don't like the reporters shipped with phantomjs-mammoth, you can
very easy write your own--look at <code>lib/reporters/*</code> for
examples. phantomjs-mammoth can load any CommonJS module & try to use it
as a reporter, so make & install your reporters as npm packages.

## Invocation

phantomjs-mammoth only runs suites supplied as CL arguments. There is no
recursive search for files or anything. Use Unix utilities & shell
expansion for that.

<pre>
Usage: phantomjs-mammoth.coffee [options] file.coffee ...

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
$ npm install chai
[...]
$ cat test/smoke.coffee
# pay attention to how chai is required
assert = require('chai/chai.js').assert

suite = {
    setup: ->
        console.log '(setup)'
        @one = 1
        @zero = 0

    teardown: ->
        console.log '(teardown)'

    '2+2 is 4': ->
        assert.equal 2+2, 4

    'water is wet': ->
        assert.equal 'wet', 'dry'

    'war is peace': ->
        assert.ok @one

    'ignorance is strength': ->
        asser1 @zero

    'freedom is slavery': ->
        assert.ok 1
}

module.exports = suite

$ phantomjs-mammoth.coffee test/smoke.coffee
Freak show begins

Suite smoke.coffee:
(setup)
+ 2+2 is 4: ok (0 ms)
- water is wet: FAIL (2 ms)
OMG! Error: expected 'wet' to equal 'dry'
    at /home/alex/lib/software/alex/phantomjs-mammoth/test/example/smoke.coffee:19
    at /home/alex/lib/software/alex/phantomjs-mammoth/lib/suite.coffee:135
    at /home/alex/lib/software/alex/phantomjs-mammoth/lib/suite.coffee:89
    at Suite (/home/alex/lib/software/alex/phantomjs-mammoth/lib/suite.coffee:32)
    at bin/phantomjs-mammoth.coffee:115
    at bin/phantomjs-mammoth.coffee:125
+ war is peace: ok (0 ms)
- ignorance is strength: FAIL (1 ms)
ReferenceError: Can't find variable: asser1
    at /home/alex/lib/software/alex/phantomjs-mammoth/test/example/smoke.coffee:25
    at /home/alex/lib/software/alex/phantomjs-mammoth/lib/suite.coffee:135
    at /home/alex/lib/software/alex/phantomjs-mammoth/lib/suite.coffee:89
    at Suite (/home/alex/lib/software/alex/phantomjs-mammoth/lib/suite.coffee:32)
    at bin/phantomjs-mammoth.coffee:115
    at bin/phantomjs-mammoth.coffee:125
+ freedom is slavery: ok (0 ms)
(teardown)
Suite time: 5 ms

Suits total / :( / tests total / skipped / :(
1 0 5 0 2
Elapsed: 38 ms
</pre>

## TODO

- add more reporters (dot, tap)
- release as npm module

## License

MIT.
