module CustomScalarCodecs exposing (..)

import Api.Scalar
import Graphql.Codec exposing (Codec)
import Json.Decode as Decode
import Json.Encode as Encode
import UUID exposing (UUID)


type alias Uuid =
    UUID


codecs : Api.Scalar.Codecs Uuid
codecs =
    Api.Scalar.defineCodecs { codecUuid = uuidCodec }


uuidCodec : Codec Uuid
uuidCodec =
    { encoder = \raw -> raw |> UUID.toString |> Encode.string
    , decoder =
        Decode.string
            |> Decode.map UUID.fromString
            |> Decode.map Result.toMaybe
            |> Decode.andThen
                (\maybeParsedId ->
                    case maybeParsedId of
                        Just parsedId ->
                            Decode.succeed parsedId

                        Nothing ->
                            Decode.fail "Could not parse ID as an Int."
                )
    }
