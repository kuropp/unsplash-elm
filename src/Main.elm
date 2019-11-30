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
        , subscriptions = \_ -> Sub.none
        }



-- model


type alias Model =
    { term : String
    , photos : List Photo
    , loading : Bool
    }


init : () -> ( Model, Cmd Msg )
init _ =
    ( Model "" [] False
    , Cmd.none
    )



-- update


type Msg
    = HitUnsplash
    | GetPhotos (Result Http.Error (List Photo))


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        HitUnsplash ->
            ( model
            , Http.request
                { method = "GET"
                , headers =
                    [ Http.header "Authorization" "Client-ID 902cb9fdb5e991ce4aaca23c29e92a6ba573264021433f9d093db910c432d505" ]
                , url = "https://api.unsplash.com/photos"
                , expect = Http.expectJson GetPhotos photosDecoder
                , body = Http.emptyBody
                , timeout = Nothing
                , tracker = Nothing
                }
            )

        GetPhotos (Ok photos) ->
            ( { model
                | photos = photos
              }
            , Cmd.none
            )

        GetPhotos (Err error) ->
            ( model, Cmd.none )



--view


view : Model -> Html Msg
view model =
    div []
        [ button [ onClick HitUnsplash ] [ text "get latest photos" ]
        ]



-- data


type alias Photo =
    { id : String
    , regularSizedUrl : String
    }


photoDecoder : Decoder Photo
photoDecoder =
    D.map2 Photo
        (D.field "id" D.string)
        (D.field "urls" (D.field "regular" D.string))


photosDecoder : Decoder (List Photo)
photosDecoder =
    D.list photoDecoder
