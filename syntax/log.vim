" Vim syntax file
" Language:         Generic logs
" Maintainer:       fei6409 <fei6409@gmail.com>
" Latest Revision:  2025-08-14

if exists("b:current_syntax")
  finish
endif

let s:cpo_save = &cpo
set cpo&vim

" Symbols / special characters
" ------------------------------
syn match LogSymbol    display     '[!@#$%^&*;:?]'

" Separators
" ------------------------------
syn match LogSeparatorLine  display     '-\{3,}\|=\{3,}\|#\{3,}\|\*\{3,}\|<\{3,}\|>\{3,}'

" Strings
" ------------------------------
syn region LogString      start=/"/  end=/"/  end=/$/  skip=/\\./
syn region LogString      start=/`/  end=/`/  end=/$/  skip=/\\./
" Quoted strings, but no match on quotes like `don't`, possessive `s'` and `'s`
syn region LogString      start=/\(s\)\@<!'\(s \|t \)\@!/  end=/'/  end=/$/  skip=/\\./

" Numbers
" ------------------------------
syn match LogNumber         display     '\<\d\+\>'
syn match LogNumberFloat    display     '\<\d\+\.\d\+\([eE][+-]\?\d\+\)\?\>'
syn match LogNumberBin      display     '\<0[bB][01]\+\>'
syn match LogNumberOctal    display     '\<0[oO]\o\+\>'
syn match LogNumberHex      display     '\<0[xX]\x\+\>'
" Possible hex numbers without the '0x' prefix
syn match LogNumberHex      display     '\<\x\{4,}\>'

" Numbers in Hardware Description Languages e.g. Verilog
" These must be placed after LogString to ensure they take precedence
syn match LogNumber         display     '\'d\d\+\>'
syn match LogNumberBin      display     '\'b[01]\+\>'
syn match LogNumberOctal    display     '\'o\o\+\>'
syn match LogNumberHex      display     '\'h\x\+\>'

" Constants
" ------------------------------
syn keyword LogBool    TRUE True true FALSE False false
syn keyword LogNull    NULL Null null

" Date & Time
" ------------------------------
" MM-DD, DD-MM, MM/DD, DD/MM
syn match LogDate       display     '\<\d\{2}[-\/]\d\{2}\>'
" YYYY-MM-DD, YYYY/MM/DD
syn match LogDate       display     '\<\d\{4}[-\/]\d\{2}[-\/]\d\{2}\>'
" DD-MM-YYYY, DD/MM/YYYY
syn match LogDate       display     '\<\d\{2}[-\/]\d\{2}[-\/]\d\{4}\>'
" First half of RFC3339 e.g. 2023-01-01T
syn match LogDate       display     '\<\d\{4}-\d\{2}-\d\{2}T'
" 'Dec 31', 'Dec 31, 2023', 'Dec 31 2023'
syn match LogDate       display     '\<\a\{3} \d\{1,2}\(,\? \d\{4}\)\?\>'
" '31-Dec-2023', '31 Dec 2023'
syn match LogDate       display     '\<\d\{1,2}[- ]\a\{3}[- ]\d\{4}\>'

" Weekday string
syn keyword LogWeekdayStr   Mon Tue Wed Thu Fri Sat Sun

" 12:34:56, 12:34:56.700000
syn match LogTime       display     '\d\{2}:\d\{2}:\d\{2}\(\.\d\{2,6}\)\?'  skipwhite  nextgroup=LogTimeZone,LogTimeAMPM,LogSysColumns
" AM / PM
syn match LogTimeAMPM   display     '\cAM\|\cPM\>'  contained  skipwhite  nextgroup=LogSysColumns
" Time zone e.g. Z, +08:00, PST
syn match LogTimeZone   display     'Z\|[+-]\d\{2}:\d\{2}\|\a\{3}\>'  contained  skipwhite  nextgroup=LogSysColumns

" Duration e.g. 10d20h30m40s, 123.456s, 123ms, 456us, 789ns
syn match LogDuration   display     '\(\(\(\d\+d\)\?\d\+h\)\?\d\+m\)\?\d\+\(\.\d\+\)\?[mun]\?s\>'

" System info
" ------------------------------
" Match letters & digits, dots, underscores and hyphens in system columns.
" Usually the first column is the host name or log level keywords.
syn match LogSysColumns     display     '\<[[:alnum:]\._-]\+ [[:alnum:]\._-]\+\(\[[[:digit:]:]\+\]\)\?:'  contained  contains=@LogLvs,LogSysProcess
syn match LogSysProcess     display     '\<[[:alnum:]\._-]\+\(\[[[:digit:]:]\+\]\)\?:'  contained  contains=LogNumber

" Objects
" ------------------------------
syn match LogUrl        display     '\<https\?:\/\/\S\+'
syn match LogIPv4       display     '\<\d\{1,3}\(\.\d\{1,3}\)\{3}\(\/\d\+\)\?\>'
syn match LogIPv6       display     '\<\x\{1,4}\(:\x\{1,4}\)\{7}\(\/\d\+\)\?\>'
syn match LogMacAddr    display     '\<\x\{2}\([:-]\?\x\{2}\)\{5}\>'
syn match LogUUID       display     '\<\x\{8}-\x\{4}-\x\{4}-\x\{4}-\x\{12}\>'
syn match LogMD5        display     '\<\x\{32}\>'
syn match LogSHA        display     '\<\(\x\{40}\|\x\{56}\|\x\{64}\|\x\{96}\|\x\{128}\)\>'

