module Increment exposing
  ( Model
  , Msg (Inc)
  , init
  , update
  , subscriptions
  )

import Increment.Raw as IncRaw

import Dict exposing (Dict)


type alias ThreadId = Int

type alias Model a =
  { threads  : Dict ThreadId (Int -> Cmd a)
  , threadId : ThreadId
  }

freshId : Model a -> (ThreadId, Model a)
freshId model =
  ( model.threadId
  , { model | threadId = model.threadId + 1 }
  )

type Msg a
  = Inc (Int -> Cmd a) Int
  | GotInc (Int, ThreadId)

init : Model a
init =
  { threads  = Dict.empty
  , threadId = 0
  }


update : Msg a -> Model a -> (Model a, Cmd (Result (Msg a) a))
update action model =
  case action of
    Inc onComplete x ->
      let (threadId, model') = freshId model
      in  ( { model' | threads = Dict.insert threadId onComplete model'.threads }
          , Cmd.map Err <| IncRaw.getInc (x, threadId)
          )
    GotInc (x, threadId) ->
      case Dict.get threadId model.threads of
        Nothing -> Debug.crash "thread nonexistent"
        Just onComplete ->
          ( { model | threads = Dict.remove threadId model.threads }
          , Cmd.map Ok <| onComplete x
          )

subscriptions : Sub (Msg a)
subscriptions =
  IncRaw.gotInc GotInc
