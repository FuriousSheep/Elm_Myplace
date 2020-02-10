module InvitationWindow exposing (..)

import Browser
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onInput, onClick)
import Json.Decode as Json
import Maybe
import Process
import Regex
import Result
import Task

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
    , formMessage : Maybe String
    }


init: () -> (Model, Cmd Msg)
init _ = 
    (
        { typedEmail = Nothing
        , typedPhone = Nothing
        , selected = Email
        , email = Nothing
        , phone = Nothing
        , formMessage = Nothing
        }
    , Cmd.none )


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
    | SentValidContact (Result String IsSavedContact)


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
                    let isvalid = validateValue "[^\\s@]+@[^\\s@]+\\.[^\\s@]+" model.typedEmail 
                    in
                    if isvalid then 
                            ( { model | email = model.typedEmail, formMessage = Just "Sending Contact Info..." }, sendValidContact)
                    else
                            ( { model | formMessage = Just "Invalid Email" } , Cmd.none)

                Phone ->
                    let isvalid = validateValue "\\+(9[976]\\d|8[987530]\\d|6[987]\\d|5[90]\\d|42\\d|3[875]\\d|2[98654321]\\d|9[8543210]|8[6421]|6[6543210]|5[87654321]|4[987654310]|3[9643210]|2[70]|7|1)\\W*\\d\\W*\\d\\W*\\d\\W*\\d\\W*\\d\\W*\\d\\W*\\d\\W*\\d\\W*(\\d{1,2})$" model.typedPhone 
                    in
                    if isvalid then 
                            ( { model | phone = model.typedPhone , formMessage = Just "Sending Contact Info..." }, sendValidContact)
                    else
                            ( { model | formMessage = Just "Invalid Phone Number" } , Cmd.none)

        SentValidContact (Ok isSaved) ->
            if isSaved then 
                ( { model | formMessage = Just "Contact Info Saved" } , Cmd.none)
            else
                ( { model | formMessage = Just "Contact Info not Saved!" } , Cmd.none)


        SentValidContact (Err error) ->
            case error of
                _ ->
                    ( { model | formMessage = Just "Error in sending Contact Info" } , Cmd.none)
            





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
        p [] [ text ( Maybe.withDefault "" model.formMessage) ] ,
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
validateValue : String -> Maybe String -> Bool
validateValue regex string =
    case string of 
        Nothing -> 
            False
        Just value -> 
            matchRegexStringExactly regex value


--HTTP

type alias IsSavedContact = Bool


sendValidContact : Cmd Msg
sendValidContact = 
    Process.sleep 2000
    |> Task.perform (\_ ->
      SentValidContact (Ok fakeIsSavedContact)
    )
    {-
    Http.request
        { method = "PUT"
        , headers = []
        , url = ""
        , body = ""
        , expect = Http.expectString GotText
        , timeout = Nothing
        , tracker = Nothing
        }
        -}

fakeIsSavedContact : IsSavedContact
fakeIsSavedContact = 
    False


            
    