module Elmi.Ascii exposing (..)

{-|

# Simple ascii table

## to string

@docs toString, toChar

## from string

@docs fromString, fromChar

-}


{-| Will discard un-recognized chars.
-}
toString : List Int -> String
toString =
    List.foldr String.cons ""
        << List.filterMap toChar


{-| Only return chars (from 0x20 to 0x7e)
-}
toChar : Int -> Maybe Char
toChar c =
    -- Symbols 1/4
    if c == 0x20 then
        Just ' '
    else if c == 0x21 then
        Just '!'
    else if c == 0x22 then
        Just '"'
    else if c == 0x23 then
        Just '#'
    else if c == 0x24 then
        Just '$'
    else if c == 0x25 then
        Just '%'
    else if c == 0x26 then
        Just '&'
    else if c == 0x27 then
        Just '"'
    else if c == 0x28 then
        Just '('
    else if c == 0x29 then
        Just ')'
    else if c == 0x2A then
        Just '*'
    else if c == 0x2B then
        Just '+'
    else if c == 0x2C then
        Just ','
    else if c == 0x2D then
        Just '-'
    else if c == 0x2E then
        Just '.'
    else if c == 0x2F then
        Just '/'
        -- Numbers
    else if c == 0x30 then
        Just '0'
    else if c == 0x31 then
        Just '1'
    else if c == 0x32 then
        Just '2'
    else if c == 0x33 then
        Just '3'
    else if c == 0x34 then
        Just '4'
    else if c == 0x35 then
        Just '5'
    else if c == 0x36 then
        Just '6'
    else if c == 0x37 then
        Just '7'
    else if c == 0x38 then
        Just '8'
    else if c == 0x39 then
        Just '9'
        -- Symbols 2/4
    else if c == 0x3A then
        Just ':'
    else if c == 0x3B then
        Just ';'
    else if c == 0x3C then
        Just '<'
    else if c == 0x3D then
        Just '='
    else if c == 0x3E then
        Just '>'
    else if c == 0x3F then
        Just '?'
    else if c == 0x40 then
        Just '@'
        -- Uppercases
    else if c == 0x41 then
        Just 'A'
    else if c == 0x42 then
        Just 'B'
    else if c == 0x43 then
        Just 'C'
    else if c == 0x44 then
        Just 'D'
    else if c == 0x45 then
        Just 'E'
    else if c == 0x46 then
        Just 'F'
    else if c == 0x47 then
        Just 'G'
    else if c == 0x48 then
        Just 'H'
    else if c == 0x49 then
        Just 'I'
    else if c == 0x4A then
        Just 'J'
    else if c == 0x4B then
        Just 'K'
    else if c == 0x4C then
        Just 'L'
    else if c == 0x4D then
        Just 'M'
    else if c == 0x4E then
        Just 'N'
    else if c == 0x4F then
        Just 'O'
    else if c == 0x50 then
        Just 'P'
    else if c == 0x51 then
        Just 'Q'
    else if c == 0x52 then
        Just 'R'
    else if c == 0x53 then
        Just 'S'
    else if c == 0x54 then
        Just 'T'
    else if c == 0x55 then
        Just 'U'
    else if c == 0x56 then
        Just 'V'
    else if c == 0x57 then
        Just 'W'
    else if c == 0x58 then
        Just 'X'
    else if c == 0x59 then
        Just 'Y'
    else if c == 0x5A then
        Just 'Z'
        -- Symbols 3/4
    else if c == 0x5B then
        Just '['
    else if c == 0x5C then
        Just '\\'
    else if c == 0x5D then
        Just ']'
    else if c == 0x5E then
        Just '^'
    else if c == 0x5F then
        Just '_'
    else if c == 0x60 then
        Just '`'
        -- Lowercases
    else if c == 0x61 then
        Just 'a'
    else if c == 0x62 then
        Just 'b'
    else if c == 0x63 then
        Just 'c'
    else if c == 0x64 then
        Just 'd'
    else if c == 0x65 then
        Just 'e'
    else if c == 0x66 then
        Just 'f'
    else if c == 0x67 then
        Just 'g'
    else if c == 0x68 then
        Just 'h'
    else if c == 0x69 then
        Just 'i'
    else if c == 0x6A then
        Just 'j'
    else if c == 0x6B then
        Just 'k'
    else if c == 0x6C then
        Just 'l'
    else if c == 0x6D then
        Just 'm'
    else if c == 0x6E then
        Just 'n'
    else if c == 0x6F then
        Just 'o'
    else if c == 0x70 then
        Just 'p'
    else if c == 0x71 then
        Just 'q'
    else if c == 0x72 then
        Just 'r'
    else if c == 0x73 then
        Just 's'
    else if c == 0x74 then
        Just 't'
    else if c == 0x75 then
        Just 'u'
    else if c == 0x76 then
        Just 'v'
    else if c == 0x77 then
        Just 'w'
    else if c == 0x78 then
        Just 'x'
    else if c == 0x79 then
        Just 'y'
    else if c == 0x7A then
        Just 'z'
        -- Symbols 4/4
    else if c == 0x7B then
        Just '{'
    else if c == 0x7C then
        Just '|'
    else if c == 0x7D then
        Just '}'
    else if c == 0x7E then
        Just '~'
    else
        Just '•'


