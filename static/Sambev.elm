module Sambev where
import Debug exposing (log)

import Dict
import Effects exposing (Never, Effects)
import Html exposing (..)
import Html.Attributes exposing (..)
import Http
import Json.Decode as Json
import StartApp
import Task

import Totals
import Person


-- Model
type alias Model =
  { totals: Totals.Total
  , person: Person.Person
  }


init : (Model, Effects Action)
init =
  let
    (totals, totalsFx) = Totals.init
    (person, personFx) = Person.init "Deanna Dillard"
  in
  ( Model totals person
  , Effects.batch
    [ Effects.map TotalsFetched totalsFx
    , Effects.map PersonFetched personFx
    ]
  )

-- Actions
type Action
  = TotalsFetched Totals.Action
  | PersonFetched Person.Action


update : Action -> Model -> (Model, Effects Action)
update action model =
  case action of
    TotalsFetched act ->
      let
        (totals, fx) = Totals.update act model.totals
      in
        ( Model totals model.person
        , Effects.map TotalsFetched fx
        )
    PersonFetched act ->
      let
        (person, fx) = Person.update act model.person
      in
        ( Model model.totals person
        , Effects.map PersonFetched fx
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
    , Totals.view (Signal.forwardTo address TotalsFetched) model.totals
    , Person.view (Signal.forwardTo address PersonFetched) model.person
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


