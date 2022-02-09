module Styled exposing (..)

import Colors exposing (gray40, gray50, secondary)
import Element exposing (..)
import Element.Border as Border
import Element.Font as Font
import Element.Input as Input


input : List (Attribute msg) -> { onChange : String -> msg, text : String, placeholder : Maybe (Input.Placeholder msg), label : Input.Label msg } -> Element msg
input attrs textOptions =
    Input.text (attrs ++ border) textOptions


border =
    [ Border.rounded 0, Border.color gray50, Border.widthEach { right = 0, left = 0, top = 0, bottom = 1 } ]


multiline : String -> String -> String -> (String -> msg) -> Element msg
multiline txt placeholder label onChange =
    labeled label <|
        Input.multiline ([ width fill, height (fill |> minimum 128) ] ++ border)
            { text = txt
            , spellcheck = True
            , placeholder = Just <| Input.placeholder [] <| text placeholder
            , label = Input.labelHidden label
            , onChange = onChange
            }


labeled : String -> Element msg -> Element msg
labeled txt element =
    column [ width fill, spacing 5 ]
        [ el [ Font.size 14 ] <| text txt
        , element
        ]
