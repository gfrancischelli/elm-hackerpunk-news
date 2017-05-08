port module Main exposing (..)

import Html exposing (..)
import Update exposing (update, getFeedUpdates)
import View exposing (view)
import Types exposing (..)
import Dict
import Json.Encode as Json
import RouteUrl exposing (RouteUrlProgram, HistoryEntry, UrlChange)
import UrlParser exposing ((</>), s, int, string, parsePath, map)
import Navigation exposing (Location)
import Time exposing (Time, minute)
import Task


-- APP


init : ( Model, Cmd Msg )
init =
    ( Model Dict.empty (Home Top) [] Nothing
    , Cmd.batch [ getFeedUpdates Top, Task.perform UpdateDate Time.now ]
    )


main : RouteUrlProgram Never Model Msg
main =
    RouteUrl.program
        { delta2url = delta2url
        , location2messages = location2messages
        , init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }



-- ROUTER


delta2url : Model -> Model -> Maybe UrlChange
delta2url previous current =
    let
        url =
            case current.currentPage of
                Home feed ->
                    case feed of
                        New ->
                            "/new"

                        Top ->
                            "/top"

                        Best ->
                            "/best"

                Topic id ->
                    "/topic/" ++ toString id
    in
        Just
            { entry = RouteUrl.NewEntry
            , url = url
            }


location2messages : Location -> List Msg
location2messages location =
    let
        path =
            parsePath route location
    in
        case path of
            Just page ->
                case page of
                    TopicRoute id ->
                        [ ShowPage (Topic id) ]

                    FeedRoute feed ->
                        case feed of
                            "new" ->
                                [ ShowPage (Home New) ]

                            "best" ->
                                [ ShowPage (Home Best) ]

                            _ ->
                                [ ShowPage (Home Top) ]

            Nothing ->
                []


type Route
    = TopicRoute Int
    | FeedRoute String


route : UrlParser.Parser (Route -> c) c
route =
    UrlParser.oneOf
        [ UrlParser.map TopicRoute (UrlParser.s "topic" </> UrlParser.int)
        , UrlParser.map FeedRoute (UrlParser.string)
        ]



-- SUBSCRIPTIONS


port updateFeedIds : (List Int -> msg) -> Sub msg


port updateItem : (Json.Value -> msg) -> Sub msg


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ updateFeedIds UpdateFeed
        , updateItem UpdateItem
        , Time.every minute UpdateDate
        ]
