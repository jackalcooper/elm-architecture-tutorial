module Main exposing (..)

import Html exposing (..)
import Html.App as Html
import Html.Attributes exposing (..)
import Html.Events exposing (onInput)
import String


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
    }


model : Model
model =
    Model "" "" "" ""



-- UPDATE


type Msg
    = Name String
    | Password String
    | PasswordAgain String
    | Age String


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



-- VIEW


view : Model -> Html Msg
view model =
    div []
        [ div [] [ input [ type' "text", placeholder "Name", onInput Name ] [] ]
        , div [] [ input [ type' "password", placeholder "Password", onInput Password ] [] ]
        , div [] [ input [ type' "password", placeholder "Re-enter Password", onInput PasswordAgain ] [] ]
        , div [] [ input [ type' "text", placeholder "Age", onInput Age ] [] ]
        , viewValidation model
        ]


viewValidation : Model -> Html msg
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
                        Err msg ->
                            False

                        Ok val ->
                            True
                    )
            then
                ( "red", "Not a valid age" )
            else
                ( "green", "OK" )
    in
        div [ style [ ( "color", color ) ] ] [ text message ]
