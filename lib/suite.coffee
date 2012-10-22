fs = require 'fs'
u = require '../lib/cliutils'

class Suite
    constructor: (@stat, @file, @conf) ->
        throw new Error 'suite: invalid stat object' unless @stat?
        throw new Error 'suite: empty file name' unless @file?

        @suite = {}
        @file = fs.absolute @file
        try
           @suite = require @file
        catch e
            @stat.reporter.warn "suite: cannot load test suite '#{@name()}': #{e.message}\n"
            @stat.suitsFailed++
            return

        @failed = 0
        @stat.suitsTotal++
        @stat.testsTotal += @size()
        @stat.reporter.suiteBegin @name()

        @bailed = false
        @timeStart = @stat.currentTime()
        @runAll()

        @stat.testsFailed += @failed
        @stat.suitsFailed++ if @failed == @size()
        @stat.reporter.suiteEnd @name(), (@stat.elapsed @timeStart)

    name: ->
        u.basename @file

    # Return an array of eligible tests. The 2nd time return the cache
    # of prev operation.
    getTests: ->
        return @_tests if @_tests?
        @_tests = (key for key, unused of @suite when @isTest(key))

    size: ->
        @getTests().length

    runHook: (name) ->
        if typeof @suite[name] == "function"
            try
                @suite[name]()
            catch e
                @stat.reporter.err "Error in #{name} hook:"
                @stat.reporter.err e.stack
                return false
        true

    runAll: ->
        # skip all tests if setup is broken
        if ! @runHook 'setup'
            @stat.testsSkipped = @size()
            return

        for idx in @getTests()
            @runTest idx
            break if @bailed

        # if teardown failed, just warn a user
        @runHook 'teardown'

    # Used in isTest() only.
    _markAsSkipped: ->
        @stat.testsSkipped++
        false

    # Analyze name for elegibility as a test. Calculates number of
    # skipped tests internally too.
    isTest: (name) ->
        return false unless typeof @suite[name] == "function"
        re = /^setup|teardown$/
        return false if name.match(re)

        if @conf.grep
            if @conf.grep_invert
                return if name.match @conf.grep then @_markAsSkipped() else true
            else
                return if name.match @conf.grep then true else @_markAsSkipped()

        true

    runTest: (name) ->
        @stat.reporter.testBegin name
        ok = false

        startTime = @stat.currentTime()
        try
            @suite[name]()
            ok = true
        catch e
            @failed++
            @stat.reporter.testFailed name, @getBacktrace(e), @stat.elapsed(startTime)

            if @conf.bail
                skipped = @stat.testsSkipped + (@stat.testsTotal - 1)
                @stat.testsSkipped = skipped
                @bailed = true

        @stat.reporter.testPassed name, @stat.elapsed(startTime) if ok

    getBacktrace: (err) ->
        return '' unless err instanceof Error

        lines = err.stack.split '\n'
        if err.name == 'AssertionError'
            # probably from chai
            f = lines[0]
            lines = lines[Suite.backtraceFindFile(lines, @file)..-1]
            lines.unshift "OMG! #{err.name}: #{f}"

        lines.join '\n'

    @backtraceFindFile: (lines, file_name) ->
        return 0 unless (lines instanceof Array) && file_name?
        (return index if idx.match(file_name)) for idx, index in lines
        0

module.exports = Suite
