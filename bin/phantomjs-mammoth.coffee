#!/usr/bin/env phantomjs

sys = require 'system'
fs = require 'fs'

optparse = require 'optparse'

u = require '../lib/cliutils'
Suit = require '../lib/suit'
Stat = require '../lib/stat'
Reporter = require '../lib/reporter'

prootdir = (u.dirname (fs.absolute sys.args[0])) + '/..'

conf = {
    verbose: 0
    reporter: 'plain'
    grep: null
    grep_invert: false
    bail: false
}

reporter_find = (name, onerror) ->
    r = null
    try
        r = require "../lib/reporters/#{name}"
    catch e_local
        # not found, try a system one
        try
            r = require name
        catch e_system
            onerror name, e_local, e_system
            return null
    r

parse_clo = ->
    opt = [
        ['-h', '--help', 'output usage information & exit']
        ['-V', '--version', 'output the version number & exit']
        ['-v', '--verbose', 'increase a verbosity level']
        ['-R', '--reporter [NAME]', 'specify the reporter to use']
        ['-g', '--grep [PATTERN]', 'only run tests matching pattern']
        ['-i', '--invert', 'inverts --grep matches']
        ['-b', '--bail', 'bail after first test failure']
        ['--list-reporters', 'display available reporters & exit']
    ]
    p = new optparse.OptionParser opt
    p.banner = "Usage: #{u.pnGet()}: [options] file.coffee ..."

    p.on 'verbose', -> conf.verbose++

    p.on 'help', ->
        console.log p
        phantom.exit u.EX_OK

    p.on 'version', ->
        j = JSON.parse (fs.read "#{prootdir}/package.json")
        console.log j.version
        phantom.exit u.EX_OK

    p.on 'reporter', (unused, val) ->
        reporter_find val, (name, e_local, e_system) ->
            console.error "cannot find '#{name}' reporter"
            phantom.exit u.EX_UNAVAILABLE if conf.verbose == 0
            console.error "Embedded: #{e_local.stack}\nSystem: #{e_system.stack}"
        conf.reporter = val

    p.on 'grep', (unused, val) ->
        re = null
        try
            re = new RegExp val
        catch e
            u.errx 1, 'invalid regexp: #{val}'
        conf.grep = re

    p.on 'invert', -> conf.grep_invert = true

    p.on 'bail', -> conf.bail = true

    p.on 'list-reporters', ->
        for idx in (fs.list "#{prootdir}/lib/reporters") when idx != '.' && idx != '..'
            r = reporter_find idx
            console.log "#{u.basename idx, '.coffee'}: #{r.desc}"
        phantom.exit u.EX_OK

    p.on (o) -> u.errx 1, "unknown option #{o}"

    [(p.parse sys.args), p]


[args, p] = parse_clo()
console.log p unless args.length > 1


# Main

reporter = new Reporter(conf.reporter)
stat = new Stat reporter

stat.setup()

new Suit(stat, idx, conf) for idx in args[1..-1]

stat.printResults()

phantom.exit (if stat.suitsFailed == 0 then 0 else 1)
