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
        |> List.filterMap (\id -> Dict.get id stories)
        |> List.foldl toStoryList { n = 1, stories = [] }
        |> .stories
        |> List.reverse
        |> List.map (viewStory now)


toStoryList : Story -> StoryAcc -> StoryAcc
toStoryList story record =
    { record | n = record.n + 1, stories = ( record.n, story ) :: record.stories }


type alias StoryAcc =
    { n : Int, stories : List ( Int, Story ) }


viewStory : Maybe Date -> ( Int, Story ) -> Html Msg
viewStory now ( n, story ) =
    div [ class "story" ]
        [ a [ href story.url, class "story__title" ]
            [ text <| (toString n) ++ ". " ++ story.title ]
        , div [ class "story__info" ]
            [ text <| toString story.score ++ " points"
            , text (" by " ++ story.by)
            , viewTimeAgo now story.time
            , text " | "
            , a [ onClick (ShowPage (Topic story.id)) ]
                [ text <| (toString (List.length story.kids) ++ " comments") ]
            ]
        ]


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
