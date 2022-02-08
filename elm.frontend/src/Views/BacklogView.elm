module Views.BacklogView exposing (..)

import Api.Enum.Importance exposing (Importance(..))
import Api.Enum.IssueType exposing (IssueType(..))
import Api.Object.Backlog
import Api.Object.Epic
import Api.Object.Issue
import Api.Object.Project
import Api.Query as Query
import Browser.Dom
import Colors exposing (colorSelection, gray20, mask10, white)
import Common exposing (bodyView, breadcrumb, coloredMaterialIcon, iconTitleView, pill)
import CustomScalarCodecs exposing (uuidToUrl64)
import Dialog exposing (ChoiceDialog, Dialog, InfoDialog)
import Element exposing (Color, Element, alignRight, column, el, fill, height, link, mouseOver, none, padding, paragraph, px, row, spacing, text, width)
import Element.Background as Background
import Element.Font as Font
import Element.Input exposing (button)
import Graphql.Http
import Graphql.Operation exposing (RootQuery)
import Graphql.SelectionSet as SelectionSet exposing (SelectionSet, with)
import Issue exposing (SimpleIssue, createIssueDialog, importanceIcon, initSimpleIssue, issueDialog, issueIcon)
import Link exposing (boxButton)
import Material.Icons
import RemoteData exposing (RemoteData)
import Task
import UUID exposing (UUID)



-- model


type alias EpicData =
    { name : String, color : Color }


type alias IssueData =
    { id : UUID, name : String, type_ : IssueType, number : Int, points : Int, importance : Importance, epic : Maybe EpicData, description : String }


type alias ProjectData =
    { id : UUID, name : String }


type alias BacklogData =
    { id : UUID, name : String, issues : List IssueData, project : ProjectData }


type OpenDialog
    = IssueDialog IssueData
    | CreateDialog SimpleIssue


type alias Model =
    { backlog : Maybe BacklogData, currentDialog : Maybe OpenDialog }


init : UUID -> ( Model, Cmd Msg )
init id =
    ( Model Nothing (Just <| CreateDialog initSimpleIssue), fetch id )


type Msg
    = GotFetch (RemoteData (Graphql.Http.Error Response) Response)
    | OpenIssue IssueData
    | CloseDialog
    | OpenCreateDialog
    | CreateIssue
    | ChangeIssue SimpleIssue
    | NoOp


type alias Response =
    BacklogData



-- view


view : Model -> ( Element Msg, Maybe (Dialog Msg) )
view model =
    let
        viewDialog : OpenDialog -> Dialog Msg
        viewDialog dialog =
            case dialog of
                IssueDialog issue ->
                    Dialog.Info <| issueDialog issue CloseDialog

                CreateDialog data ->
                    Dialog.Choice <| createIssueDialog data CreateIssue CloseDialog ChangeIssue
    in
    ( column [ width fill, height fill ] [ iconTitleView "Backlog" Material.Icons.toc, bodyView <| app model ]
    , model.currentDialog |> Maybe.map viewDialog
    )



-- TODO elm-ui renderer


app : Model -> Element Msg
app model =
    let
        link =
            model.backlog
                |> Maybe.map .project
                |> Maybe.map (\p -> { label = p.name, url = "/projects/" ++ uuidToUrl64 p.id })

        backlog =
            case model.backlog of
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
                (model.backlog |> Maybe.map .name)
            , backlog
            ]
    in
    column [ spacing 64, width fill ] page


viewBacklog : BacklogData -> Element Msg
viewBacklog backlog =
    let
        sortedIssues =
            backlog.issues |> List.sortBy .number

        head =
            row [ width fill ] [ el [ alignRight ] <| addButton ]

        lines =
            head :: (sortedIssues |> List.map viewIssue)

        separator =
            el [ width fill, height (px 1), Background.color gray20 ] <| none
    in
    column [ width fill, spacing 32 ]
        [ el [ Font.size 28 ] <| text backlog.name
        , column [ width fill ] (lines |> List.intersperse separator)
        ]


addButton : Element Msg
addButton =
    button boxButton
        { onPress = Just OpenCreateDialog
        , label =
            row [ width fill ]
                [ text <| "New Issue"
                , el [ alignRight ] <| coloredMaterialIcon Material.Icons.add 24 white
                ]
        }


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

        element =
            row [ spacing 10, width fill, Font.size 16 ]
                [ issueIcon issue.type_
                , importanceIcon issue.importance
                , text ("#" ++ String.fromInt issue.number)
                , paragraph [ Font.semiBold ] [ text issue.name ]
                , row [ spacing 5, alignRight ] [ epic ]
                , el [ alignRight ] <| pill points gray20
                ]
    in
    button [ width fill, mouseOver [ Background.color mask10 ], padding 8 ] { onPress = Just <| OpenIssue issue, label = element }



--, el [] <| text ("assigned to " ++ Maybe.withDefault "Nobody" i.assigned)
-- update


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        GotFetch remoteData ->
            ( { model | backlog = RemoteData.toMaybe remoteData }, Cmd.none )

        OpenIssue issueData ->
            ( { model | currentDialog = Just <| IssueDialog issueData }, Browser.Dom.focus "focus" |> Task.attempt (\_ -> NoOp) )

        CloseDialog ->
            ( { model | currentDialog = Nothing }, Cmd.none )

        CreateIssue ->
            ( { model | currentDialog = Nothing }, Cmd.none )

        ChangeIssue data ->
            model.currentDialog
                |> Maybe.andThen
                    (\dialog ->
                        case dialog of
                            CreateDialog _ ->
                                Just ( { model | currentDialog = Just <| CreateDialog data }, Cmd.none )

                            _ ->
                                Nothing
                    )
                |> Maybe.withDefault ( model, Cmd.none )

        OpenCreateDialog ->
            ( { model | currentDialog = Just <| CreateDialog initSimpleIssue }, Cmd.none )

        NoOp ->
            ( model, Cmd.none )



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
                        |> with Api.Object.Issue.points
                        |> with Api.Object.Issue.importance
                        |> with
                            (Api.Object.Issue.epic
                                (SelectionSet.succeed EpicData
                                    |> with Api.Object.Epic.name
                                    |> with (Api.Object.Epic.color colorSelection)
                                )
                            )
                        |> with Api.Object.Issue.description
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
