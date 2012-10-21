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

    setup: ->
        @reporter.setup()

    teardown: (stat) ->
        @reporter.teardown stat

    suiteBegin: (name) ->
        @reporter.suiteBegin name

    suiteEnd: (name) ->
        @reporter.suiteEnd name

    testBegin: (name) ->
        @reporter.testBegin name

    testPassed: (name) ->
        @reporter.testPassed name

    testFailed: (name, backtrace) ->
        @reporter.testFailed name, backtrace

module.exports = Reporter
