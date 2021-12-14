module IssueOnline exposing (..)

import Api.Object
import Api.Object.Issue
import Api.Query as Query
import Browser
import Common exposing (breadcrumb, gray40, gray90, materialIcon, orange, pill, red)
import Element exposing (Color, Element, alignBottom, alignRight, centerX, column, el, fill, height, paddingXY, paragraph, px, row, spacing, text, textColumn, width)
import Element.Background as Background
import Element.Font as Font
import Graphql.Http
import Graphql.Operation exposing (RootQuery)
import Graphql.SelectionSet as SelectionSet exposing (SelectionSet)
import Material.Icons.Outlined as Outlined
import RemoteData exposing (RemoteData(..))


main : Program () Model Msg
main =
    Browser.element { init = init, view = view, subscriptions = \_ -> Sub.none, update = update }



-- model


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


type alias SimpleIssueData =
    { name : String, description : String }


type alias Model =
    { issue : Issue, error : String }


init : () -> ( Model, Cmd Msg )
init _ =
    let
        backend =
            Label "backend" orange

        janek =
            Just "Janek"

        des =
            [ "Create Mielstone swimlanes by copying the code from the task group."
            , "AC's:"
            , " - copy stuff"
            , " - convert code with group shit"
            ]
                |> String.join "\n"
    in
    ( { issue = Issue "Milestones swimlanes" Task Nothing [ Label "dev|plan" red, backend ] 80 janek des Nothing Middle 8, error = "no error" }, makeRequest )


type alias Response =
    List SimpleIssueData



-- update


type Msg
    = GotMessage (RemoteData (Graphql.Http.Error Response) Response)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        GotMessage remoteData ->
            case remoteData of
                Success f ->
                    let
                        issue =
                            model.issue

                        first =
                            Maybe.withDefault (SimpleIssueData "nothin" "no") (List.head f)

                        issue2 =
                            { issue | title = first.name, description = first.description }
                    in
                    ( { model | issue = issue2 }, Cmd.none )

                Failure f ->
                    ( { model | error = "failure" }, Cmd.none )

                Loading ->
                    ( { model | error = "loading" }, Cmd.none )

                NotAsked ->
                    ( { model | error = "not asked" }, Cmd.none )



-- commands


makeRequest : Cmd Msg
makeRequest =
    query
        |> Graphql.Http.queryRequest "http://localhost:8080/graphql"
        |> Graphql.Http.send (RemoteData.fromResult >> GotMessage)


query : SelectionSet (List SimpleIssueData) RootQuery
query =
    Query.issues issueSelection


issueSelection : SelectionSet SimpleIssueData Api.Object.Issue
issueSelection =
    SelectionSet.map2 SimpleIssueData
        Api.Object.Issue.name
        Api.Object.Issue.description



-- view


view model =
    Element.layout [ width fill, height fill ] <| app model


app : Model -> Element Msg
app model =
    column [ width fill, height fill ] [ text <| model.error, title, body model ]


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
