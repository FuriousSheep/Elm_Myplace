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
            {model | name = name}

--VIEW

view : Model -> Html Msg
view model =
    div [] [
        input [ onInput Change ] [],
        div [] [ text <| guessMyName <| model.name ]
    ]

--GUESS MY NAME
guessMyName: String -> String
guessMyName name =
    case name of
        "Ioannis" ->
            "Correct!"
        "ioannis" ->
            "Close, but use proper capitalisation."
        "loannis" ->
            "I hate you, your friends hate you, your mother hates you, your dog hates you and you will die alone and unloved. You swine."
        "ioanis" ->
            "Missed an N! Also, capitalise proper names =)"
        "Ioanis" ->
            "Missed an N!"
        _ ->
            "Nope. Try again!"