-- Do not manually edit this file, it was auto-generated by dillonkearns/elm-graphql
-- https://github.com/dillonkearns/elm-graphql


module Api.Object.Issue exposing (..)

import Api.Enum.Importance
import Api.Enum.IssueType
import Api.InputObject
import Api.Interface
import Api.Object
import Api.Scalar
import Api.Union
import CustomScalarCodecs
import Graphql.Internal.Builder.Argument as Argument exposing (Argument)
import Graphql.Internal.Builder.Object as Object
import Graphql.Internal.Encode as Encode exposing (Value)
import Graphql.Operation exposing (RootMutation, RootQuery, RootSubscription)
import Graphql.OptionalArgument exposing (OptionalArgument(..))
import Graphql.SelectionSet exposing (SelectionSet)
import Json.Decode as Decode


backlog :
    SelectionSet decodesTo Api.Object.Backlog
    -> SelectionSet decodesTo Api.Object.Issue
backlog object____ =
    Object.selectionForCompositeField "backlog" [] object____ Basics.identity


description : SelectionSet String Api.Object.Issue
description =
    Object.selectionForField "String" "description" [] Decode.string


epic :
    SelectionSet decodesTo Api.Object.Epic
    -> SelectionSet (Maybe decodesTo) Api.Object.Issue
epic object____ =
    Object.selectionForCompositeField "epic" [] object____ (Basics.identity >> Decode.nullable)


id : SelectionSet CustomScalarCodecs.Uuid Api.Object.Issue
id =
    Object.selectionForField "CustomScalarCodecs.Uuid" "id" [] (CustomScalarCodecs.codecs |> Api.Scalar.unwrapCodecs |> .codecUuid |> .decoder)


importance : SelectionSet Api.Enum.Importance.Importance Api.Object.Issue
importance =
    Object.selectionForField "Enum.Importance.Importance" "importance" [] Api.Enum.Importance.decoder


name : SelectionSet String Api.Object.Issue
name =
    Object.selectionForField "String" "name" [] Decode.string


number : SelectionSet Int Api.Object.Issue
number =
    Object.selectionForField "Int" "number" [] Decode.int


points : SelectionSet Int Api.Object.Issue
points =
    Object.selectionForField "Int" "points" [] Decode.int


state :
    SelectionSet decodesTo Api.Object.State
    -> SelectionSet decodesTo Api.Object.Issue
state object____ =
    Object.selectionForCompositeField "state" [] object____ Basics.identity


type_ : SelectionSet Api.Enum.IssueType.IssueType Api.Object.Issue
type_ =
    Object.selectionForField "Enum.IssueType.IssueType" "type" [] Api.Enum.IssueType.decoder
