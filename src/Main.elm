module Main exposing (main)

import Browser
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Http
import Json.Decode as D exposing (Decoder)



-- main


main : Program () Model Msg
main =
    Browser.element
        { init = init
        , update = update
        , view = view
        , subscriptions = subscriptions
        }



-- model


type alias Model =
    { term : String
    , photos : List Photo
    }


init : () -> ( Model, Cmd Msg )
init _ =
    ( Model "" []
    , Cmd.none
    )



-- update


type Msg
    = GetPhotos (Result Http.Error (List Photo))


update : Msg -> Model -> ( Model, Cmd.Msg )



-- data


type alias Photo =
    { id : String
    , urls : String
    , descriptions : String
    }
