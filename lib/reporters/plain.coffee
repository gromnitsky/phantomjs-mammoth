class Plain
    constructor: ->
        @desc = "Plain text, no colors"

    setup: ->
        console.log "Freak show begins\n"

    teardown: (suitsTotal, suitsFailed, testsTotal, testsFailed) ->
        console.log "Suits total / :( / tests total / :("
        console.log "#{suitsTotal} #{suitsFailed} #{testsTotal} #{testsFailed}"

    suiteBegin: (name) ->
        console.log "Suite #{name}:"

    suiteEnd: (name) ->
        console.log ""

    testBegin: (name) ->
        # nothing

    testPassed: (name) ->
        console.log "+ #{name}: ok"

    testFailed: (name, err) ->
        console.error "- #{name}: FAIL"
        console.error err.message


module.exports = new Plain()
