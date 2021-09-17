# Package

version       = "0.1.0"
author        = "Termer"
description   = "A command line interface for interacting with TwineMedia"
license       = "MIT"
srcDir        = "src"
namedBin["tm_cli"] = "tm"


# Dependencies

requires "nim >= 1.4.8"
requires "tm_client >= 0.1.2"