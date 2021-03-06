-- Do not manually edit this file, it was auto-generated by dillonkearns/elm-graphql
-- https://github.com/dillonkearns/elm-graphql


module Api.Enum.Importance exposing (..)

import Json.Decode as Decode exposing (Decoder)


type Importance
    = Low
    | Medium
    | High


list : List Importance
list =
    [ Low, Medium, High ]


decoder : Decoder Importance
decoder =
    Decode.string
        |> Decode.andThen
            (\string ->
                case string of
                    "LOW" ->
                        Decode.succeed Low

                    "MEDIUM" ->
                        Decode.succeed Medium

                    "HIGH" ->
                        Decode.succeed High

                    _ ->
                        Decode.fail ("Invalid Importance type, " ++ string ++ " try re-running the @dillonkearns/elm-graphql CLI ")
            )


{-| Convert from the union type representing the Enum to a string that the GraphQL server will recognize.
-}
toString : Importance -> String
toString enum____ =
    case enum____ of
        Low ->
            "LOW"

        Medium ->
            "MEDIUM"

        High ->
            "HIGH"


{-| Convert from a String representation to an elm representation enum.
This is the inverse of the Enum `toString` function. So you can call `toString` and then convert back `fromString` safely.

    Swapi.Enum.Episode.NewHope
        |> Swapi.Enum.Episode.toString
        |> Swapi.Enum.Episode.fromString
        == Just NewHope

This can be useful for generating Strings to use for <select> menus to check which item was selected.

-}
fromString : String -> Maybe Importance
fromString enumString____ =
    case enumString____ of
        "LOW" ->
            Just Low

        "MEDIUM" ->
            Just Medium

        "HIGH" ->
            Just High

        _ ->
            Nothing
