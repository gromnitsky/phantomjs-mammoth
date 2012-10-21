#!/usr/bin/env phantomjs

sys = require 'system'
fs = require 'fs'

optparse = require 'optparse'

u = require '../lib/cliutils'
Suite = require '../lib/suite'
Stat = require '../lib/stat'
Reporter = require '../lib/reporter'

prootdir = (u.dirname (fs.absolute sys.args[0])) + '/..'

conf = {
    verbose: 0
    reporter: null
    grep: null
    grep_invert: false
    bail: false
}

reporter_load = (name) ->
    Reporter.load name, (name, e_local, e_system) ->
        u.errx 0, "cannot load '#{name}' reporter"
        phantom.exit u.EX_UNAVAILABLE if conf.verbose == 0

        console.error "\nEmbedded: #{e_local.stack}"
        console.error "\nSystem: #{e_system.stack}"

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
        conf.reporter = reporter_load val

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
            r = Reporter.load idx
            console.log "#{u.basename idx, '.coffee'}: #{r.desc}"
        phantom.exit u.EX_OK

    p.on (o) -> u.errx 1, "unknown option #{o}"

    [(p.parse sys.args), p]


[args, p] = parse_clo()
console.log p unless args.length > 1


# Main

conf.reporter = reporter_load 'plain' unless conf.reporter
reporter = new Reporter conf.reporter
stat = new Stat reporter

stat.setup()

for idx in args[1..-1]
    s = new Suite(stat, idx, conf)
    break if s.bailed

stat.printResults()

phantom.exit (if stat.suitsFailed == 0 then 0 else 1)
