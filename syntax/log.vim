" Vim syntax file
" Language:         Generic logs
" Maintainer:       fei6409 <fei6409@gmail.com>
" Latest Revision:  2025-08-07

if exists("b:current_syntax")
  finish
endif

let s:cpo_save = &cpo
set cpo&vim

" Symbols / special characters
" ------------------------------
syn match logSymbol    display     '[!@#$%^&*;:?]'

" Separators
" ------------------------------
syn match logSeparatorLine  display     '-\{3,}\|=\{3,}\|#\{3,}\|\*\{3,}\|<\{3,}\|>\{3,}'

" Strings
" ------------------------------
syn region logString      start=/"/  end=/"/  end=/$/  skip=/\\./
syn region logString      start=/`/  end=/`/  end=/$/  skip=/\\./
" Quoted strings, but no match on quotes like `don't`, possessive `s'` and `'s`
syn region logString      start=/\(s\)\@<!'\(s \|t \)\@!/  end=/'/  end=/$/  skip=/\\./

" Numbers
" ------------------------------
syn match logNumber         display     '\<\d\+\>'
syn match logNumberFloat    display     '\<\d\+\.\d\+\([eE][+-]\?\d\+\)\?\>'
syn match logNumberBin      display     '\<0[bB][01]\+\>'
syn match logNumberOctal    display     '\<0[oO]\o\+\>'
syn match logNumberHex      display     '\<0[xX]\x\+\>'

" Numbers in Hardware Description Languages e.g. Verilog
" Note that this must come after logString to have a higher priority over it
syn match logNumber         display     '\'d\d\+\>'
syn match logNumberBin      display     '\'b[01]\+\>'
syn match logNumberOctal    display     '\'o\o\+\>'
syn match logNumberHex      display     '\'h\x\+\>'

" Constants
" ------------------------------
syn keyword logBool    TRUE True true FALSE False false
syn keyword logNull    NULL Null null

" Date & Time
" ------------------------------
" MM-DD, DD-MM, MM/DD, DD/MM
syn match logDate       display     '\<\d\{2}[-\/]\d\{2}\>'
" YYYY-MM-DD, YYYY/MM/DD
syn match logDate       display     '\<\d\{4}[-\/]\d\{2}[-\/]\d\{2}\>'
" DD-MM-YYYY, DD/MM/YYYY
syn match logDate       display     '\<\d\{2}[-\/]\d\{2}[-\/]\d\{4}\>'
" First half of RFC3339 e.g. 2023-01-01T
syn match logDate       display     '\<\d\{4}-\d\{2}-\d\{2}T'
" 'Dec 31', 'Dec 31, 2023', 'Dec 31 2023'
syn match logDate       display     '\<\a\{3} \d\{1,2}\(,\? \d\{4}\)\?\>'
" '31-Dec-2023', '31 Dec 2023'
syn match logDate       display     '\<\d\{1,2}[- ]\a\{3}[- ]\d\{4}\>'

" Weekday string
syn keyword logWeekdayStr   Mon Tue Wed Thu Fri Sat Sun

" 12:34:56, 12:34:56.700000
syn match logTime       display     '\d\{2}:\d\{2}:\d\{2}\(\.\d\{2,6}\)\?'  skipwhite  nextgroup=logTimeZone,logTimeAMPM,logSysColumns
" AM / PM
syn match logTimeAMPM   display     '\cAM\|\cPM\>'  contained  skipwhite  nextgroup=logSysColumns
" Time zone e.g. Z, +08:00, PST
syn match logTimeZone   display     'Z\|[+-]\d\{2}:\d\{2}\|\a\{3}\>'  contained  skipwhite  nextgroup=logSysColumns

" Duration e.g. 10d20h30m40s, 123.456s, 123ms, 456us, 789ns
syn match logDuration   display     '\(\(\(\d\+d\)\?\d\+h\)\?\d\+m\)\?\d\+\(\.\d\+\)\?[mun]\?s\>'

" System info
" ------------------------------
" Match letters & digits, dots, underscores and hyphens in system columns.
" Usually the first column is the host name or log level keywords.
syn match logSysColumns     display     '\<[[:alnum:]\._-]\+ [[:alnum:]\._-]\+\(\[[[:digit:]:]\+\]\)\?:'  contained  contains=@logLvs,logSysProcess
syn match logSysProcess     display     '\<[[:alnum:]\._-]\+\(\[[[:digit:]:]\+\]\)\?:'  contained  contains=logNumber

