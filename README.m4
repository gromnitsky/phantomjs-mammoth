define(`tt', `<code>$1</code>')dnl
# phantomjs-mammoth

A tiny TDD test framework for phantomjs 1.7.1+. (Beware of a bug in
phantomjs 1.7.0 with tt(`phantom.exit()') function.)

Tests consist of 'suits', where each suite is a file (in CoffeeSript or
JavaScript). Also, every suite is a standalone module in CommonJS terms.

A suite may have tt(`setup') & tt(`teardown') hooks & any number
of actual unit tests.

phantomjs-mammoth doesn't provide assertions for you--use chai for that
(install it separately as any other npm package, but make sure you
'require' it in a proper manner for phantomjs; see an example below).

If you don't like chai, make sure that your assertion library throws
tt(`AssertionError'), otherwise a backtrace would be garbled with
redundant data.

If you don't like the reporters shipped with phantomjs-mammoth, you can
very easy write your own--look at tt(`lib/reporters/*') for
examples. phantomjs-mammoth can load any CommonJS module & try to use it
as a reporter, so make & install your reporters as npm packages.

## Invocation

phantomjs-mammoth only runs suites supplied as CL arguments. There is no
recursive search for files or anything. Use Unix utilities & shell
expansion for that.

<pre>
syscmd(`bin/phantomjs-mammoth.coffee')</pre>

## Example

<pre>
$ npm install chai
[...]
$ cat test/smoke.coffee
undivert(`test/smoke.coffee')
$ phantomjs-mammoth.coffee test/smoke.coffee
syscmd(`bin/phantomjs-mammoth.coffee test/smoke.coffee')</pre>

## TODO

- add more reporters (dot, tap)
- release as npm module

## License

MIT.
