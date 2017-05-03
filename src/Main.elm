module Main exposing (..)

import Html exposing (..)
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



type Msg
    = NoOp


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOp ->
            ( model, Cmd.none )



-- VIEW


story : Story -> Html Msg
story value =
    div [] [ text value.title ]


view : Model -> Html Msg
view model =
    div []
        (List.map story model.stories)



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none
