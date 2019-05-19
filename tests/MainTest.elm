module MainTest exposing (..)

import Expect exposing (..)
import Test exposing (..)
import Dict

import Test.Html.Query as Query
import Test.Html.Selector as Selector
import Test.Html.Event as Event

import Bootstrap.Navbar exposing (initialState)
import Json.Encode exposing (..)

import Main

dropdownIsOpen : String -> Result String Main.Msg -> Bool
dropdownIsOpen name resultToCheck =
    case resultToCheck of
        Ok msg -> case msg of
            Main.NavbarMsg state -> Dict.member name state.dropdowns
            --> This is not a record, so it has no fields to access! This `state` value is a: Bootstrap.Navbar.State
            _ -> False
        _ -> False

suite : Test
suite =
    describe "Learning to write a test"
        [
            test "Page shows some content" <|
                \() ->
                    let
                        ( navbarState, _ ) = initialState Main.NavbarMsg
                    in
                        Main.view { navbarState = navbarState }
                            |> Query.fromHtml
                            |> Query.has [ Selector.text "Loaded" ]
            ,
            test "Open menu with click" <|
                \() ->
                    let
                        ( navbarState, _ ) = initialState Main.NavbarMsg
                        menuOpenState =
                            Main.view { navbarState = navbarState }
                                |> Query.fromHtml
                                |> Query.find [Selector.tag "a", Selector.containing [ Selector.text "Dropdown 2" ] ]
                                |> Event.simulate Event.click
                                |> Event.toResult
                    in
                        menuOpenState
                            |> dropdownIsOpen "navbar-dropdown-2"
                            |> Expect.equal True
                            -- |> Expect.equal (Ok (Main.NavbarMsg { navbarState | dropdowns = Dict.fromList [("navbar-dropdown-2", DropdownStatus.Open)] }))
                            -- |> Event.expect (Main.NavbarMsg navbarState)
                        --> Event.expectEvent: Expected the msg NavbarMsg (State { dropdowns = Dict.fromList [], height = Nothing, visibility = Hidden, windowWidth = Nothing }) from the event ("click",<internals>) but could not find the event.
            {--
                            |> Query.find [ Selector.class "show" ]
                            |> Query.has [ Selector.text "Drop 2-1" ]
            ,
            test "Close menu with escape key" <|
                \() ->
                    let
                        ( navbarState, _ ) = initialState Main.NavbarMsg
                        keyEventEscape = Json.Encode.object [ ("type", Json.Encode.string "keyup"), ("key", Json.Encode.string "Escape") ]
                        keyEscapeEvent = Main.BodyEvent keyEventEscape
                        ( resultModel, _ ) = Main.update keyEscapeEvent { navbarState = navbarState } 
                    in
                        resultModel
            --}
        ]
