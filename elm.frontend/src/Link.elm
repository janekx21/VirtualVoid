module Link exposing (..)

import Colors exposing (..)
import Element exposing (Attribute, Element, focused, link, mouseOver, padding, px, text, width)
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font
import Placeholder exposing (..)


type alias Link =
    { label : String, url : String }


linkPlaceholder : Loadable Link -> Element msg
linkPlaceholder maybeLink =
    maybeLink |> Maybe.map (\{ label, url } -> link genericLink { label = text label, url = url }) |> Maybe.withDefault (placeholder 100)


genericLink : List (Attribute msg)
genericLink =
    [ Font.color primary, Font.underline, Border.width 3, Border.color transparent, mouseOver [ Font.color primaryActive ], focused [ Border.color focusedColor ] ]


buttonLink : List (Attribute msg)
buttonLink =
    [ Border.color primary, Border.rounded 5, Border.width 1, padding 10, mouseOver [ Background.color gray20 ] ]


boxButton =
    [ padding 10, Background.color primary, Font.color white, width (px 180), mouseOver [ Background.color primaryActive ] ]
