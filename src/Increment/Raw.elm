port module Increment.Raw exposing (..)

-- left is data, right is threadId
port getInc : (Int, Int) -> Cmd a

port gotInc : ((Int, Int) -> a) -> Sub a
