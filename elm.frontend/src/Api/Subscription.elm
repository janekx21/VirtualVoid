-- Do not manually edit this file, it was auto-generated by dillonkearns/elm-graphql
-- https://github.com/dillonkearns/elm-graphql


module Api.Subscription exposing (..)

import Api.InputObject
import Api.Interface
import Api.Object
import Api.Scalar
import Api.ScalarCodecs
import Api.Union
import Graphql.Internal.Builder.Argument as Argument exposing (Argument)
import Graphql.Internal.Builder.Object as Object
import Graphql.Internal.Encode as Encode exposing (Value)
import Graphql.Operation exposing (RootMutation, RootQuery, RootSubscription)
import Graphql.OptionalArgument exposing (OptionalArgument(..))
import Graphql.SelectionSet exposing (SelectionSet)
import Json.Decode as Decode exposing (Decoder)


type alias ChangedIssueRequiredArguments =
    { id : Api.ScalarCodecs.Uuid }


{-| Returns subscribed issue when it changes
-}
changedIssue :
    ChangedIssueRequiredArguments
    -> SelectionSet decodesTo Api.Object.Issue
    -> SelectionSet decodesTo RootSubscription
changedIssue requiredArgs____ object____ =
    Object.selectionForCompositeField "changedIssue" [ Argument.required "id" requiredArgs____.id (Api.ScalarCodecs.codecs |> Api.Scalar.unwrapEncoder .codecUuid) ] object____ Basics.identity


type alias CounterOptionalArguments =
    { limit : OptionalArgument Int }


{-| Returns a random number every second
-}
counter :
    (CounterOptionalArguments -> CounterOptionalArguments)
    -> SelectionSet Int RootSubscription
counter fillInOptionals____ =
    let
        filledInOptionals____ =
            fillInOptionals____ { limit = Absent }

        optionalArgs____ =
            [ Argument.optional "limit" filledInOptionals____.limit Encode.int ]
                |> List.filterMap Basics.identity
    in
    Object.selectionForField "Int" "counter" optionalArgs____ Decode.int
