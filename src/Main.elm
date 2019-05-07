port module Main exposing (..)

import Browser
import Html exposing (..)
import Html.Attributes exposing (..)

main : Program Flags Model Msg
main =
    Browser.element
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
    }

type alias Flags =
    {
        -- url: String
    }

type alias Model =
    {
        -- property : propertyType
    }

type Msg
    = Msg1
    | Msg2

type alias Msg2 = String

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
    case msg of
        Msg1 ->
            (model, Cmd.none)

        Msg2 ->
            (model, Cmd.none)


view : Model -> Html Msg
view model =
    div []
        [ text "Loaded" ]


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none


init : Flags -> ( Model, Cmd Msg )
init flags =
    ( Model, Cmd.none )