{-| Will discard non-ascii chars
-}
fromString : String -> List Int
fromString =
    List.filterMap fromChar
        << String.toList


{-| Only returns valid ascii chars (from 0x20 to 0x7e)
-}
fromChar : Char -> Maybe Int
fromChar c =
    -- Symbols 1/4
    if c == ' ' then
        Just 0x20
    else if c == '!' then
        Just 0x21
    else if c == '"' then
        Just 0x22
    else if c == '#' then
        Just 0x23
    else if c == '$' then
        Just 0x24
    else if c == '%' then
        Just 0x25
    else if c == '&' then
        Just 0x26
    else if c == '"' then
        Just 0x27
    else if c == '(' then
        Just 0x28
    else if c == ')' then
        Just 0x29
    else if c == '*' then
        Just 0x2A
    else if c == '+' then
        Just 0x2B
    else if c == ',' then
        Just 0x2C
    else if c == '-' then
        Just 0x2D
    else if c == '.' then
        Just 0x2E
    else if c == '/' then
        Just 0x2F
        -- Numbers
    else if c == '0' then
        Just 0x30
    else if c == '1' then
        Just 0x31
    else if c == '2' then
        Just 0x32
    else if c == '3' then
        Just 0x33
    else if c == '4' then
        Just 0x34
    else if c == '5' then
        Just 0x35
    else if c == '6' then
        Just 0x36
    else if c == '7' then
        Just 0x37
    else if c == '8' then
        Just 0x38
    else if c == '9' then
        Just 0x39
        -- Symbols 2/4
    else if c == ':' then
        Just 0x3A
    else if c == ';' then
        Just 0x3B
    else if c == '<' then
        Just 0x3C
    else if c == '=' then
        Just 0x3D
    else if c == '>' then
        Just 0x3E
    else if c == '?' then
        Just 0x3F
    else if c == '@' then
        Just 0x40
        -- Uppercases
    else if c == 'A' then
        Just 0x41
    else if c == 'B' then
        Just 0x42
    else if c == 'C' then
        Just 0x43
    else if c == 'D' then
        Just 0x44
    else if c == 'E' then
        Just 0x45
    else if c == 'F' then
        Just 0x46
    else if c == 'G' then
        Just 0x47
    else if c == 'H' then
        Just 0x48
    else if c == 'I' then
        Just 0x49
    else if c == 'J' then
        Just 0x4A
    else if c == 'K' then
        Just 0x4B
    else if c == 'L' then
        Just 0x4C
    else if c == 'M' then
        Just 0x4D
    else if c == 'N' then
        Just 0x4E
    else if c == 'O' then
        Just 0x4F
    else if c == 'P' then
        Just 0x50
    else if c == 'Q' then
        Just 0x51
    else if c == 'R' then
        Just 0x52
    else if c == 'S' then
        Just 0x53
    else if c == 'T' then
        Just 0x54
    else if c == 'U' then
        Just 0x55
    else if c == 'V' then
        Just 0x56
    else if c == 'W' then
        Just 0x57
    else if c == 'X' then
        Just 0x58
    else if c == 'Y' then
        Just 0x59
    else if c == 'Z' then
        Just 0x5A
        -- Symbols 3/4
    else if c == '[' then
        Just 0x5B
    else if c == '\\' then
        Just 0x5C
    else if c == ']' then
        Just 0x5D
    else if c == '^' then
        Just 0x5E
    else if c == '_' then
        Just 0x5F
    else if c == '`' then
        Just 0x60
        -- Lowercases
    else if c == 'a' then
        Just 0x61
    else if c == 'b' then
        Just 0x62
    else if c == 'c' then
        Just 0x63
    else if c == 'd' then
        Just 0x64
    else if c == 'e' then
        Just 0x65
    else if c == 'f' then
        Just 0x66
    else if c == 'g' then
        Just 0x67
    else if c == 'h' then
        Just 0x68
    else if c == 'i' then
        Just 0x69
    else if c == 'j' then
        Just 0x6A
    else if c == 'k' then
        Just 0x6B
    else if c == 'l' then
        Just 0x6C
    else if c == 'm' then
        Just 0x6D
    else if c == 'n' then
        Just 0x6E
    else if c == 'o' then
        Just 0x6F
    else if c == 'p' then
        Just 0x70
    else if c == 'q' then
        Just 0x71
    else if c == 'r' then
        Just 0x72
    else if c == 's' then
        Just 0x73
    else if c == 't' then
        Just 0x74
    else if c == 'u' then
        Just 0x75
    else if c == 'v' then
        Just 0x76
    else if c == 'w' then
        Just 0x77
    else if c == 'x' then
        Just 0x78
    else if c == 'y' then
        Just 0x79
    else if c == 'z' then
        Just 0x7A
        -- Symbols 4/4
    else if c == '{' then
        Just 0x7B
    else if c == '|' then
        Just 0x7C
    else if c == '}' then
        Just 0x7D
    else if c == '~' then
        Just 0x7E
    else
        Nothing
