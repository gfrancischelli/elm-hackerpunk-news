module View exposing (..)

import View.Story exposing (viewStoryList)
import View.Topic exposing (viewTopic)
import Html exposing (..)
import Html.Events exposing (..)
import Html.Attributes exposing (href, class, id)
import Types exposing (..)
import Dict
import Date


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
        [ h1 [] [ text "HackerNews" ]
        , button [ onClick (ShowPage <| Home Top) ] [ text "Top" ]
        , button [ onClick (ShowPage <| Home New) ] [ text "New" ]
        , button [ onClick (ShowPage <| Home Best) ] [ text "Best" ]
        ]


viewpage : Model -> Html Msg
viewpage model =
    case model.currentPage of
        Topic id ->
            viewTopic id model

        Home feed ->
            viewfeed model


viewfeed : Model -> Html Msg
viewfeed { stories, feed } =
    if List.length feed == 0 then
        div [ class "loading_spinner" ] [ text "loading ..." ]
    else
        div []
            [ div [] (viewStoryList feed stories)
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
