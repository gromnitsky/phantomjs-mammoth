fs = require 'fs'
u = require '../lib/cliutils'

class Suit
    constructor: (@stat, @file) ->
        throw new Error 'suit: invalid stat object' unless @stat?

        @suite = {}
        @file = fs.absolute @file
        try
           @suite = require @file
        catch e
            u.warnx "suit: cannot load test suit '#{@name()}': #{e.message}\n"
            @stat.suitsFailed++
            return

        @failed = 0
        @stat.suitsTotal++
        @stat.testsTotal += @size()
        @stat.reporter.suiteBegin @name()
        
        @runAll()
        
        @stat.testsFailed += @failed
        @stat.suitsFailed++ if @failed == @size()
        @stat.reporter.suiteEnd @name()

    name: ->
        u.basename @file

    size: ->
        return 0 unless @suite?

        size = 0
        size++ for key, unused of @suite when @isTest(key)
        size
        
    runAll: ->
        if typeof @suite.setup == "function"
            @suite.setup()
            
        @runTest(key) for key, unused of @suite when @isTest(key)

        if typeof @suite.teardown == "function"
            @suite.teardown()

    isTest: (name) ->
        re = /^setup|teardown$/
        return false unless typeof @suite[name] == "function"
        return false if name.match(re)
        true
        
    runTest: (name) ->
        @stat.reporter.testBegin name
        ok = false

        try
            @suite[name]()
            ok = true
        catch e
            @failed++
            @stat.reporter.testFailed name, e

        @stat.reporter.testPassed name if ok


module.exports = Suit
