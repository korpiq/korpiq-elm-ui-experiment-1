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
                        initialModel = { navbarState = navbarState }
                        initialView = Main.view initialModel
                        menuOpenMsg =
                            initialView
                                |> Query.fromHtml
                                |> Query.find [Selector.tag "a", Selector.containing [ Selector.text "Dropdown 2" ] ]
                                |> Event.simulate Event.click
                                |> Event.toResult
                        modelAfterMenuOpenUpdate =
                            case menuOpenMsg of
                                Ok msg -> Ok (Main.update msg initialModel)
                                Err reason -> Err reason
                        viewWithMenuOpen =
                            case modelAfterMenuOpenUpdate of
                                Ok (model, _) -> Ok (Main.view model)
                                Err reason -> Err reason
                    in
                        case viewWithMenuOpen of
                            Ok view ->
                                view
                                    |> Query.fromHtml
                                    |> Query.has [Selector.class "shown", Selector.containing [ Selector.text "Drop 2-1" ] ]
                            Err reason -> Expect.fail reason
            {--
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
