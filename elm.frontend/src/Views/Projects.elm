module Views.Projects exposing (Model, Msg, init, update, view)

import Api.Mutation exposing (CreateProjectRequiredArguments)
import Api.Object.Project
import Api.Query as Query
import Colors exposing (gray20, gray30, lightGlassColor, mask10, primary)
import Common exposing (aspect, backdropBlur, bodyView, breadcrumb, materialIcon, mutate, pill, query, titleView)
import CustomScalarCodecs exposing (uuidToUrl64)
import Dialog exposing (Dialog)
import Element exposing (Element, alignTop, centerX, centerY, column, el, fill, htmlAttribute, link, mouseOver, padding, paragraph, px, spacing, text, width, wrappedRow)
import Element.Background as Background
import Element.Font as Font
import Graphql.Http
import Graphql.SelectionSet as SelectionSet exposing (SelectionSet)
import Html.Attributes exposing (style)
import Link
import Material.Icons as Icons
import Project
import RemoteData exposing (RemoteData(..))
import Styled
import UUID exposing (UUID)



-- model


type alias Model =
    { dialog : Maybe CreateProjectRequiredArguments, projects : RemoteData (Graphql.Http.Error Response) Response }


type alias Project =
    { id : UUID, name : String, short : String, thumbnailUrl : String }


init : ( Model, Cmd Msg )
init =
    ( { dialog = Nothing, projects = NotAsked }, fetchProjects )


emptyProjectArguments : CreateProjectRequiredArguments
emptyProjectArguments =
    { name = "", short = "", thumbnailUrl = "" }



-- update


type alias Response =
    List Project


type Msg
    = GotFetch (Result (Graphql.Http.Error Response) Response)
    | OpenDialog
    | CloseDialog
    | ChangeDialogData CreateProjectRequiredArguments
    | CreatedProject (Result (Graphql.Http.Error ()) ())
    | CreateProject CreateProjectRequiredArguments


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        GotFetch result ->
            ( { model | projects = RemoteData.fromResult result }, Cmd.none )

        OpenDialog ->
            ( { model | dialog = Just emptyProjectArguments }, Cmd.none )

        CloseDialog ->
            ( { model | dialog = Nothing }, Cmd.none )

        ChangeDialogData data ->
            ( { model | dialog = Just data }, Cmd.none )

        CreateProject data ->
            ( { model | dialog = Nothing }, createProject data )

        CreatedProject _ ->
            ( model, fetchProjects )



-- commands


fetchProjects : Cmd Msg
fetchProjects =
    query GotFetch
        (Query.projects
            (SelectionSet.map4 Project
                Api.Object.Project.id
                Api.Object.Project.name
                Api.Object.Project.short
                Api.Object.Project.thumbnailUrl
            )
        )


createProject : CreateProjectRequiredArguments -> Cmd Msg
createProject input =
    mutate CreatedProject
        (Api.Mutation.createProject input (SelectionSet.succeed ()))



-- view


view : Model -> ( Element Msg, Maybe (Dialog Msg) )
view model =
    ( column [ width fill ] [ titleView "Projects", bodyView <| app model ]
    , model.dialog
        |> Maybe.map (\data -> Project.createProjectDialog (CreateProject data) CloseDialog ChangeDialogData data)
        |> Maybe.map Dialog.Choice
    )


app : Model -> Element Msg
app model =
    column [ spacing 20, width fill ]
        [ breadcrumb [ Just { label = "home", url = "/" } ] (Just "projects")
        , maybeProjects model
        ]


maybeProjects : Model -> Element Msg
maybeProjects model =
    case model.projects of
        NotAsked ->
            text <| "not asked"

        Loading ->
            text <| "loading"

        Failure _ ->
            text <| "failure"

        Success a ->
            projectsView a


projectsView : List Project -> Element Msg
projectsView projectData =
    wrappedRow
        [ width fill, spacing 2 ]
        ((projectData |> List.map (\p -> projectView p)) ++ [ add ])


add =
    Styled.button [ width (px (256 + 128)), aspect 1 1, Background.color gray20, mouseOver [ Background.color gray30 ] ] OpenDialog <|
        el [ centerX, centerY ] <|
            materialIcon Icons.add 64


projectView : Project -> Element Msg
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
        [ Background.image project.thumbnailUrl, htmlAttribute <| style "background-color" "#ccc" ]
        { url = projectUrl project, label = box }



-- , behindContent <| el [ width fill, height fill, Background.color gray30 ] none


projectUrl { id } =
    "/projects/" ++ uuidToUrl64 id
