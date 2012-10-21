ms = require 'ms'

class Plain
    constructor: ->
        @desc = "plain text, verbose, no colors"

    setup: ->
        console.log "Freak show begins\n"

    teardown: (stat) ->
        console.log "Suits total / :( / tests total / skipped / :("
        console.log "#{stat.suitsTotal} #{stat.suitsFailed} #{stat.testsTotal} #{stat.testsSkipped} #{stat.testsFailed}"
        console.log "Elapsed: #{ms(stat.elapsed)}"

    suiteBegin: (name) ->
        console.log "Suite #{name}:"

    suiteEnd: (name, elapsed) ->
        console.log "Suite time: #{ms(elapsed)}"
        console.log ""

    testBegin: (name) ->
        # nothing

    testPassed: (name, elapsed) ->
        console.log "+ #{name}: ok (#{ms(elapsed)})"

    testFailed: (name, backtrace, elapsed) ->
        console.error "- #{name}: FAIL (#{ms(elapsed)})"
        console.error backtrace


module.exports = new Plain()
