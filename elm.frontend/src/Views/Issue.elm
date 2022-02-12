module Views.Issue exposing (..)

-- model

import Element exposing (Element, text)
import Html exposing (Html)
import UUID exposing (UUID)


type alias Model =
    {}


init : UUID -> ( Model, Cmd Msg )
init id =
    ( {}
    , Cmd.none
    )



-- update


type Msg
    = Never


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    ( model, Cmd.none )



-- subscriptions


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none



-- view


view : Model -> Html Msg
view model =
    Element.layout [] <| text <| "issues"
