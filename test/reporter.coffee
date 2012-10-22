assert = require('chai/chai.js').assert

Reporter = require '../lib/reporter'

suite = {
    setup: ->
        @plain = require '../lib/reporters/plain'

    teardown: ->

    'init fail': ->
        assert.throws ->
            new Reporter()
        , Error
        assert.throws ->
            new Reporter undefined
        , Error
        assert.throws ->
            new Reporter {}
        , Error

    'init ok': ->
        assert.doesNotThrow =>
            new Reporter @plain
        , Error
}

module.exports = suite
