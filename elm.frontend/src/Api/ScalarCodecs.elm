-- Do not manually edit this file, it was auto-generated by dillonkearns/elm-graphql
-- https://github.com/dillonkearns/elm-graphql


module Api.ScalarCodecs exposing (..)

import Api.Scalar exposing (defaultCodecs)


type alias Uuid =
    Api.Scalar.Uuid


codecs : Api.Scalar.Codecs Uuid
codecs =
    Api.Scalar.defineCodecs
        { codecUuid = defaultCodecs.codecUuid
        }