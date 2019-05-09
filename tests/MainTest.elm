module MainTest exposing (..)

import Expect exposing (..)
import Test exposing (..)

import Test.Html.Query as Query
import Test.Html.Selector as Selector

import Bootstrap.Navbar exposing (initialState)

import Main

suite : Test
suite =
    describe "Learning to write a test"
        [ test "dummy" <|
            \() ->
                let
                    ( navbarState, _ ) =
                        initialState Main.NavbarMsg
                in
                Main.view { navbarState = navbarState }
                    |> Query.fromHtml
                    |> Query.has [ Selector.text "Loaded" ]
        ]
