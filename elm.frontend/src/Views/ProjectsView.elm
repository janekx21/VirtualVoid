module Views.ProjectsView exposing (..)

-- model

import Api.Object
import Api.Object.Project
import Api.Query as Query
import Colors exposing (primary)
import Common exposing (bodyView, breadcrumb, pill, titleView)
import Element exposing (Element, centerY, column, el, fill, link, padding, row, spacing, text, width)
import Element.Border as Border
import Element.Font as Font
import Graphql.Http
import Graphql.Operation exposing (RootQuery)
import Graphql.SelectionSet as SelectionSet exposing (SelectionSet)
import Html exposing (Html)
import Link exposing (genericLink)
import RemoteData exposing (RemoteData(..))
import UUID exposing (UUID)


type alias Model =
    RemoteData (Graphql.Http.Error Response) Response


type alias ProjectData =
    { id : UUID, name : String, short : String }


init : ( Model, Cmd Msg )
init =
    ( NotAsked
    , fetchProjects
    )



-- update


type alias Response =
    List ProjectData


type Msg
    = GotFetch (RemoteData (Graphql.Http.Error Response) Response)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        GotFetch remoteData ->
            ( remoteData, Cmd.none )



-- commands


fetchProjects : Cmd Msg
fetchProjects =
    query
        |> Graphql.Http.queryRequest "http://localhost:8080/graphql"
        |> Graphql.Http.send (RemoteData.fromResult >> GotFetch)


query : SelectionSet (List ProjectData) RootQuery
query =
    Query.projects selection


selection : SelectionSet ProjectData Api.Object.Project
selection =
    SelectionSet.map3 ProjectData
        Api.Object.Project.id
        Api.Object.Project.name
        Api.Object.Project.short



-- view


view : Model -> Element Msg
view model =
    column [ width fill ] [ titleView "Projects", bodyView <| app model ]


app : Model -> Element Msg
app model =
    column [ spacing 20 ]
        [ breadcrumb [ Just { label = "home", url = "/" } ] (Just "projects")
        , maybeProjects model
        ]


maybeProjects : Model -> Element Msg
maybeProjects model =
    case model of
        NotAsked ->
            text <| "not asked"

        Loading ->
            text <| "loading"

        Failure _ ->
            text <| "failure"

        Success a ->
            projectsView a


projectsView : List ProjectData -> Element Msg
projectsView projectData =
    column [] (projectData |> List.map (\p -> projectView p))


projectView : ProjectData -> Element Msg
projectView project =
    column [ Border.color primary, Border.rounded 5, Border.width 1, padding 10, spacing 10 ]
        [ row [ spacing 10 ] [ el [ Font.size 48, Font.bold ] <| text <| project.name, el [ Font.size 24, centerY ] <| pill project.short primary ]
        , link genericLink { url = "/projects/" ++ UUID.toString project.id, label = text <| "Open Project" }
        ]
