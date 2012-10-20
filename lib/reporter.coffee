class Reporter
    constructor: (name) ->
        throw new Error "reporter: invalid reporter" unless name?

        @reporter = null
        try
           @reporter = require "./reporters/#{name}"
        catch e
            throw new Error "reporter: cannot load reporter '#{name}': #{e.message}"

    setup: ->
        @reporter.setup()

    teardown: (suitsTotal, suitsFailed, testsTotal, testsFailed) ->
        @reporter.teardown suitsTotal, suitsFailed, testsTotal, testsFailed

    suiteBegin: (name) ->
        @reporter.suiteBegin name

    suiteEnd: (name) ->
        @reporter.suiteEnd name

    testBegin: (name) ->
        @reporter.testBegin name

    testPassed: (name) ->
        @reporter.testPassed name

    testFailed: (name, err) ->
        @reporter.testFailed name, err

module.exports = Reporter
