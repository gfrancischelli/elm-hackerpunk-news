module View exposing (..)

import View.Story exposing (viewStoryList)
import View.Topic exposing (viewTopic)
import Html exposing (..)
import Html.Events exposing (..)
import Html.Attributes exposing (href, class, id)
import Types exposing (..)
import Dict
import Date exposing (hour, Date)


view : Model -> Html Msg
view model =
    div [ class "wrapper" ]
        [ div [ class "noise" ] []
        , header
        , viewpage model
        ]


header : Html Msg
header =
    div [ class "header" ]
        [ h1 []
            [ text "HackerNews" ]
        , div []
            [ button [ onClick (ShowPage <| Home Top) ] [ text "T0P" ]
            , button [ onClick (ShowPage <| Home New) ] [ text "N3W" ]
            , button [ onClick (ShowPage <| Home Best) ] [ text "B35T" ]
            ]
        ]


viewpage : Model -> Html Msg
viewpage model =
    case model.currentPage of
        Topic id ->
            viewTopic id model

        Home feed ->
            viewfeed model


viewfeed : Model -> Html Msg
viewfeed { stories, feed, date } =
    if List.length feed == 0 then
        div [ class "loading_spinner" ] [ text "loading ..." ]
    else
        div []
            [ div [] (viewStoryList feed stories date)
            ]


viewTimeAgo : String -> String
viewTimeAgo time =
    let
        result =
            Date.fromString time
    in
        case result of
            Ok date ->
                ""

            Err err ->
                ""
