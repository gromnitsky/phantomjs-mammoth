class Grabber
    constructor: ->
        @desc = "for internal testing"
        @collapsar = []

    setup: ->
        @collapsar.push ["setup"]

    teardown: (stat) ->
        @collapsar.push ["teardown", stat]

    suiteBegin: (name) ->
        @collapsar.push ["begin", name]

    suiteEnd: (name, elapsed) ->
        @collapsar.push ["end", name, elapsed]

    testBegin: (name) ->
        @collapsar.push ["test", "begin", name]

    testPassed: (name, elapsed) ->
        @collapsar.push ["test", "passed", name, elapsed]

    testFailed: (name, backtrace, elapsed) ->
        @collapsar.push ["test", "failed", name, backtrace, elapsed]

    err: (msg) ->
        @collapsar.push ["error", msg]

    warn: (msg) ->
        @collapsar.push ["warning", msg]

module.exports = new Grabber()
