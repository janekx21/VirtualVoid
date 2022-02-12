module Views.Offline exposing (..)

import Element exposing (Element, centerX, centerY, column, el, height, padding, row, text, width)
import Element.Font as Font


view : Element msg
view =
    el [ centerX, centerY, padding 100, Font.size 64 ] <| text "You are Offline 😟"
