class Grabber
    constructor: ->
        @desc = "for internal testing only"
        @collapsar = []

    showBegin: ->
        @collapsar = []
        @collapsar.push ["showBegin"]

    showEnd: (stat) ->
        @collapsar.push ["showEnd", stat]

    suiteBegin: (name) ->
        @collapsar.push ["suiteBegin", name]

    suiteEnd: (name, elapsed) ->
        @collapsar.push ["suiteEnd", name, elapsed]

    testBegin: (name) ->
        @collapsar.push ["testBegin", name]

    testPassed: (name, elapsed) ->
        @collapsar.push ["testPassed", name, elapsed]

    testFailed: (name, backtrace, elapsed) ->
        @collapsar.push ["testFailed", name, backtrace, elapsed]

    err: (msg) ->
        @collapsar.push ["err", msg]

    warn: (msg) ->
        @collapsar.push ["warn", msg]

module.exports = new Grabber()
