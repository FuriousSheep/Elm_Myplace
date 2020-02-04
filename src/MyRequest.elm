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
type alias Model =
    ({ statusText : String
    }, Cmd Msg)


init : Model
init =
    ({ statusText = "Ready"
    }, Cmd.none )


--UPDATE
type Msg
    = None
    | DoRequest
    | ReceivedUserFromServer Result User
    
update : Msg -> Model -> Model
update msg model =
    let (record, command) = model
    in
    case msg of
        None ->
            ({ record | statusText = "Ready" }, Cmd.none)
        DoRequest ->
            ({ record | statusText = "Doing Request" }, pretendRequest)
        ReceivedUserFromServer ( Ok User )->
            ({ record | statusText = "User Found!" }, pretendRequest)
        ReceivedUserFromServer ( Err User )->
            ({ record | statusText = "User Missed!" }, pretendRequest)

        
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