class Assert
    constructor: ->
    
    equal: (expected, actual) ->
        if expected != actual
            throw new Error "assert.equal failed: #{expected} != #{actual}"

    ok: (value) ->
        unless value?
            throw new Error "assert.ok failed: value is #{value}"

module.exports = new Assert()
