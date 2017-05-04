module View.Story exposing (..)

import Html exposing (..)
import Html.Events exposing (..)
import Html.Attributes exposing (href, class, id)
import Types exposing (..)
import Dict


viewStoryList : List Int -> StoryPool -> List (Html Msg)
viewStoryList ids stories =
    ids
        |> List.map (\id -> Dict.get id stories)
        |> List.map viewStory


viewStory : Maybe Story -> Html Msg
viewStory maybe =
    case maybe of
        Just story ->
            div [ class "story" ]
                [ a [ href story.url, class "story__title" ] [ text story.title ]
                , viewStoryInfo story
                ]

        Nothing ->
            text " Nothing Here"


viewStoryInfo : Story -> Html Msg
viewStoryInfo story =
    div [ class "story__info" ]
        [ text ("by: " ++ story.by)
        , text " | "
        , a [ onClick (ShowPage (Thread story)) ] [ text "comments" ]
        ]
