module Totals where

import Task
import Json.Decode as Json exposing (object7, (:=), int, float, Decoder)
import Http
import Html exposing (..)
import Html.Attributes exposing (..)


-- Model
type TotalEntry = Int Int | Float Float

type alias Total =
  { days : TotalEntry
  , reports : TotalEntry
  , avgPerDay : TotalEntry
  , people : TotalEntry
  , locations : TotalEntry
  , totalCoffees : TotalEntry
  , coffeesPerDay : TotalEntry
  }

init : Total
init =
  { days = Int 0
  , reports = Int 0
  , avgPerDay = Float 0.0
  , people = Int 0
  , locations = Int 0
  , totalCoffees = Int 0
  , coffeesPerDay = Float 0.0
  }


-- Actions
type Action = Fetched


update : Action -> Total -> Total
update action model =
  case action of
    Fetched ->
      model


-- View
totalEntryToString : TotalEntry -> String
totalEntryToString entry =
  case entry of
    Int val ->
      toString val
    Float val ->
      toString val

buildTotalEntry : String -> TotalEntry -> Html
buildTotalEntry name entry =
  div [ class "col-lg-2 col-xs-4" ]
    [ div [ class "well" ]
      [ p [] [ text (totalEntryToString entry) ]
      , small [] [ text name ]
      ]
    ]


view : Signal.Address Action -> Total -> Html
view address model =
  div [ class "row" ]
    [ buildTotalEntry "Days" model.days
    , buildTotalEntry "Reports" model.reports
    , buildTotalEntry "Avg/Day" model.avgPerDay
    , buildTotalEntry "People" model.people
    , buildTotalEntry "Locations" model.locations
    , buildTotalEntry "Coffees" model.totalCoffees
    , buildTotalEntry "Coffess/Day" model.coffeesPerDay
    ]

