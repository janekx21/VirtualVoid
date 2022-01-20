module Views.BacklogView exposing (..)

import Api.Enum.Importance exposing (Importance)
import Api.Enum.IssueType exposing (IssueType(..))
import Api.Object.Backlog
import Api.Object.Epic
import Api.Object.Issue
import Api.Object.Project
import Api.Query as Query
import Colors exposing (fatal, primary)
import Common exposing (bodyView, breadcrumb, materialIcon, pill, titleView)
import Element exposing (Element, alignRight, column, el, fill, height, inFront, link, minimum, none, paragraph, px, row, scrollbarY, spacing, text, width)
import Element.Border as Border
import Element.Font as Font
import Element.Input exposing (button)
import Graphql.Http
import Graphql.Operation exposing (RootQuery)
import Graphql.SelectionSet as SelectionSet exposing (SelectionSet, with)
import Html exposing (Html)
import InfoDialog exposing (InfoDialog)
import Link exposing (buttonLink)
import Markdown.Parser
import Markdown.Renderer
import Material.Icons.Outlined as Outlined
import RemoteData exposing (RemoteData)
import UUID exposing (UUID)



-- model


type alias EpicData =
    { name : String }


type alias IssueData =
    { id : UUID, name : String, type_ : IssueType, number : Int, points : Int, importance : Importance, epic : Maybe EpicData, description : String }


type alias ProjectData =
    { id : UUID, name : String }


type alias BacklogData =
    { id : UUID, name : String, issues : List IssueData, project : ProjectData }


type alias Model =
    { backlog : Maybe BacklogData, openIssue : Maybe IssueData }


init : UUID -> ( Model, Cmd Msg )
init id =
    ( Model Nothing Nothing, fetch id )


type Msg
    = GotFetch (RemoteData (Graphql.Http.Error Response) Response)
    | OpenIssue IssueData
    | CloseIssue


type alias Response =
    BacklogData



-- view


view : Model -> Element Msg
view model =
    column [ width fill, height fill, inFront <| InfoDialog.view <| Maybe.map issueDialog model.openIssue ] [ titleView "Backlog", bodyView <| app model ]


issueDialog : IssueData -> InfoDialog Msg
issueDialog issue =
    let
        result : Result String (List (Html msg))
        result =
            render Markdown.Renderer.defaultHtmlRenderer issue.description

        description =
            case result of
                Ok value ->
                    paragraph [ width fill ] (value |> List.map Element.html |> List.map (el [ width fill ]))

                Err error ->
                    text <| error
    in
    { title = issue.name
    , body =
        column [ spacing 16, width fill, height fill, scrollbarY ]
            [ row [ spacing 8 ] [ issueIcon issue.type_, text <| ("#" ++ String.fromInt issue.number) ]
            , description
            ]
    , onClose = CloseIssue
    }



-- TODO elm-ui renderer


render : Markdown.Renderer.Renderer view -> String -> Result String (List view)
render renderer markdown =
    markdown
        |> Markdown.Parser.parse
        |> Result.mapError deadEndsToString
        |> Result.andThen (\ast -> Markdown.Renderer.render renderer ast)


deadEndsToString deadEnds =
    deadEnds
        |> List.map Markdown.Parser.deadEndToString
        |> String.join "\n"


app : Model -> Element Msg
app model =
    let
        link =
            model.backlog
                |> Maybe.map .project
                |> Maybe.map (\p -> { label = p.name, url = "/projects/" ++ UUID.toString p.id })

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
    column [ spacing 20, width fill ] page


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
viewIssue issue =
    let
        epic =
            issue.epic |> Maybe.map (\e -> pill e.name primary) |> Maybe.withDefault none

        element =
            row [ spacing 10, width fill, Font.size 16 ]
                [ issueIcon issue.type_
                , text ("#" ++ String.fromInt issue.number)
                , paragraph [ Font.semiBold ] [ text issue.name ]
                , row [ spacing 5, alignRight ] [ epic ]
                ]
    in
    button (buttonLink ++ [ width fill ]) { onPress = Just <| OpenIssue issue, label = element }



--, el [] <| text ("assigned to " ++ Maybe.withDefault "Nobody" i.assigned)


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
update msg model =
    case msg of
        GotFetch remoteData ->
            ( { model | backlog = RemoteData.toMaybe remoteData }, Cmd.none )

        OpenIssue issueData ->
            ( { model | openIssue = Just issueData }, Cmd.none )

        CloseIssue ->
            ( { model | openIssue = Nothing }, Cmd.none )



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
                        |> with (Api.Object.Issue.epic (SelectionSet.succeed EpicData |> with Api.Object.Epic.name))
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
