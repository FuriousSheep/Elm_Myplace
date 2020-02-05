module InvitationWindow exposing (..)

import Browser
import Email exposing (Email)
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
    | Fill

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
    case msg of
        ChangeEmail email ->
            ({ model | typedEmail = Just email }, Cmd.none)

        ChangePhone phone ->
            ({ model | typedPhone = Just phone }, Cmd.none)
                
        Select selected ->
            ({ model | selected = selected }, Cmd.none)

        Fill ->
            (model, Cmd.none)

--VIEW

view : Model -> Html Msg
view model =
    div [] [ 
        select [] [
            option [ onClick (Select Email) ] [ text "Email" ],
            option [ onClick (Select Phone) ] [ text "Phone" ]
        ],
        shownInput model,
        button [] [text "Send"],
        div [] [
            p [] [text "Model = {" ],
            p [] [text ("email : " ++ Maybe.withDefault "empty" model.typedEmail) ],
            p [] [text ("phone : " ++ Maybe.withDefault "empty" model.typedPhone ) ],
            p [] [text ("selected :" ++ showSelected model.selected )],
            p [] [text "}"]
        ],
        div [] [text apollo11]

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
                , value (model.phone
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
{-
pattern : String
pattern = "[^\\s@]+@[^\\s@]+\.[^\\s@]+"

maybeRegex : Maybe Regex.Regex
maybeRegex = Regex.fromString pattern

regex : Regex.Regex
regex = Maybe.withDefault Regex.never maybeRegex

-}
apollo11 : String
apollo11 = """On July 16, 1969, the massive Saturn V rocket\n
    lifted off from NASA's Kennedy Space Center at 09:32 a.m.\n
    EDT. Four days later, on July 20, Neil Armstrong and Buzz \n
    Aldrin landed on the Moon. """

stringToRegex : String -> Regex.Regex
stringToRegex string =
    Regex.fromString string |> Maybe.withDefault Regex.never 


matchesRegexExactly : Regex.Regex -> String -> Bool
matchesRegexExactly regex string =
    Regex.split regex string == ["",""]
    
    

--VALIDATION

{-
validateEmail: Maybe String -> (Bool, String)
validateEmail = 
    -- CODE THAT VALIDATES THE EMAIL

validatePhone: Maybe String -> (Bool, String)
validatePhone = 
    -- CODE THAT VALIDATES THE PHONE

=> See Regexes

-}