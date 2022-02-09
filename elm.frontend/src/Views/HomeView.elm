module Views.HomeView exposing (..)

import Colors exposing (gray20, primary)
import Common exposing (bodyView, imageTitleView)
import Element exposing (Attribute, Element, column, fill, height, image, link, minimum, mouseOver, padding, px, text, width)
import Element.Background as Background
import Element.Border as Border
import Element.Input as Input exposing (labelHidden)
import Link exposing (buttonLink)


type alias Model =
    String


init : ( Model, Cmd Msg )
init =
    ( "Foo", Cmd.none )


type Msg
    = Change String


view : Model -> Element Msg
view model =
    column [ width fill, height fill ] [ imageTitleView "Virtual Void" (image [ width (px 52) ] { src = "assets/logo_white.svg", description = "Virtual Void Logo" }), bodyView <| links model ]


links : Model -> Element Msg
links model =
    column []
        [ link buttonLink { url = "/projects", label = text "Projects" }
        , Input.multiline [ height (fill |> minimum 200) ] { text = model, placeholder = Nothing, label = labelHidden "FOo", onChange = Change, spellcheck = True }
        , text "Das ist ein langer langer langer text was geht ab"
        ]


projectLink : List (Attribute msg)
projectLink =
    [ Border.color primary, Border.rounded 5, Border.width 1, padding 10, mouseOver [ Background.color gray20 ] ]


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Change string ->
            ( string, Cmd.none )


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none
