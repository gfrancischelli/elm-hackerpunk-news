module Types.Story exposing (..)

import Dict


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


type alias StoryId =
    Int


type alias Stories =
    Dict.Dict Int Story
