module View.Topic exposing (..)

import Html exposing (..)
import Html.Attributes exposing (href, class, id)
import Types exposing (..)
import Types.Story exposing (Stories, StoryId)
import View.Story exposing (viewStoryInfo)
import Dict


viewTopic : StoryId -> Model -> Html Msg
viewTopic id { stories, date } =
    let
        maybe =
            Dict.get id stories
    in
        case maybe of
            Just story ->
                div [ class "thread" ]
                    , text story.text
                    [ a [ href story.url, class "thread__title" ]
                        [ text story.title ]
                    , viewStoryInfo date story
                    , div [] (List.map (viewComment stories) story.kids)
                    ]

            Nothing ->
                div [] [ text "..." ]


viewComment : Stories -> Int -> Html Msg
viewComment stories id =
    let
        maybe =
            Dict.get id stories
    in
        case maybe of
            Just story ->
                div [ class "comment" ]
                    [ text story.by
                    , p [] [ text story.text ]
                    , story.kids
                        |> List.filter (\n -> n > 0)
                        |> List.map (viewComment stories)
                        |> div []
                    ]

            Nothing ->
                text "..."
