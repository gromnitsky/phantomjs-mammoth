assert = require('chai/chai.js').assert

Reporter = require '../lib/reporter'
Stat = require '../lib/stat'
Suite = require '../lib/suite'

isNum = (n) -> !isNaN(parseFloat n) && isFinite n

suite = {
    setup: ->
        @grabber = require './reporters/grabber'
        @stat = new Stat (new Reporter @grabber)

    teardown: ->

    'init fail': ->
        assert.throws ->
            new Suite()
        , Error
        assert.throws =>
            new Suite(@stat)
        , Error

    'init fine': ->
        s = null
        assert.doesNotThrow =>
            s = new Suite(@stat, "/DOESN'T EXISTS")
        , Error
        assert.equal s.stat.suitsFailed, 1
        t = @grabber.collapsar[0]
        assert.equal t[0], 'warn'
        assert.match t[1], /cannot load test suite/

    'suite stats': ->
        @stat.metersClean()
        s = new Suite(@stat, "test/example/smoke-quiet.coffee", {})
        
        assert.equal s.stat.suitsTotal, 1
        assert.equal s.stat.suitsFailed, 0
        assert.equal s.size(), 5
        assert.equal s.stat.testsTotal, 5
        assert.equal s.stat.testsSkipped, 0
        assert.equal s.stat.testsFailed, 2

        assert.equal @grabber.collapsar[3][0], 'testPassed'
        assert.ok (isNum @grabber.collapsar[3][2])
        
        assert.equal @grabber.collapsar[5][0], 'testFailed'
        assert.match @grabber.collapsar[5][2], /AssertionError/
        assert.ok (isNum @grabber.collapsar[5][3])

        assert.equal @grabber.collapsar[7][0], 'testPassed'
        assert.ok (isNum @grabber.collapsar[7][2])

        assert.equal @grabber.collapsar[9][0], 'testFailed'
        assert.match @grabber.collapsar[9][2], /ReferenceError/
        assert.ok (isNum @grabber.collapsar[9][3])

        assert.equal @grabber.collapsar[11][0], 'testPassed'
        assert.ok (isNum @grabber.collapsar[11][2])

    'grep': ->
        @stat.metersClean()
        s = new Suite(@stat, "test/example/smoke-quiet.coffee", {grep: new RegExp 'war'})
        
        assert.equal s.stat.suitsTotal, 1
        assert.equal s.stat.suitsFailed, 0
        assert.equal s.size(), 1
        assert.equal s.stat.testsTotal, 1
        assert.equal s.stat.testsSkipped, 4
        assert.equal s.stat.testsFailed, 0

    'grep invert': ->
        @stat.metersClean()
        s = new Suite(@stat, "test/example/smoke-quiet.coffee", {
            grep: new RegExp 'war'
            grep_invert: true
        })
        
        assert.equal s.stat.suitsTotal, 1
        assert.equal s.stat.suitsFailed, 0
        assert.equal s.size(), 4
        assert.equal s.stat.testsTotal, 4
        assert.equal s.stat.testsSkipped, 1
        assert.equal s.stat.testsFailed, 2

    'bail': ->
        @stat.metersClean()
        s = new Suite(@stat, "test/example/smoke-quiet.coffee", {bail: true})
        
        assert.equal s.stat.suitsTotal, 1
        assert.equal s.stat.suitsFailed, 0
        assert.equal s.size(), 5
        assert.equal s.stat.testsTotal, 5
        assert.equal s.stat.testsSkipped, 3
        assert.equal s.stat.testsFailed, 1
                                
}

module.exports = suite
