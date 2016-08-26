module Main exposing (..)

import Html exposing (..)
import Html.App as Html
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Http
import Json.Decode as Json
import Task


main =
    Html.program
        { init = init "cats"
        , view = view
        , update = update
        , subscriptions = subscriptions
        }



-- MODEL


type alias Model =
    { topic : String
    , gifUrl : String
    , notice_text : String
    }


init : String -> ( Model, Cmd Msg )
init topic =
    ( Model topic "waiting.gif" "Click to get an image"
    , getRandomGif topic
    )



-- UPDATE


type Msg
    = MorePlease
    | FetchSucceed String
    | FetchFail Http.Error
    | ChangeTopic String


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        MorePlease ->
            ( model, getRandomGif model.topic )

        FetchSucceed newUrl ->
            ( Model model.topic newUrl "Request succeeded", Cmd.none )

        FetchFail _ ->
            ( { model | notice_text = "Request failed" }, Cmd.none )

        ChangeTopic newTopic ->
            ( { model | topic = newTopic }, Cmd.none )



-- VIEW


view : Model -> Html Msg
view model =
    div []
        [ text model.notice_text
          -- , h2 [] [ text model.topic ]
        , div [] [ input [ placeholder model.topic, onInput ChangeTopic ] [] ]
        , div [] [ button [ onClick MorePlease ] [ text "More Please!" ] ]
        , br [] []
        , img [ src model.gifUrl ] []
        ]



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none



-- HTTP


getRandomGif : String -> Cmd Msg
getRandomGif topic =
    let
        url =
            "//api.giphy.com/v1/gifs/random?api_key=dc6zaTOxFJmzC&tag=" ++ topic
    in
        Task.perform FetchFail FetchSucceed (Http.get decodeGifUrl url)


decodeGifUrl : Json.Decoder String
decodeGifUrl =
    Json.at [ "data", "image_url" ] Json.string
