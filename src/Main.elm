port module Main exposing (..)

import Html exposing (..)
import Update exposing (update, loadFeedData)
import View exposing (view)
import Types exposing (..)
import Dict
import Json.Encode as Json
import RouteUrl exposing (RouteUrlProgram, HistoryEntry, UrlChange)
import UrlParser exposing ((</>), s, int, string, parsePath, map)
import Navigation exposing (Location)


-- APP


init : ( Model, Cmd Msg )
init =
    ( Model Dict.empty (Main Top) Nothing Nothing, loadFeedData Top )


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
                Main feed ->
                    case feed of
                        New ->
                            "/new"

                        Top ->
                            "/top"

                        Best ->
                            "/best"

                Thread story ->
                    "/topic/" ++ toString story.id
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
                    Topic id ->
                        [ ShowTopicById id ]

                    Stories stories ->
                        case stories of
                            "top" ->
                                [ ShowPage (Main Top) ]

                            "new" ->
                                [ ShowPage (Main New) ]

                            "best" ->
                                [ ShowPage (Main Best) ]

                            _ ->
                                [ ShowPage (Main Top) ]

            Nothing ->
                []


route =
    UrlParser.oneOf
        [ UrlParser.map Topic (UrlParser.s "topic" </> UrlParser.int)
        ]



-- SUBSCRIPTIONS


port updateFeedIds : (List Int -> msg) -> Sub msg


port updateItem : (Json.Value -> msg) -> Sub msg


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ updateFeedIds UpdateFeedIds
        , updateItem UpdateItem
        ]
