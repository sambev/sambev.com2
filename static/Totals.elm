module Totals where

import Json.Decode as Json exposing (object7, (:=), Decoder)
import Http
import Html exposing (..)
import Html.Attributes exposing (..)


-- Model
type alias Total =
  { days : Int
  , avgPerDay: Float
  , reports : Int
  , people : Int
  , locations : Int
  , coffees : Int
  , coffeesPerDay: Float
  }

init : Total
init =
  { days = 0
  , avgPerDay = 0.0
  , reports = 0
  , people = 0
  , locations = 0
  , coffees = 0
  , coffeesPerDay = 0.0
  }


-- View
buildTotalEntry : String -> number -> Html
buildTotalEntry name entry =
  div [ class "col-lg-2 col-xs-4" ]
    [ div [ class "well" ]
      [ p [] [ text (toString entry) ]
      , small [] [ text name ]
      ]
    ]


view : Total -> Html
view model =
  div [ class "row" ]
    [ buildTotalEntry "Days" model.days
    , buildTotalEntry "Avg/Day" model.avgPerDay
    , buildTotalEntry "Reports" model.reports
    , buildTotalEntry "People" model.people
    , buildTotalEntry "Locations" model.locations
    , buildTotalEntry "Coffees" model.coffees
    , buildTotalEntry "Coffees/Day" model.coffeesPerDay
    ]

-- Effects
decodeTotal : Json.Decoder Total
decodeTotal =
  object7 Total
      ("days" := Json.int)
      ("avgPerDay" := Json.float)
      ("reports" := Json.int)
      ("people" := Json.int)
      ("locations" := Json.int)
      ("coffees" := Json.int)
      ("coffeesPerDay" := Json.float)
