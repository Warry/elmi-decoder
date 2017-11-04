module Elmi.Interface
    exposing
        ( Interface
        , Version
        , PackageName
        , Imports
        , Types
        , Unions
        , Aliases
        , UnionInfo
        , CanonicalVar
        , CanonicalModuleName
        , Exports
        , Export(..)
        , Canonical(..)
        , AliasedCanonical(..)
        , Home(..)
        , Infixes
        , Infix
        , Assoc(..)
        , parseInterface
        )

{-|

# Parse

@docs parseInterface

# Types

@docs Interface, Version, PackageName, Imports, Types, Unions, Aliases, UnionInfo, CanonicalVar, CanonicalModuleName, Exports, Export, Canonical, AliasedCanonical, Home,  Infixes,  Infix, Assoc

-}

import Ascii
import Elmi.Parser exposing (..)


--import Data exposing (Data)


{-| -}
type alias Interface =
    { version : Version
    , pkg : PackageName
    , exports : Exports
    , imports : Imports
    , types : Types
    , unions : Unions
    , aliases : Aliases
    , fixities : Infixes
    }


{-| -}
type alias Version =
    { major : Int
    , minor : Int
    , patch : Int
    }


{-| -}
type alias PackageName =
    { user : String
    , project : String
    }


{-| -}
type alias Exports =
    List Export


{-| -}
type Export
    = ExportValue String
    | ExportAlias String
    | ExportUnion String Listing


{-| -}
type alias Listing =
    { explicits : List String
    , open : Bool
    }


{-| -}
type alias Imports =
    List (List String)


{-| -}
type alias Types =
    List ( String, Canonical )


{-| -}
type alias Unions =
    List ( String, UnionInfo )


{-| -}
type alias Aliases =
    List ( String, ( List String, Canonical ) )


{-| -}
type alias UnionInfo =
    ( List String, List ( String, List Canonical ) )


{-| -}
type Canonical
    = Lambda Canonical Canonical
    | Var String
    | Type CanonicalVar
    | App Canonical (List Canonical)
    | Record (List ( String, Canonical )) (Maybe Canonical)
    | Aliased CanonicalVar (List ( String, Canonical )) AliasedCanonical


{-| -}
type alias CanonicalVar =
    { home : Home
    , name : String
    }


{-| -}
type alias CanonicalModuleName =
    { pkg : PackageName
    , modul : List String
    }


{-| -}
type AliasedCanonical
    = Holley Canonical
    | Filled Canonical


{-| -}
type Home
    = BuiltIn
    | Module CanonicalModuleName
    | TopLevel CanonicalModuleName
    | Local


{-| -}
type alias Infixes =
    List Infix


{-| -}
type alias Infix =
    { op : String
    , associativity : Assoc
    , precedence : Int
    }


{-| -}
type Assoc
    = L
    | N
    | R


{-| -}
parseInterface : Parser Interface
parseInterface =
    lazy
        (\_ ->
            parse Interface
                |. parseVersion
                |. parsePackageName
                |. parseExports
                |. parseImports
                |. parseTypes
                |. parseUnions
                |. parseAliases
                |. parseInfixes
        )


{-| -}
parseVersion : Parser Version
parseVersion =
    parse Version
        |. parseInt
        |. parseInt
        |. parseInt


{-| -}
parsePackageName : Parser PackageName
parsePackageName =
    parse PackageName
        |. parseString
        |. parseString


{-| -}
parseImports : Parser Imports
parseImports =
    parseList (parseList parseString)


{-| -}
parseTypes : Parser Types
parseTypes =
    parseList (parseTuple parseString parseCanonical)


{-| -}
parseUnions : Parser Unions
parseUnions =
    parseList (parseTuple parseString parseUnionInfo)


{-| -}
parseAliases : Parser Aliases
parseAliases =
    parseList <|
        parseTuple parseString (parseTuple (parseList parseString) parseCanonical)


{-| -}
parseUnionInfo : Parser UnionInfo
parseUnionInfo =
    parseTuple
        (parseList parseString)
        (parseList
            (parseTuple
                parseString
                (parseList parseCanonical)
            )
        )


{-| -}
parseCanonicalVar : Parser CanonicalVar
parseCanonicalVar =
    parse CanonicalVar
        |. parseHome
        |. parseString


{-| -}
parseCanonicalModuleName : Parser CanonicalModuleName
parseCanonicalModuleName =
    parse CanonicalModuleName
        |. parsePackageName
        |. parseList parseString


{-| -}
parseHome : Parser Home
parseHome =
    parseUnion
        [ ( 0, parseEnum BuiltIn )
        , ( 1, map Module parseCanonicalModuleName )
        , ( 2, map TopLevel parseCanonicalModuleName )
        , ( 3, parseEnum Local )
        ]


{-| -}
parseExports : Parser Exports
parseExports =
    parseList parseExport


{-| -}
parseExport : Parser Export
parseExport =
    parseUnion
        [ ( 0, parse ExportValue |. parseString )
        , ( 1, parse ExportAlias |. parseString )
        , ( 2, parse ExportUnion |. parseString |. parseListing )
        ]


{-| -}
parseListing : Parser Listing
parseListing =
    parse Listing
        |. parseList parseString
        |. parseBool


{-| -}
parseCanonical : Parser Canonical
parseCanonical =
    lazy
        (\_ ->
            parseUnion
                [ ( 0, parseLambda )
                , ( 1, parseVar )
                , ( 2, parseType )
                , ( 3, parseApp )
                , ( 4, parseRecord )
                , ( 5, parseAliased )
                ]
        )


{-| -}
parseLambda : Parser Canonical
parseLambda =
    parse Lambda
        |. parseCanonical
        |. parseCanonical


{-| -}
parseVar : Parser Canonical
parseVar =
    parse Var
        |. parseString


{-| -}
parseType : Parser Canonical
parseType =
    parse Type
        |. parseCanonicalVar


{-| -}
parseApp : Parser Canonical
parseApp =
    parse App
        |. parseCanonical
        |. parseList parseCanonical


{-| -}
parseRecord : Parser Canonical
parseRecord =
    parse Record
        |. parseList (parseTuple parseString parseCanonical)
        |. parseMaybe parseCanonical


{-| -}
parseAliased : Parser Canonical
parseAliased =
    lazy
        (\_ ->
            parse Aliased
                |. parseCanonicalVar
                |. parseList (parseTuple parseString parseCanonical)
                |. parseAliasedCanonical
        )


{-| -}
parseAliasedCanonical : Parser AliasedCanonical
parseAliasedCanonical =
    lazy
        (\_ ->
            parseUnion
                [ ( 0, parse Holley |. parseCanonical )
                , ( 1, parse Filled |. parseCanonical )
                ]
        )


{-| -}
parseInfixes : Parser (List Infix)
parseInfixes =
    parseList parseInfix


{-| -}
parseInfix : Parser Infix
parseInfix =
    parse Infix
        |. parseString
        |. parseAssoc
        |. parseInt


{-| -}
parseAssoc : Parser Assoc
parseAssoc =
    parseUnion
        [ ( 0, parseEnum L )
        , ( 1, parseEnum N )
        , ( 1, parseEnum R )
        ]
