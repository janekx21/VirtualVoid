module CustomScalarCodecs exposing (..)

import Api.Scalar
import Base64
import Graphql.Codec exposing (Codec)
import Json.Decode as Decode
import Json.Encode as Encode
import Maybe
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
                            Decode.fail "Could not parse String as an UUID."
                )
    }


uuidToUrl64 : UUID -> String
uuidToUrl64 uuid =
    uuid |> UUID.toBytes |> Base64.fromBytes |> Maybe.map base64ToUrl64 |> Maybe.withDefault ""


url64ToUuid : String -> Maybe UUID
url64ToUuid url =
    url |> url64ToBase64 |> Base64.toBytes |> Maybe.map UUID.fromBytes |> Maybe.andThen Result.toMaybe


base64ToUrl64 : String -> String
base64ToUrl64 =
    String.replace "+" "."
        >> String.replace "/" "_"
        >> String.replace "=" "-"


url64ToBase64 : String -> String
url64ToBase64 =
    String.replace "." "+"
        >> String.replace "_" "/"
        >> String.replace "-" "="
