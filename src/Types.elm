module Types exposing (..)

import Dict


type alias Model =
    { stories : StoryPool
    , currentPage : Page
    , feed : Maybe Feed
    , topic : Maybe Story
    }


type Msg
    = ShowPage Page
    | ListenToFeed Feed
    | UpdateFeedIds (List Story)


type alias Story =
    { by : String
    , id : Int
    , time : Int
    , score : Int
    , url : String
    , title : String
    , type_ : String
    , kids : List Int
    , parent : Maybe String
    , kids : List Int
    }


type alias Feed =
    List Int


type Comments
    = Comments (List Story)


type alias StoryPool =
    Dict.Dict Int Story


type Page
    = Best
    | Top
    | New
    | Topic
