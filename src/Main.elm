module Main exposing (..)

import Browser exposing (UrlRequest)
import Browser.Navigation as Nav
import Html exposing (Html, a, div, footer, i, li, nav, span, text, ul)
import Html.Attributes exposing (class, classList, href)
import Url exposing (Url)


main : Program () Model Msg
main =
    Browser.application
        { init = init
        , update = update
        , view = view
        , subscriptions = subscriptions
        , onUrlRequest = LinkClicked
        , onUrlChange = UrlChanged
        }


init : () -> Url -> Nav.Key -> ( Model, Cmd Msg )
init _ url key =
    ( { currentPage = Home
      , key = key
      , url = url
      }
    , Cmd.none
    )


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none


type Page
    = Other
    | Home
    | NewArticle
    | Settings
    | SignIn
    | SignUp


route : Page -> String
route page =
    case page of
        Home ->
            "/#/"

        NewArticle ->
            "/#/editor"

        Settings ->
            "/#/settings"

        SignIn ->
            "/#/login"

        SignUp ->
            "/#/register"

        Other ->
            Debug.todo "branch 'Other' not implemented"


routeUrl : Url -> Page
routeUrl url =
    case url.fragment of
        Just "/" ->
            Home

        Just "/editor" ->
            NewArticle

        Just "/settings" ->
            Settings

        Just "/login" ->
            SignIn

        Just "/register" ->
            SignUp

        _ ->
            Other


type alias Model =
    { currentPage : Page
    , key : Nav.Key
    , url : Url.Url
    }


type Msg
    = LinkClicked UrlRequest
    | UrlChanged Url


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        LinkClicked urlRequest ->
            case urlRequest of
                Browser.Internal url ->
                    ( { model | currentPage = routeUrl url }, Nav.pushUrl model.key (Url.toString url) )

                Browser.External href ->
                    ( model, Nav.load href )

        UrlChanged url ->
            ( { model | url = url }, Cmd.none )


pageActive : Model -> Page -> Bool
pageActive model page =
    model.currentPage == page


docView : Model -> List (Html Msg)
docView _ =
    template Home []


header : Page -> Html Msg
header page =
    nav [ classList [ ( "navbar", True ), ( "navbar-light", True ) ] ]
        [ div [ class "container" ]
            [ a [ class "navbar-brand", href (route Home) ]
                [ text "conduit" ]
            , ul [ classList [ ( "nav", True ), ( "navbar-nav", True ), ( "pull-xs-right", True ) ] ]
                [ li [ class "nav-item" ]
                    [ a [ classList [ ( "nav-link", True ), ( "active", page == Home ) ], href (route Home) ]
                        [ text "Home" ]
                    ]
                , li [ class "nav-item" ]
                    [ a [ classList [ ( "nav-link", True ), ( "active", page == NewArticle ) ], href (route NewArticle) ]
                        [ i [ class "ion-compose" ] [], text "\u{00A0}New Article" ]
                    ]
                , li [ class "nav-item" ]
                    [ a [ classList [ ( "nav-link", True ), ( "active", page == Settings ) ], href (route Settings) ]
                        [ i [ class "ion-gear-a" ] [], text "\u{00A0}Settings" ]
                    ]
                , li [ class "nav-item" ]
                    [ a [ classList [ ( "nav-link", True ), ( "active", page == SignIn ) ], href (route SignIn) ]
                        [ text "Sign in" ]
                    ]
                , li [ class "nav-item" ]
                    [ a [ classList [ ( "nav-link", True ), ( "active", page == SignUp ) ], href (route SignUp) ]
                        [ text "Sign up" ]
                    ]
                ]
            ]
        ]


ftr : Html Msg
ftr =
    footer []
        [ div [ class "container" ]
            [ a [ href (route Home), class "logo-font" ] [ text "conduit" ]
            , span [ class "attribution" ]
                [ text "An interactive learning project from "
                , a [ href "https://thinkster.io" ] [ text "Thinkster" ]
                , text " Code design licensed under MIT."
                ]
            ]
        ]


template : Page -> List (Html Msg) -> List (Html Msg)
template page rest =
    List.append [ header page ] (List.append rest (List.singleton ftr))


view : Model -> Browser.Document Msg
view model =
    { title = "Conduit", body = template model.currentPage [] }
