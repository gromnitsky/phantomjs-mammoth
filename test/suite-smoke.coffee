assert = require('chai/chai.js').assert

Reporter = require '../lib/reporter'
Stat = require '../lib/stat'
Suite = require '../lib/suite'

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

    'suite 1 stats': ->
        @stat.metersClean()
        s = new Suite(@stat, "test/example/smoke-quiet.coffee", {})
        
        assert.equal s.stat.suitsTotal, 1
        assert.equal s.stat.suitsFailed, 0
        assert.equal s.size(), 5
        assert.equal s.stat.testsTotal, 5
        assert.equal s.stat.testsSkipped, 0
        assert.equal s.stat.testsFailed, 2
}

module.exports = suite
