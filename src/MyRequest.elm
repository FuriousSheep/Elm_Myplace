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
--    | ReceivedUserFromServer


update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
    case msg of
        Start ->
            ( {model | name = "start"} , Cmd.none)
        UserClickedGetUser ->
            ( {model | name = "click"} , getUser)
--        ReceivedUserFromServer (Ok user) ->
--            ( {}, Cmd.none)
--        ReceivedUserFromServer (Ok Err error) ->
--            ( {} Cmd.none)

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
    Cmd.none
--  Process.sleep 2000
--    |> Task.perform (\_ ->
--      ReceivedUserFromServer (Ok fakeUser)
--    )

fakeUser : User
fakeUser =
  { name = "Fake", age  = 42 }
