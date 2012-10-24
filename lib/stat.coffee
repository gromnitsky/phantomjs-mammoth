class Stat
    constructor: (@reporter) ->
        throw new Error 'invalid reporter' unless @reporter?

        @metersClean()

    metersClean: ->
        @suitsTotal = 0
        @suitsFailed = 0
        @testsTotal = 0
        @testsSkipped = 0
        @testsFailed = 0

        @timeStart = @currentTime()

    showBegin: ->
        @metersClean()
        @reporter.showBegin()

    elapsed: (start) ->
        new Date().getTime() - start

    currentTime: ->
        new Date().getTime()

    showEnd: ->
        @reporter.showEnd {
            suitsTotal: @suitsTotal
            suitsFailed: @suitsFailed
            testsTotal: @testsTotal
            testsSkipped: @testsSkipped
            testsFailed: @testsFailed
            elapsed: @elapsed(@timeStart)
        }

module.exports = Stat
