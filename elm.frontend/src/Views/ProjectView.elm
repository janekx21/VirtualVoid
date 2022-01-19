module Views.ProjectView exposing (..)

-- model

import Api.Object
import Api.Object.Backlog
import Api.Object.Project
import Api.Query as Query
import Common exposing (body, breadcrumb, genericLink, pill, primary, title)
import Element exposing (Element, centerY, column, el, fill, link, padding, row, spacing, text, width)
import Element.Border as Border
import Element.Font as Font
import Graphql.Http
import Graphql.Operation exposing (RootQuery)
import Graphql.SelectionSet as SelectionSet exposing (SelectionSet, with)
import Html exposing (Html)
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
    , fetchBacklogs id
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


fetchBacklogs : UUID -> Cmd Msg
fetchBacklogs id =
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


view : Model -> Html Msg
view model =
    Element.layout [ width fill ] <| column [ width fill ] [ title "Projects", body <| app model ]


app : Model -> Element Msg
app model =
    column [ spacing 20 ]
        [ breadcrumb [ { label = "home", url = "/" }, { label = "projects", url = "/projects" } ] (RemoteData.withDefault "Projects" (model |> RemoteData.map .name))
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
        , link genericLink { url = "/backlogs/" ++ UUID.toString backlogData.id, label = text <| "open backlog" }
        ]
