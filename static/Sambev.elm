module Sambev where

import Debug exposing (log)

import Effects exposing (Never, Effects)
import Html exposing (..)
import Html.Attributes exposing (..)
import Http
import Json.Decode as Json
import StartApp
import Task
import Totals

-- Model
type alias Model =
  { totals: Totals.Total
  }


init : (Model, Effects Action)
init =
  ( { totals = Totals.init
    }
  , getTotals
  )

-- Actions
type Action = TotalsFetched (Maybe Totals.Total)


update : Action -> Model -> (Model, Effects Action)
update action model =
  case action of
    TotalsFetched totals ->
      log (toString totals)
      ( { model | totals = Maybe.withDefault model.totals totals }
      , Effects.none
      )


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


app =
  StartApp.start
    { init = init
    , update = update
    , view = view
    , inputs = []
    }


main =
  app.html


port tasks : Signal (Task.Task Never ())
port tasks =
  app.tasks


-- Effects
getTotals : Effects Action
getTotals =
  Http.get Totals.decodeTotal ("/reports/totals")
    |> Task.toMaybe
    |> Task.map TotalsFetched
    |> Effects.task
