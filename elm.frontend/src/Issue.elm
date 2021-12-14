module Issue exposing (..)

import Common exposing (breadcrumb, gray40, gray90, green, materialIcon, orange, pill, red)
import Element exposing (Color, Element, alignBottom, alignRight, centerX, column, el, fill, height, paddingXY, paragraph, px, row, spacing, text, textColumn, width)
import Element.Background as Background
import Element.Font as Font
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


type alias Epic =
    { title : String, short : String }


type Importance
    = High
    | Middle
    | Low


type alias Issue =
    { title : String
    , type_ : IssueType
    , state : Maybe State
    , labels : List Label
    , number : Int
    , assigned : Maybe User
    , description : String
    , epic : Maybe Epic
    , importance : Importance
    , points : Int
    }


type alias Model =
    { issue : Issue }


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

        des =
            [ "Create Mielstone swimlanes by copying the code from the task group."
            , "AC's:"
            , " - copy stuff"
            , " - convert code with group shit"
            ]
                |> String.join "\n"
    in
    { issue = Issue "Milestones swimlanes" Task Nothing [ Label "dev|plan" red, backend ] 80 janek des Nothing Middle 8 }


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
            [ el [ Font.size 48 ] <| text "Issue"
            , el [ alignRight ] (materialIcon Outlined.translate 24)
            ]


body : Model -> Element Msg
body model =
    el [ width fill, height fill, paddingXY 100 10 ] <|
        el [ centerX, width fill, height fill ] <|
            column [ width fill, height fill, spacing 20 ]
                [ breadcrumb [ "root", "foo", "issue" ] ("#" ++ String.fromInt model.issue.number)
                , viewIssue model.issue
                ]


viewIssue : Issue -> Element Msg
viewIssue i =
    let
        lines =
            String.split "\n" i.description

        state =
            case i.state of
                Just s ->
                    s.title

                Nothing ->
                    "no state"
    in
    row [ width fill, Font.size 16, spacing 10 ]
        [ column [ spacing 20, width fill ]
            [ row [ spacing 10 ] [ issueIcon i.type_, el [ Font.family [ Font.monospace ] ] <| text <| "#" ++ String.fromInt i.number ]
            , row [ spacing 5 ] (i.labels |> List.map (\l -> pill l.text l.color))
            , el [ Font.size 32, Font.bold ] <| text i.title
            , textColumn [] (lines |> List.map (\l -> paragraph [] [ text l ]))
            ]
        , column [ spacing 20 ]
            [ section "assigned to" <| text (Maybe.withDefault "Nobody" i.assigned)
            , section "status" <| text state
            , section "story points" <| pill (String.fromInt i.points) gray90
            ]
        ]


section : String -> Element msg -> Element msg
section heading child =
    column [ spacing 5 ]
        [ el [ Font.bold, Font.color gray40 ] <| text (String.toUpper heading)
        , el [] <| child
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
