module MyRequest exposing (..)

import Browser
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)
import Maybe
import Result


--MAIN
main = 
    Browser.element { init = init
                    , subscriptions = subscriptions
                    , update = update
                    , view = view
    }


--INIT
type alias Model = 
    { name : String
    , age : Int }


init: () -> ( Model, Cmd Msg )
init _ = 
    ( { name = "test", age = 13} , Cmd.none )


--UPDATE
type Msg = Start
    | UserClickedGetUser


update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
    case msg of
        Start ->
            ( {model | name = "start"} , Cmd.none)
        UserClickedGetUser ->
            ( {model | name = "click"} , Cmd.none)

subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none

--VIEW
view : Model -> Html Msg
view model =

    div [] [
        button [ onClick UserClickedGetUser ] [ text "Get the user" ],
        div [] [ text model.name]
    ]