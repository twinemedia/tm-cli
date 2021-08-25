import strformat
import strutils
import json
import options
import os

import objects

proc slice*[T](s: seq[T], startIndex: int, endIndex: int): seq[T] =
    ## Takes a slice out of a sequence. Works the same way as JavaScript's array slice menthod

    let realEnd = if endIndex < 0:
        s.len-1+endIndex
    else:
        endIndex
    
    let len = realEnd-startIndex+1
    if len < 0:
        raise newException(IndexError, fmt"The size between indexes {startIndex} and {realEnd} is less than 0")

    var res = newSeq[T](len)

    for i in startIndex..realEnd:
        res[i-startIndex] = s[i]

    return res

proc slice*[T](s: seq[T], startIndex: int): seq[T] =
    ## Takes a slice out of a sequence. Works the same way as JavaScript's array slice menthod
    
    return s.slice(startIndex, s.len-1)

proc filenameInPath*(path: string): string =
    ## Returns the filename in a path
    
    let index = path.find('/')
    
    if index > -1:
        let parts = path.split('/')
        return parts[parts.len-1]
    else:
        return path

proc parseArgs*(): Args =
    ## Parses the current command line arguments
    
    let cmd = if paramCount() > 0: paramStr(0) else: ""
    var args = newSeq[string]()
    var options = newSeq[ArgOption]()

    for i in 1..paramCount():
        let str = paramStr(i)
        if str.startsWith("--"):
            let opStr = str.substr(2)

            if str.contains("="):
                let index = opStr.find('=')
                let key = opStr.substr(0, index-1).toLower
                let value = opStr.substr(index+1)
                options.add(ArgOption(key: key, value: some[string](value)))
            else:
                options.add(ArgOption(key: opStr.toLower, value: none[string]()))
        else:
            args.add(str)
    
    return Args(command: cmd, args: args, options: options)

proc hasOption*(args: Args, option: string): bool =
    ## Returns whether the parsed command line arguments contains the provided option

    let key = option.toLower

    for op in args.options:
        if op.key == key:
            return true
    
    return false

proc getOption*(args: Args, option: string): Option[string] =
    ## Returns the value of the specified option, or none if there is no value or the option does not exist
    
    let key = option.toLower

    for op in args.options:
        if op.key == key:
            return op.value
    
    return none[string]()

proc adjustedForArgs*(config: Config, args: Args): Config =
    ## Returns a version of a Config object adjusted for arguments and options

    var cfg = config.deepCopy

    let url = args.getOption("url")
    let token = args.getOption("token")
    let source = args.getOption("source")

    if url.isSome:
        cfg.url = url.get
    if token.isSome:
        cfg.token = token.get
    if source.isSome:
        cfg.source = source.get.parseInt
    
    return cfg

proc genStr*(c: char, len: int): string =
    ## Generates a string of the specified length using the provided character

    var str = newString(len)

    for i in countup(0, len-1):
        str[i] = c
    
    return str