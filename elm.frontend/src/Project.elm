module Project exposing (..)

import Common
import Dialog exposing (Dialog)
import Element exposing (..)
import Element.Font as Font
import Element.Input as Input
import Styled exposing (input)


type alias CreateData =
    { name : String
    , short : String
    , thumbnailUrl : String
    }


createProjectDialog : msg -> msg -> (CreateData -> msg) -> CreateData -> Dialog.ChoiceDialog msg
createProjectDialog onCreate onClose onChange model =
    let
        body =
            column [ spacing 16, width fill ]
                [ input [ Common.defaultFocusTarget ]
                    { text = model.name
                    , label = Input.labelAbove [ Font.size 14 ] <| text "Name"
                    , placeholder = Just <| Input.placeholder [] <| text "Your Project Name"
                    , onChange = \string -> onChange { model | name = string }
                    }
                , column [ spacing 5 ]
                    [ el [ Font.size 14 ] <| text "Short"
                    , input [ Font.family [ Font.monospace ], width (px 60) ]
                        { text = model.short
                        , label = Input.labelHidden "Short"
                        , placeholder = Nothing
                        , onChange = \string -> onChange { model | short = string }
                        }
                    ]
                , input []
                    { text = model.thumbnailUrl
                    , label = Input.labelAbove [ Font.size 14 ] <| text "Thumbnail Url"
                    , placeholder = Just <| Input.placeholder [] <| text "https://your-link.domain/image.jpg"
                    , onChange = \string -> onChange { model | thumbnailUrl = string }
                    }
                ]
    in
    { title = "Create Project", label = "Project", okText = "Create", onClose = onClose, onOk = onCreate, body = body }
