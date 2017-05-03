module Update exposing (..)

import Types exposing (..)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ShowPage page ->
            ( { model | currentPage = page }, Cmd.none )

        ListenToFeed feed ->
            ( model, Cmd.none )

        UpdateFeedIds list ->
            ( model, Cmd.none )
