module Types exposing (..)

import Json.Encode as Json
import Types.Story exposing (Stories, Story, StoryId)
import Date
import Time


type alias Model =
    { stories : Stories
    , currentPage : Page
    , feed : List StoryId
    , date : Maybe Date.Date
    }


type Msg
    = ShowPage Page
    | UpdateItem Json.Value
    | UpdateFeed (List StoryId)
    | UpdateDate Time.Time


type Page
    = Topic StoryId
    | Home Feed


type Feed
    = Top
    | New
    | Best
