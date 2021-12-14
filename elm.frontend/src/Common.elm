module Common exposing (..)

import Element exposing (Attribute, Color, Element, alignBottom, alignRight, centerX, centerY, el, fill, height, link, mouseOver, none, padding, paddingXY, px, rgb255, row, text, toRgb, width)
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font
import Material.Icons.Outlined as Outlined
import Material.Icons.Types exposing (Coloring(..), Icon)


breadcrumb : List { txt : String, url : String } -> String -> Element msg
breadcrumb prev current =
    let
        spacer =
            el [ paddingXY 5 0 ] <| text "/"
    in
    row [ padding 5 ] <|
        (prev
            |> List.map (\i -> row [] [ link genericLink { label = text i.txt, url = i.url }, spacer ])
        )
            ++ [ text current ]


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
        , Border.color blue
        , Background.color <|
            if isChecked then
                lightBlue

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
        rgb =
            toRgb color

        flipFontColor =
            (rgb.red + rgb.blue + rgb.green) / 3.0 < 0.5
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


title : String -> Element msg
title txt =
    el [ height (px 120), width fill, paddingXY 100 5, Background.color gray90 ] <|
        row [ width fill, alignBottom ]
            [ el [ Font.size 48 ] <| text txt
            , el [ alignRight ] <| Element.html <| Outlined.translate 24 Inherit
            ]


body : Element msg -> Element msg
body child =
    el [ width fill, height fill, paddingXY 100 10 ] <|
        el [ centerX, width fill, height fill ] <|
            child


genericLink : List (Attribute msg)
genericLink =
    [ Font.color blue, Font.underline, mouseOver [ Font.color lightBlue ] ]


white =
    rgb255 255 255 255


blue =
    rgb255 21 94 231


lightBlue =
    rgb255 200 211 248


green =
    rgb255 9 182 18


orange =
    rgb255 218 158 6


red =
    rgb255 183 8 54


gray90 =
    rgb255 222 222 222


gray40 =
    rgb255 72 72 72


black =
    rgb255 0 0 0
