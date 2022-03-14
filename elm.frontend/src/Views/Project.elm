module Views.Project exposing (..)

import Api.Enum.Importance exposing (Importance)
import Api.Enum.IssueType exposing (IssueType)
import Api.Object.Backlog
import Api.Object.Epic
import Api.Object.Issue
import Api.Object.Project
import Api.Query as Query
import Browser.Events exposing (onClick)
import Colors exposing (..)
import Common exposing (bodyView, breadcrumb, focusDefaultTarget, iconTitleView, materialIcon, pill, query)
import CustomScalarCodecs exposing (uuidToUrl64)
import Dialog exposing (Dialog)
import Element exposing (Color, Element, alignRight, column, el, fill, height, inFront, link, mouseOver, none, padding, paddingXY, paragraph, pointer, px, row, spacing, text, width)
import Element.Background as Background
import Element.Font as Font
import Element.Input exposing (button)
import Graphql.Http
import Graphql.Operation exposing (RootQuery)
import Graphql.SelectionSet as SelectionSet exposing (SelectionSet, with)
import Issue exposing (importanceIcon, typeIcon)
import Link exposing (genericLink)
import Material.Icons as Icons
import RemoteData exposing (RemoteData(..))
import UUID exposing (UUID)



-- model


type alias Model =
    { project : RemoteData (Graphql.Http.Error ProjectData) ProjectData
    , dialog : Maybe DetailedIssueData
    }


type alias EpicData =
    { name : String, color : Color }


type alias SimpleIssueData =
    { id : UUID, name : String, type_ : IssueType, number : Int, points : Int, importance : Importance, epic : Maybe EpicData }


type alias DetailedIssueData =
    { id : UUID
    , name : String
    , type_ : IssueType
    , number : Int
    , points : Int
    , importance : Importance
    , epic : Maybe EpicData
    , description : String
    }


type alias BacklogData =
    { id : UUID, name : String, issues : List SimpleIssueData }


type alias ProjectData =
    { name : String, backlogs : List BacklogData }


init : UUID -> ( Model, Cmd Msg )
init id =
    ( { project = NotAsked, dialog = Nothing }
    , fetchProject id
    )



-- update


type Msg
    = GotProjectFetch (Result (Graphql.Http.Error ProjectData) ProjectData)
    | OpenIssueDialog UUID
    | GotIssueFetch (Result (Graphql.Http.Error DetailedIssueData) DetailedIssueData)
    | CloseIssueDialog
    | NoOp


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        GotProjectFetch result ->
            ( { model | project = RemoteData.fromResult result }, Cmd.none )

        OpenIssueDialog id ->
            ( model, fetchIssue id )

        GotIssueFetch result ->
            case result of
                Ok issue ->
                    ( { model | dialog = Just issue }, focusDefaultTarget NoOp )

                Err _ ->
                    ( model, Cmd.none )

        CloseIssueDialog ->
            ( { model | dialog = Nothing }, Cmd.none )

        NoOp ->
            ( model, Cmd.none )



-- commands


fetchProject : UUID -> Cmd Msg
fetchProject id =
    query GotProjectFetch
        (Query.project { id = id }
            (SelectionSet.succeed ProjectData
                |> with Api.Object.Project.name
                |> with
                    (Api.Object.Project.backlogs
                        (SelectionSet.succeed BacklogData
                            |> with Api.Object.Backlog.id
                            |> with Api.Object.Backlog.name
                            |> with
                                (Api.Object.Backlog.issues
                                    (SelectionSet.succeed SimpleIssueData
                                        |> with Api.Object.Issue.id
                                        |> with Api.Object.Issue.name
                                        |> with Api.Object.Issue.type_
                                        |> with Api.Object.Issue.number
                                        |> with Api.Object.Issue.points
                                        |> with Api.Object.Issue.importance
                                        |> with epicSelectionSet
                                    )
                                )
                        )
                    )
            )
        )


