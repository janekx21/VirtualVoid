module InfoDialog exposing (..)

import Colors exposing (fatal, glasColor)
import Common exposing (materialIcon)
import Element exposing (Element, alignRight, centerX, centerY, column, el, fill, height, inFront, maximum, minimum, none, padding, px, rgba, row, spacing, text, width)
import Element.Background as Background
import Element.Border as Border
import Element.Events exposing (onClick)
import Element.Font as Font
import Element.Input exposing (button)
import Html
import Html.Attributes
import Html.Events exposing (preventDefaultOn)
import Json.Decode as Json
import Material.Icons


type alias InfoDialog msg =
    { title : String, body : Element msg, onClose : msg }


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
                , Element.htmlAttribute <| Html.Attributes.style "backdrop-filter" "blur(4px)"
                , height fill
                , width fill
                ]
            <|
                el [ width (fill |> minimum 750), height (fill |> minimum 300) ] <|
                    column [ padding 16, width fill, height fill, spacing 16 ]
                        [ row [ spacing 20, width fill ]
                            [ el [ Font.size 32, Font.bold ] <| text <| config.title
                            , button [ alignRight ] { label = materialIcon Material.Icons.close 32, onPress = Just config.onClose }
                            ]
                        , config.body
                        ]
    in
    el [ Background.color mask, width fill, height fill ] <|
        column [ width fill, height fill ]
            [ cancel config.onClose
            , row [ width fill, height fill ]
                [ cancel config.onClose
                , dialog
                , cancel config.onClose
                ]
            , cancel config.onClose
            ]


cancel : msg -> Element msg
cancel message =
    el [ onClick message, width fill, height fill ] <| none


mask =
    rgba 0 0 0 0.2
