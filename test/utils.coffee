assert = require('chai/chai.js').assert

u = require '../lib/cliutils'

suite = {
    'objInspect.branchy': ->
        q = {
            q: 1
            w: 'foo'
            e: {
                d: [2]
                f: 'bar'
                g: -> console.log 'hi'
                h: {
                    n: null
                }
                j: {
                    k: {
                    }
                }
            }
            r: NaN
        }
        assert.equal JSON.stringify(u.objInspect(q)), '{"q":1,"w":"foo","e":{"d":{"0":2},"f":"bar","g":"[function]","h":{"n":null},"j":{"k":{}}},"r":null}'

    'objInspect.class': ->
        class C
            @w = 2
            constructor: ->
                @q = 1
            foo: ->
        c = new C()
        assert.equal JSON.stringify(u.objInspect(c)), '{"q":1,"foo":"[function]","[prototype]":{"foo":"[function]"}}'
        assert.equal JSON.stringify(u.objInspect(C)), '{"w":2}'

    'objInspect.null': ->
        assert.equal u.objInspect(null), null
        assert.equal u.objInspect(undefined), undefined

    'objInspect.array': ->
        assert.equal JSON.stringify(u.objInspect([1,2])), '{"0":1,"1":2}'
        
        q = [1, {
            w: 2
            }]
        assert.equal JSON.stringify(u.objInspect(q)), '{"0":1,"1":{"w":2}}'

    'objInspect.circular': ->
        q = { q: 1, w: 2, e: { d: 'BOOM' }, r: 3 }
        q.e.d = q
        assert.equal JSON.stringify(u.objInspect(q)), '{"q":1,"w":2,"e":{"d":"[circular reference]"},"r":3}'
        q = { q: 1 }
        q.q = q
        assert.equal JSON.stringify(u.objInspect(q)), '{"q":"[circular reference]"}'
}

module.exports = suite
