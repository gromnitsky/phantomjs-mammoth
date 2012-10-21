fs = require 'fs'
u = require '../lib/cliutils'

class Suite
    constructor: (@stat, @file, @conf) ->
        throw new Error 'suite: invalid stat object' unless @stat?

        @suite = {}
        @file = fs.absolute @file
        try
           @suite = require @file
        catch e
            u.warnx "suite: cannot load test suite '#{@name()}': #{e.message}\n"
            @stat.suitsFailed++
            return

        @failed = 0
        @stat.suitsTotal++
        @stat.testsTotal += @size()
        @stat.reporter.suiteBegin @name()

        @bailed = false
        @runAll()

        @stat.testsFailed += @failed
        @stat.suitsFailed++ if @failed == @size()
        @stat.reporter.suiteEnd @name()

    name: ->
        u.basename @file

    # Return an array of eligible tests. The 2nd time return the cache
    # of prev operation.
    getTests: ->
        return @_tests if @_tests?
        @_tests = (key for key, unused of @suite when @isTest(key))

    size: ->
        @getTests().length

    runAll: ->
        if typeof @suite.setup == "function"
            @suite.setup()

        for idx in @getTests()
            @runTest idx
            break if @bailed

        if typeof @suite.teardown == "function"
            @suite.teardown()

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

        try
            @suite[name]()
            ok = true
        catch e
            @failed++
            @stat.reporter.testFailed name, e

            if @conf.bail
                skipped = @stat.testsSkipped + (@stat.testsTotal - 1)
#                console.log "#{@stat.testsSkipped} #{skipped}"
                @stat.testsSkipped = skipped
                @bailed = true

        @stat.reporter.testPassed name if ok


module.exports = Suite
