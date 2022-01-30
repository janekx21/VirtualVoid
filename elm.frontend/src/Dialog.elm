module Dialog exposing (..)

import Colors exposing (glasColor, gray70, primary, secondary)
import Common exposing (materialIcon)
import Element exposing (Element, alignBottom, alignRight, column, el, fill, height, inFront, minimum, none, padding, px, rgba, row, scrollbarY, spacing, text, width)
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
    framework config.onClose <|
        el
            [ Background.color glasColor
            , Border.color glasColor
            , Border.width 1
            , Element.htmlAttribute <| Html.Attributes.style "backdrop-filter" "blur(10px)"
            , Element.htmlAttribute <| Html.Attributes.style "max-height" "100vh"
            , height fill
            , width fill
            , inFront <| button [ alignRight, padding 14 ] { label = materialIcon Material.Icons.close 20, onPress = Just config.onClose }
            ]
        <|
            el [ width (fill |> minimum 750), height (fill |> minimum 300), maxHeightFill ] <|
                column [ padding 16, width fill, height fill, maxHeightFill, spacing 16 ]
                    [ column [ spacing 8 ]
                        [ el [ Font.size 12, Font.color gray70 ] <| text <| config.label
                        , el [ Font.size 20 ] <| text <| config.title
                        ]
                    , el [ width fill, scrollbarY, Element.htmlAttribute <| Html.Attributes.style "flex-basis" "auto" ] <| config.body
                    ]


viewChoiceDialog : ChoiceDialog msg -> Element msg
viewChoiceDialog config =
    framework config.onClose <|
        el
            [ Background.color glasColor
            , Border.color glasColor
            , Border.width 1
            , Element.htmlAttribute <| Html.Attributes.style "backdrop-filter" "blur(10px)"
            , Element.htmlAttribute <| Html.Attributes.style "max-height" "100vh"
            , height fill
            , width fill
            , inFront <| button [ alignRight, padding 14 ] { label = materialIcon Material.Icons.close 20, onPress = Just config.onClose }
            , inFront <|
                row [ alignRight, alignBottom ]
                    [ button (boxButtonBig secondary) { label = text "Cancel", onPress = Just config.onClose }
                    , button (boxButtonBig primary) { label = text config.okText, onPress = Just config.onOk }
                    ]
            ]
        <|
            el [ width (fill |> minimum 750), height (fill |> minimum 300), maxHeightFill ] <|
                column [ padding 16, width fill, height fill, maxHeightFill, spacing 16 ]
                    [ column [ spacing 8 ]
                        [ el [ Font.size 12, Font.color gray70 ] <| text <| config.label
                        , el [ Font.size 20 ] <| text <| config.title
                        ]
                    , el [ width fill, height fill, scrollbarY, padding 4, Element.htmlAttribute <| Html.Attributes.style "flex-basis" "auto" ] <| config.body
                    , el [ height (px 48) ] none
                    ]


framework : msg -> Element msg -> Element msg
framework onClose element =
    let
        cancelZone =
            el [ onClick onClose, width fill, height fill ] <| none
    in
    el
        [ Background.color mask
        , width fill
        , height fill
        ]
    <|
        column [ width fill, height fill ]
            [ cancelZone
            , row [ width fill, height fill ]
                [ cancelZone
                , element
                , cancelZone
                ]
            , cancelZone
            ]


maxHeightFill =
    Element.htmlAttribute <| Html.Attributes.style "max-height" "100%"


cancel : msg -> Element msg
cancel message =
    el [ onClick message, width fill, height fill ] <| none


mask =
    rgba 0 0 0 0.2
