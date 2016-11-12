{- This app is the basic Ace editor app.
-}

import Html exposing (..)
import Html.App as App
import Html.Events exposing (..)
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
  { }


init : (Model, Cmd Msg)
init =
  ({ }, Cmd.none)



-- UPDATE


type Msg
  = NoOp


update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
    (model, Cmd.none)


-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.none



-- VIEW

view : Model -> Html Msg
view model =
  div []
    [ Dygraphs.toHtml
        [ Dygraphs.labels
            [ "XAxis"
            , "Label A"
            , "Label B"
            ]
        , Dygraphs.data <| Dygraphs.Rows [ [1, 3, 6], [2, 34, -1] ]
        ] []
    ]
