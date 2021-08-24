import commandant

import asyncdispatch
import strformat
import strutils
import sequtils

import tm_cli/private/constants
import tm_cli/private/utils
import tm_cli/private/commands/upload
import tm_cli/private/commands/configure

proc main(): Future[void] {.async.} =
    # Define arguments
    arguments allArgs, string
    commandline:
        exitoption "help", "h", HELP_STR
        errormsg "You must specify an action. Use \"--help\" to show program help."
    
    let action = allArgs[0].toLower
    
    if action == "up" or action == "upload":
        if allArgs.len < 2:
            echo "You must specify file path"
            system.quit(1)
        
        let path = allArgs[1]
        let tags = allArgs.slice(2)
        
        await uploadCommand(path, tags)
    elif action == "cfg" or action == "configure":
        if allArgs.len > 1:
            let sub = allArgs[1].toLower

            if allArgs.len < 3:
                echo "Missing argument for "&sub
                system.quit(1)
            
            let arg = allArgs[2]

            if sub == "url":
                configureUrlCommand(arg)
            elif sub == "token":
                configureTokenCommand(arg)
            elif sub == "tags":
                configureTagsCommand(allArgs.slice(2))
            elif sub == "source":
                configureSourceCommand(arg.parseInt)
            else:
                echo "Unknown sub-action "&sub
                system.quit(1)
        else:
            await configureCommand()

# Run program
when isMainModule:
    waitFor main()