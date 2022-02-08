module Common exposing (..)

import Api.Enum.Importance exposing (Importance(..))
import Api.Enum.IssueType exposing (IssueType(..))
import Browser.Dom
import Colors exposing (black, fatal, gray20, primary, secondary, success, warning, white)
import Element exposing (Attribute, Color, Element, alignBottom, alignRight, centerX, centerY, el, fill, height, htmlAttribute, none, padding, paddingXY, px, row, text, toRgb, width)
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font
import Html.Attributes
import Link exposing (Link, linkPlaceholder)
import Markdown.Parser
import Markdown.Renderer
import Material.Icons
import Material.Icons.Outlined as Outlined
import Material.Icons.Types exposing (Coloring(..), Icon)
import Placeholder exposing (Loadable, textPlaceholder)
import Task


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
    el titleBar <|
        row [ width fill, alignBottom ]
            [ el [ Font.size 52, Font.color white, Font.extraLight ] <| text txt
            , el [ alignRight ] <| coloredMaterialIcon Outlined.translate 24 white
            ]


iconTitleView : String -> Icon msg -> Element msg
iconTitleView txt icon =
    el titleBar <|
        row [ width fill, alignBottom ]
            [ coloredMaterialIcon icon 52 white
            , el [ Font.size 52, Font.color white, Font.extraLight ] <| text txt
            , el [ alignRight ] <| coloredMaterialIcon Outlined.translate 24 white
            ]


imageTitleView : String -> Element msg -> Element msg
imageTitleView txt image =
    el
        titleBar
    <|
        row [ width fill, alignBottom ]
            [ image
            , el [ Font.size 52, Font.color white, Font.extraLight ] <| text txt
            , el [ alignRight ] <| coloredMaterialIcon Outlined.translate 24 white
            ]


titleBar =
    [ Background.color black, height (px 220), width fill, paddingXY 100 32 ]


gridBackground =
    [ Background.tiled "assets/dots_white.svg"
    , Element.htmlAttribute <| Html.Attributes.style "background-size" "16px"
    ]


bodyView : Element msg -> Element msg
bodyView child =
    el [ width fill, height fill, paddingXY 100 10 ] <|
        el [ centerX, width fill, height fill ] <|
            child


backdropBlur : Int -> Attribute msg
backdropBlur amount =
    Element.htmlAttribute <| Html.Attributes.style "backdrop-filter" ("blur( " ++ String.fromInt amount ++ "px)")


render : Markdown.Renderer.Renderer view -> String -> Result String (List view)
render renderer markdown =
    markdown
        |> Markdown.Parser.parse
        |> Result.mapError deadEndsToString
        |> Result.andThen (\ast -> Markdown.Renderer.render renderer ast)


deadEndsToString deadEnds =
    deadEnds
        |> List.map Markdown.Parser.deadEndToString
        |> String.join "\n"


validateWith : (a -> Bool) -> a -> Maybe a
validateWith function a =
    if function a then
        Just a

    else
        Nothing


defaultFocusTarget =
    htmlAttribute <| Html.Attributes.id "focus"


focusDefaultTarget onSuccess =
    Browser.Dom.focus "focus" |> Task.attempt (\_ -> onSuccess)
