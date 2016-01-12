module Person where

import Debug exposing (log)

import Effects exposing (Never, Effects)
import Dict exposing (empty)
import Http
import Html exposing (..)
import Html.Attributes exposing (..)
import Json.Decode as Json exposing (dict, int, object4, string, (:=))
import Task


-- Model
type alias Person =
  { person: String
  , people: (Dict.Dict String Int)
  , places: (Dict.Dict String Int)
  , activities: (Dict.Dict String Int)
  }

init : String -> (Person, Effects Action)
init person =
  ( Person "" Dict.empty Dict.empty Dict.empty
  , getPerson person
  )


-- Actions
type Action = Fetched (Maybe Person)

update : Action -> Person -> (Person, Effects Action)
update action model =
  case action of
    Fetched person ->
      log (toString person)
      ( Maybe.withDefault model person
      , Effects.none
      )



-- View
view : Signal.Address Action -> Person -> Html
view address model =
  div [ class "row" ]
    [ p [] [ text (toString model.person) ]
    ]


-- Helpers
decodePerson : Json.Decoder Person
decodePerson =
  object4 Person
    ("person" := string)
    ("places" := dict int)
    ("activities" := dict int)
    ("people" := dict int)


-- Effects
getPerson : String -> Effects Action
getPerson person =
  Http.get decodePerson ("/people/" ++ person)
    |> Task.toMaybe
    |> Task.map Fetched
    |> Effects.task
