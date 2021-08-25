const VERSION* = "0.1.0"
const VERSION_INT* = 0

const HELP_STR* = "TwineMedia command line interface v"&VERSION&"""
Usage: tm <action> <arguments>
  Available actions (* means required, ... means 0 or more, "" means literal):
    "help", "h": Shows this message

    "upload", "u": Uploads a file
      *path: The path to the file to upload
      *...tags: Tags to give to the file
    
    "search", "s": Searches files by a plaintext query
      query: The search query (use "%" to search everything)
      --page=<page>: The page number
    
    "tags", "t": Searches files by tags
      *...tags: Tags to search for (supports excluding tags like "-cat")
      --page=<page>: The page number
    
    "delete", "d": Deletes a file
      *id: The ID of the file to delete
    
    "configure", "c": Configures the program with an interactive wizard (if not specifying any sub-actions)
      "url": Sets the instance URL to interact with
        *url: The instance URL
      "token": Sets the API token to use
        *token: The API token
      "tags": Sets the tags to add to uploaded files
        *...tags: The tags
      "source": Sets the source ID to upload to
        *source: The source ID
  
  Available options:
    --help: Shows this message
    --url=<url>: Overrides the configured URL
    --token=<token>: Overrides the configured token
    --source=<source ID>: Overrides the configured source ID
  
  Examples:
    tm upload awesome.webm tag1 funny last_tag - Uploads "awesome.webm" with the tags "tag1, funny, last_tag"
    tm upload my_file.txt --token=stuffandstuffandstuff - Uploads "my_file.txt", using the token "stuffandstuffandstuff"
    tm search "my search term" - Searches for files that match "my search term"
    tm tags find_this -exclude_this - Searches for files with the tag "find_this" and without the tag "-exclude_this"
    tm configure token mytoken_thing_stuff_this_is_really_long - Sets the configured token to "mytoken_thing_stuff_this_is_really_long"
    tm configure url https://tm.example.org - Sets the configured URL to "https://tm.example.org"
"""

const CONFIG_NAME* = ".tm_cli.json"

const PAGE_SIZE* = 50