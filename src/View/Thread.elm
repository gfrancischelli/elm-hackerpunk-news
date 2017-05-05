module View.Thread exposing (..)

import Html exposing (..)
import Html.Events exposing (..)
import Html.Attributes exposing (href, class, id)
import Types exposing (..)
import Dict


viewThread : Model -> Html Msg
viewThread { thread, stories } =
    case thread of
        Just story ->
            div [ class "thread" ]
                [ a [ href story.url, class "thread__title" ] [ text story.title ]
                , text story.text
                , div [] (List.map (viewComment stories) story.kids)
                ]

        Nothing ->
            div [] [ text "No story something went wrong" ]


viewComment : StoryPool -> Int -> Html Msg
viewComment stories id =
    let
        maybe =
            Dict.get id stories

        _ =
            Debug.log "birbi" maybe
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
                text "failed to load"
