module Sambev where

import Effects exposing (Never, Effects)
import Html exposing (..)
import Html.Attributes exposing (..)
import Http
import Json.Decode as Json
import StartApp.Simple
import Task
import Totals

-- Model
type alias Model =
  { totals: Totals.Total
  }


init : Model
init =
  { totals = Totals.init
  }

-- Actions
type Action = TotalsFetched Totals.Total

update : Action -> Model -> Model
update action model =
  case action of
    TotalsFetched totals ->
      Model totals


-- View
view : Signal.Address Action -> Model -> Html
view address model =
  div []
    [ div [ class "row" ]
      [ div [ class "col-xs-12" ]
        [ h1 [] [ text "sambev.com" ]
        , small [] [ text "i have no idea what i am doing." ]
        ]
      ]
    , Totals.view model.totals
    ]


main =
  StartApp.Simple.start
    { model = init
    , update = update
    , view = view
    }


-- Effects
--getTotals : (Model, Effects Action)
--getTotals =
--  Http.get Totals.decodeTotal ("/reports/totals")
--    |> Task.toMaybe
--    |> Task.map TotalsFetched
--    |> Effects.task
