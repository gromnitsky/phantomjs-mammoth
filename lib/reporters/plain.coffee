ms = require 'ms'
sprintf = require 'sprint'

class Plain
    constructor: ->
        @desc = "plain text, verbose, no colors"

    @fmt: (name, elapsed) ->
        sprintf '%-66s%14s', name, elapsed

    showBegin: ->
        console.log "Freak show begins\n"

    showEnd: (stat) ->
        fmt = (st, sf, tt, ts, tf) ->
            sprintf '%-15s %-15s %-15s %-15s %-15s', st, sf, tt, ts, tf
            
        console.log (fmt 'Suits total', 'Failed', 'Tests total', 'Skipped', 'Failed')
        console.log (fmt stat.suitsTotal, stat.suitsFailed, stat.testsTotal, stat.testsSkipped, stat.testsFailed)
        console.log "Elapsed: #{ms(stat.elapsed)}"

    suiteBegin: (name) ->
        console.log "Suite #{name}:"

    suiteEnd: (name, elapsed) ->
        console.log Plain.fmt "Suite time:", ms(elapsed)
        console.log ""

    testBegin: (name) ->
        # nothing

    testPassed: (name, elapsed) ->
        console.log Plain.fmt "+ #{name}", ms(elapsed)

    testFailed: (name, backtrace, elapsed) ->
        console.error Plain.fmt "- #{name}: FAIL", ms(elapsed)
        console.error backtrace

    err: (msg) ->
        console.error msg

    warn: (msg) ->
        console.error msg

module.exports = new Plain()
