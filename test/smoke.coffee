assert = require '../lib/assert'

suite = {
    setup: ->
        console.log '(setup)'
        @one = 1
        @two = 2

    teardown: ->
        console.log '(teardown)'
        @one--
        @two--

    '2+2 is 4': ->
        assert.equal 2+2, 4

    'water is wet': ->
        assert.equal 'wet', 'dry'

    'war is peace': ->
        assert.ok @one

    # will fail
    'ignorance is strength': ->
        assert 1

    'freedom is slavery': ->
        assert.ok 1
}

module.exports = suite
