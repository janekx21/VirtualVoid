module Route exposing (..)

import CustomScalarCodecs exposing (url64ToUuid)
import UUID exposing (UUID)
import Url exposing (Url)
import Url.Parser exposing ((</>), Parser, custom, map, oneOf, parse, s, top)


type Route
    = HomeRoute
    | ProjectsRoute
    | ProjectRoute UUID
    | BacklogRoute UUID
    | IssueRoute UUID
    | NotFoundRoute
    | OfflineRoute


parseUrl : Url -> Route
parseUrl url =
    case parse matchRoute url of
        Just route ->
            route

        Nothing ->
            NotFoundRoute


matchRoute : Parser (Route -> a) a
matchRoute =
    oneOf
        [ map HomeRoute top
        , map ProjectsRoute (s "projects")
        , map ProjectRoute (s "projects" </> uuid)
        , map BacklogRoute (s "backlogs" </> uuid)
        , map IssueRoute (s "issues" </> uuid)
        , map OfflineRoute (s "offline")
        ]


uuid : Parser (UUID -> a) a
uuid =
    custom "UUID" url64ToUuid
