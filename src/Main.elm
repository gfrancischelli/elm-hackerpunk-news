port module Main exposing (..)

import Html exposing (..)
import Update exposing (update, getFeedUpdates)
import View exposing (view)
import Types exposing (..)
import Dict
import Json.Encode as Json


-- APP


init : ( Model, Cmd Msg )
init =
    ( Model Dict.empty (Home Top) [], getFeedUpdates Top )


main : Program Never Model Msg
main =
    Html.program
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }



-- SUBSCRIPTIONS


port updateFeedIds : (List Int -> msg) -> Sub msg


port updateItem : (Json.Value -> msg) -> Sub msg


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ updateFeedIds UpdateFeed
        , updateItem UpdateItem
        ]
