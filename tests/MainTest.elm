module MainTest exposing (..)

import Expect exposing (..)
import Test exposing (..)

import Test.Html.Query as Query
import Test.Html.Selector as Selector

import Main

suite : Test
suite =
    describe "Learning to write a test"
        [ test "dummy" <|
            \() ->
                Main.view {}
                    |> Query.fromHtml
                    |> Query.has [ Selector.text "Loaded" ]
        ]
