module View.Topic exposing (..)

import Html exposing (..)
import Html.Attributes exposing (href, class, id)
import Types exposing (..)
import Types.Story exposing (Stories, StoryId)
import View.Story exposing (viewStoryInfo)
import Json.Encode
import HtmlParser exposing (parse)
import HtmlParser.Util exposing (..)
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
                    [ a [ href story.url, class "thread__title" ]
                        [ text story.title ]
                    , viewStoryInfo date story
                    , div []
                        (parse story.text
                            |> toVirtualDom
                        )
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
                    [ p [ class "comment__author" ] [ text <| "> " ++ story.by ]
                    , div []
                        (parse story.text
                            |> toVirtualDom
                        )
                    , story.kids
                        |> List.filter (\n -> n > 0)
                        |> List.map (viewComment stories)
                        |> div []
                    ]

            Nothing ->
                text "..."
