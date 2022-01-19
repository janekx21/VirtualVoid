module Route exposing (..)

import UUID exposing (UUID)
import Url exposing (Url)
import Url.Parser exposing ((</>), Parser, custom, map, oneOf, parse, s, top)


type Route
    = HomeRoute
    | ProjectsRoute
    | ProjectRoute UUID
    | BacklogsRoute UUID
    | IssuesRoute UUID
    | NotFoundRoute


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
        , map BacklogsRoute (s "backlogs" </> uuid)
        , map IssuesRoute (s "issues" </> uuid)
        ]


uuid : Parser (UUID -> a) a
uuid =
    custom "UUID" <|
        \segment ->
            Result.toMaybe (UUID.fromString segment)