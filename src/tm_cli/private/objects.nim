type
    Config* = object
        ## Object representation of the program configuration
        
        url*: string
        token*: string
        tags*: seq[string]
        source*: int