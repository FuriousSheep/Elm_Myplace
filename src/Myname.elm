module Myname exposing (..)

import Browser
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onInput, onClick)

--MAIN
main : Program () Model Msg
main =
    Browser.sandbox
        { init = init
        , view = view
        , update = update
        }


--MODEL
type alias Model =
    { input : String
    }

init: Model
init = 
    Model ""

--UPDATE
type Msg
    = Change


--VIEW
