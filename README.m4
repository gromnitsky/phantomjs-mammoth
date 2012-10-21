# phantomjs-mammoth

A tiny TDD test framework for phantomjs 1.7.1+.

## Invocation

<pre>
syscmd(`bin/phantomjs-mammoth.coffee -h')</pre>

## Example

<pre>
$ cat test/smoke.coffee
undivert(`test/smoke.coffee')
$ phantomjs-mammoth.coffee test/smoke.coffee
syscmd(`bin/phantomjs-mammoth.coffee test/smoke.coffee')
</pre>

## TODO

- time
- add more succinct reporter

## License

MIT.
