module InvitationWindow exposing (..)

import Browser
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onInput, onClick)
import Maybe
import Regex

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

type alias Phone = String

type alias Email = String

type alias Model =
    { typedEmail : Maybe String
    , typedPhone : Maybe String
    , selected : Selected
    , email : Maybe Email
    , phone : Maybe Phone
    }

init: () -> (Model, Cmd Msg)
init _ = 
    ( Model Nothing Nothing Email Nothing Nothing
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
    | SendInvitationMethod

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
    case msg of
        ChangeEmail email ->
            ({ model | typedEmail = Just email }, Cmd.none)

        ChangePhone phone ->
            ({ model | typedPhone = Just phone }, Cmd.none)
                
        Select selected ->
            ({ model | selected = selected }, Cmd.none)

        SendInvitationMethod ->
            case model.selected of
                Email ->
                    let isvalid = validateValue "" model.typedEmail 
                    in
                    if isvalid then 
                            ({ model | email = model.typedEmail}, Cmd.none)
                    else
                            ( model, Cmd.none)

                Phone ->
                    let isvalid = validateValue "" model.typedPhone 
                    in
                    if isvalid then 
                            ({ model | email = model.typedPhone}, Cmd.none)
                    else
                            ( model, Cmd.none)

--VIEW

view : Model -> Html Msg
view model =
    div [] [ 
        select [] [
            option [ onClick (Select Email) ] [ text "Email" ],
            option [ onClick (Select Phone) ] [ text "Phone" ]
        ],
        shownInput model,
        button [onClick SendInvitationMethod] [text "Send"],
        div [] [
            p [] [text "Model = {" ],
            p [] [text ("typed email : " ++ Maybe.withDefault "empty" model.typedEmail) ],
            p [] [text ("typed phone : " ++ Maybe.withDefault "empty" model.typedPhone ) ],
            p [] [text ("selected : " ++ showSelected model.selected )],
            p [] [text ("email : " ++ Maybe.withDefault "empty" model.email )],
            p [] [text ("phone : " ++ Maybe.withDefault "empty" model.phone )],
            p [] [text "}"]
        ]
    ]

shownInput: Model -> Html Msg
shownInput model =
    case model.selected of
        Email ->
            input [ onInput ChangeEmail
                , value ( 
                    model.typedEmail 
                    |> Maybe.withDefault "" 
                )] []
        Phone ->
            input [onInput ChangePhone
                , value (model.typedPhone
                    |> Maybe.withDefault ""
                )] []
                

showSelected: Selected -> String
showSelected selected =
    case selected of
        Email ->
            "email"
        Phone ->
            "phone"

--REGEX

stringToRegex : String -> Regex.Regex
stringToRegex string =
    Regex.fromString string |> Maybe.withDefault Regex.never 


matchesRegexExactly : Regex.Regex -> String -> Bool
matchesRegexExactly regex string =
    Regex.split regex string == ["",""]
    
matchRegexStringExactly : String -> String -> Bool
matchRegexStringExactly regex string =
    matchesRegexExactly (stringToRegex regex) string

--VALIDATION


validateValue: String -> Maybe String -> Bool
validateValue regex string =
    case string of 
        Nothing -> 
            False
        Just value -> 
            matchRegexStringExactly regex value
    
