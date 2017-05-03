module Main exposing (..)

import Html exposing (..)
import Update exposing (update)
import View exposing (view)
import Types exposing (..)
import Dict


-- APP


init : ( Model, Cmd Msg )
init =
    ( Model Dict.empty Top Nothing Nothing, Cmd.none )


main : Program Never Model Msg
main =
    Html.program
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none
