module Common exposing (..)

import Api.Enum.Importance exposing (Importance(..))
import Api.Enum.IssueType exposing (IssueType(..))
import Colors exposing (black, fatal, gray20, primary, secondary, success, warning, white)
import Element exposing (Attribute, Color, Element, alignBottom, alignRight, centerX, centerY, el, fill, height, none, padding, paddingXY, px, row, text, toRgb, width)
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font
import Html.Attributes
import Link exposing (Link, linkPlaceholder)
import Material.Icons
import Material.Icons.Outlined as Outlined
import Material.Icons.Types exposing (Coloring(..), Icon)
import Placeholder exposing (Loadable, textPlaceholder)


breadcrumb : List (Loadable Link) -> Loadable String -> Element msg
breadcrumb prev current =
    let
        spacer =
            el [ paddingXY 4 0 ] <| text "/"
    in
    row [ padding 4 ]
        (List.map linkPlaceholder prev ++ [ textPlaceholder current 120 ] |> List.intersperse spacer)


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


coloredMaterialIcon : Icon msg -> Int -> Color -> Element msg
coloredMaterialIcon icon size color =
    el [ Font.color color ] <| Element.html <| icon size Inherit


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
    el [ height (px 220), width fill, paddingXY 100 32, Background.color black ] <|
        row [ width fill, alignBottom ]
            [ el [ Font.size 52, Font.color white, Font.extraLight ] <| text txt
            , el [ alignRight ] <| coloredMaterialIcon Outlined.translate 24 white
            ]


iconTitleView : String -> Icon msg -> Element msg
iconTitleView txt icon =
    el [ height (px 220), width fill, paddingXY 100 32, Background.color black ] <|
        row [ width fill, alignBottom ]
            [ coloredMaterialIcon icon 52 white
            , el [ Font.size 52, Font.color white, Font.extraLight ] <| text txt
            , el [ alignRight ] <| coloredMaterialIcon Outlined.translate 24 white
            ]


imageTitleView : String -> Element msg -> Element msg
imageTitleView txt image =
    el [ height (px 220), width fill, paddingXY 100 32, Background.color black ] <|
        row [ width fill, alignBottom ]
            [ image
            , el [ Font.size 52, Font.color white, Font.extraLight ] <| text txt
            , el [ alignRight ] <| coloredMaterialIcon Outlined.translate 24 white
            ]


bodyView : Element msg -> Element msg
bodyView child =
    el [ width fill, height fill, paddingXY 100 10 ] <|
        el [ centerX, width fill, height fill ] <|
            child


backdropBlur : Int -> Attribute msg
backdropBlur amount =
    Element.htmlAttribute <| Html.Attributes.style "backdrop-filter" ("blur( " ++ String.fromInt amount ++ "px)")


issueIcon : IssueType -> Element msg
issueIcon issueType =
    let
        ( icon, color ) =
            case issueType of
                Task ->
                    ( Outlined.task_alt, primary )

                Bug ->
                    ( Outlined.bug_report, fatal )

                Improvement ->
                    ( Outlined.arrow_circle_up, success )

                Dept ->
                    ( Outlined.compare, warning )
    in
    coloredMaterialIcon icon 20 color


importanceIcon : Importance -> Element msg
importanceIcon importance =
    let
        icon =
            case importance of
                Low ->
                    Material.Icons.trending_down

                Medium ->
                    Material.Icons.trending_flat

                High ->
                    Material.Icons.trending_up
    in
    materialIcon icon 20
