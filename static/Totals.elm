module Totals where

import Task
import Json.Decode as Json exposing (object5, (:=), Decoder)
import Http
import Html exposing (..)
import Html.Attributes exposing (..)


-- Model
type alias Total =
  { days : Int
  , reports : Int
  , people : Int
  , locations : Int
  , totalCoffees : Int
  }

init : Total
init =
  { days = 0
  , reports = 0
  , people = 0
  , locations = 0
  , totalCoffees = 0
  }


-- View
buildTotalEntry : String -> Int -> Html
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
    , buildTotalEntry "Reports" model.reports
    , buildTotalEntry "People" model.people
    , buildTotalEntry "Locations" model.locations
    , buildTotalEntry "Coffees" model.totalCoffees
    ]

-- Effects
decodeTotal : Json.Decoder Total
decodeTotal =
  object5 Total
      ("days" := Json.int)
      ("reports" := Json.int)
      ("people" := Json.int)
      ("locations" := Json.int)
      ("totalCoffees" := Json.int)
