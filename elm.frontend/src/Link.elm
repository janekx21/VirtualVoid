module Link exposing (..)

import Colors exposing (..)
import Element exposing (Attribute, Element, link, mouseOver, padding, text)
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
    [ Font.color primary, Font.underline, mouseOver [ Font.color primaryActive ] ]


buttonLink : List (Attribute msg)
buttonLink =
    [ Border.color primary, Border.rounded 5, Border.width 1, padding 10, mouseOver [ Background.color gray90 ] ]
