#!/usr/bin/env phantomjs

sys = require 'system'

u = require '../lib/cliutils'
Suit = require '../lib/suit'
Stat = require '../lib/stat'
Reporter = require '../lib/reporter'

usage = ->
    console.log "Usage: #{u.pnGet()}: file1.coffee ..."
    phantom.exit u.EX_USAGE

usage() unless sys.args.length > 1


# Main

reporter = new Reporter('plain')
stat = new Stat reporter

stat.setup()

new Suit(stat, idx) for idx in sys.args[1..-1]

stat.printResults()

phantom.exit (if stat.suitsFailed == 0 then 0 else 1)
