module Views.BacklogsView exposing (..)

import Api.Object.Backlog
import Api.Object.Issue
import Api.Object.Project
import Api.Query as Query
import Common exposing (body, breadcrumb, title)
import Element exposing (Element, column, fill, link, none, spacing, text, width)
import Graphql.Http
import Graphql.Operation exposing (RootQuery)
import Graphql.SelectionSet as SelectionSet exposing (SelectionSet, with)
import Html exposing (Html)
import RemoteData exposing (RemoteData)
import UUID exposing (UUID)



-- model


type alias IssueData =
    { id : UUID, name : String }


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
    Element.layout [ width fill ] <| column [ width fill ] [ title "Backlogs", body <| app model ]


app : Model -> Element Msg
app model =
    let
        link =
            model
                |> Maybe.map .project
                |> Maybe.map (\p -> { label = p.name, url = "/projects/" ++ UUID.toString p.id })
                |> Maybe.withDefault { label = "loading", url = "" }

        page =
            [ breadcrumb
                [ { label = "home", url = "/" }
                , { label = "projects", url = "/projects" }
                , link
                ]
                "backlog name"
            , text <| "foo"
            ]
    in
    column [ spacing 20 ] page



-- update


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
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
subscriptions model =
    Sub.none
