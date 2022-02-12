module Main exposing (..)

import Browser exposing (Document, UrlRequest(..))
import Browser.Navigation as Nav
import Colors exposing (darkGlassColor, focus, gray10, gray70, white)
import Common exposing (coloredMaterialIcon)
import Dialog exposing (Dialog)
import Element exposing (Element, alignRight, el, fill, focusStyle, height, image, inFront, link, none, padding, paddingXY, px, row, spacing, text, width)
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font
import Html exposing (Html)
import Html.Attributes
import Material.Icons
import Route exposing (Route(..))
import Url exposing (Url)
import Views.Backlog as BacklogView
import Views.Home as HomeView
import Views.Issue as IssuesView
import Views.Offline as OfflineView
import Views.Project as ProjectView
import Views.Projects as ProjectsView


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
    | OfflinePage
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

                Route.OfflineRoute ->
                    ( OfflinePage, Cmd.none )
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
                    ProjectsView.update subMsg model.navKey pageModel
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

        OfflinePage ->
            Sub.none



-- view


view : Model -> Document Msg
view parentModel =
    case parentModel.page of
        NotFoundPage ->
            Document "Not Found" [ notFoundView ]

        HomePage model ->
            ( HomeView.view model, Nothing ) |> defaultLayout |> document "Virtual Void" HomePageMsg

        ProjectsPage model ->
            ( ProjectsView.view model, Nothing ) |> defaultLayout |> document "Projects | Virtual Void" ProjectsPageMsg

        ProjectPage model ->
            ProjectView.view model |> defaultLayout |> document "Project | Virtual Void" ProjectPageMsg

        IssuesPage pageModel ->
            Document "Issues | Virtual Void"
                [ IssuesView.view pageModel
                    |> Html.map IssuesPageMsg
                ]

        BacklogPage model ->
            BacklogView.view model |> defaultLayout |> document "Backlog | Virtual Void" BacklogPageMsg

        OfflinePage ->
            Document "Offline" [ defaultLayout ( OfflineView.view, Nothing ) ]


defaultLayout : ( Element msg, Maybe (Dialog msg) ) -> Html msg
defaultLayout ( element, maybeDialog ) =
    Element.layoutWith { options = [ focusStyle { shadow = Nothing, borderColor = Just focus, backgroundColor = Nothing } ] }
        [ width fill
        , Font.size 16
        , Font.family [ Font.typeface "IBM Plex Sans", Font.sansSerif ]
        , Background.color gray10
        , inFront <| header
        , inFront <| (maybeDialog |> Maybe.map Dialog.view |> Maybe.withDefault none)
        ]
        element


header : Element msg
header =
    let
        corp =
            row [ spacing 8 ]
                [ image [ width (px 32), height (px 32) ] { src = "/assets/logo_white.svg", description = "logo" }
                , el [ Font.light, Font.size 24, Font.color white ] <| text "Virtual Void"
                ]
    in
    row
        [ height (px 48)
        , width fill
        , Background.color darkGlassColor
        , Border.widthEach { bottom = 1, top = 0, left = 0, right = 0 }
        , Border.color gray70
        , Element.htmlAttribute <| Html.Attributes.style "backdrop-filter" "blur(8px) grayscale(70%)"
        ]
        [ link [ height fill, paddingXY 10 0 ] { label = corp, url = "/" }
        , el [ alignRight, padding 8 ] <| coloredMaterialIcon Material.Icons.apps 32 white
        ]


document : String -> (msg -> Msg) -> Html msg -> Document Msg
document name msg html =
    Document name [ fontLink, rebootLink, themeLink, html |> Html.map msg ]


fontLink =
    Html.node "link" [ Html.Attributes.rel "stylesheet", Html.Attributes.href "https://fonts.googleapis.com/css2?family=IBM+Plex+Sans:wght@300;400;700&display=swap" ] []


rebootLink =
    Html.node "link" [ Html.Attributes.rel "stylesheet", Html.Attributes.href "https://cdn.jsdelivr.net/npm/bootstrap-reboot@4.5.6/reboot.css" ] []


themeLink =
    Html.node "link" [ Html.Attributes.rel "stylesheet", Html.Attributes.href "/assets/theme.css" ] []


notFoundView : Html msg
notFoundView =
    Element.layout [] <| text <| "not found"
