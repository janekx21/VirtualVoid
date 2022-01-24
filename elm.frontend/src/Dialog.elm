module Dialog exposing (..)

import Colors exposing (glasColor, gray70)
import Common exposing (materialIcon)
import Element exposing (Element, alignRight, column, el, fill, height, inFront, minimum, none, padding, rgba, row, scrollbarY, spacing, text, width)
import Element.Background as Background
import Element.Border as Border
import Element.Events exposing (onClick)
import Element.Font as Font
import Element.Input exposing (button)
import Html.Attributes
import Material.Icons


type Dialog msg
    = Info (InfoDialog msg)


type alias InfoDialog msg =
    { title : String, label : String, body : Element msg, onClose : msg }


view : Dialog msg -> Element msg
view dialog =
    case dialog of
        Info infoDialog ->
            viewInfoDialog infoDialog


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
