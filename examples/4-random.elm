module Main exposing (..)

import Html exposing (..)
import Html.App as Html
import Html.Events exposing (..)
import Random
import Svg exposing (..)
import Svg.Attributes exposing (..)
import Array
import List


main =
    Html.program
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }



-- MODEL


type alias Model =
    { dieFace1 : Int, dieFace2 : Int }


init : ( Model, Cmd Msg )
init =
    ( Model 1 1, Cmd.none )



-- UPDATE


type Msg
    = Roll
    | NewFace { newFace1 : Int, newFace2 : Int }


newFaceRecord newFace1 newFace2 =
    { newFace1 = newFace1, newFace2 = newFace2 }


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Roll ->
            ( model, Random.generate NewFace (Random.map2 newFaceRecord (Random.int 1 6) (Random.int 1 6)) )

        NewFace newFace ->
            let
                model =
                    { model | dieFace1 = newFace.newFace1, dieFace2 = newFace.newFace2 }
            in
                ( model, Cmd.none )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none



-- VIEW


view : Model -> Html Msg
view model =
    let
        radius =
            toString (model.dieFace1 * 10)
    in
        div []
            [ h1 [] [ Html.text (toString model.dieFace1) ]
            , h1 [] [ Html.text (toString model.dieFace2) ]
            , button [ onClick Roll ] [ Html.text "Roll" ]
            , Svg.svg
                [ viewBox "0 0 120 120", width "300px" ]
                [ circle [ cx "60", cy "60", r radius, fill "#0B79CE" ] []
                ]
            ]
