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
        assert.doesNotThrow =>
            @s1 = new Suite(@stat, "/DOESN'T EXISTS")
        , Error
        assert.equal @s1.stat.suitsFailed, 1
        t = @grabber.collapsar[0]
        assert.equal t[0], 'warning'
        assert.match t[1], /cannot load test suite/

        assert.doesNotThrow =>
            @s1 = new Suite(@stat, "test/example/smoke-quiet.coffee", {})
        , Error

    'suite 1 stats': ->
        assert.equal @s1.size(), 5
        assert.equal @s1.stat.testsSkipped, 0
        assert.equal @s1.stat.testsFailed, 2
}

module.exports = suite
