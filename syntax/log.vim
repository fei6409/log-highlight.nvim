" Vim syntax file
" Language:         Generic logs
" Maintainer:       fei6409 <fei6409@gmail.com>
" Latest Revision:  2023-05-06

if exists("b:current_syntax")
  finish
endif

let s:cpo_save = &cpo
set cpo&vim

" Separators
" ------------------------------
syn match logSeparatorLine  display     '-\{3,}\|=\{3,}\|#\{3,}\|\*\{3,}\|<\{3,}\|>\{3,}'

" Numbers
" ------------------------------
syn match logNumber         display     '\<\d\+\>'
syn match logNumberFloat    display     '\<\d\+\.\d\+\([eE][+-]\?\d\+\)\?\>'
syn match logNumberBin      display     '\<0[bB][01]\+\>'
syn match logNumberOctal    display     '\<0[oO]\o\+\>'
syn match logNumberHex      display     '\<0[xX]\x\+\>'

" Constants
" ------------------------------
syn keyword logBool    TRUE True true FALSE False false
syn keyword logNull    NULL Null null

" Strings
" ------------------------------
syn region logString      start=/"/  end=/"/  end=/$/  skip=/\\./
syn region logString      start=/`/  end=/`/  end=/$/  skip=/\\./
" Quoted strings, but no match on quotes like `don't`, possessive `s'` and `'s`
syn region logString      start=/\(s\)\@<!'\(s \|t \)\@!/  end=/'/  end=/$/  skip=/\\./

" Date & Time
" ------------------------------
" 2023-01-01 or 2023/01/01 or 01/01/2023 or 01-Jan-2023
syn match logDate       display     '\<\d\{4}[-\/]\(\d\d\|\a\{3}\)[-\/]\d\d\|\d\d[-\/]\(\d\d\|\a\{3}\)[-\/]\d\{4}'  contains=logDateMonth
" RFC3339 e.g. 2023-01-01T
syn match logDate       display     '\<\d\{4}-\d\d-\d\dT'
" YYYYMMDD starting with '20' e.g. 20230101
syn match logDate       display     '\<20\d{6}'
" Day 01-31
syn match logDateDay    display     '0[1-9]\|[1-2]\d\|3[0-1]\>'  contained

" 12:34:56 or 12:34:56.700000Z or 12:34:56.700000+08:00
syn match logTime       display     '\d\d:\d\d:\d\d\(\.\d\{2,6}\)\?'  skipwhite  nextgroup=logTimeZone,logTimeAMPM,logSysColumns
" AM / PM
syn match logTimeAMPM   display     '\cAM\|\cPM\>'  contained  skipwhite  nextgroup=logSysColumns
" Time zones, e.g. PST, CST etc.
syn match logTimeZone   display     'Z\|[+-]\d\d:\d\d\|\a\{3}\>'  contained  skipwhite  nextgroup=logSysColumns

syn keyword logDateMonth    Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec  nextgroup=logDateDay  skipwhite
syn keyword logDateWeekDay  Mon Tue Wed Thu Fri Sat Sun

" System info
" ------------------------------
" Match letters & digits, dots, underscores and hyphens in system columns.
" Usually the first column is the host name or log level keywords.
syn match logSysColumns     display     '\<[[:alnum:]\._-]\+ [[:alnum:]\._-]\+\(\[[[:digit:]:]\+\]\)\?:'  contained  contains=@logLvs,logSysProcess
syn match logSysProcess     display     '\<[[:alnum:]\._-]\+\(\[[[:digit:]:]\+\]\)\?:'  contained  contains=logNumber

" Objects
" ------------------------------
syn match logUrl        display     '\<https\?:\/\/\S\+'
syn match logIPv4       display     '\<\d\{1,3}\(\.\d\{1,3}\)\{3}\>'
syn match logIPv6       display     '\<\x\{1,4}\(:\x\{1,4}\)\{7}\>'
syn match logMacAddr    display     '\x\{2}\(:\x\{2}\)\{5}'
syn match logUUID       display     '\<\x\{8}-\x\{4}-\x\{4}-\x\{4}-\x\{12}\>'
syn match logMD5        display     '\<\x\{32}\>'
syn match logSHA        display     '\<\(\x\{40}\|\x\{56}\|\x\{64}\|\x\{96}\|\x\{128}\)\>'

" Log Levels
" ------------------------------
syn keyword logLvFatal      FATAL
syn keyword logLvEmergency  EMERGENCY EMERG
syn keyword logLvAlert      ALERT
syn keyword logLvCritical   CRITICAL CRIT
syn keyword logLvError      ERROR ERRORS ERR
syn keyword logLvFailure    FAILURE FAILED FAIL
syn keyword logLvWarning    WARNING WARN
syn keyword logLvNotice     NOTICE
syn keyword logLvInfo       INFO
syn keyword logLvDebug      DEBUG DBG
syn keyword logLvTrace      TRACE

syn cluster logLvs contains=logLvFatal,logLvEmergency,logLvAlert,logLvCritical,logLvError,logLvFailure,logLvWarning,logLvNotice,logLvInfo,logLvDebug,logLvTrace

" Highlight Links
" ------------------------------
hi def link logNumber           Number
hi def link logNumberFloat      Float
hi def link logNumberBin        Number
hi def link logNumberOctal      Number
hi def link logNumberHex        Number

hi def link logSeparatorLine    Comment

hi def link logBool             Boolean
hi def link logNull             Constant
hi def link logString           String

hi def link logDate             Identifier
hi def link logDateDay          Identifier
hi def link logDateMonth        Identifier
hi def link logDateWeekDay      Identifier
hi def link logTime             Type
hi def link logTimeAMPM         Type
hi def link logTimeZone         Type

hi def link logSysColumns       Conditional
hi def link logSysProcess       Function

hi def link logUrl              Underlined
hi def link logIPv4             Underlined
hi def link logIPv6             Underlined
hi def link logMacAddr          Label
hi def link logUUID             Label
hi def link logMD5              Label
hi def link logSHA              Label

hi def link logLvFatal       ErrorMsg
hi def link logLvEmergency   ErrorMsg
hi def link logLvAlert       ErrorMsg
hi def link logLvCritical    ErrorMsg
hi def link logLvError       ErrorMsg
hi def link logLvFailure     ErrorMsg
hi def link logLvWarning     WarningMsg
hi def link logLvNotice      Include
hi def link logLvInfo        Repeat
hi def link logLvDebug       Debug
hi def link logLvTrace       Comment


let b:current_syntax = "log"

let &cpo = s:cpo_save
unlet s:cpo_save
