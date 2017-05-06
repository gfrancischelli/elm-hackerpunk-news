port module Update exposing (update, getFeedUpdates)

import Types exposing (..)
import Types.Story exposing (..)
import Json.Encode as Json
import Json.Decode as Decode
import Json.Decode.Pipeline as Pipe
import Dict


port subscribeToFeed : String -> Cmd msg


port loadTopic : StoryId -> Cmd msg


port loadStoriesById : List Int -> Cmd msg


getFeedUpdates : Feed -> Cmd msg
getFeedUpdates feed =
    case feed of
        Top ->
            subscribeToFeed "topstories"

        New ->
            subscribeToFeed "newstories"

        Best ->
            subscribeToFeed "beststories"


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ShowPage page ->
            case page of
                Topic id ->
                    ( { model | currentPage = page }
                    , loadTopic id
                    )

                Home feed ->
                    ( { model | currentPage = page }
                    , getFeedUpdates feed
                    )

        UpdateFeed idList ->
            ( { model | feed = idList }, loadStoriesById idList )

        UpdateItem item ->
            ( { model | stories = addStoryToDict item model.stories }, Cmd.none )


addStoryToDict : Json.Value -> Stories -> Stories
addStoryToDict item stories =
    let
        result =
            Decode.decodeValue decodeStory item
    in
        case result of
            Ok story ->
                Dict.insert story.id story stories

            Err error ->
                stories


decodeStory : Decode.Decoder Story
decodeStory =
    Pipe.decode Story
        |> Pipe.optional "by" (Decode.string) ""
        |> Pipe.required "id" (Decode.int)
        |> Pipe.optional "url" (Decode.string) ""
        |> Pipe.optional "descendants" (Decode.int) 0
        |> Pipe.optional "kids" (Decode.list Decode.int) [ 0 ]
        |> Pipe.optional "parts" (Decode.list Decode.int) [ 0 ]
        |> Pipe.optional "score" (Decode.int) 0
        |> Pipe.optional "text" (Decode.string) ""
        |> Pipe.optional "time" (Decode.int) 0
        |> Pipe.optional "title" (Decode.string) ""
        |> Pipe.optional "type_" (Decode.string) ""
