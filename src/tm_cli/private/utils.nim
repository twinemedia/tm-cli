import strformat
import strutils
import json

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