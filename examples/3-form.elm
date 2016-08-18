module Main exposing (..)

import Html exposing (..)
import Html.App as Html
import Html.Attributes exposing (..)
import Html.Events exposing (onInput)
import String
import Html.Events exposing (onClick)
import Regex


main =
    Html.beginnerProgram
        { model = model
        , view = view
        , update = update
        }



-- MODEL


type alias Model =
    { name : String
    , password : String
    , passwordAgain : String
    , age : String
    , info :
        { color : String
        , message : String
        }
    }


model : Model
model =
    Model ""
        ""
        ""
        ""
        { color = ""
        , message = ""
        }



-- UPDATE


type Msg
    = Name String
    | Password String
    | PasswordAgain String
    | Age String
    | Submit


update : Msg -> Model -> Model
update msg model =
    case msg of
        Name name ->
            { model | name = name }

        Password password ->
            { model | password = password }

        PasswordAgain password ->
            { model | passwordAgain = password }

        Age age ->
            { model | age = age }

        Submit ->
            { model | info = viewValidation model }



-- VIEW


view : Model -> Html Msg
view model =
    div []
        [ div [] [ input [ type' "text", placeholder "Name", onInput Name ] [] ]
        , div [] [ input [ type' "password", placeholder "Password", onInput Password ] [] ]
        , div [] [ input [ type' "password", placeholder "Re-enter Password", onInput PasswordAgain ] [] ]
        , div [] [ input [ type' "text", placeholder "Age", onInput Age ] [] ]
        , div [] [ button [ onClick Submit ] [ text "Submit" ] ]
        , div [ style [ ( "color", model.info.color ) ] ] [ text model.info.message ]
        ]


viewValidation :
    Model
    -> { color : String
       , message : String
       }
viewValidation model =
    let
        ( color, message ) =
            if String.length model.password < 8 then
                ( "red", "Passwords too short" )
            else if not (model.password == model.passwordAgain) then
                ( "red", "Passwords do not match!" )
            else if
                not
                    (case String.toInt model.age of
                        Err _ ->
                            False

                        Ok _ ->
                            True
                    )
            then
                ( "red", "Not a valid age" )
            else if
                let
                    downcase =
                        Regex.contains (Regex.regex "[a-z]") model.password == True

                    upcase =
                        Regex.contains (Regex.regex "[A-Z]") model.password == True

                    numeric =
                        Regex.contains (Regex.regex "\\d") model.password == True
                in
                    not (downcase && upcase && numeric)
            then
                ( "red", "Password too simple" )
            else
                ( "green", "OK" )
    in
        { color = color, message = message }
