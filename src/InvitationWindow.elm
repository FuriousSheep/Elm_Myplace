module InvitationWindow exposing (..)

import Browser
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onInput, onClick)
import Maybe
import String exposing (toInt, trim)

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
    { email : Maybe String
    , phone : Maybe Int
    }

init: Model
init = 
    Model Nothing Nothing

--UPDATE
type Msg
    = FillEmail String
    | FillPhone Int
    | Fill

update : Msg -> Model -> Model
update msg model =
    case msg of
        FillEmail email ->
            { model | email = Just email} 
        FillPhone phone ->
            { model | phone = Just phone} 
        Fill ->
            model
--            let value = String.toInt (String.trimInput a)
--            in

--VIEW

view : Model -> Html Msg
view model =
    div [] [ 
        select [] [] ,
        input [] [] ,
        button [] [text "Send"]
    ]