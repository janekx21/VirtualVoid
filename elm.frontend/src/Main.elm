module Main exposing (..)

import Browser exposing (Document, UrlRequest)
import Browser.Navigation as Nav
import Colors exposing (gray10)
import Dialog exposing (Dialog)
import Element exposing (Element, el, fill, inFront, none, text, width)
import Element.Background as Background
import Element.Font as Font
import Html exposing (Html)
import Html.Attributes
import Route exposing (Route(..))
import Url exposing (Url)
import Views.BacklogView as BacklogView
import Views.HomeView as HomeView
import Views.IssuesView as IssuesView
import Views.ProjectView as ProjectView
import Views.ProjectsView as ProjectsView


main : Program () Model Msg
main =
    Browser.application
        { view = view
        , update = update
        , init = init
        , subscriptions = subscriptions
        , onUrlChange = UrlChanged
        , onUrlRequest = LinkClicked
        }



-- model


type alias Model =
    { route : Route
    , page : Page
    , navKey : Nav.Key
    }


type Page
    = NotFoundPage
    | HomePage HomeView.Model
    | ProjectsPage ProjectsView.Model
    | ProjectPage ProjectView.Model
    | IssuesPage IssuesView.Model
    | BacklogPage BacklogView.Model


init : () -> Url -> Nav.Key -> ( Model, Cmd Msg )
init _ url navKey =
    let
        model =
            { route = Route.parseUrl url
            , page = NotFoundPage
            , navKey = navKey
            }
    in
    initCurrentPage ( model, Cmd.none )


initCurrentPage : ( Model, Cmd Msg ) -> ( Model, Cmd Msg )
initCurrentPage ( model, existingCmds ) =
    let
        ( currentPage, mappedPageCmds ) =
            case model.route of
                Route.NotFoundRoute ->
                    ( NotFoundPage, Cmd.none )

                Route.HomeRoute ->
                    let
                        ( pageModel, pageCmds ) =
                            HomeView.init
                    in
                    ( HomePage pageModel, Cmd.map HomePageMsg pageCmds )

                Route.ProjectsRoute ->
                    let
                        ( pageModel, pageCmds ) =
                            ProjectsView.init
                    in
                    ( ProjectsPage pageModel, Cmd.map ProjectsPageMsg pageCmds )

                Route.ProjectRoute id ->
                    let
                        ( pageModel, pageCmds ) =
                            ProjectView.init id
                    in
                    ( ProjectPage pageModel, Cmd.map ProjectPageMsg pageCmds )

                Route.IssueRoute id ->
                    let
                        ( pageModel, pageCmds ) =
                            IssuesView.init id
                    in
                    ( IssuesPage pageModel, Cmd.map IssuesPageMsg pageCmds )

                Route.BacklogRoute id ->
                    let
                        ( pageModel, pageCmds ) =
                            BacklogView.init id
                    in
                    ( BacklogPage pageModel, Cmd.map BacklogPageMsg pageCmds )
    in
    ( { model | page = currentPage }
    , Cmd.batch [ existingCmds, mappedPageCmds ]
    )



-- update


