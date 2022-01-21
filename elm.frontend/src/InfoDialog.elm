module InfoDialog exposing (..)

import Colors exposing (glasColor, gray40)
import Common exposing (materialIcon)
import Element exposing (Element, alignRight, column, el, fill, height, inFront, minimum, none, padding, rgba, row, scrollbarY, spacing, text, width)
import Element.Background as Background
import Element.Border as Border
import Element.Events exposing (onClick)
import Element.Font as Font
import Element.Input exposing (button)
import Html.Attributes
import Material.Icons


type alias InfoDialog msg =
    { title : String, label : String, body : Element msg, onClose : msg }


view : Maybe (InfoDialog msg) -> Element msg
view maybeDialog =
    maybeDialog |> Maybe.map (\d -> viewDialog d) |> Maybe.withDefault none


viewDialog : InfoDialog msg -> Element msg
viewDialog config =
    let
        dialog =
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
                el [ width (fill |> minimum 750), height (fill |> minimum 300), mh ] <|
                    column [ padding 16, width fill, height fill, mh, spacing 16 ]
                        [ column [ spacing 8 ]
                            [ el [ Font.size 12, Font.color gray40 ] <| text <| config.label
                            , el [ Font.size 20 ] <| text <| config.title
                            ]
                        , el [ width fill, scrollbarY, Element.htmlAttribute <| Html.Attributes.style "flex-basis" "auto" ] <| config.body
                        ]
    in
    el
        [ Background.color mask
        , width fill
        , height fill
        , Element.htmlAttribute <| Html.Attributes.style "position" "fixed"
        , Element.htmlAttribute <| Html.Attributes.style "height" "100vh"
        ]
    <|
        column [ width fill, height fill ]
            [ cancel config.onClose
            , row [ width fill, height fill ]
                [ cancel config.onClose
                , dialog
                , cancel config.onClose
                ]
            , cancel config.onClose
            ]


mh =
    Element.htmlAttribute <| Html.Attributes.style "max-height" "100%"


cancel : msg -> Element msg
cancel message =
    el [ onClick message, width fill, height fill ] <| none


mask =
    rgba 0 0 0 0.2