" Objects
" ------------------------------
syn match logUrl        display     '\<https\?:\/\/\S\+'
syn match logIPv4       display     '\<\d\{1,3}\(\.\d\{1,3}\)\{3}\(\/\d\+\)\?\>'
syn match logIPv6       display     '\<\x\{1,4}\(:\x\{1,4}\)\{7}\(\/\d\+\)\?\>'
syn match logMacAddr    display     '\x\{2}\(:\x\{2}\)\{5}'
syn match logUUID       display     '\<\x\{8}-\x\{4}-\x\{4}-\x\{4}-\x\{12}\>'
syn match logMD5        display     '\<\x\{32}\>'
syn match logSHA        display     '\<\(\x\{40}\|\x\{56}\|\x\{64}\|\x\{96}\|\x\{128}\)\>'
" File path starting with '/' , './', '../' and '~/'.
" Must be start-of-line or prefixed with space
syn match logPath       display     '\(^\|\s\)\(\.\{0,2}\|\~\)\/[[:alnum:]\/\.:_-]\+'

" Log Levels
" ------------------------------
syn keyword logLvFatal      FATAL Fatal fatal
syn keyword logLvEmergency  EMERGENCY EMERG Emergency emergency
syn keyword logLvAlert      ALERT Alert alert
syn keyword logLvCritical   CRITICAL CRIT Critical critical
syn keyword logLvError      ERROR ERRORS ERR E Error Errors Err error errors err
syn keyword logLvFailure    FAILURE FAILED FAIL F Failure Failed Fail failure failed fail
syn keyword logLvFault      FAULT Fault fault
syn keyword logLvNack       NACK NAK Nack Nak nack nak
syn keyword logLvWarning    WARNING WARN W Warning Warn warning warn
syn keyword logLvBad        BAD Bad bad
syn keyword logLvNotice     NOTICE
syn keyword logLvInfo       INFO I Info info
syn keyword logLvDebug      DEBUG DBG D Debug Dbg debug dbg
syn keyword logLvTrace      TRACE

" Composite log levels e.g. *_INFO
syn match logLvFatal        display '\<\u\+_FATAL\>'
syn match logLvEmergency    display '\<\u\+_EMERG\(ENCY\)\?\>'
syn match logLvAlert        display '\<\u\+_ALERT\>'
syn match logLvCritical     display '\<\u\+_CRIT\(ICAL\)\?\>'
syn match logLvError        display '\<\u\+_ERR\(OR\)\?\>'
syn match logLvFailure      display '\<\u\+_FAIL\(URE\)\?\>'
syn match logLvWarning      display '\<\u\+_WARN\(ING\)\?\>'
syn match logLvNotice       display '\<\u\+_NOTICE\>'
syn match logLvInfo         display '\<\u\+_INFO\>'
syn match logLvDebug        display '\<\u\+_DEBUG\>'
syn match logLvTrace        display '\<\u\+_TRACE\>'

" spdlog pattern level: [trace] [info] ...
syn match logLvCritical     display '\[\zscritical\ze\]'
syn match logLvError        display '\[\zserror\ze\]'
syn match logLvWarning      display '\[\zswarning\ze\]'
syn match logLvInfo         display '\[\zsinfo\ze\]'
syn match logLvDebug        display '\[\zsdebug\ze\]'
syn match logLvTrace        display '\[\zstrace\ze\]'

syn cluster logLvs contains=logLvFatal,logLvEmergency,logLvAlert,logLvCritical,logLvError,logLvFailure,logLvFault,logLvNack,logLvWarning,logLvBad,logLvNotice,logLvInfo,logLvDebug,logLvTrace

" Highlight Links
" ------------------------------
hi def link logNumber           Number
hi def link logNumberFloat      Float
hi def link logNumberBin        Number
hi def link logNumberOctal      Number
hi def link logNumberHex        Number

hi def link logSymbol           Special
hi def link logSeparatorLine    Comment

hi def link logBool             Boolean
hi def link logNull             Constant
hi def link logString           String

hi def link logDate             Type
hi def link logWeekdayStr       Type
hi def link logTime             Operator
hi def link logTimeAMPM         Operator
hi def link logTimeZone         Operator
hi def link logDuration         Operator

hi def link logSysColumns       Statement
hi def link logSysProcess       Function

hi def link logUrl              Underlined
hi def link logIPv4             Underlined
hi def link logIPv6             Underlined
hi def link logMacAddr          Label
hi def link logUUID             Label
hi def link logMD5              Label
hi def link logSHA              Label
hi def link logPath             Structure

hi def link logLvFatal          ErrorMsg
hi def link logLvEmergency      ErrorMsg
hi def link logLvAlert          ErrorMsg
hi def link logLvCritical       ErrorMsg
hi def link logLvError          ErrorMsg
hi def link logLvFailure        ErrorMsg
hi def link logLvFault          ErrorMsg
hi def link logLvNack           ErrorMsg
hi def link logLvWarning        WarningMsg
hi def link logLvBad            WarningMsg
hi def link logLvNotice         Exception
hi def link logLvInfo           MoreMsg
hi def link logLvDebug          Debug
hi def link logLvTrace          Comment


let b:current_syntax = "log"

let &cpo = s:cpo_save
unlet s:cpo_save
