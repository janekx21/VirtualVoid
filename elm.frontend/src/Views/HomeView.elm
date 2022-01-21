module Views.HomeView exposing (..)

import Colors exposing (gray90, primary)
import Common exposing (bodyView, titleView)
import Element exposing (Attribute, Element, column, fill, link, mouseOver, padding, text, width)
import Element.Background as Background
import Element.Border as Border


type alias Model =
    ()


init : ( Model, Cmd Msg )
init =
    ( (), Cmd.none )


type Msg
    = Never


view : Model -> Element Msg
view model =
    column [ width fill ] [ titleView "Virtual Void", bodyView links ]


links : Element Msg
links =
    column []
        [ link projectLink { url = "/projects", label = text "Projects" }
        ]


projectLink : List (Attribute msg)
projectLink =
    [ Border.color primary, Border.rounded 5, Border.width 1, padding 10, mouseOver [ Background.color gray90 ] ]


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    ( model, Cmd.none )


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none
