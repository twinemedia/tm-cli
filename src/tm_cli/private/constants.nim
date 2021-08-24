const VERSION* = "0.1.0"
const VERSION_INT* = 0

const HELP_STR* = "TwineMedia command line interface v"&VERSION&"""
Usage: tm <action> <arguments>
  Available actions (* means required, ... means 0 or more, "" means literal):
    "up", "upload": Uploads a file
      *path: The path to the file to upload
      *...tags: Tags to give to the file
    
    "configure", cfg: Configures the program with an interactive wizard (if not specifying any sub-actions)
      "url": Sets the instance URL to interact with
        *url: The instance URL
      "token": Sets the API token to use
        *token: The API token
      "tags": Sets the tags to add to uploaded files
        *...tags: The tags
      "source": Sets the source ID to upload to
        *source: The source ID
  
  Examples:
    tm up awesome.webm tag1 funny last_tag
    tm configure token mytoken_thing_stuff_this_is_really_long
    tm configure url https://tm.example.org
"""

const CONFIG_NAME* = ".tm_cli.json"