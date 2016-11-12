module Dygraphs exposing (..)

{-| A library to use Dygraph as component.

# Chart
@docs toHtml

# Types
@docs Data

# Attributes
@docs data, labels

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
    | Rows (List (List Int))


{-| Attribute to set the theme to Ace.

    Ace.toHtml [ Ace.theme "monokai" ] []
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
                conv row =
                    List.map JE.int row
                    |> Array.fromList
                    |> JE.array
                rows' =
                    List.map conv rows
                    |> Array.fromList
                    |> JE.array
            in
                Attributes.property "file" rows'

{-| Set labels of plotted lines.
-}
labels : List String -> Attribute msg
labels vals =
    let
        vals' =
            List.map JE.string vals
            |> Array.fromList
            |> JE.array
    in
        Attributes.property "labels" vals'

{-| Creates `Html` instance with Dygraph attached to it.

    Ace.toHtml [] []
-}
toHtml : List (Attribute msg) -> List (Html msg) -> Html msg
toHtml =
    Native.Dygraphs.toHtml