type Msg
    = HomePageMsg HomeView.Msg
    | ProjectsPageMsg ProjectsView.Msg
    | IssuesPageMsg IssuesView.Msg
    | BacklogPageMsg BacklogView.Msg
    | ProjectPageMsg ProjectView.Msg
    | LinkClicked UrlRequest
    | UrlChanged Url


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case ( msg, model.page ) of
        ( HomePageMsg subMsg, HomePage pageModel ) ->
            let
                ( updatedPageModel, updatedCmd ) =
                    HomeView.update subMsg pageModel
            in
            ( { model | page = HomePage updatedPageModel }
            , Cmd.map HomePageMsg updatedCmd
            )

        ( IssuesPageMsg subMsg, IssuesPage pageModel ) ->
            let
                ( updatedPageModel, updatedCmd ) =
                    IssuesView.update subMsg pageModel
            in
            ( { model | page = IssuesPage updatedPageModel }
            , Cmd.map IssuesPageMsg updatedCmd
            )

        ( ProjectsPageMsg subMsg, ProjectsPage pageModel ) ->
            let
                ( updatedPageModel, updatedCmd ) =
                    ProjectsView.update subMsg pageModel
            in
            ( { model | page = ProjectsPage updatedPageModel }
            , Cmd.map ProjectsPageMsg updatedCmd
            )

        ( ProjectPageMsg subMsg, ProjectPage pageModel ) ->
            let
                ( updatedPageModel, updatedCmd ) =
                    ProjectView.update subMsg pageModel
            in
            ( { model | page = ProjectPage updatedPageModel }
            , Cmd.map ProjectPageMsg updatedCmd
            )

        ( BacklogPageMsg subMsg, BacklogPage pageModel ) ->
            let
                ( updatedPageModel, updatedCmd ) =
                    BacklogView.update subMsg pageModel
            in
            ( { model | page = BacklogPage updatedPageModel }
            , Cmd.map BacklogPageMsg updatedCmd
            )

        ( LinkClicked urlRequest, _ ) ->
            case urlRequest of
                Browser.Internal url ->
                    ( model, Nav.pushUrl model.navKey (Url.toString url) )

                Browser.External url ->
                    ( model, Nav.load url )

        ( UrlChanged url, _ ) ->
            let
                newRoute =
                    Route.parseUrl url
            in
            ( { model | route = newRoute }, Cmd.none )
                |> initCurrentPage

        ( _, _ ) ->
            ( model, Cmd.none )



-- subscriptions


subscriptions : Model -> Sub Msg
subscriptions parentModel =
    case parentModel.page of
        IssuesPage model ->
            Sub.map IssuesPageMsg (IssuesView.subscriptions model)

        HomePage model ->
            Sub.map HomePageMsg (HomeView.subscriptions model)

        NotFoundPage ->
            Sub.none

        ProjectsPage _ ->
            Sub.none

        ProjectPage model ->
            Sub.map ProjectPageMsg (ProjectView.subscriptions model)

        BacklogPage model ->
            Sub.map BacklogPageMsg (BacklogView.subscriptions model)



-- view


view : Model -> Document Msg
view parentModel =
    case parentModel.page of
        NotFoundPage ->
            Document "Not Found" [ notFoundView ]

        HomePage model ->
            ( HomeView.view model, Nothing ) |> defaultLayout |> document "Home" HomePageMsg

        ProjectsPage model ->
            ( ProjectsView.view model, Nothing ) |> defaultLayout |> document "Projects" ProjectsPageMsg

        ProjectPage model ->
            ( ProjectView.view model, Nothing ) |> defaultLayout |> document "Project" ProjectPageMsg

        IssuesPage pageModel ->
            Document "Issues"
                [ IssuesView.view pageModel
                    |> Html.map IssuesPageMsg
                ]

        BacklogPage model ->
            BacklogView.view model |> defaultLayout |> document "Backlog | Virtual Void" BacklogPageMsg


defaultLayout : ( Element msg, Maybe (Dialog msg) ) -> Html msg
defaultLayout ( el, maybeDialog ) =
    Element.layout
        [ width fill
        , Font.size 16
        , Font.family [ Font.typeface "IBM Plex Sans", Font.sansSerif ]
        , Background.color gray10
        , inFront <| (maybeDialog |> Maybe.map Dialog.view |> Maybe.withDefault none)
        ]
        el


document : String -> (msg -> Msg) -> Html msg -> Document Msg
document name msg html =
    Document name [ fontLink, rebootLink, html |> Html.map msg ]


fontLink =
    Html.node "link" [ Html.Attributes.rel "stylesheet", Html.Attributes.href "https://fonts.googleapis.com/css2?family=IBM+Plex+Sans:wght@300;400;700&display=swap" ] []


rebootLink =
    Html.node "link" [ Html.Attributes.rel "stylesheet", Html.Attributes.href "https://cdn.jsdelivr.net/npm/bootstrap-reboot@4.5.6/reboot.css" ] []


notFoundView : Html msg
notFoundView =
    Element.layout [] <| text <| "not found"
