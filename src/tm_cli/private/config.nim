import json
import os

import tm_client/private/utils
import constants

import objects

proc getConfigPath*(): string = getHomeDir().stripTrailingSlash&'/'&CONFIG_NAME

proc isConfigCreated*(): bool =
    ## Returns whether th config has been created
    
    return fileExists(getConfigPath())

proc configToJson*(cfg: Config): JsonNode =
    ## Serializes a Config instance to JSON

    return %*{
        "token": cfg.token,
        "url": cfg.url,
        "tags": cfg.tags.stringSeqToJsonArray,
        "source": cfg.source
    }

proc readConfig*(): Config =
    ## Reads the configuration and returns the deserialized Config object representing it
    
    let json = readFile(getConfigPath()).parseJson
    
    return json.to(Config)

proc saveConfig*(cfg: Config) =
    ## Saves a configuration to disk
    
    writeFile(getConfigPath(), $cfg.configToJson)