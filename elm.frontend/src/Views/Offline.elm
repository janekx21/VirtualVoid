module Views.Offline exposing (..)

import Common exposing (materialIcon)
import Element exposing (Element, centerX, centerY, column, el, height, padding, row, spacing, text, width)
import Element.Font as Font
import Material.Icons as Icons


view : Element msg
view =
    row [ centerX, centerY, padding 100, Font.size 64, spacing 8 ] [ materialIcon Icons.cloud_off 64, text "You are Offline" ]
