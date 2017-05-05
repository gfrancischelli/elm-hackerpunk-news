module View exposing (..)

import View.Story exposing (viewStoryList)
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
        , button [ onClick (ShowPage <| Main Top) ] [ text "Top" ]
        , button [ onClick (ShowPage <| Main Best) ] [ text "Best" ]
        , button [ onClick (ShowPage <| Main New) ] [ text "New" ]

        -- , button [ onClick (ShowPage <| About) ] [ text "About" ]
        ]


viewpage : Model -> Html Msg
viewpage model =
    case model.currentPage of
        Thread story ->
            viewtopic model

        Main feed ->
            viewfeed model


viewfeed : Model -> Html Msg
viewfeed { stories, feed } =
    case feed of
        Nothing ->
            div [ class "loading_spinner" ] [ text "loading ..." ]

        Just ids ->
            div []
                [ div [] (viewStoryList ids stories)
                ]


viewtopic : Model -> Html Msg
viewtopic { thread, stories } =
    case thread of
        Just story ->
            div []
                [ text story.title
                , text story.text
                , a [ href story.url ] [ text "->" ]
                ]

        Nothing ->
            text "No story something went wrong"
