import tm_client

import asyncdispatch
import strutils

import ../objects
import ../config
import ../utils
import ../constants

proc tagsCommand*(args: Args, tags: seq[string], excludeTags: seq[string], page: int = 1): Future[void] {.async.} =
    ## The tags command
    
    # Make sure config is present
    if not isConfigCreated():
        echo "Configuration is not created. Use \"configure\" to create it."
        system.quit(1)
    
    # Read configuration
    let cfg = readConfig().adjustedForArgs(args)

    # Create TM client
    let client = tm_client.createClientWithToken(cfg.url, cfg.token)

    # Fetch files
    let realPage = max(page, 1)
    let offset = PAGE_SIZE*(realPage-1)
    let limit = PAGE_SIZE
    let res = await client.fetchMediaByTags(
        tags = tags,
        excludeTags = excludeTags,
        offset = offset,
        limit = limit
    )

    # Print results
    client.printFileResults(res, realPage)