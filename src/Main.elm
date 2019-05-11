port module Main exposing (..)

import Browser
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events
import Bootstrap.Grid as Grid
import Bootstrap.Navbar as Navbar
import Json.Encode
import Json.Decode
import Debug exposing (log)

main : Program Flags Model Msg
main =
    Browser.element
        {
            init = init
            , view = view
            , update = update
            , subscriptions = subscriptions
        }

port bodyEvent : (Json.Encode.Value -> msg) -> Sub msg

type alias Flags =
    {
        -- url: String
    }

type alias Model =
    {
        navbarState : Navbar.State
    }

type Msg
    = NavbarMsg Navbar.State
    | BodyEvent Json.Encode.Value

type alias Msg2 = String

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
    case msg of
        BodyEvent eventJson ->
            updateOnBodyEvent model eventJson
        NavbarMsg state ->
            ( { model | navbarState = state }, Cmd.none )

updateOnBodyEvent : Model -> Json.Encode.Value -> (Model, Cmd Msg)
updateOnBodyEvent model eventJson =
    let
        eventType = getJsonFieldString "type" eventJson
    in
        case eventType of
            "keyup" -> updateOnBodyKeyEvent model eventJson
            _ -> (model, Cmd.none)

updateOnBodyKeyEvent : Model -> Json.Encode.Value -> (Model, Cmd Msg)
updateOnBodyKeyEvent model eventJson =
    let
        keyName = getJsonFieldString "key" eventJson
    in
        case keyName of
            "Escape" -> initNavbarState
            _ -> (model, Cmd.none)

getJsonFieldString : String -> Json.Encode.Value -> String
getJsonFieldString name eventJson =
    case Json.Decode.decodeValue (Json.Decode.field name Json.Decode.string) eventJson of
        Ok fieldValue -> fieldValue
        Err error -> Json.Decode.errorToString error

view : Model -> Html Msg
view model =
    Html.div []
        [
            Navbar.config NavbarMsg
                |> Navbar.withAnimation
                |> Navbar.brand [ href "#"] [ text "korpiq"]
                |> Navbar.items
                    [
                        Navbar.dropdown
                            {
                                id = "navbar-dropdown-1"
                                ,
                                toggle = Navbar.dropdownToggle [] [ text "Dropdown 1" ]
                                ,
                                items = [
                                    Navbar.dropdownItem [href "#drop-1-1"] [ text "Drop 1-1"]
                                    , Navbar.dropdownItem [href "#drop-1-2"] [ text "Drop 1-2"]
                                ]
                            }
                        , Navbar.dropdown
                            {
                                id = "navbar-dropdown-2"
                                ,
                                toggle = Navbar.dropdownToggle [] [ text "Dropdown 2" ]
                                ,
                                items = [
                                    Navbar.dropdownItem [href "#drop-2-1"] [ text "Drop 2-1"]
                                    , Navbar.dropdownItem [href "#drop-2-2"] [ text "Drop 2-2"]
                                ]
                            }
                        , Navbar.itemLink [href "#navbar-item-1"] [ text "Navigation bar Item 1"]
                        , Navbar.itemLink [href "#navbar-item-2"] [ text "Navigation bar Item 2"]
                        , Navbar.itemLink [href "#navbar-item-3"] [ text "Navigation bar Item 3"]
                        , Navbar.itemLink [href "#navbar-item-4"] [ text "Navigation bar Item 4"]
                    ]
                |> Navbar.view model.navbarState
            ,
            Grid.container []
                [ Grid.row []
                    [ Grid.col []
                        [ text "Loaded"]
                    ]
                ]
        ]

subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
    [
        bodyEvent BodyEvent
        ,
        Navbar.subscriptions model.navbarState NavbarMsg
    ]

init : Flags -> ( Model, Cmd Msg )
init flags =
    initNavbarState

initNavbarState =
    let
        (navbarState, navbarCmd)
            = Navbar.initialState NavbarMsg
    in
        ({ navbarState = navbarState }, navbarCmd )
