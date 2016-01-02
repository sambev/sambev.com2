module Sambev where

import Totals
import StartApp.Simple
import Html exposing (..)
import Html.Attributes exposing (..)

-- Model
type alias Model =
  { totals: Totals.Total
  }


init : Model
init =
  { totals = Totals.init
  }

-- Actions
type Action = TotalsFetched Totals.Action

update : Action -> Model -> Model
update action model =
  case action of
    TotalsFetched totalAction ->
      { model |
        totals = Totals.update totalAction model.totals
      }


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
    , Totals.view (Signal.forwardTo address TotalsFetched) model.totals
    ]


main =
  StartApp.Simple.start
    { model = init
    , update = update
    , view = view
    }
