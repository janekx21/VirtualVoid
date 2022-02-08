module Issue exposing (..)

import Api.Enum.Importance exposing (Importance(..))
import Api.Enum.IssueType exposing (IssueType(..))
import Colors exposing (fatal, primary, success, warning)
import Common exposing (coloredMaterialIcon, materialIcon, render, validateWith)
import Dialog exposing (ChoiceDialog, InfoDialog)
import Element exposing (Element, alignRight, column, fill, height, minimum, paragraph, px, row, spacing, text, width)
import Element.Font as Font
import Element.Input as Input
import Html exposing (Html)
import Markdown.Renderer exposing (defaultHtmlRenderer)
import Material.Icons
import Material.Icons.Outlined as Outlined


type alias SimpleIssue =
    { name : String, points : Int, description : String }


initSimpleIssue : SimpleIssue
initSimpleIssue =
    { name = "", points = 0, description = "" }


issueDialog : { a | type_ : IssueType, name : String, description : String, number : Int } -> msg -> InfoDialog msg
issueDialog issue onClose =
    let
        result : Result String (List (Html msg))
        result =
            render defaultHtmlRenderer issue.description

        description =
            case result of
                Ok value ->
                    paragraph [ width fill, spacing 6 ] (value |> List.map Element.html)

                Err error ->
                    text <| error
    in
    { title = issue.name
    , label = "Issue"
    , body =
        column [ spacing 16, width fill ]
            [ row [ spacing 8 ] [ issueIcon issue.type_, text <| ("#" ++ String.fromInt issue.number) ]
            , description
            ]
    , onClose = onClose
    }


createIssueDialog : SimpleIssue -> msg -> msg -> (SimpleIssue -> msg) -> ChoiceDialog msg
createIssueDialog issue onCreate onClose onChange =
    let
        emptyToZero str =
            if String.isEmpty str then
                "0"

            else
                str

        parsePoints string =
            string
                |> emptyToZero
                |> String.toInt
                |> Maybe.andThen (validateWith validPoints)

        body : Element msg
        body =
            column [ spacing 16, width fill ]
                [ Input.text []
                    { text = issue.name
                    , label = Input.labelAbove [ Font.size 14 ] <| text "Name"
                    , placeholder = Just <| Input.placeholder [] <| text "Your Issue Name"
                    , onChange = \string -> onChange { issue | name = string }
                    }
                , Input.text [ width (px 48) ]
                    { text =
                        issue.points
                            |> String.fromInt
                            |> (\d ->
                                    if d == "0" then
                                        ""

                                    else
                                        d
                               )
                    , label = Input.labelAbove [ Font.size 14 ] <| text "Points"
                    , placeholder = Just <| Input.placeholder [ alignRight ] <| text "0"
                    , onChange = \string -> onChange { issue | points = string |> parsePoints |> Maybe.withDefault issue.points }
                    }
                , Input.multiline [ width fill, height (fill |> minimum 100) ]
                    { text = issue.description
                    , spellcheck = True
                    , placeholder = Just <| Input.placeholder [] <| text "Describe your Issue here"
                    , label = Input.labelAbove [ Font.size 14 ] <| text "Description"
                    , onChange = \string -> onChange { issue | description = string }
                    }
                ]
    in
    { title = "Create Issue"
    , label = "Issue"
    , body =
        body
    , onClose = onClose
    , onOk = onCreate
    , okText = "Create"
    }


issueIcon : IssueType -> Element msg
issueIcon issueType =
    let
        ( icon, color ) =
            case issueType of
                Task ->
                    ( Outlined.task_alt, primary )

                Bug ->
                    ( Outlined.bug_report, fatal )

                Improvement ->
                    ( Outlined.arrow_circle_up, success )

                Dept ->
                    ( Outlined.compare, warning )
    in
    coloredMaterialIcon icon 20 color


importanceIcon : Importance -> Element msg
importanceIcon importance =
    let
        icon =
            case importance of
                Low ->
                    Material.Icons.trending_down

                Medium ->
                    Material.Icons.trending_flat

                High ->
                    Material.Icons.trending_up
    in
    materialIcon icon 20


validPoints num =
    num >= 0 && num < 100
