{- This app is the basic Ace editor app.
-}

import Date exposing (Date)
import Date.Extra exposing(..)
import Task
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
    { data : List (Date, List Float)
    , labels : List String
    , drawPoints : Bool
    , counter : Int
    , seed : Random.Seed
    , day : Date
    }


init : (Model, Cmd Msg)
init =
    let
        model =
            { data = [ ]
            , labels = [ "X", "A", "B" ]
            , drawPoints = False
            , counter = 2
            , seed = Random.initialSeed 1985
            , day = fromParts 2000 Date.Jan 1 0 0 0 0
            }
        task = Task.perform TaskFailed ItsNow Date.now
    in
        (model, task)


genItem = Random.float -20 20

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
  | ItsNow Date
  | TaskFailed String


update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
    case msg of
        AddPoint ->
            let
                counter' = model.counter + 1
                day' = add Day 1 model.day
                (item, seed') = genList [] 2 genItem model.seed
                data' = List.append model.data [(day', item)]
            in
                ({ model | data = data', seed = seed', counter = counter', day = day' }, Cmd.none)
        TogglePoints ->
            ({ model | drawPoints = not model.drawPoints }, Cmd.none)
        ItsNow day ->
            ({ model | data = [ (day, [ 3, 6 ]) ], day = day }, Cmd.none)
        TaskFailed _ ->
            (model, Cmd.none)


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
        , Dygraphs.data <| Dygraphs.Slices model.data
        ] []
    , button [ onClick AddPoint ] [ text "Add point" ]
    , button [ onClick TogglePoints ] [ text "Toggle points" ]
    ]
