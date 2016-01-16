module Totals where

import Dict as Dict exposing (empty)
import Json.Decode.Extra exposing ((|:))
import Json.Decode as Json exposing (float, int, dict, (:=), succeed)
import List as List
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
  , peopleList: Dict.Dict String Int
  , locationList: Dict.Dict String Int
  , activityList: Dict.Dict String Int
  }

init : (Total, Effects Action)
init =
  ( Total 0 0.0 0 0 0 0 0.0 empty empty empty
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

listEntry : (String, Int) -> Html
listEntry person =
  let
    name = fst person
    amount = toString (snd person)
  in
    ol [] [ text (name ++ ":" ++ amount) ]

buildTotalListEntry : String -> Dict.Dict String Int -> Html
buildTotalListEntry name entry =
  div [ class "col-lg-4 col-xs-6" ]
    [ div [ class "panel panel-success" ]
      [ div [ class "panel-heading" ]
        [ div [ class "row" ]
          [ div [ class "col-lg-6" ]
            [ h3 [ class "panel-title" ] [ text name ]
            ]
          , div [ class "col-lg-6" ]
            [ input [] []
            ]
          ]
        ]
      , div [ class "panel-body" ]
        [ div [ class "row" ]
          [ div [ class "col-lg-12" ]
            (List.map listEntry
              (List.reverse
                (List.sortBy snd
                  (Dict.toList entry))))
          ]
        ]
      ]
    ]

view : Signal.Address Action -> Total -> Html
view address model =
  div [ class "row" ]
    [ buildTotalEntry "Avg/Day" model.avgPerDay
    , buildTotalEntry "Reports" model.reports
    , buildTotalEntry "People" model.people
    , buildTotalEntry "Locations" model.locations
    , buildTotalEntry "Coffees" model.coffees
    , buildTotalEntry "Coffees/Day" model.coffeesPerDay
    , buildTotalListEntry "People" model.peopleList
    , buildTotalListEntry "Locations" model.locationList
    , buildTotalListEntry "Activities" model.activityList
    ]


-- Helpers
decodeTotal : Json.Decoder Total
decodeTotal =
  succeed Total
    |: ("days" := int)
    |: ("avgPerDay" := float)
    |: ("reports" := int)
    |: ("people" := int)
    |: ("locations" := int)
    |: ("coffees" := int)
    |: ("coffeesPerDay" := float)
    |: ("peopleList" := dict int)
    |: ("locationList" := dict int)
    |: ("activityList" := dict int)


-- Effects
getTotals : Effects Action
getTotals =
  Http.get decodeTotal ("/reports/totals")
    |> Task.toMaybe
    |> Task.map Fetched
    |> Effects.task
