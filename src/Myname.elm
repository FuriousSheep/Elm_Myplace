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
    { name : String
    }

init: Model
init = 
    Model ""

--UPDATE
type Msg
    = Change String

update : Msg -> Model -> Model
update msg model =
    case msg of
        Change name ->
            {modem | name = name}

--VIEW

view : Model -> Html Msg
view model =
    div [] [
        input [ onInput Change ] []
        guessMyName model.name
    ]