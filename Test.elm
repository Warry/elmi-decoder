module Test exposing (..)

import Elmi.Interface
import Html exposing (Html)


main =
    Html.programWithFlags
        { init = init
        , update = update
        , view = view
        , subscriptions = subscriptions
        }


init : List Int -> ( String, Cmd Msg )
init flags =
    let
        coco =
            Elmi.Interface.parseInterface flags
    in
        (toString coco) ! []


type Msg
    = Noop


update : Msg -> String -> ( String, Cmd Msg )
update msg model =
    model ! []


view : String -> Html Msg
view model =
    Html.text model


subscriptions : String -> Sub Msg
subscriptions model =
    Sub.none
