module MyRequest exposing (..)

import Browser
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)
import Maybe
import Result
import Process
import Task


--MAIN
main = 
    Browser.element { init = init
                    , subscriptions = subscriptions
                    , update = update
                    , view = view
    }


--INIT


type alias User = 
    { name : String
    , age : Int }

type alias Model = User

init: () -> ( Model, Cmd Msg )
init _ = 
    ( { name = "test", age = 13} , Cmd.none )


--UPDATE
type Msg = Start
    | UserClickedGetUser
    | ReceivedUserFromServer (Result String User )


update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
    case msg of
        Start ->
            ( { model | name = "Start! No Request made"} , Cmd.none )
        UserClickedGetUser ->
            ( { model | name = "\"Loading\""} , getUser )
        ReceivedUserFromServer (Ok user) ->
            ( user, Cmd.none )
        ReceivedUserFromServer (Err error) ->
            ( { model | name = "Error! User not found"}, Cmd.none )

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

--GETUSER
getUser : Cmd Msg
getUser =
  Process.sleep 2000
    |> Task.perform (\_ ->
      ReceivedUserFromServer (Ok fakeUser)
    )

fakeUser : User
fakeUser =
  { name = "Fake", age  = 42 }
