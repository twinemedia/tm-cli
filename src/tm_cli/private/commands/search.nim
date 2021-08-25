import tm_client

import asyncdispatch
import strformat
import strutils
import terminal

import ../objects
import ../config
import ../utils
import ../constants

proc searchCommand*(args: Args, query: string, page: int = 1): Future[void] {.async.} =
    ## The search command
    
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
    let res = await client.fetchMediaByPlaintextSearch(
        query = query,
        searchNames = true,
        searchFilenames = true,
        searchDescriptions = true,
        searchTags = true,
        offset = offset,
        limit = limit
    )

    # Print results
    if res.len > 0:
        let openMsg = if res.len >= PAGE_SIZE:
            fmt"===== Returned {res.len} results - see next page with --page={realPage+1} ====="
        else:
            fmt"===== Returned {res.len} results ====="
        echo openMsg
        
        for file in res:
            writeStyled(fmt"{file.name} ({formatSize(file.size)})", { styleBright })
            stdout.write(" - ")
            writeStyled($client.idToDownloadUrl(file.id, file.filename), { styleItalic })
            echo ""
        
        echo '='.genStr(openMsg.len)
    else:
        echo "No results"