epicSelectionSet =
    Api.Object.Issue.epic
        (SelectionSet.succeed EpicData
            |> with Api.Object.Epic.name
            |> with (Api.Object.Epic.color colorSelection)
        )


fetchIssue : UUID -> Cmd Msg
fetchIssue id =
    query GotIssueFetch
        (Query.issue { id = id }
            (SelectionSet.succeed DetailedIssueData
                |> with Api.Object.Issue.id
                |> with Api.Object.Issue.name
                |> with Api.Object.Issue.type_
                |> with Api.Object.Issue.number
                |> with Api.Object.Issue.points
                |> with Api.Object.Issue.importance
                |> with epicSelectionSet
                |> with Api.Object.Issue.description
            )
        )



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
-- subscriptions


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none



-- view


view : Model -> ( Element Msg, Maybe (Dialog Msg) )
view model =
    ( column [ width fill ] [ iconTitleView "Project" Icons.domain, bodyView <| app model ]
    , model.dialog |> Maybe.map (Issue.issueDialog CloseIssueDialog) |> Maybe.map Dialog.Info
    )


app : Model -> Element Msg
app model =
    column [ spacing 64, width fill ]
        [ breadcrumb [ Just { label = "home", url = "/" }, Just { label = "projects", url = "/projects" } ] (RemoteData.toMaybe (model.project |> RemoteData.map .name))
        , maybeProjects model.project
        ]


maybeProjects : RemoteData (Graphql.Http.Error ProjectData) ProjectData -> Element Msg
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
    let
        backlogs =
            if List.isEmpty project.backlogs then
                row [ padding 16, spacing 8 ] [ materialIcon Icons.hide_source 24, text "This Project is empty. You should add a backlog." ]

            else
                column [ spacing 16, width fill ] (project.backlogs |> List.map backlogView)
    in
    column [ width fill, spacing 32 ]
        [ el [ Font.size 28 ] <| text project.name
        , backlogs
        ]


backlogView : BacklogData -> Element Msg
backlogView backlogData =
    column
        [ width fill
        , spacing 24
        , padding 16
        , Background.color gray20
        , inFront <|
            row [ alignRight ]
                [ button transparentButton { label = materialIcon Icons.add 24, onPress = Nothing }
                , el transparentButton <|
                    materialIcon Icons.more_horiz 24
                ]
        ]
        [ row [ spacing 8, width fill ]
            [ el [ Font.bold ] <| text <| backlogData.name
            , link genericLink { url = "/backlogs/" ++ uuidToUrl64 backlogData.id, label = text <| "open backlog" }
            ]
        , viewBacklog backlogData
        ]


transparentButton =
    [ padding 10, mouseOver [ Background.color mask10 ], pointer, height (px 44) ]


viewBacklog : BacklogData -> Element Msg
viewBacklog backlog =
    if List.isEmpty backlog.issues then
        row [ padding 16, spacing 8 ] [ materialIcon Icons.hide_source 24, text "This Backlog is empty" ]

    else
        let
            sortedIssues =
                backlog.issues |> List.sortBy .number
        in
        column [ width fill, spacing 32 ]
            [ column [ width fill ] (sortedIssues |> List.map (\i -> viewIssue i) |> List.intersperse (el [ width fill, height (px 1), Background.color Colors.mask10 ] <| none))
            ]


viewIssue : SimpleIssueData -> Element Msg
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
    button [ width fill, paddingXY 8 2 ]
        { onPress = Just <| OpenIssueDialog issue.id
        , label =
            row [ spacing 10, width fill, Font.size 16 ]
                [ typeIcon issue.type_
                , importanceIcon issue.importance
                , text ("#" ++ String.fromInt issue.number)
                , paragraph [ spacing 5 ] [ text issue.name ]
                , row [ spacing 5, alignRight ] [ epic ]
                , el [ alignRight ] <| pill points white
                ]
        }
