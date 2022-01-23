module Views.ProjectView exposing (..)

-- model

import Api.Enum.Importance exposing (Importance)
import Api.Enum.IssueType exposing (IssueType)
import Api.Object.Backlog
import Api.Object.Epic
import Api.Object.Issue
import Api.Object.Project
import Api.Query as Query
import Colors exposing (colorSelection, gray20, mask10, primary)
import Common exposing (bodyView, breadcrumb, iconTitleView, importanceIcon, issueIcon, pill, titleView)
import CustomScalarCodecs exposing (uuidToUrl64)
import Element exposing (Color, Element, alignRight, column, el, fill, height, link, mouseOver, none, padding, paddingXY, paragraph, px, row, spacing, text, width)
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font
import Element.Input exposing (button)
import Graphql.Http
import Graphql.Operation exposing (RootQuery)
import Graphql.SelectionSet as SelectionSet exposing (SelectionSet, with)
import Link exposing (genericLink)
import Material.Icons
import RemoteData exposing (RemoteData(..))
import UUID exposing (UUID)
import Views.BacklogView exposing (EpicData)


type alias Model =
    RemoteData (Graphql.Http.Error Response) Response


type alias EpicData =
    { name : String, color : Color }


type alias IssueData =
    { id : UUID, name : String, type_ : IssueType, number : Int, points : Int, importance : Importance, epic : Maybe EpicData }


type alias BacklogData =
    { id : UUID, name : String, issues : List IssueData }


type alias ProjectData =
    { name : String, backlogs : List BacklogData }


init : UUID -> ( Model, Cmd Msg )
init id =
    ( NotAsked
    , fetch id
    )



-- update


type alias Response =
    ProjectData


type Msg
    = GotFetch (RemoteData (Graphql.Http.Error Response) Response)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg _ =
    case msg of
        GotFetch remoteData ->
            ( remoteData, Cmd.none )



-- commands


fetch : UUID -> Cmd Msg
fetch id =
    query id
        |> Graphql.Http.queryRequest "http://localhost:8080/graphql"
        |> Graphql.Http.send (RemoteData.fromResult >> GotFetch)



{--
query : UUID -> SelectionSet ProjectData RootQuery
query id =
    Query.project { id = id }
        (SelectionSet.map ProjectData
            (Api.Object.Project.backlogs
                (SelectionSet.map2 BacklogData Api.Object.Backlog.name Api.Object.Backlog.id)
            )
        )
        --}


query : UUID -> SelectionSet ProjectData RootQuery
query id =
    Query.project { id = id }
        (SelectionSet.succeed ProjectData
            |> with Api.Object.Project.name
            |> with
                (Api.Object.Project.backlogs
                    (SelectionSet.succeed BacklogData
                        |> with Api.Object.Backlog.id
                        |> with Api.Object.Backlog.name
                        |> with
                            (Api.Object.Backlog.issues
                                (SelectionSet.succeed IssueData
                                    |> with Api.Object.Issue.id
                                    |> with Api.Object.Issue.name
                                    |> with Api.Object.Issue.type_
                                    |> with Api.Object.Issue.number
                                    |> with Api.Object.Issue.points
                                    |> with Api.Object.Issue.importance
                                    |> with
                                        (Api.Object.Issue.epic
                                            (SelectionSet.succeed EpicData
                                                |> with Api.Object.Epic.name
                                                |> with (Api.Object.Epic.color colorSelection)
                                            )
                                        )
                                )
                            )
                    )
                )
        )



-- subscriptions


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none



-- view


view : Model -> Element Msg
view model =
    column [ width fill ] [ iconTitleView "Project" Material.Icons.domain, bodyView <| app model ]


app : Model -> Element Msg
app model =
    column [ spacing 64, width fill ]
        [ breadcrumb [ Just { label = "home", url = "/" }, Just { label = "projects", url = "/projects" } ] (RemoteData.toMaybe (model |> RemoteData.map .name))
        , maybeProjects model
        ]


maybeProjects : Model -> Element Msg
maybeProjects model =
    case model of
        NotAsked ->
            text <| "not asked"

        Loading ->
            text <| "loading"

        Failure e ->
            text <| "failure"

        Success a ->
            projectView a


projectView : ProjectData -> Element Msg
projectView project =
    column [ width fill, spacing 32 ]
        [ el [ Font.size 28 ] <| text project.name
        , column [ spacing 16, width fill ] (project.backlogs |> List.map (\b -> backlogView b))
        ]


backlogView : BacklogData -> Element Msg
backlogView backlogData =
    column [ width fill, spacing 10, Border.color primary, Border.rounded 5, Border.width 1, padding 10 ]
        [ text <| backlogData.name
        , link genericLink { url = "/backlogs/" ++ uuidToUrl64 backlogData.id, label = text <| "open backlog" }
        , viewBacklog backlogData
        ]


viewBacklog : BacklogData -> Element Msg
viewBacklog backlog =
    let
        sortedIssues =
            backlog.issues |> List.sortBy .number
    in
    column [ width fill, spacing 32 ]
        [ column [ width fill ] (sortedIssues |> List.map (\i -> viewIssue i) |> List.intersperse (el [ width fill, height (px 1), Background.color gray20 ] <| none))
        ]


viewIssue : IssueData -> Element Msg
viewIssue issue =
    let
        epic =
            issue.epic |> Maybe.map (\e -> pill e.name e.color) |> Maybe.withDefault none

        points =
            if issue.points > 0 then
                String.fromInt issue.points

            else
                "-"
    in
    el [ width fill, paddingXY 8 2 ] <|
        row [ spacing 10, width fill, Font.size 16 ]
            [ issueIcon issue.type_
            , importanceIcon issue.importance
            , text ("#" ++ String.fromInt issue.number)
            , paragraph [ spacing 5 ] [ text issue.name ]
            , row [ spacing 5, alignRight ] [ epic ]
            , el [ alignRight ] <| pill points gray20
            ]
