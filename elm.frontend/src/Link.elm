module Link exposing (..)

import Colors exposing (primary, primaryLight)
import Element exposing (Attribute, Element, link, mouseOver, text)
import Element.Font as Font
import Placeholder exposing (..)


type alias Link =
    { label : String, url : String }


linkPlaceholder : Loadable Link -> Element msg
linkPlaceholder maybeLink =
    maybeLink |> Maybe.map (\{ label, url } -> link genericLink { label = text label, url = url }) |> Maybe.withDefault (placeholder 100)


genericLink : List (Attribute msg)
genericLink =
    [ Font.color primary, Font.underline, mouseOver [ Font.color primaryLight ] ]
