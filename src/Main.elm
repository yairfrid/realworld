module Main exposing (..)

import Browser exposing (UrlRequest)
import Browser.Navigation as Nav
import Home exposing (view)
import Html exposing (Html, a, div, footer, i, li, nav, span, text, ul)
import Html.Attributes exposing (class, classList, href)
import Time exposing (millisToPosix)
import Url exposing (Url)


main : Program () Model Msg
main =
    Browser.application
        { init = init
        , update = update
        , subscriptions = subscriptions
        , view = view
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


header : Page -> Html msg
header activePage =
    nav [ classList [ ( "navbar", True ), ( "navbar-light", True ) ] ]
        [ div [ class "container" ]
            [ a [ class "navbar-brand", href (route Home) ]
                [ text "conduit" ]
            , ul [ classList [ ( "nav", True ), ( "navbar-nav", True ), ( "pull-xs-right", True ) ] ]
                [ li [ class "nav-item" ]
                    [ a [ classList [ ( "nav-link", True ), ( "active", activePage == Home ) ], href (route Home) ]
                        [ text "Home" ]
                    ]
                , li [ class "nav-item" ]
                    [ a [ classList [ ( "nav-link", True ), ( "active", activePage == NewArticle ) ], href (route NewArticle) ]
                        [ i [ class "ion-compose" ] [], text "\u{00A0}New Article" ]
                    ]
                , li [ class "nav-item" ]
                    [ a [ classList [ ( "nav-link", True ), ( "active", activePage == Settings ) ], href (route Settings) ]
                        [ i [ class "ion-gear-a" ] [], text "\u{00A0}Settings" ]
                    ]
                , li [ class "nav-item" ]
                    [ a [ classList [ ( "nav-link", True ), ( "active", activePage == SignIn ) ], href (route SignIn) ]
                        [ text "Sign in" ]
                    ]
                , li [ class "nav-item" ]
                    [ a [ classList [ ( "nav-link", True ), ( "active", activePage == SignUp ) ], href (route SignUp) ]
                        [ text "Sign up" ]
                    ]
                ]
            ]
        ]


ftr : Html msg
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


template : Page -> Html msg -> List (Html msg)
template activePage pageContent =
    [ header activePage, pageContent, ftr ]


view : Model -> Browser.Document msg
view model =
    { title = "Conduit"
    , body =
        template model.currentPage
            (Home.view
                { currentFeed = Home.Personal
                , articles =
                    [ { slug = "my-slug"
                      , title = "If we quantify the alarm, we can get to the FTP pixel through the online SSL interface!"
                      , description = "Omnis perspiciatis qui quia commodi sequi modi. Nostrum quam aut cupiditate est facere omnis possimus. Tenetur similique nemo illo soluta molestias facere quo. Ipsam totam facilis delectus nihil quidem soluta vel est omnis."
                      , body = "My body"
                      , tagList = [ "tag" ]
                      , createdAt = millisToPosix 0
                      , updatedAt = millisToPosix 0
                      , favorited = False
                      , favoritesCount = 13
                      , author =
                            { username = "user"
                            , bio = "bio"
                            , image = "http://i.imgur.com/Qr71crq.jpg"
                            , following = True
                            }
                      }
                    ]
                , tags = [ "programming", "javascript", "emberjs", "angularjs", "react", "mean", "node", "rails" ]
                }
            )
    }
