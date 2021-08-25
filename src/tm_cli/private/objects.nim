import options

type
    Config* = object
        ## Object representation of the program configuration
        
        url*: string
        token*: string
        tags*: seq[string]
        source*: int
    
    Args* = object
        ## Object that contains arguments
        
        command*: string
        args*: seq[string]
        options*: seq[ArgOption]
    
    ArgOption* = object
        ## Object that contains argument option values
        
        key*: string
        value*: Option[string]