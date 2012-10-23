class Reporter
    constructor: (@reporter) ->
        throw new Error "reporter: invalid reporter" unless @reporter?.desc?

    @load: (name, onerror) ->
        r = null
        try
            r = require "./reporters/#{name}"
        catch e_local
            # not found, try a system one
            try
                r = require name
            catch e_system
                onerror name, e_local, e_system
                return null
        r

    showBegin: ->
        @reporter.showBegin()

    showEnd: (stat) ->
        @reporter.showEnd stat

    suiteBegin: (name) ->
        @reporter.suiteBegin name

    suiteEnd: (name, elapsed) ->
        @reporter.suiteEnd name, elapsed

    testBegin: (name) ->
        @reporter.testBegin name

    testPassed: (name, elapsed) ->
        @reporter.testPassed name, elapsed

    testFailed: (name, backtrace, elapsed) ->
        @reporter.testFailed name, backtrace, elapsed

    err: (msg) ->
        @reporter.err msg

    warn: (msg) ->
        @reporter.warn msg

module.exports = Reporter
