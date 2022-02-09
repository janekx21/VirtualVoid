module Dialog exposing (..)

import Colors exposing (glassColor, gray70, primary, secondary, warning)
import Common exposing (defaultFocusTarget, materialIcon)
import Element exposing (Element, alignBottom, alignRight, behindContent, centerX, centerY, column, el, fill, height, htmlAttribute, inFront, maximum, minimum, none, padding, px, rgba, row, scrollbarY, spacing, text, width)
import Element.Background as Background
import Element.Border as Border
import Element.Events exposing (onClick)
import Element.Font as Font
import Element.Input exposing (button)
import Html.Attributes
import Link exposing (boxButton, boxButtonBig)
import Material.Icons


type Dialog msg
    = Info (InfoDialog msg)
    | Choice (ChoiceDialog msg)


type alias InfoDialog msg =
    { title : String, label : String, body : Element msg, onClose : msg }


type alias ChoiceDialog msg =
    { title : String, label : String, body : Element msg, onClose : msg, onOk : msg, okText : String }


view : Dialog msg -> Element msg
view dialog =
    case dialog of
        Info infoDialog ->
            viewInfoDialog infoDialog

        Choice choiceDialog ->
            viewChoiceDialog choiceDialog


viewInfoDialog : InfoDialog msg -> Element msg
viewInfoDialog config =
    let
        closeButton onClose =
            button [ alignRight, padding 14, defaultFocusTarget ] { label = materialIcon Material.Icons.close 20, onPress = Just onClose }
    in
    framework config.onClose <|
        el
            ([ centerX
             , centerY
             , inFront <| closeButton config.onClose
             , height100
             ]
                ++ glassPanel
            )
        <|
            el [ width (fill |> minimum 750), height (fill |> minimum 300 |> maximum 800), height100 ] <|
                column [ padding 16, width fill, height fill, spacing 16, height100 ]
                    [ column [ spacing 8 ]
                        [ el [ Font.size 12, Font.color gray70 ] <| text <| config.label
                        , el [ Font.size 20 ] <| text <| config.title
                        ]
                    , el [ width fill, scrollbarY, Element.htmlAttribute <| Html.Attributes.style "flex-basis" "auto" ] <| config.body
                    ]


glassPanel =
    [ Background.color glassColor
    , Border.color glassColor
    , Border.width 1
    , Element.htmlAttribute <| Html.Attributes.style "backdrop-filter" "blur(10px)"
    ]


viewChoiceDialog : ChoiceDialog msg -> Element msg
viewChoiceDialog config =
    let
        closeButton onClose =
            button [ alignRight, padding 14 ] { label = materialIcon Material.Icons.close 20, onPress = Just onClose }
    in
    framework config.onClose <|
        el
            ([ centerX
             , centerY
             , height100
             , inFront <| closeButton config.onClose
             , inFront <|
                row [ alignRight, alignBottom ]
                    [ button (boxButtonBig secondary) { label = text "Cancel", onPress = Just config.onClose }
                    , button (boxButtonBig primary) { label = text config.okText, onPress = Just config.onOk }
                    ]
             ]
                ++ glassPanel
            )
        <|
            el [ width (fill |> minimum 750), height (fill |> minimum 300), height100 ] <|
                column [ padding 16, width fill, height fill, spacing 16, height100 ]
                    [ column [ spacing 8 ]
                        [ el [ Font.size 12, Font.color gray70 ] <| text <| config.label
                        , el [ Font.size 20 ] <| text <| config.title
                        ]
                    , el [ width fill, height fill, padding 4, Element.htmlAttribute <| Html.Attributes.style "flex-basis" "auto" ] <| config.body
                    , el [ height (px 48) ] none
                    ]


framework : msg -> Element msg -> Element msg
framework onClose element =
    let
        cancelZone =
            el [ onClick onClose, width fill, height fill, Background.color mask ] <| none
    in
    el [ behindContent cancelZone, width fill, height fill, padding 120, height100 ] <|
        element


height100 =
    Element.htmlAttribute <| Html.Attributes.style "max-height" "100%"


cancel : msg -> Element msg
cancel message =
    el [ onClick message, width fill, height fill ] <| none


mask =
    rgba 0 0 0 0.2
