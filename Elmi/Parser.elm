module Elmi.Parser exposing (..)

{-| # Set of helpers to parse lists of HEX

## Types

@docs Hex, Parser

# Functions

@docs take, andThen, (|.), with, (|=), parseInt, parseString, parseList, parseListHelp, parseUnion, parseTuple, parseMaybe, parseBool

-}

import Bitwise
import Result
import Ascii


{-|
-}
type alias Hex =
    Int


intLength : Int
intLength =
    8


{-|
-}
type alias Tape =
    List Hex


{-|
-}
type alias Parser a =
    Tape -> Result String ( a, Tape )


{-|
-}
parse : (a -> b) -> Tape -> Result String ( a -> b, Tape )
parse fn tape =
    Ok ( fn, tape )


{-|
-}
parseEnum : a -> Tape -> Result String ( a, Tape )
parseEnum v tape =
    Ok ( v, tape )


{-|
-}
map : (a -> b) -> (Tape -> Result String ( a, Tape )) -> Parser b
map fn parser tape =
    case parser tape of
        Ok ( value, tape_ ) ->
            Ok ( fn value, tape_ )

        Err err ->
            Err err


{-|
-}
take : Int -> Parser (List Hex)
take length list =
    let
        acc =
            List.take length list

        rest =
            List.drop length list
    in
        Ok ( acc, rest )


{-|
-}
app : Parser (a -> b) -> Parser a -> Parser b
app tagger next tape =
    case tagger tape of
        Ok ( fn, tape_ ) ->
            map fn next tape_

        Err err ->
            Err err


{-|
-}
(|.) : Parser (a -> b) -> Parser a -> Parser b
(|.) =
    app


{-|
-}
andThen : Parser a -> (a -> Parser b) -> Parser b
andThen tagger next tape =
    case tagger tape of
        Ok ( value, tape_ ) ->
            next value tape_

        Err err ->
            Err err


{-|
-}
(|=) : Parser a -> (a -> Parser b) -> Parser b
(|=) =
    andThen


{-|
-}
parseInt : Parser Int
parseInt =
    map
        (Tuple.second
            << List.foldl
                (\value ( shift, acc ) ->
                    ( shift - 1, acc + (Bitwise.shiftLeftBy (4 * shift) value) )
                )
                ( intLength - 1, 0 )
        )
        (take intLength)


{-|
-}
parseString : Parser String
parseString =
    parseInt
        |= (\size tape ->
                case take size tape of
                    Ok ( t, rest ) ->
                        Ok ( Ascii.toString t, rest )

                    Err err ->
                        Err err
           )


{-|
-}
parseList : Parser a -> Parser (List a)
parseList parser =
    parseInt
        |= (\size ->
                parseListHelp parser ( size, [] )
           )


{-|
-}
parseListHelp : Parser a -> ( Int, List a ) -> Parser (List a)
parseListHelp parser ( size, acc ) tape =
    if size == 0 then
        Ok ( List.reverse acc, tape )
    else
        case parser tape of
            Ok ( item, tape_ ) ->
                parseListHelp parser ( size - 1, item :: acc ) tape_

            Err err ->
                Err err


{-|
-}
parseUnion : List ( Int, Parser a ) -> Parser a
parseUnion choices tape =
    case tape of
        code :: rest ->
            List.foldr
                (\( unionCode, parser ) value ->
                    if code == unionCode then
                        parser rest
                    else
                        value
                )
                (Err "Not in union.")
                choices

        [] ->
            Err "List is too short."


{-|
-}
parseTuple : Parser a -> Parser b -> Parser ( a, b )
parseTuple p1 p2 =
    parse (,)
        |. p1
        |. p2


{-|
-}
parseMaybe : Parser a -> Parser (Maybe a)
parseMaybe p tape =
    case tape of
        0 :: rest ->
            Ok ( Nothing, rest )

        1 :: list ->
            map Just p list

        _ ->
            Err ">>>>>"



{-
   parseMaybe : Parser a -> Parser (Maybe a)
   parseMaybe p tape =
       case p tape of
           Ok ( value, rest ) ->
               Ok ( Just value, rest )

           _ ->
               Ok ( Nothing, tape )

-}


{-|
-}
parseBool : Parser Bool
parseBool tape =
    case tape of
        1 :: rest ->
            Ok ( True, rest )

        0 :: rest ->
            Ok ( False, rest )

        _ ->
            Err "Bool error"


{-|
-}
lazy : (() -> Parser a) -> Parser a
lazy fn tape =
    fn () tape
