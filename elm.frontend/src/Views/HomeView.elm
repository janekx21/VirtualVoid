module Views.HomeView exposing (..)

import Colors exposing (gray20, primary)
import Common exposing (bodyView, imageTitleView)
import Element exposing (Attribute, Element, column, fill, height, image, link, mouseOver, padding, px, text, width)
import Element.Background as Background
import Element.Border as Border
import Link exposing (buttonLink)


type alias Model =
    ()


init : ( Model, Cmd Msg )
init =
    ( (), Cmd.none )


type Msg
    = Never


view : Model -> Element Msg
view model =
    column [ width fill, height fill ] [ imageTitleView "Virtual Void" (image [ width (px 52) ] { src = "assets/logo_white.svg", description = "Virtual Void Logo" }), bodyView links ]


links : Element Msg
links =
    column []
        [ link buttonLink { url = "/projects", label = text "Projects" }
        ]


projectLink : List (Attribute msg)
projectLink =
    [ Border.color primary, Border.rounded 5, Border.width 1, padding 10, mouseOver [ Background.color gray20 ] ]


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    ( model, Cmd.none )


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none
