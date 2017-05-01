module Main exposing (..)

import Html exposing (..)


-- APP


main : Program Never Model Msg
main =
    Html.program
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }



-- MODEL


type alias Story =
    { by : String
    , id : Int
    , kids : List Int
    , score : Int
    , time : Int
    , title : String
    , type_ : String
    , url : String
    }


type alias Model =
    { stories : List Story
    }


init : ( Model, Cmd Msg )
init =
    ( Model [ Story "Author" 0 [ 0 ] 0 0 "Title" "type" "url" ], Cmd.none )



-- UPDATE


type Msg
    = NoOp


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOp ->
            ( model, Cmd.none )



-- VIEW


story : Story -> Html Msg
story value =
    div [] [ text value.title ]


view : Model -> Html Msg
view model =
    div []
        (List.map story model.stories)



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none
