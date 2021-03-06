module Colors exposing (..)

import Api.Object
import Api.Object.Color
import Element exposing (Color, rgb, rgb255, rgba255)
import Graphql.SelectionSet as SelectionSet exposing (SelectionSet)


colorSelection : SelectionSet Color Api.Object.Color
colorSelection =
    SelectionSet.map3 (\r g b -> rgb r g b)
        Api.Object.Color.red
        Api.Object.Color.green
        Api.Object.Color.blue


white =
    rgb255 255 255 255


black =
    rgb255 0 0 0


red50 =
    rgb255 250 77 86


red60 =
    rgb255 218 30 40


blue90 =
    rgb255 0 29 108


blue70 =
    rgb255 0 67 206


blue60 =
    rgb255 15 98 254


green50 =
    rgb255 36 162 72


green60 =
    rgb255 25 128 56


gray80 =
    rgb255 57 57 57


gray70 =
    rgb255 82 82 82


gray60 =
    rgb255 111 111 111


gray50 =
    rgb255 141 141 141


gray40 =
    rgb255 168 168 168


gray30 =
    rgb255 198 198 198


gray20 =
    rgb255 224 224 224


gray10 =
    rgb255 244 244 244


orange40 =
    rgb255 255 131 43


buildInGray =
    rgb255 186 189 182


primary : Color
primary =
    blue60


primaryActive : Color
primaryActive =
    blue90


secondary : Color
secondary =
    gray70


success : Color
success =
    green60


warning =
    orange40


fatal =
    red60


lightGlassColor =
    rgba255 255 255 255 0.8


darkGlassColor =
    rgba255 38 38 38 0.8


transparent =
    rgba255 0 0 0 0


mask10 =
    rgba255 0 0 0 0.1


mask20 =
    rgba255 0 0 0 0.2


focus =
    rgb255 155 203 255
