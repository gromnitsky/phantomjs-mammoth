class Stat
    constructor: (@reporter) ->
        throw new Error 'invalid reporter' unless @reporter?

        @suitsTotal = 0
        @suitsFailed = 0
        @testsTotal = 0
        @testsSkipped = 0
        @testsFailed = 0
        
    setup: ->
        @reporter.setup()

    printResults: ->
        @reporter.teardown {
            suitsTotal: @suitsTotal
            suitsFailed: @suitsFailed
            testsTotal: @testsTotal
            testsSkipped: @testsSkipped
            testsFailed: @testsFailed
        }

module.exports = Stat
