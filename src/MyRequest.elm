module MyRequest exposing (..)

import Browser
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onInput, onClick)
import Process
import Task

--MAIN
main : Program () Model Msg
main =
    Browser.sandbox
        { init = init
        , view = view
        , update = update
        }
 

--INIT
type alias Model error =
    ({ statusText : String
    }, Cmd Msg error User)


init : Model
init =
    ({ statusText = "Ready"
    }, Cmd.none )


--UPDATE
type Msg error
    = None
    | DoRequest
    | ReceivedUserFromServer Result error User

update : Msg -> Model -> Model
update msg model =
    let (record, command) = model
    in
    case msg of
        None ->
            ({ record | statusText = "Ready" }, Cmd.none)
        DoRequest ->
            ({ record | statusText = "Doing Request" }, pretendRequest)
        ReceivedUserFromServer user ->
            ({ record | statusText = "Found User" ++ user.name }, pretendRequest)

--VIEW
view : Model -> Html Msg
view model =
    let (record, command) = model
    in
    div [] [ button [onClick DoRequest] [ text "doRequest" ]
           , text record.statusText
           ]

--pretendRequest
pretendRequest : Cmd Msg
pretendRequest = 
    Process.sleep 2000 
        |> Task.perform (\_ -> 
            ReceivedUserFromServer ( Ok fakeUser )
        )


type alias User =
    { name: String
    , age: Int
    }

fakeUser : User
fakeUser = 
    User 28 "Ioannis"