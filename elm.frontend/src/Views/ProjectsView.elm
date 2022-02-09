module Views.ProjectsView exposing (..)

-- model

import Api.Object
import Api.Object.Project
import Api.Query as Query
import Browser.Navigation exposing (Key, pushUrl, replaceUrl)
import Colors exposing (glassColor, mask10, primary)
import Common exposing (backdropBlur, bodyView, breadcrumb, pill, titleView)
import CustomScalarCodecs exposing (uuidToUrl64)
import Element exposing (Element, alignTop, centerY, column, el, fill, height, inFront, link, mouseOver, none, padding, paragraph, px, row, spacing, text, width, wrappedRow)
import Element.Background as Background
import Element.Font as Font
import Element.Input exposing (button)
import Graphql.Http
import Graphql.Operation exposing (RootQuery)
import Graphql.SelectionSet as SelectionSet exposing (SelectionSet)
import Html.Attributes
import RemoteData exposing (RemoteData(..))
import UUID exposing (UUID)


type alias Model =
    RemoteData (Graphql.Http.Error Response) Response


type alias ProjectData =
    { id : UUID, name : String, short : String, thumbnailUrl : String }


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
    | OpenProject ProjectData



-- url = "/projects/" ++ uuidToUrl64 project.id


update : Msg -> Key -> Model -> ( Model, Cmd Msg )
update msg key model =
    case msg of
        GotFetch remoteData ->
            case remoteData of
                Failure _ ->
                    ( model, replaceUrl key "/offline" )

                _ ->
                    ( remoteData, Cmd.none )

        OpenProject project ->
            ( model, pushUrl key ("/projects/" ++ uuidToUrl64 project.id) )



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
    SelectionSet.map4 ProjectData
        Api.Object.Project.id
        Api.Object.Project.name
        Api.Object.Project.short
        Api.Object.Project.thumbnailUrl



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
        (projectData |> List.map (\p -> projectView p))


projectView : ProjectData -> Element Msg
projectView project =
    let
        box =
            column [ width (px (256 + 128)), Element.htmlAttribute <| Html.Attributes.style "aspect-ratio" "1/1" ]
                [ wrappedRow
                    [ spacing 10
                    , Background.color glassColor
                    , backdropBlur 5
                    , padding 16
                    , width fill
                    ]
                    [ paragraph [ Font.size 48, Font.bold, padding 8 ] [ text <| project.name ]
                    , el [ Font.size 24, alignTop, padding 8 ] <| pill project.short primary
                    ]
                ]
    in
    button
        [ inFront <| el [ mouseOver [ Background.color mask10 ], width fill, height fill ] <| none
        , Background.image project.thumbnailUrl
        ]
        { onPress = Just <| OpenProject project, label = box }



-- behindContent <| el [ width fill, height fill, Background.color white]
