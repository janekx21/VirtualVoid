module Views.Projects exposing (..)

-- model

import Api.Object.Project
import Api.Query as Query
import Colors exposing (gray10, gray20, gray30, lightGlassColor, mask10, primary, secondary, white)
import Common exposing (aspect, backdropBlur, bodyView, breadcrumb, materialIcon, pill, query, titleView)
import CustomScalarCodecs exposing (uuidToUrl64)
import Element exposing (Element, alignTop, centerX, centerY, column, el, fill, link, mouseOver, padding, paragraph, px, spacing, text, width, wrappedRow)
import Element.Background as Background
import Element.Font as Font
import Graphql.Http
import Graphql.SelectionSet as SelectionSet exposing (SelectionSet)
import Html.Attributes
import Link exposing (boxButton)
import Material.Icons as Icons
import RemoteData exposing (RemoteData(..))
import UUID exposing (UUID)


type alias Model =
    RemoteData (Graphql.Http.Error Response) Response


type alias ProjectData =
    { id : UUID, name : String, short : String, thumbnailUrl : String }


init : ( Model, Cmd Msg )
init =
    ( NotAsked, fetchProjects )



-- update


type alias Response =
    List ProjectData


type Msg
    = GotFetch (Result (Graphql.Http.Error Response) Response)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg _ =
    case msg of
        GotFetch result ->
            ( RemoteData.fromResult result, Cmd.none )



-- commands


fetchProjects : Cmd Msg
fetchProjects =
    query GotFetch
        (Query.projects
            (SelectionSet.map4 ProjectData
                Api.Object.Project.id
                Api.Object.Project.name
                Api.Object.Project.short
                Api.Object.Project.thumbnailUrl
            )
        )



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
        ((projectData |> List.map (\p -> projectView p)) ++ [ add ])


add =
    el [ width (px (256 + 128)), aspect 1 1, Background.color gray20, mouseOver [ Background.color gray30 ] ] <|
        el [ centerX, centerY ] <|
            materialIcon Icons.add 64


projectView : ProjectData -> Element Msg
projectView project =
    let
        head =
            wrappedRow
                [ spacing 10
                , Background.color lightGlassColor
                , backdropBlur 5
                , padding 16
                , width fill
                ]
                [ paragraph [ Font.size 48, Font.bold, padding 8 ] [ text <| project.name ]
                , el [ Font.size 24, alignTop, padding 8 ] <| pill project.short primary
                ]

        box =
            column
                [ width (px (256 + 128))
                , aspect 1 1
                , mouseOver [ Background.color mask10 ]
                ]
                [ head ]
    in
    link
        [ Background.image project.thumbnailUrl ]
        { url = projectUrl project, label = box }


projectUrl { id } =
    "/projects/" ++ uuidToUrl64 id
