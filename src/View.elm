module View exposing (..)

import View.Story exposing (viewStoryList)
import Html exposing (..)
import Html.Events exposing (..)
import Types exposing (..)


view : Model -> Html Msg
view model =
    div []
        [ h2 [] [ text "HackerNews" ]
        , navbar
        , viewpage model
        ]


navbar : Html Msg
navbar =
    div []
        [ button [ onClick (ShowPage Top) ] [ text "Top" ]
        , button [ onClick (ShowPage Best) ] [ text "Best" ]
        , button [ onClick (ShowPage New) ] [ text "New" ]
        , button [ onClick (ShowPage Topic) ] [ text "topic placeholder" ]
        ]


viewpage : Model -> Html Msg
viewpage model =
    case model.currentPage of
        Topic ->
            viewtopic model

        _ ->
            viewfeed model


viewfeed : Model -> Html Msg
viewfeed { stories, feed } =
    case feed of
        Nothing ->
            text "no feed to see here"

        Just ids ->
            div [] [ text "we got a feed" ]


viewtopic : Model -> Html Msg
viewtopic model =
    text "heres a story"