" Only highlight a path which is at the start of a line, or preceded by a space
" or an equal sign (for env vars, e.g. PATH=/usr/bin)
" POSIX-style path    e.g. '/var/log/system.log', './run.sh', '../a/b', '~/c'.
syn match LogPath       display     '\(^\|\s\|=\)\zs\(\.\{0,2}\|\~\)\/[^ \t\n\r]\+\ze'
" Windows drive path  e.g. 'C:\Users\Test'
syn match LogPath       display     '\(^\|\s\|=\)\zs\a:\\[^ \t\n\r]\+\ze'
" Windows UNC path    e.g. '\\server\share'
syn match LogPath       display     '\(^\|\s\|=\)\zs\\\\[^ \t\n\r]\+\ze'

" Log Levels
" ------------------------------
syn keyword LogLvFatal      FATAL Fatal fatal
syn keyword LogLvEmergency  EMERGENCY EMERG Emergency emergency
syn keyword LogLvAlert      ALERT Alert alert
syn keyword LogLvCritical   CRITICAL CRIT Critical critical
syn keyword LogLvError      ERROR ERRORS ERR E Error Errors Err error errors err
syn keyword LogLvFailure    FAILURE FAILED FAIL F Failure Failed Fail failure failed fail
syn keyword LogLvFault      FAULT Fault fault
syn keyword LogLvNack       NACK NAK Nack Nak nack nak
syn keyword LogLvWarning    WARNING WARN W Warning Warn warning warn
syn keyword LogLvBad        BAD Bad bad
syn keyword LogLvNotice     NOTICE
syn keyword LogLvInfo       INFO I Info info
syn keyword LogLvDebug      DEBUG DBG D Debug Dbg debug dbg
syn keyword LogLvTrace      TRACE Trace trace
syn keyword LogLvPass       PASS PASSED Pass Passed pass passed
syn keyword LogLvSuccess    SUCCESS SUCCEEDED Success Succeeded success succeeded

" Composite log levels e.g. *_INFO
syn match LogLvFatal        display '\<\u\+_FATAL\>'
syn match LogLvEmergency    display '\<\u\+_EMERG\(ENCY\)\?\>'
syn match LogLvAlert        display '\<\u\+_ALERT\>'
syn match LogLvCritical     display '\<\u\+_CRIT\(ICAL\)\?\>'
syn match LogLvError        display '\<\u\+_ERR\(OR\)\?\>'
syn match LogLvFailure      display '\<\u\+_FAIL\(URE\)\?\>'
syn match LogLvWarning      display '\<\u\+_WARN\(ING\)\?\>'
syn match LogLvNotice       display '\<\u\+_NOTICE\>'
syn match LogLvInfo         display '\<\u\+_INFO\>'
syn match LogLvDebug        display '\<\u\+_DEBUG\>'
syn match LogLvTrace        display '\<\u\+_TRACE\>'

syn cluster LogLvs contains=LogLvFatal,LogLvEmergency,LogLvAlert,LogLvCritical,LogLvError,LogLvFailure,LogLvFault,LogLvNack,LogLvWarning,LogLvBad,LogLvNotice,LogLvInfo,LogLvDebug,LogLvTrace

" Highlight Links
" ------------------------------
hi def link LogNumber           Number
hi def link LogNumberFloat      Float
hi def link LogNumberBin        Number
hi def link LogNumberOctal      Number
hi def link LogNumberHex        Number

hi def link LogSymbol           Special
hi def link LogSeparatorLine    Comment

hi def link LogBool             Boolean
hi def link LogNull             Constant
hi def link LogString           String

hi def link LogDate             Type
hi def link LogWeekdayStr       Type
hi def link LogTime             Operator
hi def link LogTimeAMPM         Operator
hi def link LogTimeZone         Operator
hi def link LogDuration         Operator

hi def link LogSysColumns       Statement
hi def link LogSysProcess       Function

hi def link LogUrl              Underlined
hi def link LogIPv4             Underlined
hi def link LogIPv6             Underlined
hi def link LogMacAddr          Underlined
hi def link LogUUID             Label
hi def link LogMD5              Label
hi def link LogSHA              Label
hi def link LogPath             Structure

hi def link LogLvFatal          ErrorMsg
hi def link LogLvEmergency      ErrorMsg
hi def link LogLvAlert          ErrorMsg
hi def link LogLvCritical       ErrorMsg
hi def link LogLvError          ErrorMsg
hi def link LogLvFailure        ErrorMsg
hi def link LogLvFault          ErrorMsg
hi def link LogLvNack           ErrorMsg
hi def link LogLvWarning        WarningMsg
hi def link LogLvBad            WarningMsg
hi def link LogLvNotice         Exception
hi def link LogLvInfo           MoreMsg
hi def link LogLvDebug          Debug
hi def link LogLvTrace          Debug
hi def link LogLvPass           LogGreen
hi def link LogLvSuccess        LogGreen

" Custom highlight group
" ------------------------------
hi LogGreen     ctermfg=lightgreen guifg=#a4c672


let b:current_syntax = "log"

let &cpo = s:cpo_save
unlet s:cpo_save
