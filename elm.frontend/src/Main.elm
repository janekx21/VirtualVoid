module Main exposing (..)

import Browser exposing (Document, UrlRequest)
import Browser.Navigation as Nav exposing (Key)
import Element exposing (Element, text)
import Html exposing (Html)
import Route exposing (Route(..))
import Url exposing (Url)
import Views.HomeView as HomeView
import Views.IssuesView as IssuesView
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
    | IssuesPage IssuesView.Model



-- | IssuePage IssueView.Model


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

                IssuesRoute id ->
                    let
                        ( pageModel, pageCmds ) =
                            IssuesView.init id
                    in
                    ( IssuesPage pageModel, Cmd.map IssuesPageMsg pageCmds )

                _ ->
                    ( NotFoundPage, Cmd.none )
    in
    ( { model | page = currentPage }
    , Cmd.batch [ existingCmds, mappedPageCmds ]
    )



-- update


type Msg
    = HomePageMsg HomeView.Msg
    | ProjectsPageMsg ProjectsView.Msg
    | IssuesPageMsg IssuesView.Msg
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
subscriptions model =
    case model.page of
        IssuesPage mo ->
            Sub.map IssuesPageMsg (IssuesView.subscriptions mo)

        HomePage mo ->
            Sub.map HomePageMsg (HomeView.subscriptions mo)

        _ ->
            Sub.none



-- view


view : Model -> Document Msg
view model =
    case model.page of
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

        IssuesPage pageModel ->
            Document "Issues"
                [ IssuesView.view pageModel
                    |> Html.map IssuesPageMsg
                ]


notFoundView : Html msg
notFoundView =
    Element.layout [] <| text <| "not found"
