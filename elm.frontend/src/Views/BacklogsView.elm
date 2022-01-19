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


type alias BacklogData =
    { id : UUID, name : String, issues : List IssueData }


type alias ProjectData =
    { name : String, backlogs : List BacklogData }


type alias Model =
    ()


init : UUID -> ( Model, Cmd Msg )
init id =
    ( (), fetch id )


type Msg
    = GotFetch (RemoteData (Graphql.Http.Error Response) Response)


type alias Response =
    ProjectData



-- view


view : Model -> Html Msg
view model =
    Element.layout [ width fill ] <| column [ width fill ] [ title "Backlogs", body <| app model ]


app : Model -> Element Msg
app model =
    column [ spacing 20 ]
        [ breadcrumb [ { txt = "home", url = "/" }, { txt = "projects", url = "/projects" }, { txt = "parnet project", url = "/projects/uuid" } ] "backlog name"
        , text <| "foo"
        ]



-- update


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    ( model, Cmd.none )



-- commands


fetch : UUID -> Cmd Msg
fetch id =
    query id
        |> Graphql.Http.queryRequest "http://localhost:8080/graphql"
        |> Graphql.Http.send (RemoteData.fromResult >> GotFetch)


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
                                )
                            )
                    )
                )
        )



-- subscriptions


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none
