module Link exposing (..)

import Colors exposing (..)
import Element exposing (Attribute, Element, el, fill, focused, height, inFront, link, mouseOver, none, padding, paddingEach, px, scale, text, width)
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font
import Html.Attributes
import Placeholder exposing (..)


type alias Link =
    { label : String, url : String }


linkPlaceholder : Loadable Link -> Element msg
linkPlaceholder maybeLink =
    maybeLink |> Maybe.map (\{ label, url } -> link genericLink { label = text label, url = url }) |> Maybe.withDefault (el [ padding 4 ] <| placeholder 100)


genericLink : List (Attribute msg)
genericLink =
    [ Font.color primary
    , Border.color transparent
    , mouseOver [ Font.color primaryActive ]
    , padding 4
    ]


buttonLink : List (Attribute msg)
buttonLink =
    [ Border.color primary
    , Border.rounded 5
    , Border.width 1
    , padding 10
    , mouseOver [ Background.color gray20 ]
    ]


boxButton =
    [ padding 10, Background.color primary, Font.color white, width (px 180), mouseOver [ Background.color primaryActive ] ]



-- padding 24 48


boxButtonBig color =
    [ paddingEach { top = 16, left = 16, bottom = 32, right = 16 }, Background.color color, Font.color white, width (px 196), inFront <| el [ width fill, height fill, mouseOver [ Background.color mask20 ] ] <| none ]
