assert = require('chai/chai.js').assert

suite = {
    setup: ->
        bwaa

    teardown: ->

    '2+2 is 4': ->
        assert.equal 2+2, 4

    'water is wet': ->
        assert.equal 'wet', 'dry'

    'war is peace': ->
        assert.ok @one

    'ignorance is strength': ->
        asser1 @zero

    'freedom is slavery': ->
        assert.ok 1
}

module.exports = suite
