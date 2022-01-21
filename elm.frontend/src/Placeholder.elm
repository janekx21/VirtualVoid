module Placeholder exposing (..)

import Colors exposing (..)
import Element exposing (..)
import Element.Background as Background
import Element.Border as Border


type alias Loadable a =
    Maybe a


textPlaceholder : Loadable String -> Int -> Element msg
textPlaceholder maybeString w =
    maybeString |> Maybe.map text |> Maybe.withDefault (placeholder w)


placeholder : Int -> Element msg
placeholder pixelWidth =
    el [ Background.color gray20, height fill, width (px pixelWidth), Border.rounded 2 ] <| none
