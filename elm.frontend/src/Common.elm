module Common exposing (..)

import Colors exposing (black, gray90, primary, secondary, white)
import Element exposing (Attribute, Color, Element, alignBottom, alignRight, centerX, centerY, el, fill, height, none, padding, paddingXY, px, row, text, toRgb, width)
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font
import Link exposing (Link, linkPlaceholder)
import Material.Icons.Outlined as Outlined
import Material.Icons.Types exposing (Coloring(..), Icon)
import Placeholder exposing (Loadable, textPlaceholder)


breadcrumb : List (Loadable Link) -> Loadable String -> Element msg
breadcrumb prev current =
    let
        spacer =
            el [ paddingXY 5 0 ] <| text "/"
    in
    row [ padding 5 ] <|
        List.map (\ml -> row [] [ linkPlaceholder ml, spacer ]) prev
            ++ [ textPlaceholder current 120 ]


labelledCheckboxIcon : Bool -> Element msg
labelledCheckboxIcon isChecked =
    let
        size =
            32

        knob =
            el
                [ width <| px size
                , height <| px size
                , Border.rounded 999
                , Background.color white
                ]
                none
    in
    el
        [ width <| px 80
        , height <| px (size + 2 * 2)
        , centerY
        , Border.rounded 999
        , Border.width 2
        , Border.color primary
        , Background.color <|
            if isChecked then
                secondary

            else
                white
        ]
    <|
        row [ width fill ] <|
            if isChecked then
                [ el [ centerX ] <| text "On", knob ]

            else
                [ knob, el [ centerX ] <| text "Off" ]


materialIcon : Icon msg -> Int -> Element msg
materialIcon icon size =
    el [] <| Element.html <| icon size Inherit


pill : String -> Color -> Element msg
pill string color =
    let
        { red, green, blue } =
            toRgb color

        flipFontColor =
            (red + green + blue) / 3.0 < 0.5
    in
    el
        [ padding 6
        , Border.rounded 100
        , Background.color color
        , Font.color
            (if flipFontColor then
                white

             else
                black
            )
        ]
    <|
        text string


titleView : String -> Element msg
titleView txt =
    el [ height (px 120), width fill, paddingXY 100 5, Background.color gray90 ] <|
        row [ width fill, alignBottom ]
            [ el [ Font.size 48 ] <| text txt
            , el [ alignRight ] <| Element.html <| Outlined.translate 24 Inherit
            ]


bodyView : Element msg -> Element msg
bodyView child =
    el [ width fill, height fill, paddingXY 100 10 ] <|
        el [ centerX, width fill, height fill ] <|
            child
