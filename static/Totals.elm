module Totals where

import Json.Decode as Json exposing (object7, (:=), Decoder)
import Effects exposing (Never, Effects)
import Http
import Html exposing (..)
import Html.Attributes exposing (..)
import Task


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

init : (Total, Effects Action)
init =
  ( Total 0 0.0 0 0 0 0 0.0
  , getTotals
  )


-- Actions
type Action = Fetched (Maybe Total)

update : Action -> Total -> (Total, Effects Action)
update action model =
  case action of
    Fetched total ->
      ( Maybe.withDefault model total
      , Effects.none
      )


-- View
buildTotalEntry : String -> number -> Html
buildTotalEntry name entry =
  div [ class "col-lg-2 col-xs-4" ]
    [ div [ class "well" ]
      [ p [] [ text (toString entry) ]
      , small [] [ text name ]
      ]
    ]

view : Signal.Address Action -> Total -> Html
view address model =
  div [ class "row" ]
    [ buildTotalEntry "Days" model.days
    , buildTotalEntry "Avg/Day" model.avgPerDay
    , buildTotalEntry "Reports" model.reports
    , buildTotalEntry "People" model.people
    , buildTotalEntry "Locations" model.locations
    , buildTotalEntry "Coffees" model.coffees
    , buildTotalEntry "Coffees/Day" model.coffeesPerDay
    ]


-- Helpers
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


-- Effects
getTotals : Effects Action
getTotals =
  Http.get decodeTotal ("/reports/totals")
    |> Task.toMaybe
    |> Task.map Fetched
    |> Effects.task
