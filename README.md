# tm-cli
A command line interface for interacting with TwineMedia

# Compile
First, make sure you have Nim and [Nimble](https://github.com/nim-lang/nimble) installed. Then, clone the repsitory.

Once you have Nimble and the code, go into the code directory and run `nimble install`. If all does well, you will have the software installed, and available as the binary `tm` (or perhaps `tm.exe` on Windows).

# TODO
Features that I would like to get done.

## Interactive and programmatic file editing
Example: `tm edit abcdefghij`
Example: `tm edit abcdefghij set --name="My File" --description="My stuff is my stuff" --tags="tag1 tag2"`

Interactive would let you fill out each field, and each field would be auto-filled with the existing value.