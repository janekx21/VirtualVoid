module Issue exposing (..)

import Api.Enum.Importance exposing (Importance(..))
import Api.Enum.IssueType exposing (IssueType(..))
import Colors exposing (fatal, gray50, primary, success, warning, white)
import Common exposing (Direction(..), coloredMaterialIcon, materialIcon, render, tooltip, validateWith)
import Dialog exposing (ChoiceDialog, InfoDialog)
import Element exposing (..)
import Element.Background as Background
import Element.Font as Font
import Element.Input as Input
import Html exposing (Html)
import Markdown.Renderer exposing (defaultHtmlRenderer)
import Material.Icons
import Material.Icons.Outlined as Outlined
import Styled exposing (labeled, multiline)


type alias SimpleIssue =
    { name : String, points : Int, description : String }


initSimpleIssue : SimpleIssue
initSimpleIssue =
    { name = "", points = 0, description = "" }


issueDialog : msg -> { a | type_ : IssueType, name : String, description : String, number : Int } -> InfoDialog msg
issueDialog onClose issue =
    let
        result : Result String (List (Html msg))
        result =
            render defaultHtmlRenderer issue.description

        description =
            case result of
                Ok value ->
                    paragraph [ width fill, spacing 6 ] (value |> List.map html)

                Err error ->
                    text <| error
    in
    { title = issue.name
    , label = "Issue"
    , body =
        column [ spacing 16, width fill ]
            [ row [ spacing 8 ] [ typeIcon issue.type_, text <| ("#" ++ String.fromInt issue.number) ]
            , description
            ]
    , onClose = onClose
    }


createIssueDialog : SimpleIssue -> msg -> msg -> (SimpleIssue -> msg) -> ChoiceDialog msg
createIssueDialog issue onCreate onClose onChange =
    let
        body : Element msg
        body =
            column [ spacing 16, width fill ]
                [ Styled.input [ Common.defaultFocusTarget ]
                    { text = issue.name
                    , label = Input.labelAbove [ Font.size 14 ] <| text "Name"
                    , placeholder = Just <| Input.placeholder [] <| text "Your Issue Name"
                    , onChange = \string -> onChange { issue | name = string }
                    }
                , pointInput issue onChange
                , multiline issue.description "Describe your Issue here" "Description" (\string -> onChange { issue | description = string })
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


pointInput : { a | points : Int } -> ({ a | points : Int } -> b) -> Element b
pointInput issue onChange =
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
    in
    labeled "Points" <|
        row []
            [ Input.button [ height fill, Background.color gray50, Font.color white ] { label = materialIcon Material.Icons.remove 24, onPress = Just <| onChange { issue | points = issue.points - 1 } }
            , Styled.input [ width (px 48) ]
                { text =
                    issue.points
                        |> String.fromInt
                        |> (\d ->
                                if d == "0" then
                                    ""

                                else
                                    d
                           )
                , label = Input.labelHidden "Points"
                , placeholder = Just <| Input.placeholder [ alignRight ] <| text "0"
                , onChange = \string -> onChange { issue | points = string |> parsePoints |> Maybe.withDefault issue.points }
                }
            , Input.button [ height fill, Background.color gray50, Font.color white ]
                { label = materialIcon Material.Icons.add 24
                , onPress = Just <| onChange { issue | points = issue.points + 1 }
                }
            ]


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


typeText : IssueType -> String
typeText type_ =
    case type_ of
        Improvement ->
            "Improvement"

        Bug ->
            "Bug / Issue"

        Dept ->
            "Technical Dept / Dept"

        Task ->
            "Task / Subtask"


typeIcon type_ =
    let
        matIcon : IssueType -> Element msg
        matIcon issueType =
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
    in
    el (tooltip Right <| typeText type_) <| matIcon type_


validPoints num =
    num >= 0 && num < 100
