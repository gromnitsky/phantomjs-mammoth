class Stat
    constructor: (@reporter) ->
        throw new Error 'invalid reporter' unless @reporter?

        @suitsTotal = 0
        @suitsFailed = 0
        @testsTotal = 0
        @testsFailed = 0
        
    setup: ->
        @reporter.setup()

    printResults: ->
        @reporter.teardown @suitsTotal, @suitsFailed, @testsTotal, @testsFailed

module.exports = Stat
