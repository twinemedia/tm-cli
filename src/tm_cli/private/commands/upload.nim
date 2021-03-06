import tm_client

import asyncdispatch
import sequtils
import options
import os
import strformat

import ../objects
import ../config
import ../utils

proc uploadCommand*(args: Args, path: string, tags: seq[string]): Future[void] {.async.} =
    ## The upload command
    
    # Make sure config is present
    if not isConfigCreated():
        echo "Configuration is not created. Use \"configure\" to create it."
        system.quit(1)
    
    # Check if file exists
    if not fileExists(path):
        echo fmt"File ""{path}"" does not exist"
        system.quit(1)
    
    # Read configuration
    let cfg = readConfig().adjustedForArgs(args)

    # Figure out all tags to use
    let allTags = cfg.tags.concat(tags)

    # Create TM client
    let client = tm_client.createClientWithToken(cfg.url, cfg.token)

    # Upload file
    let id = await client.uploadFile(
        path = path,
        name = none[string](),
        description = none[string](),
        tags = some[seq[string]](allTags),
        noThumbnail = false,
        doNotProcess = false,
        ignoreHash = false,
        source = if cfg.source < 0: none[int]() else: some[int](cfg.source)
    )

    # Print download link
    echo client.idToDownloadUrl(id, path.filenameInPath)