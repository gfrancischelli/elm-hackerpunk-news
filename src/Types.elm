module Types exposing (..)

import Dict
import Json.Encode as Json


type alias Model =
    { stories : StoryPool
    , currentPage : Page
    , feed : Maybe (List Int)
    , thread : Maybe Story
    }


type Page
    = Main Feed
    | Thread Story


type Msg
    = ShowPage Page
    | ListenToFeed Feed
    | UpdateItem Json.Value
    | UpdateFeedIds (List Int)


type alias Story =
    { by : String
    , id : Int
    , url : String
    , descendants : Int
    , kids : List Int
    , parts : List Int
    , score : Int
    , text : String
    , time : Int
    , title : String
    , type_ : String
    }


type Comments
    = Comments (List Story)


type alias StoryPool =
    Dict.Dict Int Story


type Feed
    = Best
    | Top
    | New
