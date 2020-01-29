module Calculatrice exposing (..)

import Browser
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onInput, onClick)


--MAIN

main =
  Browser.sandbox { init = init, view = view, update = update }


--MODEL
type alias Model = {
    result : Float,
    operand1 : Float,
    operand2 : Float,
    operator : String
    }


--INIT
init: Model
init =
  Model 0 0 0 ""


--UPDATE
type Msg = Add
    | Sub
    | Mul 
    | Div
    | ChangeOp1 String
    | ChangeOp2 String
    
update : Msg -> Model -> Model
update msg model =
    let operand1 = model.operand1
        operand2 = model.operand2
    in
    case msg of
        ChangeOp1 newNumber ->
            { model | operand1 = Maybe.withDefault 0 <| String.toFloat <| newNumber }

        ChangeOp2 newNumber ->
            { model | operand2 = Maybe.withDefault 0 <| String.toFloat <| newNumber }

        Add ->
            { model | result =  operand1 + operand2 }

        Sub ->
            { model | result =  operand1 - operand2 }
        
        Mul ->
            { model | result =  operand1 * operand2 }
        
        Div ->
            { model | result =  operand1 / operand2 }


--VIEW
view: Model -> Html Msg
view model = 
    div [] [ 
        div [] [ 
            input [ 
                value (String.fromFloat model.operand1), 
                onInput ChangeOp1 ] [], 
            input [ 
                value (String.fromFloat model.operand2), 
                onInput ChangeOp2 ] [], 
            div [] [ text ("Result : " ++ (String.fromFloat <| model.result )) ] 
        ]
        , div [] [ 
            button [ onClick Add] [ text "+"],
            button [ onClick Sub] [ text "-"],
            button [ onClick Mul] [ text "*"],
            button [ onClick Div] [ text "/"]
        ]
    ]

--