module Views.ProjectsView exposing (..)

-- model

import Api.Object
import Api.Object.Project
import Api.Query as Query
import Browser.Navigation exposing (Key, pushUrl, replaceUrl)
import Colors exposing (glasColor, mask10, primary)
import Common exposing (backdropBlur, bodyView, breadcrumb, pill, titleView)
import CustomScalarCodecs exposing (uuidToUrl64)
import Element exposing (Element, centerY, column, el, fill, height, inFront, link, mouseOver, none, padding, px, row, spacing, text, width, wrappedRow)
import Element.Background as Background
import Element.Font as Font
import Graphql.Http
import Graphql.Operation exposing (RootQuery)
import Graphql.SelectionSet as SelectionSet exposing (SelectionSet)
import Html.Attributes
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


update : Msg -> Key -> Model -> ( Model, Cmd Msg )
update msg key model =
    case msg of
        GotFetch remoteData ->
            case remoteData of
                Failure _ ->
                    ( model, replaceUrl key "/offline" )

                _ ->
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
    column [ spacing 20, width fill ]
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
    wrappedRow
        [ width fill, spacing 2 ]
        (projectData |> List.map (List.repeat 19) |> List.concat |> List.map (\p -> projectView p))


projectView : ProjectData -> Element Msg
projectView project =
    let
        label =
            column [ width (px (256 + 128)), Element.htmlAttribute <| Html.Attributes.style "aspect-ratio" "1/1" ]
                [ row [ spacing 10, Background.color glasColor, backdropBlur 5, padding 16, width fill ] [ el [ Font.size 48, Font.bold ] <| text <| project.name, el [ Font.size 24, centerY ] <| pill project.short primary ]
                ]
    in
    link
        [ inFront <| el [ mouseOver [ Background.color mask10 ], width fill, height fill ] <| none
        , Background.image "assets/pexels-mikhael-mayim-8826427.jpg"
        ]
        { url = "/projects/" ++ uuidToUrl64 project.id, label = label }



-- behindContent <| el [ width fill, height fill, Background.color white]
