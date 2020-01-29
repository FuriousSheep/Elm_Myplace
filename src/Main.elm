module Main exposing (..)

import Browser
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onInput, onClick)


--MAIN

main =
  Browser.sandbox { init = init, view = view, update = update }


--MODEL
type alias Model = {
    result : Maybe Float,
    operand1 : Maybe Float,
    operand2 : Maybe Float,
    operator : String
    }
--INIT
init: Model
init =
  Model Nothing Nothing Nothing ""


--UPDATE
type Msg = Add
    | Sub
    | Mul 
    | Div
    | ChangeOp1 String
    | ChangeOp2 String
    
update : Msg -> Model -> Model
update msg model =
    case msg of
        ChangeOp1 newNumber ->
            { model | operand1 = String.toFloat <| newNumber }

        ChangeOp2 newNumber ->
            { model | operand2 = String.toFloat <| newNumber }

        Add ->
            { model | result = Just ((Maybe.withDefault 0 model.operand1) + (Maybe.withDefault 0 model.operand2)) }

        Sub ->
            { model | result = Just ((Maybe.withDefault 0 model.operand1) - (Maybe.withDefault 0 model.operand2)) }
        
        Mul ->
            { model | result = Just ((Maybe.withDefault 0 model.operand1) * (Maybe.withDefault 0 model.operand2))}
        
        Div ->
            { model | result = Just ((Maybe.withDefault 0 model.operand1) / (Maybe.withDefault 0 model.operand2)) }


--VIEW
view: Model -> Html Msg
view model = 
    div [] [ 
        div [] [ 
            input [ 
                value (String.fromFloat <| Maybe.withDefault 0 model.operand1), 
                onInput ChangeOp1 ] [], 
            input [ 
                value (String.fromFloat <| Maybe.withDefault 0 model.operand2), 
                onInput ChangeOp2 ] [], 
            div [] [ text ("Result : " ++ (String.fromFloat <| Maybe.withDefault 0 model.result)) ] 
        ]
        , div [] [ 
            button [ onClick Add] [ text "+"],
            button [ onClick Sub] [ text "-"],
            button [ onClick Mul] [ text "*"],
            button [ onClick Div] [ text "/"]
        ]
    ]