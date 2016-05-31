module Main exposing (..)

import Increment

import Html.App        as App
import Html            exposing (..)
import Html.Attributes exposing (..)
import Html.Events     exposing (..)

import Task


type alias Model =
  { incState : Increment.Model Msg
  , value    : Int
  }

type Msg
  = IncMsg (Increment.Msg Msg)
  | Increment
  | NewValue Int

init : (Model, Cmd Msg)
init =
  ( { incState = Increment.init
    , value    = 0
    }
  , Cmd.none
  )

update : Msg -> Model -> (Model, Cmd Msg)
update action model =
  case action of
    IncMsg a ->
      let (newInc, eff) = Increment.update a model.incState
      in  ( { model | incState = newInc }
          , Cmd.map (\r -> case r of
                             Err x -> IncMsg x
                             Ok  x -> x) eff
          )
    Increment ->
      ( model
      , mkCmd <| IncMsg <| Increment.Inc (mkCmd << NewValue) model.value
      )
    NewValue v ->
      ( { model | value = v }
      , Cmd.none
      )

subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.map IncMsg Increment.subscriptions


view : Model -> Html Msg
view model =
  div []
    [ p []
        [ text <| "Value: " ++ toString model.value
        ]
    , button
        [ onClick Increment
        ]
        [text "Increment"]
    ]


mkCmd : a -> Cmd a
mkCmd = Task.perform (Debug.crash << toString) identity << Task.succeed


main : Program Never
main = App.program
  { init = init
  , update = update
  , view = view
  , subscriptions = subscriptions
  }
