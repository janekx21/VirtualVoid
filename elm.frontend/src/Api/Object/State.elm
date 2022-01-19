-- Do not manually edit this file, it was auto-generated by dillonkearns/elm-graphql
-- https://github.com/dillonkearns/elm-graphql


module Api.Object.State exposing (..)

import Api.Object
import Api.Scalar
import CustomScalarCodecs
import Graphql.Internal.Builder.Object as Object
import Graphql.SelectionSet exposing (SelectionSet)
import Json.Decode as Decode


id : SelectionSet CustomScalarCodecs.Uuid Api.Object.State
id =
    Object.selectionForField "CustomScalarCodecs.Uuid" "id" [] (CustomScalarCodecs.codecs |> Api.Scalar.unwrapCodecs |> .codecUuid |> .decoder)


name : SelectionSet String Api.Object.State
name =
    Object.selectionForField "String" "name" [] Decode.string