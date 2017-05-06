module Types exposing (..)

import Json.Encode as Json
import Types.Story exposing (Stories, Story, StoryId)


type alias Model =
    { stories : Stories
    , currentPage : Page
    , feed : List StoryId
    }


type Msg
    = ShowPage Page
    | UpdateItem Json.Value
    | UpdateFeed (List StoryId)


type Page
    = Topic StoryId
    | Home Feed


type Feed
    = Top
    | New
    | Best
