module Dygraphs exposing (
    toHtml,
    Data(..),
    data, labels, drawPoints
    )

{-| A library to use Dygraph as component.

# Chart
@docs toHtml

# Types
@docs Data

# Attributes
@docs data, labels, drawPoints

-}

import Array exposing (Array)
import Html exposing (Html, Attribute)
import Html.Attributes as Attributes
import Html.Events as Events
import Json.Encode as JE
import Json.Decode as JD
import Native.Dygraphs

{-| Wrapper for data types of dygraphs.
-}
type Data
    = Csv String
    | Url String
    | Rows (List (List Float))


{-| Data which will be attached to Dygraph.
-}
data : Data -> Attribute msg
data val =
    case val of
        Csv csv ->
            Attributes.property "file" (JE.string csv)
        Url url ->
            Attributes.property "file" (JE.string url)
        Rows rows ->
            let
                conv row = List.map JE.float row |> packArray
                rows' = List.map conv rows |> packArray
            in
                Attributes.property "file" rows'

{-| Set labels of plotted lines.
-}
labels : List String -> Attribute msg
labels vals =
    let vals' = List.map JE.string vals |> packArray
    in Attributes.property "labels" vals'

{-| Set labels of plotted lines.
-}
drawPoints : Bool -> Attribute msg
drawPoints flag =
    let flag' = JE.bool flag
    in Attributes.property "drawPoints" flag'

{-| Creates `Html` instance with Dygraph attached to it.

    Dygraph.toHtml [] []
-}
toHtml : List (Attribute msg) -> List (Html msg) -> Html msg
toHtml =
    Native.Dygraphs.toHtml

-- Some internal stuffs

packArray = Array.fromList >> JE.array
