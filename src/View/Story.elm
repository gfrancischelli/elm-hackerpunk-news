module View.Story exposing (..)

import Html exposing (..)
import Html.Events exposing (..)
import Html.Attributes exposing (href, class, id)
import Types exposing (..)
import Types.Story exposing (Story, StoryId, Stories)
import Dict
import Date exposing (Date)
import Date.Extra.Duration as Period
import Date.Extra.Core


viewStoryList : List StoryId -> Stories -> Maybe Date -> List (Html Msg)
viewStoryList ids stories now =
    ids
        |> List.map (\id -> Dict.get id stories)
        |> List.map (viewStory now)


viewStory : Maybe Date -> Maybe Story -> Html Msg
viewStory now maybe =
    case maybe of
        Just story ->
            div [ class "story" ]
                [ a [ href story.url, class "story__title" ] [ text story.title ]
                , div [ class "story__info" ]
                    [ text ("by: " ++ story.by)
                    , viewTimeAgo now story.time
                    , text " | "
                    ]
                , a [ onClick (ShowPage (Topic story.id)) ] [ text "comments" ]
                ]

        Nothing ->
            text " Nothing Here"


viewTimeAgo : Maybe Date -> Int -> Html Msg
viewTimeAgo maybeago now =
    case maybeago of
        Just ago ->
            let
                nowDate =
                    Date.fromTime <| toFloat <| 1000 * now

                period =
                    Period.diff ago nowDate
            in
                text <| " " ++ deltaRecordToString period

        Nothing ->
            text ""


deltaRecordToString : Period.DeltaRecord -> String
deltaRecordToString { year, month, day, hour, minute, second } =
    if year > 0 then
        toString year ++ " years ago"
    else if month > 0 then
        toString month ++ " months ago"
    else if day > 0 then
        toString day ++ " days ago"
    else if hour > 0 then
        toString hour ++ " hour ago"
    else if minute > 0 then
        toString minute ++ " minutes ago"
    else
        toString second ++ " seconds ago"
