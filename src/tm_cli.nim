import asyncdispatch
import strformat
import strutils
import options
import terminal

import tm_cli/private/constants
import tm_cli/private/utils

import tm_cli/private/commands/upload
import tm_cli/private/commands/configure
import tm_cli/private/commands/search
import tm_cli/private/commands/tags

proc main(): Future[void] {.async.} =
    let parsedArgs = parseArgs()
    let args = parsedArgs.args

    if parsedArgs.hasOption("help"):
        echo HELP_STR
        system.quit(0)

    if args.len < 1:
        echo "You must specify an action. Use \"--help\" to show program help."
        system.quit(1)
    
    let action = args[0].toLower
    
    if action == "upload" or action == "u":
        if args.len < 2:
            echo "You must specify file path"
            system.quit(1)
        
        let path = args[1]
        let tags = args.slice(2)
        
        await uploadCommand(parsedArgs, path, tags)
    elif action == "configure" or action == "c":
        if args.len > 1:
            let sub = args[1].toLower

            if args.len < 3:
                echo "Missing argument for "&sub
                system.quit(1)
            
            let arg = args[2]

            if sub == "url":
                configureUrlCommand(arg)
            elif sub == "token":
                configureTokenCommand(arg)
            elif sub == "tags":
                configureTagsCommand(args.slice(2))
            elif sub == "source":
                configureSourceCommand(arg.parseInt)
            else:
                echo "Unknown sub-action "&sub
                system.quit(1)
        else:
            await configureCommand()
    elif action == "search" or action == "s":
        let query = if args.len > 1: args[1] else: "%"
        let pageOp = parsedArgs.getOption("page")
        let page = if pageOp.isSome: pageOp.get.parseInt else: 1

        await searchCommand(parsedArgs, query, page)
    elif action == "tags" or action == "t":
        # Determine which tags are normal and which are to be excluded
        let tagsRaw = args.slice(1)
        var tags = newSeq[string]()
        var excludeTags = newSeq[string]()

        for tag in tagsRaw:
            if tag.startsWith('-'):
                excludeTags.add(tag.substr(1))
            else:
                tags.add(tag)

        let pageOp = parsedArgs.getOption("page")
        let page = if pageOp.isSome: pageOp.get.parseInt else: 1

        await tagsCommand(parsedArgs, tags, excludeTags, page)
    elif action == "help" or action == "h":
        echo HELP_STR
        system.quit(1)
    else:
        echo fmt"Unknown action ""{action}"". Use ""--help"" to show available actions."

# Remove terminal color attributes after
system.addQuitProc(resetAttributes)

# Run program
when isMainModule:
    waitFor main()