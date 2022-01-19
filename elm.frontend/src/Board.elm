module Board exposing (main)

import Common exposing (breadcrumb, fatal, gray90, labelledCheckboxIcon, pill, primary, primaryLight, success, warning)
import Element exposing (Color, Element, alignBottom, alignRight, alignTop, centerX, centerY, column, el, fill, height, padding, paddingXY, paragraph, px, row, scrollbarX, spacing, text, width, wrappedRow)
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font
import Element.Input as Input exposing (labelHidden, labelLeft, placeholder)
import Html exposing (Html)
import Material.Icons.Outlined as Outlined
import Material.Icons.Types exposing (Coloring(..))


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


type alias Issue =
    { title : String, type_ : IssueType, labels : List Label, number : Int, assigned : User }


type alias State =
    { title : String, issues : List Issue }


type alias Model =
    { states : List State }


init : Model
init =
    let
        backend =
            Label "backend" warning

        frontend =
            Label "frontend" success
    in
    { states =
        [ State "Todo"
            [ Issue "Milestones swimlanes" Task [ Label "dev|plan" fatal, backend ] 80 "Janek"
            , Issue "Assign issue to epic" Task [ backend ] 45 "Tobi"
            , Issue "Create group" Task [ frontend, Label "group-task" fatal ] 78 "Janek"
            , Issue "Remove issue from board" Task [] 38 "Tobi"
            ]
        , State "Doing"
            [ Issue "Update issue due date from sidebar" Task [ frontend ] 54 "Tobi"
            , Issue "Update issue's labels from sidebar" Bug [ frontend ] 55 "Janek"
            , Issue "Update issue labels" Task [] 75 "Tobi"
            ]
        , State "Done"
            [ Issue "Persist collapsed state of Swimlanes" Task [ Label "Deliverable" fatal, Label "test test" success ] 32 "Tobi"
            , Issue "Remove list from board" Task [ Label "Caliber" fatal, Label "Colorado" success, Label "feature proposal" primary ] 44 "Janek"
            , Issue "Remove issue from Swimlane" Bug [ frontend ] 36 "Tobi"
            , Issue "Expand diff to entire file" Task [ Label "Premium" warning, Label "dev" primary, Label "manage" fatal, frontend ] 25 "Tobi"
            ]
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
            [ el [ Font.size 48 ] <| text "Issues"
            , el [ alignRight ] <| Element.html <| Outlined.translate 24 Inherit
            ]


body : Model -> Element Msg
body model =
    el [ width fill, height fill, paddingXY 100 10 ] <|
        el [ centerX, width fill, height fill ] <|
            column [ width fill, height fill, spacing 20 ]
                [ breadcrumb [ "root", "foo" ] "issues"
                , filter
                , board model.states
                ]


filter : Element Msg
filter =
    row [ Font.size 16, spacing 24 ]
        [ Input.text [ width (px 250), Border.rounded 5, Border.color primaryLight ] { label = labelHidden "filter", onChange = SetFilter, placeholder = Just (placeholder [] <| text "Search or Filter results..."), text = "" }
        , Input.checkbox [] { onChange = SetLabelVisible, checked = True, label = labelLeft [ centerY ] <| text "Show labels:", icon = labelledCheckboxIcon }
        , row [ spacing 6 ] [ text "Group by:", row [ Border.rounded 5, Border.width 1, Border.color primaryLight, padding 12 ] [ text "None", el [] <| Element.html <| Outlined.expand_more 16 Inherit ] ]
        ]


board : List State -> Element Msg
board states =
    row [ width fill, height fill, spacing 10, scrollbarX ]
        (states |> List.map (\s -> viewState s))


viewState : State -> Element Msg
viewState state =
    column [ width fill, alignTop, spacing 10 ] <|
        [ el [ Font.size 24, Font.bold ] <| text state.title ]
            ++ (state.issues |> List.map (\i -> viewIssue i))


viewIssue : Issue -> Element Msg
viewIssue i =
    column [ width fill, padding 10, Border.color primary, Border.rounded 3, Border.width 1, Font.size 16, spacing 10 ]
        [ paragraph [ Font.semiBold ] [ text i.title ]
        , wrappedRow [ spacing 5 ] (i.labels |> List.map (\l -> pill l.text l.color))
        , row [ width fill, spacing 5 ] [ issueIcon i.type_, text ("#" ++ String.fromInt i.number), el [ alignRight ] <| text ("assigned to " ++ i.assigned) ]
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
    el [] <| Element.html <| icon 20 Inherit
