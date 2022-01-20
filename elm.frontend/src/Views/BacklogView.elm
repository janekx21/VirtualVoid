module Views.BacklogView exposing (..)

import Api.Enum.Importance exposing (Importance)
import Api.Enum.IssueType exposing (IssueType(..))
import Api.Object.Backlog
import Api.Object.Epic
import Api.Object.Issue
import Api.Object.Project
import Api.Query as Query
import Colors exposing (primary)
import Common exposing (bodyView, breadcrumb, materialIcon, pill, titleView)
import Element exposing (Element, column, el, fill, link, none, padding, paragraph, row, spacing, text, width)
import Element.Border as Border
import Element.Font as Font
import Graphql.Http
import Graphql.Operation exposing (RootQuery)
import Graphql.SelectionSet as SelectionSet exposing (SelectionSet, with)
import Html exposing (Html)
import Material.Icons.Outlined as Outlined
import RemoteData exposing (RemoteData)
import UUID exposing (UUID)



-- model


type alias EpicData =
    { name : String }


type alias IssueData =
    { id : UUID, name : String, type_ : IssueType, number : Int, importance : Importance, epic : Maybe EpicData }


type alias ProjectData =
    { id : UUID, name : String }


type alias BacklogData =
    { id : UUID, name : String, issues : List IssueData, project : ProjectData }


type alias Model =
    Maybe BacklogData


init : UUID -> ( Model, Cmd Msg )
init id =
    ( Nothing, fetch id )


type Msg
    = GotFetch (RemoteData (Graphql.Http.Error Response) Response)


type alias Response =
    BacklogData



-- view


view : Model -> Html Msg
view model =
    Element.layout [ width fill ] <| column [ width fill ] [ titleView "Backlog", bodyView <| app model ]


app : Model -> Element Msg
app model =
    let
        link =
            model
                |> Maybe.map .project
                |> Maybe.map (\p -> { label = p.name, url = "/projects/" ++ UUID.toString p.id })

        backlog =
            case model of
                Just a ->
                    viewBacklog a

                Nothing ->
                    text <| "loading"

        -- TODO make loading link
        page =
            [ breadcrumb
                [ Just { label = "home", url = "/" }
                , Just { label = "projects", url = "/projects" }
                , link
                ]
                (model |> Maybe.map .name)
            , backlog
            ]
    in
    column [ spacing 20 ] page


viewBacklog : BacklogData -> Element Msg
viewBacklog backlog =
    let
        sortedIssues =
            backlog.issues |> List.sortBy .number
    in
    column [ spacing 10, width fill ]
        ([ el [ Font.size 24, Font.bold ] <| text backlog.name
         ]
            ++ (sortedIssues |> List.map (\i -> viewIssue i))
        )


viewIssue : IssueData -> Element Msg
viewIssue i =
    let
        epic =
            i.epic |> Maybe.map (\e -> pill e.name primary) |> Maybe.withDefault none
    in
    row [ width fill, padding 10, Border.color primary, Border.rounded 3, Border.width 1, Font.size 16, spacing 10 ]
        [ issueIcon i.type_
        , text ("#" ++ String.fromInt i.number)
        , paragraph [ Font.semiBold ] [ text i.name ]
        , row [ spacing 5 ] [ epic ]

        --, el [] <| text ("assigned to " ++ Maybe.withDefault "Nobody" i.assigned)
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

                Improvement ->
                    Outlined.arrow_circle_up

                Dept ->
                    Outlined.compare
    in
    materialIcon icon 20



-- update


update : Msg -> Model -> ( Model, Cmd Msg )
update msg _ =
    case msg of
        GotFetch remoteData ->
            ( RemoteData.toMaybe remoteData, Cmd.none )



-- commands


fetch : UUID -> Cmd Msg
fetch id =
    query id
        |> Graphql.Http.queryRequest "http://localhost:8080/graphql"
        |> Graphql.Http.send (RemoteData.fromResult >> GotFetch)


query : UUID -> SelectionSet BacklogData RootQuery
query id =
    Query.backlog { id = id }
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
                        |> with Api.Object.Issue.importance
                        |> with (Api.Object.Issue.epic (SelectionSet.succeed EpicData |> with Api.Object.Epic.name))
                    )
                )
            |> with
                (Api.Object.Backlog.project
                    (SelectionSet.succeed ProjectData
                        |> with Api.Object.Project.id
                        |> with Api.Object.Project.name
                    )
                )
        )



-- subscriptions


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none
