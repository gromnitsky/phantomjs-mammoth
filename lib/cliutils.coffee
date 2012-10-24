sys = require 'system'

class CliUtils
    # Preferable exit codes. See sysexits(3) in FreeBSD.
    @EX_OK = 0
    @EX_USAGE = 64
    @EX_DATAERR = 65
    @EX_NOINPUT = 66
    @EX_NOUSER = 67
    @EX_NOHOST = 68
    @EX_UNAVAILABLE = 69
    @EX_SOFTWARE = 70
    @EX_OSERR = 71
    @EX_OSFILE = 72
    @EX_CANTCREAT = 73
    @EX_IOERR = 74
    @EX_TEMPFAIL = 75
    @EX_PROTOCOL = 76
    @EX_NOPERM = 77
    @EX_CONFIG = 78

    @basename: (file_name, ext = '') ->
        return '' unless file_name?
        r = file_name.replace /.*\/([^/]+)$/, '$1'
        if ext?
            end = r.lastIndexOf ext
            r = r[0...end] if end != -1
        r

    @dirname: (file_name) ->
        return '' unless file_name?
        file_name.replace /(.*)\/[^/]+$/, '$1'

    @hashSize: (hash) ->
        (Object.keys hash).length

    @isNum = (n) -> !isNaN(parseFloat n) && isFinite n
                
    @pnGet: ->
        CliUtils.basename sys.args[0] || 'unknown'

    @errx: (exit_code = 1, msg) ->
        console.error "#{CliUtils.pnGet()} error: #{msg}"
        phantom.exit exit_code if exit_code

    @warnx: (msg) ->
        console.error "#{CliUtils.pnGet()} warning: #{msg}"

module.exports = CliUtils
