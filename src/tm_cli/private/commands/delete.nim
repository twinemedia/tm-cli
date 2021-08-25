import tm_client

import asyncdispatch
import strutils

import ../objects
import ../config
import ../utils

proc deleteCommand*(args: Args, id: string): Future[void] {.async.} =
    ## The delete command
    
    # Make sure config is present
    if not isConfigCreated():
        echo "Configuration is not created. Use \"configure\" to create it."
        system.quit(1)
    
    # Read configuration
    let cfg = readConfig().adjustedForArgs(args)

    # Create TM client
    let client = tm_client.createClientWithToken(cfg.url, cfg.token)

    # Delete file
    await client.deleteFile(id)

    echo "Deleted file "&id