import tm_client

import strutils
import asyncdispatch

import ../config
import ../objects

proc cfgExistsOrQuit() =
    if not isConfigCreated():
        echo "Configuration is not created. Use \"configure\" to create it."
        system.quit(1)

proc configureCommand*(): Future[void] {.async.} =
    ## The configure command
    
    var cfg = Config()

    # Display warning if config is already found
    let cfgCreated = isConfigCreated()
    if cfgCreated:
        echo "WARNING: A configuration already exists, this command will overwrite the previous configuration"
        cfg = readConfig()
    
    stdout.write("Enter instance URL"&(if cfgCreated: " ["&cfg.url&"]" else: "")&": ")
    var url = stdin.readLine
    if url.isEmptyOrWhitespace:
        if cfgCreated:
            url = cfg.url
        else:
            echo "URL cannot be blank"
            system.quit(1)
    cfg.url = url

    stdout.write("Enter token"&(if cfgCreated: " ["&cfg.token&"]" else: "")&": ")
    var token = stdin.readLine
    if token.isEmptyOrWhitespace:
        if cfgCreated:
            token = cfg.token
        else:
            echo "Token cannot be blank"
            system.quit(1)
    cfg.token = token

    stdout.write("Enter tags to be added to uploaded files (space separated)"&(if cfgCreated: " (~ for none) ["&cfg.tags.join(" ")&"]" else: "")&": ")
    var tags = stdin.readLine.splitWhitespace(-1)
    if tags.len < 1 or tags[0].isEmptyOrWhitespace:
        if cfgCreated:
            tags = cfg.tags
        else:
            tags = @[]
    elif tags.len > 0 and tags[0] == "~":
        tags = @[]
    cfg.tags = tags

    stdout.write("Enter media source ID (-1 for account default)"&(if cfgCreated: " ["&($cfg.source)&"]" else: "")&": ")
    var sourceRaw = stdin.readLine
    var source = -1
    if sourceRaw.isEmptyOrWhitespace:
        if cfgCreated:
            source = cfg.source
        else:
            echo "Media source cannot be blank"
            system.quit(1)
    else:
        source = sourceRaw.parseInt
    cfg.source = source

    echo "Configuration:"
    echo "URL: "&url
    echo "Token: "&token
    echo "Tags: "&(tags.join(" "))
    echo "Source ID: "&($source)
    
    echo "Testing configuration..."

    # Create client
    let client = createClientWithToken(url, token)

    # Fetch info
    discard await client.fetchSelfAccountInfo()

    # Check for relevant permissions
    var warnings = 0
    if not client.hasPermission("upload"):
        inc warnings
        echo "WARNING: Token or account is missing permission \"upload\" which is required to upload files"
    if not client.hasPermission("files.list"):
        inc warnings
        echo "WARNING: Token or account is missing permission \"files.list\" which is required to search files"
    if not client.hasPermission("files.view"):
        inc warnings
        echo "WARNING: Token or account is missing permission \"files.view\" which is required to view file info"
    if not client.hasPermission("files.delete"):
        inc warnings
        echo "WARNING: Token or account is missing permission \"files.delete\" which is required to delete files"
    if not client.hasPermission("sources.list"):
        inc warnings
        echo "WARNING: Token or account is missing permission \"sources.list\" which is required to use non-default media sources"
    
    stdout.write("Save configuration? [y/N]: ")
    let confirm = stdin.readLine.toLower
    
    if confirm == "y":
        saveConfig(cfg)
        echo "Configuration saved"

proc configureUrlCommand*(url: string) =
    ## The url subcommand of configure
    
    cfgExistsOrQuit()

    var cfg = readConfig()
    cfg.url = url
    saveConfig(cfg)

proc configureTokenCommand*(token: string) =
    ## The token subcommand of configure
    
    cfgExistsOrQuit()

    var cfg = readConfig()
    cfg.token = token
    saveConfig(cfg)

proc configureTagsCommand*(tags: seq[string]) =
    ## The tags subcommand of configure
    
    cfgExistsOrQuit()

    var cfg = readConfig()
    cfg.tags = tags
    saveConfig(cfg)

proc configureSourceCommand*(id: int) =
    ## The source subcommand of configure
    
    cfgExistsOrQuit()

    var cfg = readConfig()
    cfg.source = id
    saveConfig(cfg)