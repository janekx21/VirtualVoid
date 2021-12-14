module Backlog exposing (..)

import Common exposing (blue, breadcrumb, gray90, green, labelledCheckboxIcon, lightBlue, materialIcon, orange, pill, red)
import Element exposing (Color, Element, alignBottom, alignRight, centerX, centerY, column, el, fill, height, padding, paddingXY, paragraph, px, row, spacing, text, width)
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font
import Element.Input as Input exposing (labelHidden, labelLeft, placeholder)
import Html exposing (Html)
import Material.Icons.Outlined as Outlined


main : Html Msg
main =
    Element.layout [ width fill, height fill ] <| app init


type IssueType
    = Task
    | Bug


type alias User =
    String


type alias Label =
    { text : String, color : Color }


type alias State =
    { title : String }


type alias Issue =
    { title : String, type_ : IssueType, state : Maybe State, labels : List Label, number : Int, assigned : Maybe User }


type alias Model =
    { issues : List Issue }


init : Model
init =
    let
        backend =
            Label "backend" orange

        frontend =
            Label "frontend" green

        janek =
            Just "Janek"

        tobi =
            Just "Tobi"
    in
    { issues =
        [ Issue "Milestones swimlanes" Task Nothing [ Label "dev|plan" red, backend ] 80 janek
        , Issue "Assign issue to epic" Task Nothing [ backend ] 45 tobi
        , Issue "Create group" Task Nothing [ frontend, Label "group-task" red ] 78 janek
        , Issue "Remove issue from board" Task Nothing [] 38 tobi
        , Issue "Update issue due date from sidebar" Task Nothing [ frontend ] 54 tobi
        , Issue "Update issue's labels from sidebar" Bug Nothing [ frontend ] 55 janek
        , Issue "Update issue labels" Task Nothing [] 75 tobi
        , Issue "Persist collapsed state of Swimlanes" Task Nothing [ Label "Deliverable" red, Label "test test" green ] 32 tobi
        , Issue "Remove list from board" Task Nothing [ Label "Caliber" red, Label "Colorado" green, Label "feature proposal" blue ] 44 janek
        , Issue "Remove issue from Swimlane" Bug Nothing [ frontend ] 36 tobi
        , Issue "Expand diff to entire file" Task Nothing [ Label "Premium" orange, Label "dev" blue, Label "manage" red, frontend ] 25 janek
        ]
    }


type Msg
    = SetFilter String
    | SetLabelVisible Bool


app : Model -> Element Msg
app model =
    column [ width fill, height fill ] [ title, body model ]


title : Element Msg
title =
    el [ height (px 120), width fill, paddingXY 100 5, Background.color gray90 ] <|
        row [ width fill, alignBottom ]
            [ el [ Font.size 48 ] <| text "Backlog"
            , el [ alignRight ] (materialIcon Outlined.translate 24)
            ]


body : Model -> Element Msg
body model =
    el [ width fill, height fill, paddingXY 100 10 ] <|
        el [ centerX, width fill, height fill ] <|
            column [ width fill, height fill, spacing 20 ]
                [ breadcrumb [ "root", "foo" ] "backlog"
                , filter
                , backlog model.issues
                ]


filter : Element Msg
filter =
    row [ Font.size 16, spacing 24 ]
        [ Input.text [ width (px 250), Border.rounded 5, Border.color lightBlue ] { label = labelHidden "filter", onChange = SetFilter, placeholder = Just (placeholder [] <| text "Search or Filter results..."), text = "" }
        , Input.checkbox [] { onChange = SetLabelVisible, checked = True, label = labelLeft [ centerY ] <| text "Show labels:", icon = labelledCheckboxIcon }
        , row [ spacing 6 ] [ text "Group by:", row [ Border.rounded 5, Border.width 1, Border.color lightBlue, padding 12 ] [ text "None", materialIcon Outlined.expand_more 16 ] ]
        ]


backlog : List Issue -> Element Msg
backlog issues =
    let
        sortedIssues =
            issues |> List.sortBy .number
    in
    column [ spacing 10, width fill ]
        ([ el [ Font.size 24, Font.bold ] <| text "Backlog"
         ]
            ++ (sortedIssues |> List.map (\i -> viewIssue i))
        )


viewIssue : Issue -> Element Msg
viewIssue i =
    row [ width fill, padding 10, Border.color blue, Border.rounded 3, Border.width 1, Font.size 16, spacing 10 ]
        [ issueIcon i.type_
        , text ("#" ++ String.fromInt i.number)
        , paragraph [ Font.semiBold ] [ text i.title ]
        , row [ spacing 5 ] (i.labels |> List.map (\l -> pill l.text l.color))
        , el [] <| text ("assigned to " ++ Maybe.withDefault "Nobody" i.assigned)
        ]


issueIcon : IssueType -> Element Msg
issueIcon issueType =
    let
        icon =
            case issueType of
                Task ->
                    Outlined.task_alt

                Bug ->
                    Outlined.bug_report
    in
    materialIcon icon 20
