module Views.HomeView exposing (..)

import Common exposing (blue, body, lightBlue, title)
import Element exposing (Attribute, Element, column, fill, link, mouseOver, padding, text, width)
import Element.Background as Background
import Element.Border as Border
import Html exposing (Html)


type alias Model =
    ()


init : ( Model, Cmd Msg )
init =
    ( (), Cmd.none )


type Msg
    = Never


view : Model -> Html Msg
view model =
    Element.layout [ width fill ] <| column [ width fill ] [ title "Virtual Void", body links ]


links : Element Msg
links =
    column []
        [ link projectLink { url = "/projects", label = text "Projects" }
        ]


projectLink : List (Attribute msg)
projectLink =
    [ Border.color blue, Border.rounded 5, Border.width 1, padding 10, mouseOver [ Background.color lightBlue ] ]


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    ( model, Cmd.none )


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none
