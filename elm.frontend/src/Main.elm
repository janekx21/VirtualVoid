module Main exposing (..)

import Browser exposing (Document, UrlRequest)
import Browser.Navigation as Nav
import Element exposing (text)
import Html exposing (Html)
import Route exposing (Route(..))
import Url exposing (Url)
import Views.BacklogsView as BacklogsView
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
    | BacklogsPage BacklogsView.Model


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

                Route.IssuesRoute id ->
                    let
                        ( pageModel, pageCmds ) =
                            IssuesView.init id
                    in
                    ( IssuesPage pageModel, Cmd.map IssuesPageMsg pageCmds )

                Route.BacklogsRoute id ->
                    let
                        ( pageModel, pageCmds ) =
                            BacklogsView.init id
                    in
                    ( BacklogsPage pageModel, Cmd.map BacklogsPageMsg pageCmds )
    in
    ( { model | page = currentPage }
    , Cmd.batch [ existingCmds, mappedPageCmds ]
    )



-- update


type Msg
    = HomePageMsg HomeView.Msg
    | ProjectsPageMsg ProjectsView.Msg
    | IssuesPageMsg IssuesView.Msg
    | BacklogsPageMsg BacklogsView.Msg
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

        ( BacklogsPageMsg subMsg, BacklogsPage pageModel ) ->
            let
                ( updatedPageModel, updatedCmd ) =
                    BacklogsView.update subMsg pageModel
            in
            ( { model | page = BacklogsPage updatedPageModel }
            , Cmd.map BacklogsPageMsg updatedCmd
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

        BacklogsPage model ->
            Sub.map BacklogsPageMsg (BacklogsView.subscriptions model)



-- view


view : Model -> Document Msg
view parentModel =
    case parentModel.page of
        NotFoundPage ->
            Document "Not Found" [ notFoundView ]

        HomePage pageModel ->
            Document "HomeView"
                [ HomeView.view pageModel
                    |> Html.map HomePageMsg
                ]

        ProjectsPage pageModel ->
            Document "Projects"
                [ ProjectsView.view pageModel
                    |> Html.map ProjectsPageMsg
                ]

        ProjectPage pageModel ->
            Document "Project"
                [ ProjectView.view pageModel
                    |> Html.map ProjectPageMsg
                ]

        IssuesPage pageModel ->
            Document "Issues"
                [ IssuesView.view pageModel
                    |> Html.map IssuesPageMsg
                ]

        BacklogsPage model ->
            BacklogsView.view model |> document "Issues" BacklogsPageMsg


document : String -> (msg -> Msg) -> Html msg -> Document Msg
document name msg html =
    Document name [ html |> Html.map msg ]


notFoundView : Html msg
notFoundView =
    Element.layout [] <| text <| "not found"
