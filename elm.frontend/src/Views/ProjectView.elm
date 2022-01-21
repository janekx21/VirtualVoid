module Views.ProjectView exposing (..)

-- model

import Api.Object.Backlog
import Api.Object.Project
import Api.Query as Query
import Colors exposing (primary)
import Common exposing (bodyView, breadcrumb, titleView)
import CustomScalarCodecs exposing (uuidToUrl64)
import Element exposing (Element, column, fill, link, padding, spacing, text, width)
import Element.Border as Border
import Graphql.Http
import Graphql.Operation exposing (RootQuery)
import Graphql.SelectionSet as SelectionSet exposing (SelectionSet, with)
import Link exposing (genericLink)
import RemoteData exposing (RemoteData(..))
import UUID exposing (UUID)


type alias Model =
    RemoteData (Graphql.Http.Error Response) Response


type alias BacklogData =
    { id : UUID, name : String }


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
    column [ width fill ] [ titleView "Project", bodyView <| app model ]


app : Model -> Element Msg
app model =
    column [ spacing 20 ]
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
projectView projectData =
    column [ spacing 20 ] (projectData.backlogs |> List.map (\b -> backlogView b))


backlogView : BacklogData -> Element Msg
backlogView backlogData =
    column [ spacing 10, Border.color primary, Border.rounded 5, Border.width 1, padding 10 ]
        [ text <| backlogData.name
        , link genericLink { url = "/backlogs/" ++ uuidToUrl64 backlogData.id, label = text <| "open backlog" }
        ]
