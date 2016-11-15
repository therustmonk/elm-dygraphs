{- This app is the basic Ace editor app.
-}

import Html exposing (..)
import Html.App as App
import Html.Events exposing (..)
import Html.Attributes exposing (..)
import Random
import Dygraphs

main =
  App.program
    { init = init
    , subscriptions = subscriptions
    , update = update
    , view = view
    }

-- MODEL


type alias Model =
    { data : List (List Int)
    , labels : List String
    , drawPoints : Bool
    , counter : Int
    , seed : Random.Seed
    }


init : (Model, Cmd Msg)
init =
    let
        model =
            { data = [ [ 1, 3, 6 ], [ 2, 16, -1 ] ]
            , labels = [ "X", "A", "B" ]
            , drawPoints = False
            , counter = 2
            , seed = Random.initialSeed 1985
            }
    in
        (model, Cmd.none)


genInt = Random.int -20 20

genList : List a -> Int -> Random.Generator a -> Random.Seed -> (List a, Random.Seed)
genList data quantity gen seed =
    if quantity > 0 then
        let
            (item, seed') = Random.step gen seed
            quantity' = quantity - 1
        in
            genList (item :: data) quantity' gen seed'
    else
        (data, seed)


-- UPDATE


type Msg
  = AddPoint
  | TogglePoints


update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
    case msg of
        AddPoint ->
            let
                counter' = model.counter + 1
                (item, seed') = genList [] 2 genInt model.seed
                data' = List.append model.data [counter'::item]
            in
                ({ model | data = data', seed = seed', counter = counter' }, Cmd.none)
        TogglePoints ->
            ({ model | drawPoints = not model.drawPoints }, Cmd.none)


-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.none



-- VIEW

view : Model -> Html Msg
view model =
  div [ class "chart" ]
    [ Dygraphs.toHtml
        [ Dygraphs.labels model.labels
        , Dygraphs.drawPoints model.drawPoints
        , Dygraphs.data <| Dygraphs.Rows model.data
        ] []
    , button [ onClick AddPoint ] [ text "Add point" ]
    , button [ onClick TogglePoints ] [ text "Toggle points" ]
    ]
