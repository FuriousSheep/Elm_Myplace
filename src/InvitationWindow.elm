module InvitationWindow exposing (..)

import Browser
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onInput, onClick)
import Maybe
import String exposing (toInt, trim, fromInt)

--MAIN
main : Program () Model Msg
main =
    Browser.element
        { init = init
        , subscriptions = subscriptions
        , view = view
        , update = update
        }


--MODEL

type Selected = Phone | Email

type alias Model =
    { email : Maybe String
    , phone : Maybe Int
    , selected : Selected
    }

init: () -> (Model, Cmd Msg)
init _ = 
    ( Model Nothing Nothing Email
    , Cmd.none)

--SUBSCRIPTIONS
subscriptions : Model -> Sub Msg
subscriptions _ = 
    Sub.none

--UPDATE
type Msg
    = ChangeEmail String
    | ChangePhone String
    | Select Selected
    | Fill

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
    case msg of
        ChangeEmail email ->
            ({ model | email = Just email }, Cmd.none)

        ChangePhone phone ->
            ({ model | phone = String.toInt phone }, Cmd.none)
                
        Select selected ->
            ({ model | selected = selected }, Cmd.none)

        Fill ->
            (model, Cmd.none)

--VIEW

view : Model -> Html Msg
view model =
    div [] [ 
        select [] [
            option [ onClick (Select Phone) ] [ text "Phone Number" ],
            option [ onClick (Select Email) ] [ text "Email" ]
        ],
        shownInput model,
        button [] [text "Send"],
        div [] [
            p [] [text "Model = {" ],
            p [] [text ("email : " ++ (Maybe.withDefault "empty" model.email)) ],
            p [] [text ("phone : " ++ ( String.fromInt <| Maybe.withDefault 0 <| model.phone )) ],
            p [] [text ("selected :" ++ ( showSelected model.selected ))],
            p [] [text "}"]
        ]
    ]

shownInput: Model -> Html Msg
shownInput model =
    case model.selected of
        Email ->
            input [ onInput ChangeEmail
                , value ( 
                    model.email 
                    |> Maybe.withDefault "" 
                )] []
        Phone ->
            input [onInput ChangePhone
                , value (model.phone
                    |> Maybe.withDefault 0
                    |> String.fromInt
                )] []
                

showSelected: Selected -> String
showSelected selected =
    case selected of
        Email ->
            "email"
        Phone ->
            "phone"