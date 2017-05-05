port module Update exposing (update, loadFeedData)

import Types exposing (..)
import Json.Encode as Json
import Json.Decode as Decode
import Json.Decode.Pipeline as Pipe
import Dict


port subscribeToFeed : String -> Cmd msg


port loadThread : List Int -> Cmd msg


port getStoriesById : List Int -> Cmd msg


loadFeedData : Feed -> Cmd msg
loadFeedData feed =
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
                Main feed ->
                    ( { model | currentPage = page }, loadFeedData feed )

                Thread story ->
                    ( { model | currentPage = page, thread = Just story }, loadThread story.kids )

        ListenToFeed feed ->
            ( model, Cmd.none )

        UpdateFeedIds list ->
            ( { model | feed = Just list }, getStoriesById list )

        UpdateItem item ->
            ( { model | stories = addStoryToDict item model.stories }, Cmd.none )


addStoryToDict : Json.Value -> StoryPool -> StoryPool
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
